all: antlr4 javac

antlr4:
	java -jar /usr/local/lib/antlr-4.2.2-complete.jar webscript.g4 -o output

javac:
	javac output/*.java

clean:
	rm -f *.java
	rm -f *.class
