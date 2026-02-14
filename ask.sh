#!/bin/zsh


# SET DEFAULT MODEL HERE
MODEL="claude"      # options: claude, gemini, codex, copilot

case "$1" in
    codex|gemini|claude|copilot)
        MODEL="$1"
        shift # This removes the model name from the argument list
        ;;
esac


format_duration() {
  local total_seconds=$1
  local minutes=$(((total_seconds % 3600) / 60))
  local seconds=$((total_seconds % 60))

  if [ $minutes -gt 0 ]; then
    printf "%2d:%02d" "$minutes" "$seconds"
  else
    printf "%2ds" "$seconds"
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

            sleep 0.1
            kill -0 $pid 2>/dev/null || break
        done
    done
    
    printf "\r$(format_duration $duration) ⠿ Yo ${MODEL}: I got a Q for you..." >&2
    printf "\n✓ Response from ${MODEL} received.\n" >&2
}

function expand() {
    if [ $1 = "cmt" ]; then
    	cat ~/.ask/ask-cmt.txt
    fi
}

if [ -n "$1" ]; then
  ASK=$(expand "$1")
elif [ ! -t 0 ]; then
  ASK=$(cat)
else
  echo "No question provided." >&2
  echo "Usage: 'ask ""<query>"" [<topic>]" >&2
  exit 1
fi

if [ "$ASK" = "" ]; then
    ASK="$1"
fi

TOPIC=$(printf "%q" "$2")


PREPEND=""
APPEND="Simply provide a response. Don't go browsing files or performing other commands that were not explicitly instructed."

FULLMSG="${PREPEND} ${ASK} ${APPEND}"

BEGIN=$(date +"%Y-%m-%d %T")
printf "\n=== START: $BEGIN ===\n" >&2
echo "::pinging $MODEL to see if anyone's home::" >&2

case "$MODEL" in
    codex)
        OUTPUT=$(codex exec "${FULLMSG}" &
        spinner $!
        wait $!)
        ;;
    gemini)
        echo "Using Gemini..." >&2
        OUTPUT=$(gemini -p "${FULLMSG}" &
        spinner $!
        wait $!)
        ;;
    claude)
        OUTPUT=$(claude --model sonnet -p "${FULLMSG}" &
        spinner $!
        wait $!)
        ;;
    copilot)
        OUTPUT=$(copilot -p "${FULLMSG}" &
        spinner $!
        wait $!)
        ;;
    *)
        echo "No valid model selected." >&2
        exit 1
        ;;
esac


if [ -t 1 ]; then
        printf "\n---\n"
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
