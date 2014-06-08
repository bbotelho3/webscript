grammar webscript;

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

Var : 'var';

functionDeclaration
	: 'function' Space Identifier '(' functionParameterList? ')' Space '{' functionBody '}'
	;

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

ifStatement
	: 'if' '(' expression ')' Space '{' statement '}'
	;

iteration
	:
	;

breakStatement
	:
	;

continueStatement
	:
	;

returnStatement
	: 'return' Space expression ';'
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
	: expression '<' expression
	| expression '>' expression
	| expression '<=' expression
	| expression '>=' expression
	| expression '==' expression
	| expression '+' expression
	| expression '-' expression
	| expression '*' expression
	| expression '/' expression
	| Identifier
	| literal
	;

literal
	: Decimal
	| String
	;

String
	: '"' StringCharacter* '"'
	;

Space
	: ' '
	;

LineEnd
	: [\r\n]
	;

fragment StringCharacter
	: [A-Za-z0-9 ]
	;

Decimal
	: '0' '.' DecimalDigit*
	| '.' DecimalDigit+
	| [1-9] DecimalDigit*
	;

fragment DecimalDigit
	: [0-9]
	;

Identifier
	: IdentifierStart IdentifierPart*
	;

fragment IdentifierStart
	: [A-Za-z]
	;

fragment IdentifierPart
	: [A-Za-z0-9]
	;
