package tests;
import static org.junit.Assert.*;
import static tests.TestsHelper.*;


import java.io.IOException;

import org.antlr.runtime.RecognitionException;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import core.Main;


import exceptions.RRException;

public class TestParser{
	private Main m;
	private String testsPath = "tests\\";

	@Before 
	public void setUp() {
		m = new Main();
	}
	
	private String missingFile(String fileName) {
		return "test\\" + fileName + "not found";
	}
	
	@Test
	public void testParse() {
		String filename = TestsHelper.makeFilename(testsPath, 1);
		runParse(m, filename);
		
		onlyOneException(m, RRException.class);
	}
	
	
	//missing module ident after END
	@Test
	public void testTrailingModuleIdent() throws RecognitionException{
		String filename = makeFilename(testsPath, 2);
		runParse(m, filename);
		
		onlyOneException(m, RRException.class);
	}
	
	@Test
	public void simpleOKTest() {
		String filename = makeFilename(testsPath, 3);
		runParse(m, filename);
		
		assertEquals(0, m.getErrorCount());
	}
	
	@Test
	public void simpleAssignmentTest() {
		String filename = makeFilename(testsPath, 3);
		runParse(m, filename);
		
		assertEquals(0, m.getErrorCount());
	}

}
