# 🧪 Expected behavior

| current-version | version-type | preversion | preversion-start-zero | use-build | prefix | Result | Status |
|-----------------|--------------|------------|------------------------|-----------|--------|--------|--------|
| `v1.0.0-rc.5+123` | `rc` | `false` | `false` | `false` | `false` | `1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `false` | `false` | `true` | `v1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `false` | `true` | `false` | `1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `false` | `true` | `true` | `v1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `true` | `false` | `false` | `1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `true` | `false` | `true` | `v1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `true` | `true` | `false` | `1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `false` | `true` | `true` | `true` | `v1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `false` | `false` | `false` | `1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `false` | `false` | `true` | `v1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `false` | `true` | `false` | `1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `false` | `true` | `true` | `v1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `true` | `false` | `false` | `1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `true` | `false` | `true` | `v1.0.0-rc.6` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `true` | `true` | `false` | `1.0.0-rc.6+124` | ✅ |
| `v1.0.0-rc.5+123` | `rc` | `true` | `true` | `true` | `true` | `v1.0.0-rc.6+124` | ✅ |

[Back to README](../README.md)