#!/bin/bash

LLM_FILE="llm-input.txt"
FILE_TYPES_TO_INCLUDE="\.(sh|py|js|html|css|cpp|hpp|c|h|toml|md|json)$"
EXCLUDE_DIR1="public"
EXCLUDE_DIR2="content/posts/"

echo 'I am working on a project. 
I will give you its structure and source code. 
Then, I will ask you a few questions to help me with some things. 
Until then, do nothing except read the source code.

In all your answers, make sure you have considered my input files, 
the code structure, and that you suggest all needed changes.

If you find a typo, syntax error, grammar error, or security issue anywhere, 
include it in your answer, even if the question isn’t related to it.

Make sure to do so only if it is necessary, 
as you will be penalized for unnecessary changes.

Answer my questions with simple and explanatory steps or modifications.

When asked, provide the entire code, including any modifications, 
and specify in which file the changes should be made.

The solutions suggested should take into account that the project is related to
a website, which should be responsive to different screen widths (mobile phones and tablets),
as much as SEO friendly and to follow best practices without repeating code.

If you find repeating code, or one of the solutions can be enhanced, then suggest the modifications,
even if deleting/creating new files is required.

' > ${LLM_FILE}

# Project Structure
echo '-------------------' >> ${LLM_FILE}
echo 'Project structure: ' >> ${LLM_FILE}
tree -I "public|static|posts" | head -n -1 >> ${LLM_FILE}
echo >> ${LLM_FILE}

# Find all source files
files=$(find . -type f -not -path '*/.git/*' \
    | grep -Fv "$0" \
    | grep -v "${EXCLUDE_DIR1}" \
    | grep -v "${EXCLUDE_DIR2}" \
    | grep -Fv "${LLM_FILE}" \
    | grep -E "${FILE_TYPES_TO_INCLUDE}")

# Include each file
for file in ${files}; do
    echo '=============================' >> ${LLM_FILE}
    echo "File: $file" >> ${LLM_FILE}
    echo "*** $file - CONTENT START ***" >> ${LLM_FILE}
    cat $file >> ${LLM_FILE}
    echo >> ${LLM_FILE}
    echo "*** $file - CONTENT END ***" >> ${LLM_FILE}
    echo >> ${LLM_FILE}
done