#!/bin/bash -l
set -euo pipefail

load_and_increment_build_number() {
  local file=".build-version"
  if [[ -f "$file" ]]; then
    build=$(<"$file")
  else
    build=0
  fi
  ((build++))
  echo "$build" > "$file"
  echo "$build"
}

parse_version() {
  local version="$1"
  local regex="^v?([0-9]+)\.([0-9]+)\.([0-9]+)(-([a-zA-Z]+)(\.([0-9]+))?)?(\\+[0-9]+)?$"

  if [[ "$version" =~ $regex ]]; then
    printf "%s:%s:%s:%s:%s" \
      "${BASH_REMATCH[1]:-0}" \
      "${BASH_REMATCH[2]:-0}" \
      "${BASH_REMATCH[3]:-0}" \
      "${BASH_REMATCH[5]:-}" \
      "${BASH_REMATCH[7]:-}"
  else
    echo "Error: Invalid version format: '$version'" >&2
    printf "0:0:0::"
    return 1
  fi
}

main() {
  prev_version="$1"
  release_type="$2"
  preversion_strict="${3:-true}"
  preversion_start_zero="${4:-false}"
  use_build="${5:-false}"
  prefix="${6:-false}"
  build=""

  if ! parse_version "$prev_version" > /dev/null 2>&1; then
    echo "Error: Ungültiges Format für die vorherige Version: '$prev_version'" >&2
    exit 1
  fi

  for var_name in preversion_strict preversion_start_zero use_build prefix; do
    value="${!var_name}"
    if [[ "$value" != "true" && "$value" != "false" ]]; then
      echo "Error: Parameter '$var_name' must be 'true' or 'false', but got '$value'" >&2
      exit 1
    fi
  done

  case "$release_type" in
    feature) release_type="minor" ;;
    bug|hotfix) release_type="patch" ;;
  esac

  case "$preversion_start_zero" in
    true) preversion_start="0" ;;
    false) preversion_start="1" ;;
  esac

  possible_release_types=(
    none major minor patch stable
    alpha beta pre rc
    patch-alpha patch-beta patch-pre patch-rc
    minor-alpha minor-beta minor-pre minor-rc
    major-alpha major-beta major-pre major-rc
  )
  if [[ ! " ${possible_release_types[*]} " =~ " ${release_type} " ]]; then
    echo "Valid release types: ${possible_release_types[*]}" >&2
    exit 1
  fi

  if [[ "$release_type" == "none" ]]; then
    if [[ "$use_build" == "true" ]]; then
      base_version="${prev_version%%+*}"
      IFS=':' read -r -a parsed <<< "$(parse_version "$base_version" || echo "0:0:0::")"
      version_core="${parsed[0]}.${parsed[1]}.${parsed[2]}"
      build="$(load_and_increment_build_number)"
      next_version="${version_core}+${build}"
      [[ "$prefix" == "true" ]] && next_version="v${next_version}"
      echo "create build-only version: $prev_version -> $next_version"
      echo "next-version=$next_version" >> "$GITHUB_OUTPUT"
      exit 0
    else
      echo "No changes made – neither release nor build." >&2
      exit 1
    fi
  fi

  clean_version="${prev_version%%+*}"
  IFS=':' read -r -a parsed <<< "$(parse_version "$clean_version" || echo "0:0:0::")"

  major="${parsed[0]:-0}"
  minor="${parsed[1]:-0}"
  patch="${parsed[2]:-0}"
  existing_pre_type="${parsed[3]:-}"
  existing_pre_num="${parsed[4]:-}"

  [[ "$prev_version" =~ \+([0-9]+)$ ]] && build_number_from_prev="${BASH_REMATCH[1]}" || build_number_from_prev=""

  format_pre() {
    local pre_type="$1"
    local pre_num="$2"
    if [[ -n "$pre_num" ]]; then
      echo "-${pre_type}.${pre_num}"
    else
      echo "-${pre_type}"
    fi
  }

  version_changed=false
  pre=""
  case "$release_type" in
    major) ((++major)); minor=0; patch=0; version_changed=true ;;
    minor) ((++minor)); patch=0; version_changed=true ;;
    patch) ((++patch)); version_changed=true ;;
    stable) pre=""; existing_pre_num="" ;;
    patch-*|minor-*|major-*)
      IFS='-' read -r bump pre_type <<< "$release_type"
      case "$bump" in
        patch) ((++patch)) ;;
        minor) ((++minor)); patch=0 ;;
        major) ((++major)); minor=0; patch=0 ;;
      esac
      version_changed=true
      if [[ "$version_changed" == "true" || "$existing_pre_type" != "$pre_type" ]]; then
        if [[ "$preversion_strict" == "true" ]]; then
          preversion="$preversion_start"
          pre="$(format_pre "$pre_type" "$preversion")"
        else
          pre="$(format_pre "$pre_type" "")"
        fi
      elif [[ "$preversion_strict" == "true" ]]; then
        preversion="${existing_pre_num:-$preversion_start}"
        ((preversion++))
        pre="$(format_pre "$pre_type" "$preversion")"
      else
        pre=""
      fi
      ;;
    alpha|beta|pre|rc)
      pre_type="$release_type"
      if [[ "$existing_pre_type" == "$pre_type" ]]; then
        preversion="${existing_pre_num:-$preversion_start}"
        ((preversion++))
        pre="$(format_pre "$pre_type" "$preversion")"
      elif [[ "$preversion_strict" == "true" ]]; then
        preversion="$preversion_start"
        pre="$(format_pre "$pre_type" "$preversion")"
      else
        pre="$(format_pre "$pre_type" "")"
      fi
      ;;
  esac

  if [[ "$use_build" == "true" ]]; then
    if [[ -n "$build_number_from_prev" ]]; then
      build="$((build_number_from_prev + 1))"
      echo "$build" > .build-version
    else
      build="$(load_and_increment_build_number)"
    fi
    next_version="${major}.${minor}.${patch}${pre}+${build}"
  else
    next_version="${major}.${minor}.${patch}${pre}"
  fi

  [[ "$prefix" == "true" ]] && next_version="v${next_version}"

  echo "create $release_type-release version: $prev_version -> $next_version"
  echo "next-version=$next_version" >> "$GITHUB_OUTPUT"
}

main "$@"
exit 0