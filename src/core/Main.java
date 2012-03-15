package core;

import generated.OberonLexer;
import generated.OberonParser;

import java.io.IOException;
import java.util.ArrayList;

import org.antlr.runtime.ANTLRFileStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.tree.CommonTree;


public class Main {
	private OberonParser currentParser = null;
	
	
//	public String getErrorMessage(RecognitionException e) {
//		return "line: " + e.line + " : " + 
//			currentParser.getErrorMessage(e, currentParser.getTokenNames()); 
//	}
	
	public int getErrorCount() {
		return currentParser.getErrorsNumber();
	}
	
	public ArrayList<RecognitionException> getErrors() {
		return currentParser.getErrors();
	}

	public void parse(String filePath) throws IOException, RecognitionException{
		CharStream input = null;
		input = new ANTLRFileStream(filePath);

		OberonLexer lex = new OberonLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lex);
		currentParser = new OberonParser(tokens);
		currentParser.obmodule();
	}
	public static void main(String[] args) throws RecognitionException, IOException{
		Main m = new Main();
		try {
			m.parse(args[0]);
		} catch (IndexOutOfBoundsException e) {
			System.out.println("One argument with file name expected");
		}
	}

}
