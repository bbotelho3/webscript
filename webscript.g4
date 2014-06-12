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

@parser::header {
	import java.util.Map;

	import edu.unisinos.tradutores.webscript.SymbolTable;
	import edu.unisinos.tradutores.webscript.ValueType;
	import edu.unisinos.tradutores.webscript.Symbol;
}

@parser::members {
	final SymbolTable symTab = new SymbolTable();

	void printUnusedVariables(String scope) {
		Iterator it = symTab.currentScope().symbolMap.entrySet().iterator();
		
		while (it.hasNext()){
   			Map.Entry<String, Symbol> entry = (Map.Entry<String, Symbol>)it.next();
   			Symbol symbol = (Symbol)entry.getValue();
   			if (!symbol.isUsed() && symbol.getType() != ValueType.PARAMETER) {
   				System.out.println("Warning: " + symbol.getType() + " " + symbol.getName() + " declared but not used in " + scope + ".");
   			}
		}
	}
}

program
	: elements? EOF 
	{
		//System.out.println("Symbol table: " + symTab.toString());

		printUnusedVariables("global scope");
	}
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
	: 
	{ 	
		symTab.pushScope();
	}
	'function' Space Identifier '(' functionParameterList? ')' Space '{' INDENT functionBody DEDENT '}'
	{ 
		symTab.currentScope().enclosingScope().define($Identifier.text, ValueType.FUNCTION);

	 	printUnusedVariables("function " + $Identifier.text);

		symTab.popScope();
	}
	;

/// Declaração dos parâmetros da função.
functionParameterList
	: ids+=Identifier ( ',' ids+=Identifier )*
	{ 
		for(Token t : $ids) {
			symTab.currentScope().define(t.getText(), ValueType.PARAMETER); 
		}
	}
	;

functionCallParameterList
	: ids+=Identifier ( ',' ids+=Identifier )*
	{ 
		for(Token t : $ids) {
			Symbol s = symTab.currentScope().resolve(t.getText());
			if (s != null) {
				s.setUsed();
			} else {
				System.out.println("Warning: VARIABLE " + t.getText() + " used but not declared.");
			}	
		}
	}
	;

functionBody
	: elements?
	;

statement
	: empty
	| variableDeclaration
	| assignmentDeclaration
	| ifStatement
	| iteration
	| breakStatement
	| continueStatement
	| returnStatement
	| switchStatement
	| functionCallStatement
	;

functionCallStatement
	: functionCall
	| Identifier Space '=' Space functionCall
	;

functionCall
	: Identifier '(' functionCallParameterList? ')' ';'
	{
		Symbol s = symTab.currentScope().resolve($Identifier.text);
		
		if (s != null) {
			s.setUsed();
		} else {
			System.out.println("Warning: FUNCTION " + $Identifier.text + " used but not specified.");
		}
	}
	;

/// Declaração do if.
ifStatement
	: If '(' expression ')' Space '{' INDENT elements? DEDENT '}'
	;

/// Declaração dos comantos iteração.
iteration
	: While '(' expression ')' Space '{' INDENT elements? DEDENT '}'
	| Do Space '{' INDENT elements? DEDENT '}' Space While '(' expression ')' ';'
	;

assignmentDeclaration
	: Identifier Space '=' Space expression ';'
	{
		Symbol s = symTab.currentScope().resolve($Identifier.text);
		if (s != null) {
			s.setUsed();
		} else {
			System.out.println("Warning: VARIABLE " + $Identifier.text + " used but not declared.");
		}	
	}
	;

breakStatement
	: Break ';'
	;

continueStatement
	: Continue ';'
	;

returnStatement
	: 'return' (Space expression)? ';'
	;

switchStatement
	: Switch '(' expression ')' Space caseBlock
	;

caseBlock
	: '{' INDENT caseClauses? ( defaultClause caseClauses? )? DEDENT '}'
	;

caseClauses
	: caseClause+
	;

caseClause
	: Case Space expression ':' INDENT elements? DEDENT
	;

defaultClause
	: Default ':' INDENT elements? DEDENT
	;

/// Linha vazia.
empty
	:
	;

/// Declaração de variável.
variableDeclaration
	: Var Space Identifier initializer? ';' 
	{	
		Symbol s = symTab.currentScope().resolve($Identifier.text);
		
		if (s != null) {
			System.out.println("Warning: redefinition of VARIABLE " + $Identifier.text + ".");
		}

		symTab.currentScope().define($Identifier.text, ValueType.VARIABLE);
	}
	;

/// Inicialização de variável.
initializer
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
	{
		Symbol s = symTab.currentScope().resolve($Identifier.text);
		if (s != null) {
			s.setUsed();
		} else {
			System.out.println("Warning: VARIABLE " + $Identifier.text + " used but not declared.");
		}	
	}
	| expression '.' Identifier
	| literal
	| arrayLiteral
	| expression '[' expression ']'
	;

arrayLiteral
	: '[' expression? ( ',' Space expression )* ']'
	;

literal
	: Decimal
	| String
	;

Decimal
	: '0' '.' DecimalDigit*
	| '.' DecimalDigit+
	| [1-9] DecimalDigit*
	| '0'
	;

fragment DecimalDigit
	: [0-9]
	;

String
	: '"' StringCharacter* '"'
	;

fragment StringCharacter
	: ~["\\\r\n]
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
LessThan         : '<';
GraterThan       : '>';
LessThanEquals   : '<=';
GraterThanEquals : '>=';
Equals			 : '==';
Plus			 : '+';
Minus			 : '-';
Multiply		 : '*';
Divide			 : '/';
If			     : 'if';
Var			     : 'var';
Do			     : 'do';
While			 : 'while';
Break            : 'break';
Continue         : 'continue';
Switch           : 'switch';
Case             : 'case';
Default          : 'default';

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
