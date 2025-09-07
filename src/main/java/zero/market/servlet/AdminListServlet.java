package zero.market.servlet;

import lombok.extern.slf4j.Slf4j;
import zero.market.util.DBUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * @author Zero02
 */
@Slf4j
@WebServlet("/adminList")
public class AdminListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 使用DBUtils获取数据库连接
            conn = DBUtil.getConnection();

            // 查询管理员列表数据
            String sql = "SELECT admin_id, admin_name, position, email, telephone, update_time, avatar_url FROM admin ORDER BY update_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // 将查询结果存入request属性，供JSP页面使用
            request.setAttribute("adminList", rs);

            // 转发到AdminList.jsp页面
            request.getRequestDispatcher("AdminList.jsp").forward(request, response);

        } catch (SQLException e) {
            log.info("异常错误信息：{}", e.getMessage());
            // 处理数据库异常
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<div style='color: red'>获取权限数据失败，请稍后重试</div>");
        } finally {
            // 关闭数据库资源
            DBUtil.close(rs, pstmt, conn);
        }
    }
}

