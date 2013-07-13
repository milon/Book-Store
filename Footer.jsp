<!-- Footer -->

<%@ include file="Common.jsp" %>

<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.jsp.JspWriter" %>
<%@ page import = "javax.servlet.http.HttpSession"%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>

<%! static final String sFileName = "Footer.jsp"; %>

<%
	boolean bDebug = false;

	String sAction = getParam(request, "FormAction");
	String sForm = getParam(request, "FormName");
	String sFooterErr = "";

	Connection conn = null;
	Statement stat = null;

	conn = cn();
	stat = conn.createStatement();
%>

<center>
	<hr size=1 width=60%>
		<table>
			<tr>
				<td valign="top">
					<% Footer_Show(request, response, session, out, sFooterErr, sForm, sAction, conn, stat); %>    
				</td>
			</tr>
		</table>

<%!
	void Footer_Show(HttpServletRequest request, HttpServletResponse response, HttpSession session, JspWriter out, String sFooterErr, String sForm, String sAction, Connection conn, Statement stat) throws IOException {
		try{
			out.println("<table style=\"\">");
			out.print("     <tr>");
      
			//Set URLs
			String fldField1 = "index.jsp";
			String fldField3 = "Registration.jsp";
			String fldField5 = "ShoppingCart.jsp";
			String fldField2 = "Login.jsp";
			String fldField4 = "AdminMenu.jsp";
      
			// Show fields
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField1+"\"><font style=\"font-size: 10pt; color: #000000\">Home</font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField3+"\"><font style=\"font-size: 10pt; color: #000000\">Registration</font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField5+"\"><font style=\"font-size: 10pt; color: #000000\">Shopping Cart</font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField2+"\"><font style=\"font-size: 10pt; color: #000000\">Sign In</font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField4+"\"><font style=\"font-size: 10pt; color: #000000\">Administration</font></a></td>");

			out.println("\n </tr> \n </table>");
			}
		catch(Exception e){ 
			out.println(e.toString()); 
			}
		}
%>
<center><font face="Arial"><small>This site is created by: <a href="http://www.milon521.wordpress.com">Nuruzzaman Milon</a></small></font></center>
