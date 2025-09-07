package zero.market.util;

import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author Zero02
 */
@Slf4j
public class RedisUtil {
    // Redis 连接池
    private static final JedisPool JEDISPOOL;

    static {
        // 加载配置文件
        Properties props = new Properties();
        try (InputStream in = RedisUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            props.load(in);
        } catch (IOException e) {
            log.info("异常信息:{}", e.getMessage());
            // 配置加载失败时，抛出运行时异常，终止程序初始化
            throw new RuntimeException("Failed to load db.properties", e);
        }

        // 配置 Jedis 连接池
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxTotal(Integer.parseInt(props.getProperty("redis.pool.maxTotal", "100")));
        poolConfig.setMaxIdle(Integer.parseInt(props.getProperty("redis.pool.maxIdle", "20")));
        poolConfig.setMinIdle(Integer.parseInt(props.getProperty("redis.pool.minIdle", "5")));
        poolConfig.setMaxWaitMillis(Long.parseLong(props.getProperty("redis.pool.maxWaitMillis", "10000")));
        poolConfig.setTestOnBorrow(Boolean.parseBoolean(props.getProperty("redis.pool.testOnBorrow", "true")));

        // 读取 Redis 连接配置
        String host = props.getProperty("redis.host", "localhost");
        int port = Integer.parseInt(props.getProperty("redis.port", "6379"));
        String password = props.getProperty("redis.password", "");
        int timeout = Integer.parseInt(props.getProperty("redis.timeout", "2000"));

        // 初始化 JedisPool
        if (password != null && !password.trim().isEmpty()) {
            JEDISPOOL = new JedisPool(poolConfig, host, port, timeout, password);
        } else {
            JEDISPOOL = new JedisPool(poolConfig, host, port, timeout);
        }
    }

    // 获取 Jedis 连接
    public static Jedis getJedis() {
        return JEDISPOOL.getResource();
    }

    // 关闭 Jedis 连接（返还到连接池）
    public static void closeJedis(Jedis jedis) {
        if (jedis != null) {
            jedis.close();
        }
    }
}