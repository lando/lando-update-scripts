#!/bin/bash

# Function to get the latest release version
get_latest_release() {
    gh release list --repo "$1" --limit 1 | awk '{print $1}'
}

# Get the latest release version for both repos
cli_latest=$(get_latest_release "lando/cli")
core_latest=$(get_latest_release "lando/core")

echo "Latest @lando/cli release: $cli_latest"
echo "Latest @lando/core release: $core_latest"

# Function to compare semantic versions
version_gte() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" = "$2"
}

# Get all CLI releases and filter those greater than v3.20.8
cli_releases=$(gh release list --repo "lando/cli" --limit 1000 | awk '{print $1}' | while read -r version; do
    if version_gte "${version#v}" "3.20.8"; then
        echo "$version"
    fi
done)

# Reverse the order of releases
cli_releases=$(echo "$cli_releases" | tail -r)

# Convert the output to a space-separated list
cli_releases=$(echo "$cli_releases" | tr '\n' ' ' )

for cli_version in $cli_releases; do
    echo "Processing @lando/cli release: $cli_version"
    
    # Check if a corresponding release exists in @lando/core
    if gh release view "$cli_version" --repo "lando/core" &>/dev/null; then
        echo "Corresponding release found in @lando/core"
        
        # Get all assets from @lando/cli
        assets=$(gh release view "$cli_version" --repo "lando/cli" --json assets -q '.assets[].name')
        for asset in $assets; do
            echo "Transferring asset: $asset"
            
            # Download the asset from @lando/cli
            gh release download "$cli_version" -p "$asset" --repo "lando/cli"
            
            # Upload the asset to @lando/core
            gh release upload "$cli_version" "$asset" --repo "lando/core"
            
            # Remove the downloaded asset
            rm "$asset"
        done

    else
        echo "No corresponding release found in @lando/core for version $cli_version"
    fi
    
    echo "---"
done

echo "Asset transfer complete!"
