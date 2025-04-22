# Increment Version
This GitHub action automates semantic versioning and release creation for your projects. It supports different release types, pre-release labels and build numbers.

## Features ✨
- SemVer 2.0 compatible (MAJOR.MINOR.PATCH-PRERELEASE+BUILD)
- Release types: major, minor, patch, alpha, beta, rc, stable
- Combined releases (e.g. major-alpha, patch-rc)
- Automatic build numbers (optional)
- Strict pre-versioning (e.g. consecutive numbers for pre-releases)
- Build-only updates (without version change)

## Inputs

### `current-version`  
**Required** Current semantic version to increment  
- Format: `[v]X.Y.Z[-PRERELEASE][+BUILD]`  
- Examples: `1.0.0`, `v2.5.0-rc.4`, `3.0.0-alpha+567`

### `version-type`  
**Required** Type of version increment:  

| Category        | Values                                                                |
|-----------------|-----------------------------------------------------------------------|
| **Version Bumps** | `major`, `minor`, `patch`                                           |
| **Pre-Releases**  | `alpha`, `beta`, `pre`, `rc`, `stable`                              |
| **Combined Types**| `patch-alpha`, `minor-beta`, `major-rc` etc.                        |
| **Special**       | `none` (only build number)                                          |

**Notes:**  
- **Combined Types:** All version bumps can be combined with pre-release types.  
- **Additional Types:** `hotfix`, `bug`, and `feature` are also supported. While they are not part of the SemVer standard, they can be useful for specific user scenarios.

### `preversion`  
*Optional* `[true|false]` Default: `true`  
Controls pre-release numbering behavior:  

| Value  | Behavior                                                                 |
|--------|--------------------------------------------------------------------------|
| `true` | Always use `.N` numbering (even first pre-release)                       |
| `false`| First pre-release without number, subsequent get `.1`, `.2`, etc.        |

### `preversion-start-zero`  
*Optional* `[true|false]` Default: `false`  
Sets starting index for pre-release versions:  
- `true`: Start counting at `.0` (e.g., `-alpha.0`)  
- `false`: Start counting at `.1` (e.g., `-beta.1`)  

### `use-build`  
*Optional* `[true|false]` Default: `false`  
Enables build counter stored in `.build-version` file:  
- `true`: Appends `+N` where N auto-increments  
- `false`: No build number added  

### `prefix`
*Optional* `[true|false]` Default: `false`
Determines whether a `v` prefix is prepended to the version number:  
- `true`: The version number is prefixed with a `v` (e.g. `v1.0.0`)  
- `false`: The version number is shown without a `v` prefix (e.g. `1.0.0`)

**Notes:**
Adding a `v` prefix does not conform to the Semantic Versioning 2.0.0 specification as outlined on [semver.org](https://semver.org/). Although commonly used, the `v` prefix is not part of the official SemVer definition. Nevertheless, it has been included here due to its widespread usage.

## Outputs

### `next-version`  
The generated version in SemVer format, depending on the provided parameters:  
`X.Y.Z[-PRERELEASE][+BUILD]`

## Usage Examples

### Basic Version Bumps

```yaml
- uses: psycho0verload/increment-version@latest
  with:
    current-version: '1.2.3'
    version-type: 'major'
```
The Basic example is the simplest form of usage. The expected result is: `2.0.0`.