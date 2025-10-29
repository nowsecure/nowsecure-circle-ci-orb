# Overview

NowSecure provides purpose-built, fully automated mobile application security testing (static and dynamic) for your development pipeline.
By testing your mobile application binary post-build from CircleCI, NowSecure ensures comprehensive coverage of newly developed code, third party components, and system dependencies.

NowSecure quickly identifies and details real issues, provides remediation recommendations, and integrates with ticketing systems such as Azure DevOps and Jira.

This integration requires a NowSecure platform license. See <https://www.nowsecure.com> for more information.

## Getting Started

### Sample Usage

First, find this orb in the [CircleCI Orb Registry](https://circleci.com/developer/orbs)

Then follow along with the instructions on this orb's [registry page](https://circleci.com/developer/orbs/orb/nowsecure/nowsecure-circle-ci-orb)


### Configuration

To add this component to your CI/CD pipeline, the following should be done:

- Get a token from your NowSecure platform instance. More information on this can be found in the [NowSecure Support Portal](https://support.nowsecure.com/hc/en-us/articles/7499657262093-Creating-a-NowSecure-Platform-API-Bearer-Token).
- Identify the ID of the group in NowSecure Platform that you want your assessment to be included in. More information on this can be found in the
  [NowSecure Support Portal](https://support.nowsecure.com/hc/en-us/articles/38057956447757-Retrieve-Reference-and-ID-Numbers-for-API-Use-Task-ID-Group-App-and-Assessment-Ref).
- Add a [CircleCI environment variable](https://circleci.com/docs/guides/security/set-environment-variable/#set-an-environment-variable-in-a-project) to your project named, NS_TOKEN. Set this to the value of the token created above.

## Usage Examples

> [!NOTE]
> Full usage examples can be found in the [src/examples](./src/examples) directory

### Sample job configuration

NowSecure recommends running a 'static' assessment for commits and PR events, and saving 'full' (static and dynamic) assessments for release and release candidate tags. 

This strategy allows developers quick feedback for the majority of their commits, while still ensuring thorough security testing before app releases.

``` yaml
usage:
  version: 2.1
  orbs:
    nowsecure-circle-ci-orb: test-orb@1.2.3
  workflows:
    security-scan:
      jobs:
        - build-job:  # your custom job, that builds a binary artifact
            post-steps:
              - persist_to_workspace: # Persist the binary to a workspace
                  root: ./build
                  paths:
                    - some-binary.apk
        - nowsecure-circle-ci-orb/analyze:
            requires: # require the build step to succeed before running a security assessment
              - build
            filters:
              tags:
                ignore: /^v.*/
            pre-steps:
              - attach_workspace:
                at: /tmp
            binary_file: /tmp/build/some-binary.apk # this path should match the attached workspace
            group: 00000000-0000-0000-0000-000000000000
            token: NS_TOKEN
        - nowsecure-circle-ci-orb/analyze:
            requires: # require the build step to succeed before running a security assessment
              - build
            filters:
              tags:
                only: /^v.*/
            pre-steps:
              - attach_workspace:
                at: /tmp/workspace
            analysis_type: full
            polling_duration_minutes: 90
            binary_file: /tmp/build/some-binary.apk # this path should match the attached workspace
            group: 00000000-0000-0000-0000-000000000000
            token: NS_TOKEN
```
