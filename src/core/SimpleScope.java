package core;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class SimpleScope {
	class Ints {
		int a;
		int b;
	}
	ArrayList<SimpleVar> varList;
	Map<String, SimpleVar> varMap;
	
	
	SimpleScope parentScope;
	
//	private List<String> defaultVars = new ArrayList<String>("INTEGER");
	static private String[] defaultVars = 
		{"INTEGER", "REAL", "BOOLEAN", "CHAR", "BYTE", "SHORTINT", "LONGINT", "LONGREAL"};
	
	static public SimpleScope getNewGlobalScope() {
		SimpleScope sc = new SimpleScope();
		sc.parentScope = null;
		for (String var : defaultVars) {
			sc.addVar(new SimpleVar(var));
		}
//		sc.addVar(new SimpleVar("INTEGER"));
		return sc;
	}
	public SimpleScope getParentScope() {
		return parentScope;
	}
	public void setParentScope(SimpleScope parentScope) {
		this.parentScope = parentScope;
	}
	
	public SimpleScope() {
		varList = new ArrayList<SimpleVar>();
		varMap = new HashMap<String, SimpleVar>();
	}
	public void addVar(SimpleVar var) {
		varList.add(var);
		varMap.put(var.getName(), var);
	}
	
	public boolean containsInside(String name) {
		return varMap.get(name) != null;
	}
	public boolean contains(String name) {
		return get(name) != null;
	}
	
	public SimpleVar getInside(String name) {
		return varMap.get(name);
	}
	public SimpleVar get(String name) {
		SimpleVar v = getInside(name);
		if (v != null)
			return v;
		if (parentScope != null)
			return parentScope.get(name);
		
		return null;
	}
	
	
}
