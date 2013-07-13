<!-- Header -->

<%@ include file = "Common.jsp" %>

<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.jsp.JspWriter" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.IOException"%>

<%! static final String sFileName = "Header.jsp"; %>

<%
	boolean bDebug = false;

	String sAction = getParam(request, "FormAction");
	String sForm = getParam(request, "FormName");
	String sMenuErr = "";

	Connection conn = null;
	Statement stat = null;

	conn = cn();
	stat = conn.createStatement();
%>

<center>
	<table>
		<tr>
			<td valign="top">
				<% Menu_Show(request, response, session, out, sMenuErr, sForm, sAction, conn, stat); %>   
			</td>
		</tr>
	</table>
</center>

<hr>
	<%!

	void Menu_Show (HttpServletRequest request, HttpServletResponse response, HttpSession session, JspWriter out, String sMenuErr, String sForm, String sAction, Connection conn, Statement stat) throws IOException {
		try {
			out.println("<table style=\"\">"); 
			out.print("<tr>");
			
			// Set URLs
			String fldField2 = "index.jsp";
			String fldHome = "index.jsp";
			String fldReg = "Registration.jsp";
			String fldShop = "ShoppingCart.jsp";
			String fldField1 = "Login.jsp";
			String fldAdmin = "AdminMenu.jsp";
      
			// Show fields
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField2+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/Logo_bookstore.gif\" border=\"0\"></font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldHome+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/icon_home.gif\" border=\"0\"></font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldReg+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/icon_reg.gif\" border=\"0\"></font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldShop+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/icon_shop.gif\" border=\"0\"></font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldField1+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/icon_sign.gif\" border=\"0\"></font></a></td>");
			out.print("\n <td style=\"background-color: #FFFFFF; border-width: 1\"><a href=\""+fldAdmin+"\"><font style=\"font-size: 10pt; color: #000000\"><img src=\"images/icon_admin.gif\" border=\"0\"></font></a></td>");

			out.println("\n </tr> \n </table>");
			}
		catch(Exception e){ 
			out.println(e.toString()); 
			}
		}

%>
