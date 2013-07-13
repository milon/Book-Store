<!-- AdminMenu -->

<%@ include file="Common.jsp" %>

<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.jsp.JspWriter" %>
<%@ page import = "javax.servlet.http.HttpSession"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "javax.servlet.http.HttpServletResponse" %>

<%! static final String sFileName = "AdminMenu.jsp"; %>

<%
	String cSec = checkSecurity(2, session, response, request);

	if("sendRedirect".equals(cSec)) 
		return;
					
	boolean bDebug = false;

	String sAction = getParam(request, "FormAction");
	String sForm = getParam(request, "FormName");
	String sFormErr = "";

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
					<% Form_Show(request, response, session, out, sFormErr, sForm, sAction, conn, stat); %>   
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
	void Form_Show(HttpServletRequest request, HttpServletResponse response, HttpSession session, JspWriter out, String sFormErr, String sForm, String sAction, Connection conn, Statement stat) throws IOException{
		try {
			out.println("<table style=\"\">");
			out.println("<tr> \n <td  style=\"background-color: #336699; text-align: Center; border-style: outset; border-width: 1\"><font style=\"font-size: 12pt; color: #FFFFFF; font-weight: bold\">Administration Menu</font></td>\n </tr>");
			out.print("<tr>");
     
			// Set URLs
			String fldField1 = "MembersGrid.jsp";
			String fldField2 = "OrdersGrid.jsp";
			String fldField3 = "AdminBooks.jsp";
			String fldField4 = "CategoriesGrid.jsp";
			String fldField5 = "EditorialsGrid.jsp";
			String fldField6 = "EditorialCatGrid.jsp";
			String fldField = "CardTypesGrid.jsp";

			// Show fields
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField1+"\"><font style=\"font-size: 10pt; color: #000000\">Members</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField2+"\"><font style=\"font-size: 10pt; color: #000000\">Orders</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField3+"\"><font style=\"font-size: 10pt; color: #000000\">Books</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField4+"\"><font style=\"font-size: 10pt; color: #000000\">Categories</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField5+"\"><font style=\"font-size: 10pt; color: #000000\">Editorials</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField6+"\"><font style=\"font-size: 10pt; color: #000000\">Editorial Categories</font></a></td>\n\n      </tr>\n\n      <tr>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField+"\"><font style=\"font-size: 10pt; color: #000000\">Card Types</font></a></td>");

			out.println("\n </tr> \n </table>");
			}
		catch(Exception e){ 
			out.println(e.toString()); 
			}
		}
%>
