# 🧪 Expected behavior

| current-version | version-type | preversion | preversion-start-zero | use-build | prefix | Result | Status |
|-----------------|--------------|------------|------------------------|-----------|--------|--------|--------|
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `false` | `false` | `false` | `1.0.1-alpha` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `false` | `false` | `true` | `v1.0.1-alpha` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `false` | `true` | `false` | `1.0.1-alpha+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `false` | `true` | `true` | `v1.0.1-alpha+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `true` | `false` | `false` | `1.0.1-alpha` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `true` | `false` | `true` | `v1.0.1-alpha` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `true` | `true` | `false` | `1.0.1-alpha+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `false` | `true` | `true` | `true` | `v1.0.1-alpha+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `false` | `false` | `false` | `1.0.1-alpha.1` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `false` | `false` | `true` | `v1.0.1-alpha.1` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `false` | `true` | `false` | `1.0.1-alpha.1+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `false` | `true` | `true` | `v1.0.1-alpha.1+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `true` | `false` | `false` | `1.0.1-alpha.0` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `true` | `false` | `true` | `v1.0.1-alpha.0` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `true` | `true` | `false` | `1.0.1-alpha.0+124` | ✅ |
| `v1.0.0-rc.5+123` | `patch-alpha` | `true` | `true` | `true` | `true` | `v1.0.1-alpha.0+124` | ✅ |

[Back to README](../README.md)