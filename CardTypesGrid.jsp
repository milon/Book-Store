<!-- CardTypesGrid -->

<%@ include file="Common.jsp" %>

<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.jsp.JspWriter" %>
<%@ page import = "javax.servlet.http.HttpSession"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "javax.servlet.http.HttpServletResponse" %>

<%! static final String sFileName = "CardTypesGrid.jsp"; %>

<%
	String cSec = checkSecurity(2, session, response, request);
	if("sendRedirect".equals(cSec)) 
		return;
					
	boolean bDebug = false;

	String sAction = getParam( request, "FormAction");
	String sForm = getParam( request, "FormName");
	String sCardTypesErr = "";

	Connection conn = null;
	Statement stat = null;
	String sErr = loadDriver();

	conn = cn();
	stat = conn.createStatement();

	if(!sErr.equals("")){
		try{
			out.println(sErr);
			}
		catch(Exception e){}
		}
%>            

<html>

	<head>
		<title>Online Book Store</title>
		<meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="expires" content="0"/>
		<meta http-equiv="cache-control" content="no-cache"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>

	<body style="background-color: #FFFFFF; color: #000000; font-family: Arial, Tahoma, Verdana, Helveticabackground-color: #FFFFFF; color: #000000; font-family: Arial, Tahoma, Verdana, Helvetica">
		<jsp:include page="Header.jsp" flush="true"/>
		<table>
			<tr>
				<td valign="top">
					<% CardTypes_Show(request, response, session, out, sCardTypesErr, sForm, sAction, conn, stat); %>
				</td>
			</tr>
		</table>

		<jsp:include page="Footer.jsp" flush="true"/>
	</body>

</html>

<%
	if(stat != null)
		stat.close();
	if(conn != null) 
		conn.close();
%>

<%!
	void CardTypes_Show(HttpServletRequest request, HttpServletResponse response, HttpSession session, JspWriter out, String sCardTypesErr, String sForm, String sAction, Connection conn, Statement stat) throws IOException{
		String sWhere = "";
		int iCounter=0;
		int iPage = 0;
		boolean bIsScroll = true;
		boolean hasParam = false;
		String sOrder = "";
		String sSQL="";
		String transitParams = "";
		String sQueryString = "";
		String sPage = "";
		int RecordsPerPage = 20;
		String sSortParams = "";
		String formParams = "";

		// Build WHERE statement
        
		// Build ORDER statement
		sOrder = " order by c.name Asc";
		String sSort = getParam( request, "FormCardTypes_Sorting");
		String sSorted = getParam( request, "FormCardTypes_Sorted");
		String sDirection = "";
		String sForm_Sorting = "";
		int iSort = 0;
		try {
			iSort = Integer.parseInt(sSort);
			}
		catch(NumberFormatException e){
			sSort = "";
			}
		if(iSort == 0){
			sForm_Sorting = "";
			}
		else{
			if(sSort.equals(sSorted)){ 
				sSorted="0";
				sForm_Sorting = "";
				sDirection = " DESC";
				sSortParams = "FormCardTypes_Sorting=" + sSort + "&FormCardTypes_Sorted=" + sSort + "&";
				}
			else{
				sSorted=sSort;
				sForm_Sorting = sSort;
				sDirection = " ASC";
				sSortParams = "FormCardTypes_Sorting=" + sSort + "&FormCardTypes_Sorted=" + "&";
				}
			if(iSort == 1){
				sOrder = " order by c.name" + sDirection; 
				}
			}
  
		// Build full SQL statement
		sSQL = "select c.card_type_id as c_card_type_id, " +
				"c.name as c_name from card_types c ";
		sSQL = sSQL + sWhere + sOrder;
		
		String sNoRecords = "<tr>\n <td colspan=\"1\" style=\"background-color: #FFFFFF; border-width: 1\"><font style=\"font-size: 10pt; color: #000000\">No records</font></td>\n </tr>";
		String tableHeader = "";
		tableHeader = "<tr>\n <td style=\"background-color: #FFFFFF; border-style: inset; border-width: 0\"><a href=\""+sFileName+"?"+formParams+"FormCardTypes_Sorting=1&FormCardTypes_Sorted="+sSorted+"&\"><font style=\"font-size: 10pt; color: #CE7E00; font-weight: bold\">Name</font></a></td>\n </tr>";
  
		try {
			out.println("<table style=\"\">");
			out.println("<tr>\n <td style=\"background-color: #336699; text-align: Center; border-style: outset; border-width: 1\" colspan=\"1\"><a name=\"CardTypes\"><font style=\"font-size: 12pt; color: #FFFFFF; font-weight: bold\">Card Types</font></a></td>\n </tr>");
			out.println(tableHeader);
			}
		catch(Exception e){}

		try {
			java.sql.ResultSet rs = null;
			
			// Open recordset
			rs = openrs( stat, sSQL);
			iCounter = 0;
    
			Hashtable rsHash = new Hashtable();
			String[] aFields = getFieldsName( rs );

			// Show main table based on recordset
			while(rs.next()){
				getRecordToHash( rs, rsHash, aFields );
				String fldname = (String) rsHash.get("c_name");
				out.println("<tr>");
				out.print("<td style=\"background-color: #FFFFFF; border-width: 1\">"); 
				out.print("<a href=\"CardTypesRecord.jsp?"+transitParams+"card_type_id="+toURL((String) rsHash.get("c_card_type_id"))+"&\"><font style=\"font-size: 10pt; color: #000000\">"+toHTML(fldname)+"</font></a>");
				out.println("</td>");
				out.println("</tr>");
				iCounter++;
				}
			
			if(iCounter == 0){
				// Recordset is empty
				out.println(sNoRecords);
				out.print("<tr>\n <td colspan=\"1\" style=\"background-color: #FFFFFF; border-style: inset; border-width: 0\"><font style=\"font-size: 10pt; color: #CE7E00; font-weight: bold\">");
				out.print("<a href=\"CardTypesRecord.jsp?"+formParams+"\"><font style=\"font-size: 10pt; color: #CE7E00; font-weight: bold\">Insert</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				out.println("</td> \n </tr>");
		
				iCounter = RecordsPerPage+1;
				bIsScroll = false;
				}
			else{
				out.print("<tr> \n <td colspan=\"1\" style=\"background-color: #FFFFFF; border-style: inset; border-width: 0\"><font style=\"font-size: 10pt; color: #CE7E00; font-weight: bold\">");
				out.print("<a href=\"CardTypesRecord.jsp?"+formParams+"\"><font style=\"font-size: 10pt; color: #CE7E00; font-weight: bold\">Insert</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				out.println("</td> \n </tr>");				
				}
			
			if(rs != null) 
				rs.close();
			out.println("</table>");
			}
		catch(Exception e){ 
			out.println(e.toString()); 
			}
		}
%>
