#!/usr/bin/env bash

ANNOTATIONS=(
  "argocd.argoproj.io/hook=Sync"
  "argocd.argoproj.io/sync-wave=0"
  "argocd.argoproj.io/hook-delete-policy=BeforeHookCreation,HookSucceeded"
)

for file in $(find ./loki/templates -type f -name '*.yaml'); do
  if yq e '.kind == "Job"' "$file" | grep -q true; then
    for ann in "${ANNOTATIONS[@]}"; do
      key="${ann%%=*}"
      value="${ann#*=}"
      yq e -i ".metadata.annotations.\"$key\" = \"$value\"" "$file"
    done
    echo "✅ Added annotations to: $file"
  fi
done