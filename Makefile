all: antlr4 javac

antlr4:
	antlr4 ECMAScript.g4

javac:
	javac *.java
