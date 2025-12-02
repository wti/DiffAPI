import Foundation
import SwiftParser
// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftSyntax

public enum DiffAPIUtils {
  /// Print API's only in base or delta
  /// - Parameters:
  ///   - base: String path to swiftinterface for baseline
  ///   - delta: String path to swiftinterface for change
  public static func demo(base: String, delta: String) throws {
    let baseInterface = try parseSwiftInterface(at: base)
    let deltaInterface = try parseSwiftInterface(at: delta)

    let baseExtractor = APIExtractor(viewMode: .fixedUp)
    let deltaExtractor = APIExtractor(viewMode: .fixedUp)

    baseExtractor.walk(baseInterface)
    deltaExtractor.walk(deltaInterface)

    // Compare the extracted APIs
    let baseAPIs = Set(baseExtractor.publicDeclarations)
    let deltaAPIs = Set(deltaExtractor.publicDeclarations)

    let onlyInBase = baseAPIs.subtracting(deltaAPIs)
    let onlyInDelta = deltaAPIs.subtracting(baseAPIs)
    let common = baseAPIs.intersection(deltaAPIs)

    print("APIs in common: \(common.count)")
    print("APIs in base: \(onlyInBase.count)/\(baseAPIs.count)")
    print("APIs in delta: \(onlyInDelta.count)/\(deltaAPIs.count)")
  }

  // Read and parse a .swiftinterface file
  static func parseSwiftInterface(at path: String) throws -> SourceFileSyntax {
    let content = try String(contentsOfFile: path)
    return Parser.parse(source: content)
  }

  static func isPublic(_ kind: TokenKind) -> Bool {
    kind == .keyword(.public)
  }

  static func isPublicClass(_ kind: TokenKind) -> Bool {
    kind == .keyword(.public) || kind == .keyword(.open)
  }

  // Extract public API declarations
  class APIExtractor: SyntaxVisitor {
    private typealias Utils = DiffAPIUtils
    var publicDeclarations: [String] = []
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind
    {
      if node.modifiers.contains(where: { Utils.isPublic($0.name.tokenKind) }) {
        publicDeclarations.append(node.description)
      }
      return .visitChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
      if node.modifiers.contains(
        where: { Utils.isPublicClass($0.name.tokenKind) })
      {
        publicDeclarations.append(node.description)
      }
      return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
      if node.modifiers.contains(where: { Utils.isPublic($0.name.tokenKind) }) {
        publicDeclarations.append(node.description)
      }
      return .visitChildren
    }
  }
}
