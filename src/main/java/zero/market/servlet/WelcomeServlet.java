package zero.market.servlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author Zero02
 */
//@WebServlet("/servlet/hello")
public class WelcomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        ServletContext sc = this.getServletContext();
        String encoding = sc.getInitParameter("encoding");
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>zero.market.servlet.WelcomeServlet</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>zero.market.servlet.WelcomeServlet</h1>");
        out.println("</body>");
        out.println("</html>");
    }
}
