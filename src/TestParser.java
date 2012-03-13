import static org.junit.Assert.*;

import java.io.IOException;

import org.antlr.runtime.RecognitionException;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;


public class TestParser {
	private Main m;

	@Before 
	public void setUp() {
		m = new Main();
	}
	private String missingFile(String fileName) {
		return "test\\" + fileName + "not found";
	}
	
	@Test
	public void testParse() {
		try {
			m.parse("tests\\test1.txt");
		} catch (IOException e) {
			fail(missingFile("test1.txt"));
		} catch (RecognitionException e) {
			//success
			return;
		}
		fail("test\\test1.txt error not recognised");
	}
	
	
	//missing module ident after END
	@Test
	(expected = RecognitionException.class)
	public void testTrailingModuleIdent() throws RecognitionException{
		try {
			m.parse("tests\\test2.txt");
//			fail("test\\test2.txt missed missing ident after END");
		} catch (IOException e) {
			fail(missingFile("test2.txt"));
		}
	}
	
	@Test
	public void simpleOKTest() {
		try {
			m.parse("tests\\test3.txt");
		} catch (IOException e) {
			fail(missingFile("test3.txt"));
		} catch (RecognitionException e) {
			System.out.println(m.getErrorMessage(e));
			fail("test3.txt should be parsed normally");
			
		}
		//success
	}
	@Test
	public void simpleAssignmentTest() {
		try {
			m.parse("tests\\test4.txt");
		} catch (IOException e) {
			fail(missingFile("test4.txt"));
		} catch (RecognitionException e) {
			System.out.println(m.getErrorMessage(e));
			fail("test4.txt should be parsed normally");
			
		}
		//success
	}

}
