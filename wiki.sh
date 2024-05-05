#!/bin/bash

wiki() {
    local command=${1:-show}
    shift
    case "$command" in

        new)
            wiki-new "$@"
            ;;

        show)
            wiki-show "$@"
            ;;

        edit)
            wiki-edit "$@"
            ;;

        update)
            wiki-update "$@"
            ;;

        remove)
            wiki-remove "$@"
            ;;

        *)
            echo "Unknown command: $command"
            ;;
    esac
}

__wiki_cd() {
    cd ${WIKIROOT:-~/wiki}
}

__wiki_get_tags() {
    local wikifile="$1"
    rg '^\s*Tags: (.*)' --ignore-case --only-matching --replace '$1' "$wikifile" | tr '\n' ' ' | xargs
}

__wiki_write_tags() {
    local wikifile="$1"
    local tags=$(__wiki_get_tags "$wikifile")
    echo "Updating $wikifile tags: $tags"
    echo -e "$wikifile:$tags" >> .db/tags
}

__wiki_fzf() {
    local red=$(printf '\033[31m')
    local reset=$(printf '\033[0m')

    sed -E "s/([^:]+):(.*)/\1  ${red}\2${reset}/" .db/tags |
        fzf --ansi \
            --preview 'bat --color=always {1}' \
            --height 60% --layout=reverse |
        awk '{print $1}'
}

wiki-new() {
    local file="$1"
    shift
    local tags=( $@ )

    if [[ -z "$file" ]]; then
        echo "No file name"
        return
    fi

    if [ "$file" = "${file%.md}" ]; then
        file="$file.md"
    fi

    # Convert / to ': ', '-' to ' ' and everything to title case
    # https://stackoverflow.com/a/42925783
    local title=$(echo "${file%.md}" | sed 's#/#: #g; s/-/ /g; s/.*/\L&/; s/[a-z]*/\u&/g')
    local tagline=""
    if [ $# -gt 0 ]; then
        # Prepend a '#' to tags
        tags=( ${tags[*]/#/#} )
        tagline="Tags: ${tags[@]}"
    fi

    (
        __wiki_cd
        if [[ -e $file ]]; then
            echo "'$file' already exists"
            return
        fi

        mkdir -p $(dirname "$file")

        cat << EOF > "$file"
# $title

$tagline
EOF
        "${EDITOR:-nvim}" "$file"

        wiki-update "$file"
    )
}

wiki-update() {
    local file="$1"
    if [[ -z "$file" ]]; then
        wiki-update-all
    else
        (
            __wiki_cd

            # Remove entry from db
            sed -i "\|$file:|d" .db/tags
            if [[ -e "$file" ]]; then
                __wiki_write_tags "$file"
            else
                echo "$file removed"
            fi
        )
    fi
}

wiki-update-all() {
    (
        __wiki_cd

        if [[ ! -d .db ]]; then
            mkdir .db
        fi

        if [[ -e .db/tags ]] then
            rm .db/tags
        fi

        fd -e md | while read -r wikifile ; do
            __wiki_write_tags "$wikifile"
        done
    )
}

wiki-show() {
    (
        __wiki_cd

        selected=$(__wiki_fzf)
        if [[ ! -z "$selected" ]]; then
            bat "$selected" --style=plain
        fi
    )
}

wiki-edit() {
    (
        __wiki_cd

        selected=$(__wiki_fzf)
        if [[ ! -z "$selected" ]]; then
            "${EDITOR:-nvim}" "$selected"
            wiki-update "$selected"
        fi
    )
}

wiki-remove() {
    (
        __wiki_cd

        selected=$(__wiki_fzf)
        if [[ ! -z "$selected" ]]; then
            rm "$selected"
            wiki-update "$selected"
        fi
    )
}

# When this script is executed instead of being sourced, call the wiki function
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    wiki "$@"
fi
