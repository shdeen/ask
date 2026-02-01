#!/bin/zsh

format_duration() {
  local total_seconds=$1
  local minutes=$(((total_seconds % 3600) / 60))
  local seconds=$((total_seconds % 60))

  if [ $minutes -gt 0 ]; then
    printf "%02d:%02d" "$minutes" "$seconds"
  else
    printf "%02ds" "$seconds"
  fi
}

spinner() {
    local pid=$1
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"

    local start=$(date +"%s")
    local current=$(date +"%s")
    
    local duration=$((current - start))
    
    while kill -0 $pid 2>/dev/null; do

        for (( i=0; i<${#chars}; i++ )); do
            
            current=$(date +"%s")
            duration=$((current - start))

            printf "\r$(format_duration $duration) %s Yo ${MODEL}..." "${chars:$i:1}" >&2
            # printf "$(format_duration $DURATION)" >&2

            sleep 0.1
            kill -0 $pid 2>/dev/null || break
        done
    done
    
    printf "\r$(format_duration $duration) ⠿ Yo ${MODEL}: I got a Q for you..." >&2
    printf "\n✓ Response from ${MODEL} received.\n" >&2
}

function expand() {
    if [ $1 = "cmt" ]; then
        printf "Write a commit message for the currently staged git changes. (Do NOT include comments on unstaged changes.) Use conventional commit format."
    fi
}

ASK=$(expand "$1")

if [ "$ASK" = "" ]; then
    ASK="$1"
fi

TOPIC=$(printf "%q" "$2")

if [ "$1" = "" ]; then
    echo "No question provided." >&2
    echo "Usage: 'ask ""<query>"" [<topic>]" >&2
    exit 1
fi

# SET MODEL HERE
MODEL="claude"      # options: claude, gemini, codex

PREPEND=""
APPEND=""

FULLMSG="${PREPEND} ${ASK} ${APPEND}"

BEGIN=$(date +"%Y-%m-%d %T")
printf "\n=== START: $BEGIN ===\n" >&2
echo "::pinging $MODEL to see if anyone's home::" >&2


if [ "$MODEL" = "codex" ]; then
    OUTPUT=$(codex exec "${FULLMSG}" &
    spinner $!
    wait $!)
    if [ -t 1 ]; then
        printf "\n---\n"
    fi
elif [ "$MODEL" = "gemini" ]; then
    OUTPUT=$(gemini -p "${FULLMSG}" &
    spinner $!
    wait $!)
    if [ -t 1 ]; then
        printf "\n---\n"
    fi
elif [ "$MODEL" = "claude" ]; then
    OUTPUT=$(claude -p "${FULLMSG}" &
    spinner $!
    wait $!)
    if [ -t 1 ]; then
        printf "\n---\n"
    fi
else
    echo "No valid model selected." >&2
    exit 1
fi

echo "$OUTPUT"

END=$(date +"%Y-%m-%d %T")

if [ -t 1 ]; then
    echo "---"
    echo '**Question**: ' "$ASK"
else
    echo "  See file for output." >&2
    echo
    echo "---"
    echo "_**Created**: ${END}_"
    echo "_**Model**: ${MODEL}_"
    echo "_**Question**: ${ASK}_"
    echo
    echo "<!-- markdownlint-disable-file MD041 --> <!-- first-line-heading -->"
    echo "<!-- markdownlint-disable-file MD032 --> <!-- blanks-around-lists -->"
    echo    
fi

echo "=== END: $END ===" >&2
