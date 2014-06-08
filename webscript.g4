grammar webscript;

tokens { INDENT, DEDENT }

@lexer::header {
  import com.yuvalshavit.antlr4.DenterHelper;
}


@lexer::members {
  private final DenterHelper denter = new DenterHelper(LineEnd,
                                                       webscriptParser.INDENT,
                                                       webscriptParser.DEDENT)
  {
    @Override
    public Token pullToken() {
      return webscriptLexer.super.nextToken();
    }
  };

  @Override
  public Token nextToken() {
    return denter.nextToken();
  }
}

program
	: elements? EOF
	;

elements
	: element+
	;

element
	: statement LineEnd
	| statement EOF
	| functionDeclaration LineEnd
	| functionDeclaration EOF
	;

/// Declaração de função.
functionDeclaration
	: 'function' Space Identifier '(' functionParameterList? ')' Space '{' INDENT functionBody DEDENT '}'
	;

/// Declaração dos parâmetros da função.
functionParameterList
	: Identifier ( ',' Identifier )*
	;

functionBody
	: elements?
	;

statement
	: variableDeclaration
	| empty
	| ifStatement
	| iteration
	| breakStatement
	| continueStatement
	| returnStatement
	| switchStatement
	| throwStatement
	| tryStatement
	| debuggerStatement
	;

/// Declaração do if.
ifStatement
	: If '(' expression ')' Space '{' elements? '}'
	;

/// Declaração dos comantos iteração.
iteration
	: While '(' expression ')' Space '{' elements? '}'
	| Do Space '{' INDENT elements? DEDENT '}' Space While '(' expression ')' ';'
	;

breakStatement
	:
	;

continueStatement
	:
	;

returnStatement
	: 'return' (Space expression)? ';'
	;

switchStatement
	:
	;

throwStatement
	:
	;

tryStatement
	:
	;

debuggerStatement
	:
	;

/// Linha vazia.
empty
	:
	;

/// Declaração de variável.
variableDeclaration
	: Var Space Identifier initialiser? ';'
	;

/// Inicialização de variável.
initialiser
	: Space '=' Space expression
	;

/* Declaração de uma expressão.
 *
 * Menor que segunda expressão
 * Maior que segunda expressão
 * Menor ou igual a segunda expressão
 * Maior ou igual a segunda expressão
 * Teste se expressões são iguais
 * Expressão de adição
 * Expressão de sibtração
 * Expressão de multiplicação
 * Expressão de divisão
 * Idenfificador
 * Literal
 */
expression
	: expression Space '<'  Space expression
	| expression Space '>'  Space expression
	| expression Space '<=' Space expression
	| expression Space '>=' Space expression
	| expression Space '==' Space expression
	| expression Space '+'  Space expression
	| expression Space '-'  Space expression
	| expression Space '*'  Space expression
	| expression Space '/'  Space expression
	| Identifier
	| literal
	;

literal
	: Decimal
	| String
	;

Decimal
	: '0' '.' DecimalDigit*
	| '.' DecimalDigit+
	| [1-9] DecimalDigit*
	;

fragment DecimalDigit
	: [0-9]
	;

String
	: '"' StringCharacter* '"'
	;

fragment StringCharacter
	: [A-Za-z0-9 ]
	;

/// Espaço em branco.
Space
	: ' '
	;

/// Final de linha.
LineEnd
	: ('\r'? '\n' ' '*)
	;

/// Tokens.
LessThan		: '<';
GraterThan		: '>';
LessThanEquals		: '<=';
GraterThanEquals	: '>=';
Equals			: '==';
Plus			: '+';
Minus			: '-';
Multiply		: '*';
Divide			: '/';
If			: 'if';
Var			: 'var';
Do			: 'do';
While			: 'while';

/// Identificadores.
Identifier
	: IdentifierStart IdentifierPart*
	;

fragment IdentifierStart
	: [A-Za-z]
	;

fragment IdentifierPart
	: [A-Za-z0-9]
	;
