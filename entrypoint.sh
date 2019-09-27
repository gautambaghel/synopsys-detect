#!/bin/bash
export JAVA_HOME="/usr/local/openjdk-8"
bash <(curl -s https://detect.synopsys.com/detect.sh) \
--blackduck.api.token="$BLACKDUCK_API_TOKEN" \
--blackduck.url="$BLACKDUCK_URL" \
--detect.java.path="/usr/local/openjdk-8/bin/java" \
"$*"
