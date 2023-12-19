#!/usr/bin/env bash

# Set build number to CircleCI run id
if [[ "${run_id_as_build}" =~ ^(yes|1|true)$ ]]; then
  echo "FL_BUILD_NUMBER=${CIRCLECI_BUILD_NUM}" >> "${GITHUB_ENV}"
fi

# Unset optional variables that are empty
[[ -z "${enforced_branch}" ]] && unset enforced_branch
[[ -z "${commit_increment}" ]] && unset commit_increment
[[ -z "${publish_build}" ]] && unset publish_build
[[ -z "${android_artifact}" ]] && unset android_artifact
[[ -z "${android_flavor}" ]] && unset android_flavor
[[ -z "${android_build_type}" ]] && unset android_build_type
[[ -z "${android_skip_signing}" ]] && unset android_skip_signing

if [[ "${publish_build}" =~ ^(yes|1|true)$ ]] && [[ -z "${google_json_file}" ]]; then
  echo "::error ::Missing Google Credentials (publishing is enabled)"
  exit 1
else
  [[ -z "${google_json_file}" ]] && unset google_json_file
fi

if ! [[ "${android_skip_signing}" =~ ^(yes|1|true)$ ]] && [[ -z "${android_store_file}" ]]; then
  echo "::error ::Missing Android Keystore (signing is enabled)"
  exit 1
else
  [[ -z "${android_store_file}" ]] && unset android_store_file
fi

if ! [[ "${android_skip_signing}" =~ ^(yes|1|true)$ ]] && [[ -z "${android_store_password}" ]]; then
  echo "::error ::Missing Android Keystore password (signing is enabled)"
  exit 1
else
  [[ -z "${android_store_password}" ]] && unset android_store_password
fi

if ! [[ "${android_skip_signing}" =~ ^(yes|1|true)$ ]] && [[ -z "${android_key_alias}" ]]; then
  echo "::error ::Missing Android Keystore key alias (signing is enabled)"
  exit 1
else
  [[ -z "${android_key_alias}" ]] && unset android_key_alias
fi

if ! [[ "${android_skip_signing}" =~ ^(yes|1|true)$ ]] && [[ -z "${android_key_password}" ]]; then
  echo "::error ::Missing Android Keystore key password (signing is enabled)"
  exit 1
else
  [[ -z "${android_key_password}" ]] && unset android_key_password
fi

# Execute fastlane using wrapper
./fastlanew android "${build_lane}"
