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

functionDeclaration
	: 'function' Space Identifier '(' functionParameterList? ')' Space '{' functionBody '}'
	;

functionParameterList
	:
	;

functionBody
	: elements?
	;

statement
	: variable
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
	:
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
	:
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
variable
	: 'var' Space Identifier initialiser? ';'
	;

/// Inicialização de variável.
initialiser
	: Space '=' Space expression
	;

expression
	: Identifier
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