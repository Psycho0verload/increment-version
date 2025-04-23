# 🧪 Expected behavior

| current-version | version-type | preversion | preversion-start-zero | use-build | prefix | Result | Status |
|-----------------|--------------|------------|------------------------|-----------|--------|--------|--------|
| `v1.0.0` | `patch` | `false` | `false` | `false` | `false` | `1.0.1` | ✅ |
| `v1.0.0` | `patch` | `false` | `false` | `false` | `true` | `v1.0.1` | ✅ |
| `v1.0.0` | `patch` | `false` | `false` | `true` | `false` | `1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `false` | `false` | `true` | `true` | `v1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `false` | `true` | `false` | `false` | `1.0.1` | ✅ |
| `v1.0.0` | `patch` | `false` | `true` | `false` | `true` | `v1.0.1` | ✅ |
| `v1.0.0` | `patch` | `false` | `true` | `true` | `false` | `1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `false` | `true` | `true` | `true` | `v1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `true` | `false` | `false` | `false` | `1.0.1` | ✅ |
| `v1.0.0` | `patch` | `true` | `false` | `false` | `true` | `v1.0.1` | ✅ |
| `v1.0.0` | `patch` | `true` | `false` | `true` | `false` | `1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `true` | `false` | `true` | `true` | `v1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `true` | `true` | `false` | `false` | `1.0.1` | ✅ |
| `v1.0.0` | `patch` | `true` | `true` | `false` | `true` | `v1.0.1` | ✅ |
| `v1.0.0` | `patch` | `true` | `true` | `true` | `false` | `1.0.1+1` | ✅ |
| `v1.0.0` | `patch` | `true` | `true` | `true` | `true` | `v1.0.1+1` | ✅ |

[Back to README](../README.md)