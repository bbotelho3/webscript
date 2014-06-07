grammar webscript;

program
	: elements? EOF
	;

elements
	: element+
	;

element
	: statement
	;

statement
	: variable
	;

variable
	: "var" identifier ";"
	;

identifier
	: IdentifierStart IdentifierPart*

fragment IdentifierStart
	: [A-Za-z]
	;

fragment IdentifierPart
	: [A-Za-z0-9]
	;