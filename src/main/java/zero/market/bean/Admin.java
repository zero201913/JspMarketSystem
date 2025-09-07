package zero.market.bean;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * @author Zero02
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Admin {
    // 管理员编号
    private int adminId;
    // 管理员姓名
    private String adminName;
    // 职位
    private String position;
    // 登录名
    private String loginName;
    // 密码
    private String password;
    // 出生日期
    private Date birthdate;
    // 更新时间
    private Date updateTime;
    // 电话号码
    private String telephone;
    // 电子邮箱
    private String email;
    // 头像URL
    private String avatarUrl;
}
