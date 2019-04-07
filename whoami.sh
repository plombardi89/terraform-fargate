#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

CURL_OPTS=${CURL_OPTS:-""}
LB_DNS_NAME="$(terraform output load_balancer_dns_name)"

curl ${CURL_OPTS} "http://${LB_DNS_NAME}"
