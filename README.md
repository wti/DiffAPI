# DiffAPI: DRAFT library api platform diffing using swift-syntax
- API differences in Swift across platforms
- e.g., Foundation in Linux vs. MacOS

Confidential.  All Rights Reserved.  Bad dog!

## Status: DRAFT
- Using swift-syntax API digester
- minimal scripts and syntax walkers
- next: get linux files from installers

## Products
- [Package](Package.swift)

### Scripts
- [seekInterface](scripts/seekInterface.sh) to get module interface files
- [digestDiff](scripts/digestDiff.sh) to compare mac/linux module interfaces

### Library and CLI demo
- [DiffAPI](Sources/DiffAPI/DiffAPI.swift)
- [DiffAPIDemo](Sources/DiffAPIDemo/DiffAPIMain.swift)

