all: antlr4 javac

antlr4:
	antlr4 webscript.g4 -o output

javac:
	javac -classpath lib/antlr-denter-1.2-SNAPSHOT.jar:/usr/local/Cellar/antlr/4.2/antlr-4.2-complete.jar:. output/*.java

clean:
	rm -f output/*.java
	rm -f output/*.class
	rm -f output/*.tokens
