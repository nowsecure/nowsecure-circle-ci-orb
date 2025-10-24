#!/bin/bash

# shellcheck disable=SC2034 
BINARY_FILEPATH=$(circleci env subst "$PARAM_BINARY_FILE")
NS_GROUP=$(circleci env subst "$PARAM_GROUP")
NS_API_HOST=$(circleci env subst "$PARAM_API_HOST")
NS_UI_HOST=$(circleci env subst "$PARAM_UI_HOST")
NS_LOG_LEVEL=$(circleci env subst "$PARAM_LOG_LEVEL")
NS_ANALYSIS_TYPE=$(circleci env subst "$PARAM_ANALYSIS_TYPE")
ARTIFACT_DIR=$(circleci env subst "$PARAM_ARTIFACT_DIR")
NS_TOKEN=$(circleci env subst "$PARAM_NS_TOKEN")

mkdir -p "$ARTIFACT_DIR"

/app/ns run file "$BINARY_FILEPATH" \
    --group-ref "$NS_GROUP" \
    --api-host "$NS_API_HOST" \
    --ui-host "$NS_UI_HOST" \
    --log-level "$NS_LOG_LEVEL" \
    --analysis-type "$NS_ANALYSIS_TYPE" \
    --output "$ARTIFACT_DIR/assessment.json" \
    --ci-environment "circle-ci" \
    --token "$NS_TOKEN"

