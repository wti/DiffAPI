import DiffAPI

@main struct DiffAPIMain {
  public static func main() {
    do {
      try run()
    } catch {
      print("\(error)")
    }
  }
  public static func run() throws {
    let coreDir =
      "/Volumes/beta/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib/swift/CoreFoundation.swiftmodule/"
    let suffix = "apple-macos.swiftinterface"

    let base = "\(coreDir)/arm64e-\(suffix)"
    let delta = "\(coreDir)/x86_64-\(suffix)"
    try DiffAPIUtils.demo(base: base, delta: delta)
  }
}
