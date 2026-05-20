#!/usr/bin/env bash

# Generate a table of contents for a Markdown file
# Usage: ./toc.sh <markdown_file>

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <markdown_file>"
    exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found"
    exit 1
fi

echo "## Contents"
echo ""

# Extract headings and generate table of contents
grep "^#" "$file" | while IFS= read -r line; do
    # Count leading '#' characters to determine heading level
    level=$(echo "$line" | sed 's/[^#].*//;s/#/\n/g' | wc -l)
    level=$((level - 1))
    
    # Extract heading text (remove '#' and trim whitespace)
    heading_text=$(echo "$line" | sed 's/^#* //')
    
    # Convert heading text to anchor link (lowercase, replace spaces with hyphens, remove special chars)
    anchor=$(echo "$heading_text" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 -]//g' | sed 's/ /-/g')
    
    # Create indentation (2 spaces per level)
    #indent=$(printf '%*s' $((level * 2)) | tr ' ' ' ')
   
    # Create indentation using tabs (one tab per level)
    indent=$(printf '\t%.0s' $(seq 1 $level))
    
    # Output list item with link
    echo "${indent}- [$heading_text](#$anchor)"
done
