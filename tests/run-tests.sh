#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is not installed. Please install it before running the script."
  echo "    On Linux:    sudo apt install jq (or use your distro's package manager)"
  echo "    On Mac:      brew install jq"
  echo "    On Windows:  scoop install jq (via Scoop), or download it from https://jqlang.org/download/"
  exit 1
fi

case "${1:-auto}" in
  --manual)
    TEST_FILES_DIR="$(dirname "$0")/cases/manual"
    ;;
  --auto)
    TEST_FILES_DIR="$(dirname "$0")/cases/auto"
    ;;
  -h|--help)
    echo "🧪 Usage: $(basename "$0") [auto|manual]"
    echo ""
    echo "Options:"
    echo "  --auto     Run tests from cases/auto (default)"
    echo "  --manual   Run tests from cases/manual"
    echo "  -h, --help  Show this help message"
    exit 0
    ;;
  *)
    echo "❌ Unknown option: '$1'"
    echo "👉 Use '--help' to see valid options."
    exit 1
    ;;
esac

SCRIPT_PATH="$(dirname "$0")/../increment.sh"
OUTPUT_FILE="$(dirname "$0")/test-output.txt"


fail=0
total=0
passed=0
expected_failure_passed=0
failed=0


cleanup() {
  rm -f "$(dirname "$SCRIPT_PATH")/.build-version" "$OUTPUT_FILE" 2>/dev/null || true
}
trap cleanup EXIT

run_test() {
  local line="$1"
  ((total++))

  local uid version type preversion preversion_start_zero use_build prefix expected expect_failure
  uid=$(jq -r '.uid // "unknown-uid"' <<< "$line")
  version=$(jq -r '.version // ""' <<< "$line")
  type=$(jq -r '.type // ""' <<< "$line")
  preversion=$(jq -r '.preversion' <<< "$line")
  preversion_start_zero=$(jq -r '.preversion_start_zero // false' <<< "$line")
  use_build=$(jq -r '.use_build // false' <<< "$line")
  prefix=$(jq -r '.prefix // false' <<< "$line")
  expected=$(jq -r '.expected // ""' <<< "$line")
  expect_failure=$(jq -r '.expect_failure // false' <<< "$line")

  cleanup
  export GITHUB_OUTPUT="$OUTPUT_FILE"

  local test_info="🧪 Test $total ($uid): '$version' -> '$type' / pre: '$preversion' / start0: '$preversion_start_zero' / build: '$use_build' / prefix: '$prefix' -> '$expected'"

  cd "$(dirname "$SCRIPT_PATH")"
  local output
  if output=$("$SCRIPT_PATH" "$version" "$type" "$preversion" "$preversion_start_zero" "$use_build" "$prefix" 2>&1); then

    local actual
    actual=$(grep -m1 "next-version=" "$OUTPUT_FILE" | cut -d= -f2-)

    if [[ "$actual" == "$expected" ]]; then
      ((passed++))
      echo "$test_info ... ✅ OK"
    elif [[ "$expect_failure" == "true" ]]; then
      ((expected_failure_passed++))
      echo "$test_info ... ✅ EXPECTED FAILURE"
    else
      ((failed++))
      echo "$test_info ... ❌ INCORRECT (Result: '$actual', Expected: '$expected')"
    fi
  else
    if [[ "$expect_failure" == "true" ]]; then
      ((expected_failure_passed++))
      echo "$test_info ... ✅ EXPECTED FAILURE"
      echo "    🔍 Error details: ${output//$'\n'/$'\n    '}"
      return 0
    else
      ((failed++))
      echo "$test_info ... ❌ UNEXPECTED FAILURE"
      echo "    🔍 Error details: ${output//$'\n'/$'\n    '}"
      return 0
    fi
  fi
}

current_file=""

echo "🚀 Starting test suite with test files from: ${TEST_FILES_DIR}"
for MATRIX_FILE in "$TEST_FILES_DIR"/*.json; do
  current_file="$MATRIX_FILE"
  echo "📂 Processing file: $MATRIX_FILE"
  while IFS= read -r line; do
    if ! run_test "$line"; then
      ((fail++))
    fi
  done < <(jq -c '.[]' "$MATRIX_FILE")
done

echo "Running on bash version: $BASH_VERSION"
echo -e "\n📊 Test report:"
echo " - Total tests: $total"
echo " - OK: $((passed))"
echo " - Expected failure: $((expected_failure_passed))"
echo " - Total passed: $((passed + expected_failure_passed))"
echo " - Failed: $failed"

if [[ "$failed" -gt 0 || "$total" -ne $((passed + expected_failure_passed)) ]]; then
  echo -e "\n❌ Test suite completed with failures or mismatched count!"
  exit 1
else
  echo -e "\n✅ All tests passed as expected!"
  exit 0
fi

[[ $fail -eq 0 ]] || exit 1