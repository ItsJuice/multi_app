#!/bin/bash

ANSI_GREEN="\033[32m"
ANSI_YELLOW="\033[33m"
ANSI_RED="\033[31m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

cd "$( dirname "${BASH_SOURCE[0]}" )/../"

echo -e "${ANSI_YELLOW}${ANSI_BOLD}Running bundler..${ANSI_RESET} "

SUCCEEDED=""
FAILED=""
FAILED_WITH_OUTPUT=""
LOCKED=""

for dir in `ls */Gemfile | cut -d/ -f1`; do
  echo -n -e "  ${ANSI_YELLOW}${dir}..${ANSI_RESET} "
  
  if [ -f "${dir}/lock" ]; then
    LOCKED="$LOCKED $dir"
    echo -e "${ANSI_RED}LOCKED${ANSI_RESET}"
  else
    OUTPUT=`sh -c "cd $dir && bundle install 2>&1"`
    if [ $? = 0 ]; then
      SUCCEEDED="$SUCCEEDED $dir"
      echo -e "${ANSI_GREEN}OK${ANSI_RESET}"
    else
      echo -e "${ANSI_RED}FAIL${ANSI_RESET}"
      FAILED="$FAILED $dir"
      FAILED_WITH_OUTPUT="$FAILED_WITH_OUTPUT\n${ANSI_RED}$dir${ANSI_RESET}\n$OUTPUT\n"
    fi
  fi
done

echo 
echo -e "${ANSI_YELLOW}${ANSI_BOLD}Finished bundling${ANSI_RESET}"
echo 

if [ "$SUCCEEDED" != "" ]; then
  echo -e "${ANSI_GREEN}${ANSI_BOLD}Updated successfully: ${ANSI_RESET}\n  ${SUCCEEDED}"
fi

if [ "$LOCKED" != "" ]; then
  echo 
  echo -e "${ANSI_RED}${ANSI_BOLD}Skipped due to lock file:${ANSI_RESET}\n  $LOCKED"
fi

if [ "$FAILED" != "" ]; then
  echo 
  echo -e "${ANSI_RED}${ANSI_BOLD}Pull failed for:${ANSI_RESET}${FAILED}"
  echo -e "${FAILED_WITH_OUTPUT}"
fi
