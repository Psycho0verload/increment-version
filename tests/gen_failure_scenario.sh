#!/bin/bash

output_file="cases/auto/failure_scenarios.json"

# Beginne das JSON-Dokument
echo "[" > "$output_file"

scenario_id=0

# Funktion zur Fehler-Szenario-Erstellung
add_error_scenario() {
    local version="$1"
    local type="$2"
    local preversion="$3"
    local preversion_start_zero="$4"
    local use_build="$5"
    local prefix="$6"
    local description="$7"

    scenario_id=$((scenario_id + 1))

    echo "  {" >> "$output_file"
    echo "    \"version\": \"$version\"," >> "$output_file"
    echo "    \"type\": \"$type\"," >> "$output_file"
    echo "    \"preversion\": \"$preversion\"," >> "$output_file"
    echo "    \"preversion_start_zero\": \"$preversion_start_zero\"," >> "$output_file"
    echo "    \"use_build\": \"$use_build\"," >> "$output_file"
    echo "    \"prefix\": \"$prefix\"," >> "$output_file"
    echo "    \"expected\": \"\"," >> "$output_file"
    echo "    \"expect_failure\": true," >> "$output_file"
    echo "    \"description\": \"$description\"," >> "$output_file"
    echo "    \"uid\": \"error-scenario-$scenario_id\"" >> "$output_file"
    echo "  }," >> "$output_file"
}

# Ungültige Versionen
add_error_scenario "" "minor" "false" "false" "false" "false" "Empty version string"
add_error_scenario "1.0" "minor" "false" "false" "false" "false" "Incomplete version format"
add_error_scenario "abc" "minor" "false" "false" "false" "false" "Non-numeric version string"

# Ungültige Release-Typen
add_error_scenario "1.0.0" "unknown" "false" "false" "false" "false" "Unknown release type"
add_error_scenario "1.0.0" "123" "false" "false" "false" "false" "Numeric release type"

# Falsche Datentypen
add_error_scenario "1.0.0" "minor" "yes" "false" "false" "false" "preversion not boolean"
add_error_scenario "1.0.0" "minor" "false" "nope" "false" "false" "preversion_start_zero not boolean"
add_error_scenario "1.0.0" "minor" "false" "false" "trueish" "false" "use_build not boolean"
add_error_scenario "1.0.0" "minor" "false" "false" "false" "1" "prefix not boolean"

# Fehlerhafte Kombinationen
add_error_scenario "1.0.0" "stable" "true" "false" "false" "false" "Stable release type with preversion=true"
add_error_scenario "1.0.0" "patch" "false" "true" "false" "false" "patch type with preversion_start_zero=true and no preversion"

# Entferne das letzte Komma und schließe das JSON-Dokument
sed -i '' -e '$ s/,$//' "$output_file"
echo "]" >> "$output_file"

echo "Das JSON mit Fehler-Szenarien wurde in $output_file gespeichert."