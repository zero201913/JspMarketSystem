package zero.market.filter;

import redis.clients.jedis.Jedis;
import zero.market.util.RedisUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

/**
 * @author Zero02
 * 拦截所有请求并进行路由验证和Token验证
 */
@WebFilter("/*")
public class RouteFilter implements Filter {

    // 存储所有有效路由
    private Set<String> validRoutes;
    // 存储需要登录验证的受保护路由
    private Set<String> protectedRoutes;
    // 存储公开可访问的路由
    private Set<String> publicRoutes;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化路由集合
        validRoutes = new HashSet<>();
        protectedRoutes = new HashSet<>();
        publicRoutes = new HashSet<>();

        // 加载路由配置文件
        Properties props = new Properties();
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("routes.properties")) {
            if (in == null) {
                throw new ServletException("未找到 routes.properties 配置文件");
            }
            props.load(in);
        } catch (IOException e) {
            throw new ServletException("加载路由配置文件失败", e);
        }

        // 解析公开路由
        String publicRoutesStr = props.getProperty("public.routes", "");
        if (!publicRoutesStr.isEmpty()) {
            String[] publicRoutesArr = publicRoutesStr.split(",");
            for (String route : publicRoutesArr) {
                String trimRoute = route.trim();
                publicRoutes.add(trimRoute);
                // 公开路由也是有效路由
                validRoutes.add(trimRoute);
            }
        }

        // 解析受保护路由
        String protectedRoutesStr = props.getProperty("protected.routes", "");
        if (!protectedRoutesStr.isEmpty()) {
            String[] protectedRoutesArr = protectedRoutesStr.split(",");
            for (String route : protectedRoutesArr) {
                String trimRoute = route.trim();
                protectedRoutes.add(trimRoute);
                validRoutes.add(trimRoute); // 受保护路由也是有效路由
            }
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 获取请求的相对路径
        String contextPath = httpRequest.getContextPath();
        String requestUri = httpRequest.getRequestURI();
        String relativePath = requestUri.substring(contextPath.length());

        // 放行静态资源
        if (isStaticResource(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        // 检查是否是有效路由，如果不是就跳转到 404 页面
        if (!validRoutes.contains(relativePath)) {
            httpResponse.sendRedirect(contextPath + "/common/404.jsp");
            return;
        }

        // 对受保护路由进行token验证
        if (protectedRoutes.contains(relativePath)) {
            // 从Cookie中获取token
            String token = getCookieValue(httpRequest);

            // 验证token合法性
            if (token == null || !isValidToken(token)) {
                // token无效或不存在，重定向到登录页
                httpResponse.sendRedirect(contextPath + "/index.jsp?error=session_expired");
                return;
            }
        }

        // 验证通过，放行请求
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 过滤器销毁时释放资源
        validRoutes.clear();
        protectedRoutes.clear();
        publicRoutes.clear();
    }


    private boolean isStaticResource(String path) {
        String[] staticSuffixes = {".css", ".js", ".jpg", ".png", ".gif", ".ico", ".svg", ".woff", ".ttf"};
        for (String suffix : staticSuffixes) {
            if (path.endsWith(suffix)) {
                return true;
            }
        }
        return false;
    }
    // 判断是否为静态资源
    // 从请求中获取指定名称的Cookie值
    private String getCookieValue(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    // 验证token是否合法（实际项目中应连接数据库或缓存验证）
    private boolean isValidToken(String token) {
        // 这里是token验证的核心逻辑
        if (token == null || token.trim().isEmpty()) {
            return false;
        }
        Jedis jedis = null;
        try {
            // 获取 Redis 连接
            jedis = RedisUtil.getJedis();
            // 假设 Redis 中存储的 key 为 "token:" + token，value 为用户名等标识
            // 检查 token 对应的键是否存在
            Boolean exists = jedis.exists("token:" + token);
            return exists != null && exists;
        } finally {
            // 关闭 Redis 连接
            RedisUtil.closeJedis(jedis);
        }
    }
}
