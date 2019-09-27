#!/bin/bash
bash <(curl -s https://detect.synopsys.com/detect.sh) \
--blackduck.api.token="$BLACKDUCK_API_TOKEN" \
--blackduck.url="$BLACKDUCK_URL" \
--detect.java.path="/usr/local/openjdk-8/bin/java" \
"$*"
