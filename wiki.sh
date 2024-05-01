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
            wiki-update-all "$@"
            ;;

        *)
            echo "Unknown command: $command"
            ;;
    esac
}

__wiki_get_tags() {
    local wikifile="$1"
    rg '^\s*Tags: (.*)' --ignore-case --only-matching --replace '$1' "$wikifile" | tr '\n' ' ' | xargs
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
        cd ${WIKIROOT:-~/wiki}
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
    )
}

wiki-update-all() {
    (
        cd ${WIKIROOT:-~/wiki}

        if [[ ! -d .db ]]; then
            mkdir .db
        fi

        if [[ -e .db/tags ]] then
            rm .db/tags
        fi

        fd -e md | while read -r wikifile ; do
            tags=$(__wiki_get_tags $wikifile)
            echo "Updating $wikifile > $tags"
            echo -e "$wikifile:$tags" >> .db/tags
        done
    )
}

wiki-show() {
    (
        cd ${WIKIROOT:-~/wiki}

        selected=$(__wiki_fzf)
        bat "$selected" --style=plain
    )
}

wiki-edit() {
    (
        cd ${WIKIROOT:-~/wiki}

        selected=$(__wiki_fzf)
        "${EDITOR:-nvim}" "$selected"
    )
}

# When this script is executed instead of being sourced, call the wiki function
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    wiki "$@"
fi
