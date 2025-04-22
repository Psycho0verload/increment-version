#!/bin/bash

output_file="cases/auto/scenarios.json"

# Definiere die Wertebereiche für die Parameter
versions=("0.1.0" "1.0.0" "2.0.0" "3.0.0-alpha.1" "2.3.4+123")
types=("major" "minor" "patch" "alpha" "beta" "rc" "stable" "none" "patch-alpha" "patch-beta" "patch-pre" "patch-rc" "minor-alpha" "minor-beta" "minor-pre" "minor-rc" "major-alpha" "major-beta" "major-pre" "major-rc") 
preversions=("true" "false")
preversion_start_zero=("true" "false")
use_build=("true" "false")
prefix=("true" "false")

# Beginne das JSON-Dokument
echo "[" > "$output_file"

# Szenarien generieren
scenario_id=0
for version in "${versions[@]}"; do
    for type in "${types[@]}"; do
        for preversion in "${preversions[@]}"; do
            for start_zero in "${preversion_start_zero[@]}"; do
                for build in "${use_build[@]}"; do
                    for pre in "${prefix[@]}"; do
                        scenario_id=$((scenario_id + 1))
                        echo "  {" >> "$output_file"
                        echo "    \"version\": \"$version\"," >> "$output_file"
                        echo "    \"type\": \"$type\"," >> "$output_file"
                        echo "    \"preversion\": $preversion," >> "$output_file"
                        echo "    \"preversion_start_zero\": $start_zero," >> "$output_file"
                        echo "    \"use_build\": $build," >> "$output_file"
                        echo "    \"prefix\": $pre," >> "$output_file"
                        echo "    \"expected\": \"\"," >> "$output_file"
                        echo "    \"expect_failure\": false," >> "$output_file"
                        echo "    \"uid\": \"scenario-$scenario_id\"" >> "$output_file"
                        echo "  }," >> "$output_file"
                    done
                done
            done
        done
    done
done

# Entferne das letzte Komma und schließe das JSON-Dokument
sed -i '' -e '$ s/,$//' "$output_file"
echo "]" >> "$output_file"

echo "Das JSON mit Szenarien wurde in $output_file gespeichert."