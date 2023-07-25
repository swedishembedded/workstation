#!/bin/sh

set -e

ROOT="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
TAG="v$(cat ${ROOT}/VERSION | tr -d '\n')"
