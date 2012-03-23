package tests;
import static org.junit.Assert.*;
import static tests.TestsHelper.*;

import java.io.IOException;
import java.util.ArrayList;

import org.antlr.runtime.RecognitionException;
import org.junit.Before;
import org.junit.Test;

import core.Main;

import exceptions.AmbiguousIdException;
import exceptions.MissingVariableException;


public class TestScopes {
	private Main m;
	static private String testsPath = "tests\\scopeTests\\";
	
	static private void printErrorMessage(Main m, int i) {
		System.out.println(m.getErrors().get(i).getMessage());
	}
	
//	static protected String makeFilename(String path, int num) {
//		return path + "test" + num + ".ob2";
//	}
	
	@Before 
	public void setUp() {
		m = new Main();
	}
	
//	protected void runParse(Main m, String filename) {
//		try {
//			m.parse(filename);
//		} catch (IOException e) {
//			fail("missing file " + filename);
//		} catch (RecognitionException e) {
//			fail("File has correct syntax");
//		}
//	}
	
//	protected void onlyOneException(Main m, Class exc) {
//		assertEquals(1, m.getErrorCount());
//		assertTrue(exc.isInstance(m.getErrors().get(0)));
//	}

	@Test
	public void repeatVarDeclaration() {
		String filename = makeFilename(testsPath, 1);
		runParse(m, filename);
		
		onlyOneException(m, AmbiguousIdException.class);
	}
	@Test
	public void assignmentWithDeclaredVar() {
		String filename = makeFilename(testsPath, 2);
		runParse(m, filename);
		
		assertEquals(0, m.getErrorCount());
	}
	@Test
	public void test3() {
		String filename = makeFilename(testsPath, 3);
		runParse(m, filename);
		assertEquals(0, m.getErrorCount());
	}
	@Test
	public void test4() {
		String filename = makeFilename(testsPath, 4);
		runParse(m, filename);
		
		onlyOneException(m, AmbiguousIdException.class);
	}
	@Test
	public void test5() {
		String filename = makeFilename(testsPath, 5);
		runParse(m, filename);
		assertEquals(0, m.getErrorCount());
	}
	
	@Test
	public void test6() {
		String filename = makeFilename(testsPath, 6);
		runParse(m, filename);
		onlyOneException(m, AmbiguousIdException.class);
	}
	
	@Test
	//access to variables declared outside and inside procedure 
	public void test7() {
		String filename = makeFilename(testsPath, 7);
		runParse(m, filename);

		assertEquals(0, m.getErrorCount());
	}
	
	@Test
	//single undeclared variable inside procedure 
	public void test8() {
		String filename = makeFilename(testsPath, 8);
		runParse(m, filename);

		onlyOneException(m, MissingVariableException.class);
	}
	
	@Test
	//access to variables declared outside and inside procedure 
	public void test9() {
		String filename = makeFilename(testsPath, 9);
		runParse(m, filename);

		assertEquals(0, m.getErrorCount());
	}
	
}
