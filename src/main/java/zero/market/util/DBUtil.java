package zero.market.util;

import lombok.extern.slf4j.Slf4j;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author Zero02
 */
@Slf4j
public class DBUtil {
    // 连接信息（从配置文件读取）
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    // 静态代码块：加载驱动和配置文件（只执行一次）
    static {
        try {
            // 1. 加载配置文件
            Properties prop = new Properties();
            // 使用类加载器读取resources目录下的配置文件
            InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                throw new RuntimeException("未找到db.properties配置文件！");
            }
            prop.load(is);

            // 2. 解析配置参数
            String host = prop.getProperty("db.host");
            String port = prop.getProperty("db.port");
            String dbName = prop.getProperty("db.name");
            String params = prop.getProperty("db.params");

            USER = prop.getProperty("db.username");
            PASSWORD = prop.getProperty("db.password");
            String driver = prop.getProperty("db.driver");

            // 3. 拼接URL
            URL = String.format("jdbc:mysql://%s:%s/%s?%s", host, port, dbName, params);

            // 4. 加载数据库驱动
            Class.forName(driver);

        } catch (Exception e) {
            log.info("异常错误信息:{}",e.getMessage());
            throw new RuntimeException("数据库初始化失败：" + e.getMessage());
        }
    }

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 关闭资源（重载方法，适应不同场景）
    public static void close(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            // 关闭连接，释放资源
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            log.info("异常错误信息:{}",e.getMessage());
        }
    }

    // 重载：无ResultSet的情况
    public static void close(PreparedStatement ps, Connection conn) {
        close(null, ps, conn);
    }
}