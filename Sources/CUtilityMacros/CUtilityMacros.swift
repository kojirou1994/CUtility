import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

struct SimpleDiagnosticMessage: DiagnosticMessage, Error {
  let message: String
  let diagnosticID: MessageID
  let severity: DiagnosticSeverity
}

extension SimpleDiagnosticMessage: FixItMessage {
  var fixItID: MessageID { diagnosticID }
}

enum CustomError: Error, CustomStringConvertible {
  case message(String)

  var description: String {
    switch self {
    case .message(let text):
      return text
    }
  }
}

/*
 from
 static func copy(cString: String) -> Self {
 .init(cString: strdup(cString))
 }

 to
 static func copy(cString: some CStringConvertible) -> Self {
   cString.withUnsafeCString { cString in
     .init(cString: strdup(cString))
   }
 }
 */
public struct CStringGenericMacro: PeerMacro {
  public static func expansion<
    Context: MacroExpansionContext,
    Declaration: DeclSyntaxProtocol
  >(
    of node: AttributeSyntax,
    providingPeersOf declaration: Declaration,
    in context: Context
  ) throws -> [DeclSyntax] {
    // Only on functions at the moment. We could handle initializers as well
    // with a bit of work.
    guard var funcDecl = declaration.as(FunctionDeclSyntax.self) else {
      throw CustomError.message("@addCompletionHandler only works on functions")
    }

    let parameterList = funcDecl.signature.parameterClause.parameters
    let needThrows = funcDecl.signature.effectSpecifiers?.throwsClause != nil
    let tryString = needThrows ? "try " : ""

    var newParameterList = parameterList
    newParameterList = []
    var parameterNames = [TokenSyntax]()
    for idx in parameterList.indices {
      var param = parameterList[idx]
      if param.type.description == "String" {
        parameterNames.append(param.secondName ?? param.firstName)
        param.type = "some CStringConvertible"
      }
      newParameterList.append(param)
    }

    let headers = parameterNames.map { "\($0).withUnsafeCString { \($0) in" }.joined(separator: "\n")
    let trailers = String(repeating: "}", count: parameterNames.count)
    let newBody: ExprSyntax =
      """
        \(raw: tryString)\(raw: headers)
          return \(raw: tryString)\(funcDecl.body!)()
        \(raw: trailers)
      """

    // Drop the @addCompletionHandler attribute from the new declaration.
    let newAttributeList = funcDecl.attributes.filter {
      guard case let .attribute(attribute) = $0,
            let attributeType = attribute.attributeName.as(IdentifierTypeSyntax.self),
            let nodeType = node.attributeName.as(IdentifierTypeSyntax.self)
      else {
        return true
      }

      return attributeType.name.text != nodeType.name.text
    }

    // replace parameter
    funcDecl.signature.parameterClause.parameters = newParameterList

    funcDecl.body = CodeBlockSyntax(
      leftBrace: .leftBraceToken(leadingTrivia: .space),
      statements: CodeBlockItemListSyntax(
        [CodeBlockItemSyntax(item: .expr(newBody))]
      ),
      rightBrace: .rightBraceToken(leadingTrivia: .newline)
    )

    funcDecl.attributes = newAttributeList

    return [DeclSyntax(funcDecl)]
  }
}

@main
struct CUtilityMacros: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CStringGenericMacro.self,
  ]
}
