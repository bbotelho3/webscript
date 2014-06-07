all: antlr4 javac

antlr4:
	antlr4 webscript.g4 -o output

javac:
	javac output/*.java

clean:
	rm -f *.java
	rm -f *.class
