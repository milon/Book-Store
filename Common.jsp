<!-- Common -->

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "javax.servlet.http.*" %>

<%!
	static final String CRLF = "\r\n";

	static final int UNDEFINT = Integer.MIN_VALUE;

	static final int adText = 1;
	static final int adDate = 2;
	static final int adNumber = 3;
	static final int adSearch_ = 4;
	static final int ad_Search_ = 5;
	static final String appPath   ="/";

	//Database connection string

	static final String DBDriver  ="com.mysql.jdbc.Driver";
	static final String strConn   ="jdbc:mysql://localhost:3306/bookstore";
	static final String DBusername="root";
	static final String DBpassword="";

	public static String loadDriver(){
		String sErr = "";
		try{
			DriverManager.registerDriver((Driver)(Class.forName(DBDriver).newInstance()));
			}
		catch(Exception e){
			sErr = e.toString();
			}
		return(sErr);
		}

	public static void absolute(ResultSet rs, int row) throws SQLException{
		for(int x=1;x<row;x++) 
			rs.next();
		}

	ResultSet openrs(Statement stat, String sql) throws SQLException{
		ResultSet rs = stat.executeQuery(sql);
		return (rs);
		}

	String dLookUp(Statement stat, String table, String fName, String where){
		Connection conn1 = null;
		Statement stat1 = null;
		try{
			conn1 = cn();
			stat1 = conn1.createStatement();
			ResultSet rsLookUp = openrs( stat1, "SELECT " + fName + " FROM " + table + " WHERE " + where);
			if(!rsLookUp.next()){
				rsLookUp.close();
				stat1.close();
				conn1.close();
				return "";
				}
			String res = rsLookUp.getString(1);
			rsLookUp.close();
			stat1.close();
			conn1.close();
			return (res == null ? "" : res);
			}
		catch(Exception e){
			return "";
			}
		}

	long dCountRec(Statement stat, String table, String sWhere){
		long lNumRecs = 0;
		try{
			ResultSet rs = stat.executeQuery("select count(*) from " + table + " where " + sWhere);
			if(rs != null && rs.next()){
				lNumRecs = rs.getLong(1);
				}
			rs.close();
			}
		catch(Exception e){};
		return lNumRecs;
		}

	String proceedError(HttpServletResponse response, Exception e){
		return e.toString();
		}

	String[] getFieldsName(ResultSet rs ) throws SQLException{
		ResultSetMetaData metaData = rs.getMetaData();
		int count = metaData.getColumnCount();
		String[] aFields = new String[count];
		for(int j = 0; j < count; j++) {
			aFields[j] = metaData.getColumnLabel(j+1);
			}
		return aFields;
		}

	Hashtable getRecordToHash(ResultSet rs, Hashtable rsHash, String[] aFields) throws SQLException{
		for(int iF = 0; iF < aFields.length; iF++){
			rsHash.put( aFields[iF], getValue(rs, aFields[iF]));
			}
		return rsHash;
		}

	Connection cn() throws SQLException {
		return DriverManager.getConnection(strConn , DBusername, DBpassword);
		}

	String toURL(String strValue){
		if(strValue == null) 
			return "";
		if(strValue.compareTo("") == 0) 
			return "";
		return URLEncoder.encode(strValue);
		}

	String toHTML(String value){
		if(value == null) 
			return "";
		value = replace(value, "&", "&amp;");
		value = replace(value, "<", "&lt;");
		value = replace(value, ">", "&gt;");
		value = replace(value, "\"", "&" + "quot;");
		return value;
		}

	String getValueHTML(ResultSet rs, String fieldName){
		try{
			String value = rs.getString(fieldName);
			if(value != null){
				return toHTML(value);
				}
			}
		catch(SQLException sqle){}
		return "";
		}

	String getValue(ResultSet rs, String strFieldName){
		if((rs==null) ||(isEmpty(strFieldName)) || ("".equals(strFieldName))) 
			return "";
		try{
			String sValue = rs.getString(strFieldName);
			if(sValue == null) 
				sValue = "";
			return sValue;
			}
		catch(Exception e){
			return "";
			}
		}
  
	String getParam(HttpServletRequest req, String paramName) {
		String param = req.getParameter(paramName);
		if(param == null || param.equals("")) 
			return "";
		param = replace(param,"&amp;","&");
		param = replace(param,"&lt;","<");
		param = replace(param,"&gt;",">");
		param = replace(param,"&amp;lt;","<");
		param = replace(param,"&amp;gt;",">");
		return param;
		}

	boolean isNumber(String param){
		boolean result;
		if(param == null || param.equals("")) 
			return true;
		param=param.replace('d','_').replace('f','_');
		try{
			Double dbl = new Double(param);
			result = true;
			}
		catch(NumberFormatException nfe){
			result = false;
			}
		return result;
		}

	boolean isEmpty(int val){
		return val == UNDEFINT;
		}

	boolean isEmpty(String val){
		return (val==null || val.equals("")||val.equals(Integer.toString(UNDEFINT))); 
		}

	String getCheckBoxValue(String val, String checkVal, String uncheckVal, int ctype){
		if(val==null || val.equals("")) 
			return toSQL(uncheckVal, ctype);
		else 
			return toSQL(checkVal, ctype);
		}

	String toWhereSQL(String fieldName, String fieldVal, int type){
		String res = "";
		switch(type){
			case adText: 
				if(!"".equals(fieldVal)){
					res = " " + fieldName + " like '%" + fieldVal + "%'";
					}
			
			case adNumber:
				res = " " + fieldName + " = " + fieldVal + " ";
      
			case adDate:
				res = " " + fieldName + " = '" + fieldVal + "' ";
			
			default:
				res = " " + fieldName + " = '" + fieldVal + "' ";
			}
		return res;
		}

	String toSQL(String value, int type){
		if(value == null) 
			return "Null";
		String param = value;
		if("".equals(param) && (type == adText || type == adDate)){
			return "Null";
			} 
		switch(type){
			case adText:
				{
				param = replace(param, "'", "''");
				param = replace(param, "&amp;", "&");
				param = "'" + param + "'";
				break;
				}
			
			case adSearch_:
			case ad_Search_: 
				{
				param = replace(param, "'", "''");
				break;
				}
			case adNumber: 
				{
				try{
					if(!isNumber(value) || "".equals(param)) 
						param="null";
					else 
						param = value;
					}
				catch(NumberFormatException nfe){
					param = "null";
					}
				break;
				}
				
			case adDate: 
				{
				param = "'" + param + "'";
				break;      
				}
			}
		return param;
		}

	private String replace(String str, String pattern, String replace){
		if(replace == null){
			replace = "";
			}
		int s = 0, e = 0;
		StringBuffer result = new StringBuffer((int) str.length()*2);
		while((e = str.indexOf(pattern, s)) >= 0){
			result.append(str.substring(s, e));
			result.append(replace);
			s = e + pattern.length();
			}
		result.append(str.substring(s));
		return result.toString();
		}

	String getOptions(Connection conn, String sql, boolean isSearch, boolean isRequired, String selectedValue ) {
		String sOptions = "";
		String sSel = "";

		if(isSearch){
			sOptions += "<option value=\"\">All</option>";
			}
		else{
			if(!isRequired){
				sOptions += "<option value=\"\"></option>";
				}
			}
		
		try{
			Statement stat = conn.createStatement();
			ResultSet rs = null;
			rs = openrs (stat, sql);
			while(rs.next()){
				String id = toHTML( rs.getString(1) );
				String val = toHTML( rs.getString(2) );
				if(id.compareTo(selectedValue) == 0 ) {
					sSel = "SELECTED";
					}
				else{
					sSel = "";
					}
				sOptions += "<option value=\""+id+"\" "+sSel+">"+val+"</option>";
				}
			rs.close();
			stat.close();
			}
		catch(Exception e){}
		return sOptions;
		}

	String getOptionsLOV(String sLOV, boolean isSearch, boolean isRequired, String selectedValue){
		String sSel = "";
		String slOptions = "";
		String sOptions = "";
		String id = "";
		String val = "";
		StringTokenizer LOV = new StringTokenizer(sLOV, ";", true);
		int i = 0;
		String old = ";";
		while(LOV.hasMoreTokens()){
			id = LOV.nextToken();
			if(!old.equals(";") && (id.equals(";"))){
				id = LOV.nextToken();
				}
			else{
				if(old.equals(";") && ( id.equals(";"))){
					id = "";
					}
				}
			if(!id.equals("")){ 
				old = id; 
				}
			i++;
			
			if(LOV.hasMoreTokens()){
				val = LOV.nextToken();
				if(!old.equals(";") && (val.equals(";"))){
					val = LOV.nextToken();
					}
				else{
					if(old.equals(";") && (val.equals(";"))){
						val = "";
						}
					}
				if(val.equals(";")){ 
					val = "";
					}
				if(!val.equals("")){ 
					old = val; 
					}
				i++;
				}
				
			if(id.compareTo(selectedValue) == 0){
				sSel = "SELECTED";
				}
			else{
				sSel = "";
				}
				
			slOptions += "<option value=\""+id+"\" "+sSel+">"+val+"</option>";
			}
		if((i%2) == 0) 
			sOptions += slOptions;
		return sOptions;
		}

	String getValFromLOV(String selectedValue, String sLOV){
		String sRes = "";
		String id = "";
		String val = "";
		StringTokenizer LOV = new StringTokenizer(sLOV, ";", true);
		int i = 0;
		String old = ";";
		while(LOV.hasMoreTokens()){
			id = LOV.nextToken();
			if(!old.equals(";") && (id.equals(";"))){
				id = LOV.nextToken();
				}
			else{
				if(old.equals(";") && ( id.equals(";"))){
					id = "";
					}
				}
			if(!id.equals("")){ 
				old = id; 
				}
			i++;

			if(LOV.hasMoreTokens()){
				val = LOV.nextToken();
				if(!old.equals(";") && (val.equals(";"))){
					val = LOV.nextToken();
					}
				else{
					if(old.equals(";") && (val.equals(";"))){
						val = "";
						}
					}
				if(val.equals(";")){ 
					val = ""; 
					}
				if(!val.equals("")){ 
					old = val; 
					}
				i++;
				}
				
			if(id.compareTo( selectedValue ) == 0){
				sRes = val;
				}
			}
		return sRes;
		}

	String checkSecurity(int iLevel, HttpSession session, HttpServletResponse response, HttpServletRequest request){
		try{
			Object o1 = session.getAttribute("UserID");
			Object o2 = session.getAttribute("UserRights");
			boolean bRedirect = false;
			
			if(o1 == null || o2 == null){ 
				bRedirect = true; 
				}
				
			if(!bRedirect){
				if((o1.toString()).equals("")){ 
					bRedirect = true; 
					}
				else if((new Integer(o2.toString())).intValue() < iLevel){ 
					bRedirect = true; 
					}
				}

			if(bRedirect){
				response.sendRedirect("Login.jsp?querystring=" + toURL(request.getQueryString()) + "&ret_page=" + toURL(request.getRequestURI()));
				return "sendRedirect";
				}
			}
		catch(Exception e){};
		return "";
		}

%>
