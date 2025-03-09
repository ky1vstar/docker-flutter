#!/bin/bash
set -e

releases_json=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)
configs_json="[]"

function get_latest_version_in_channel() {
    channel=$1
    # This contains the hash of the latest version in the channel
    channel_hash=$(echo "$releases_json" | jq -r '.current_release.'"$channel")
    # Look for the version corresponding to the hash in the list of releases
    version=$(echo "$releases_json" | jq -r --arg HASH "$channel_hash" \
        '.releases[] | select(.hash == $HASH).version')

    # check not empty
    if [ -z "$version" ]; then
        echo "Error fetching latest version in channel $channel"
        exit 1
    fi

    echo "$version"
}

function docker_tag_exists() {
    DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect "$1:$2" > /dev/null 2> /dev/null
}

function generate_config_for_channel() {
    flutter_channel="$1"
    flutter_version="$(get_latest_version_in_channel "$flutter_channel")"

    if docker_tag_exists ky1vstar/flutter "$flutter_version"; then
        :
    else 
        configs_json=$(echo "$configs_json" | jq '. += [{ "flutter_version": "'"$flutter_version"'", "flutter_channel": "'"$flutter_channel"'", "update_channel_image": true }]')
    fi
}

generate_config_for_channel "stable"
generate_config_for_channel "beta"

echo "$configs_json"