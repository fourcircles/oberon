package tests;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.IOException;

import org.antlr.runtime.RecognitionException;

import core.Main;


public class TestsHelper {
	static public void runParse(Main m, String filename) {
		try {
			m.parse(filename);
		} catch (IOException e) {
			fail("missing file " + filename);
		} catch (RecognitionException e) {
			fail("File has correct syntax");
		}
	}
	
	static public void onlyOneException(Main m, Class exc) {
		assertEquals(1, m.getErrorCount());
		assertTrue(exc.isInstance(m.getErrors().get(0)));
	}
	static public String makeFilename(String path, int num) {
		return path + "test" + num + ".ob2";
	}
	

}
