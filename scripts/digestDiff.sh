#!/usr/bin/env bash

digestDiff() {
  which swift >/dev/null 2>&1 || return $(echoErr 2 "no swift")
  local -r resDir="${1}/resources"
  [ -d "${resDir}" ] || return $(echoErr 3 "No resource dir: ${resDir}")
  if [[ "$2" =~ -c ]]; then
    shift
    local -r clean=clean
  fi
  local -r module="${2:-Foundation}"
  local -r arch="${3:-arm64}" # or x86_64
  local -r macos="${resDir}/${module}_macos.json"
  local -r linux="${resDir}/${module}_linux.json"
  local -r diffs="${resDir}/${module}_macos-linux.diffs.txt"
  [ -n "${clean}" ] && rm -rf "${macos}" "${linux}" "${diffs}"

  if [ ! -s "${macos}" ]; then
    swift api-digester -dump-sdk -module "${module}" \
      -o "${macos}" \
      -sdk "$(xcrun --show-sdk-path)" \
      -target "${arch}-apple-macosx10.15" \
      || return $(echoErr "$?" "macos failed")
    [ -s "${macos}" ] || return $(echoErr 4 "macOS empty")
  fi
  if [ ! -s "${linux}" ] ; then
    swift api-digester -dump-sdk -module "${module}" \
      -o "${linux}" \
      -sdk /usr/lib/swift \
      -target "${arch}-unknown-linux-gnu" \
      || return $(echoErr "$?" "linux failed")
    [ -s "${linux}" ] || return $(echoErr 5 "linux empty")
  fi
  if [ ! -s "${diffs}" ]; then
    swift api-digester -diagnose-sdk \
      -baseline-path "${macos}" \
      -input-paths "${linux}" \
      -module "${module}" \
      -o "${diffs}"
  fi
}
### START
digestDiff "$(dirname "${0}")" "${@}"
