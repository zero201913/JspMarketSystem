package zero.market.servlet;

import com.alibaba.fastjson.JSONObject;
import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;
import zero.market.util.DBUtil;
import zero.market.util.RedisUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * @author Zero02
 */
@Slf4j
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();
        JSONObject result = new JSONObject();
//
//        // 获取前端参数   TODO: 直接获取无法从前端form拿到username
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");

        // 读取请求体数据
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String requestBody = sb.toString();

        // 解析 JSON 数据
        JSONObject jsonObject = JSONObject.parseObject(requestBody);
        String username = jsonObject.getString("username");
        String password = jsonObject.getString("password");

        // 使用 zero.market.util.DBUtil 验证用户（查询数据库）
        boolean isLoginSuccess = false;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM admin WHERE login_name = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            // TODO 实际项目中应加密存储密码（如 MD5 + 盐）
            ps.setString(2, password);
            rs = ps.executeQuery();
            // 有查询结果则登录成功
            isLoginSuccess = rs.next();
        } catch (SQLException e) {
            log.info("异常错误信息:{}",e.getMessage());
            result.put("success", false);
            result.put("msg", "数据库错误");
            out.print(result);
            return;
        } finally {
            DBUtil.close(rs, ps, conn);
        }

        // 登录成功：生成令牌并返回给前端
        if (isLoginSuccess) {
            // 生成唯一令牌（可使用 UUID）
            String token = UUID.randomUUID().toString();

            // TODO 后端可将令牌存入 Redis 或数据库
            Jedis jedis = null;
            try {
                jedis = RedisUtil.getJedis();
                // 存储 token 到 Redis，设置过期时间（如 3600 秒，1 小时）
                jedis.setex("token:" + token, 3600, username);
            } finally {
                RedisUtil.closeJedis(jedis);
            }
            // 此处简化处理，直接返回令牌给前端存储
            result.put("success", true);
            result.put("token", token);
            result.put("username", username);
        } else {
            result.put("success", false);
            result.put("msg", "用户名或密码错误");
        }

        out.print(result);
    }
}