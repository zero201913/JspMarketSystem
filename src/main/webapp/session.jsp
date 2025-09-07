<%@ page import="java.util.ArrayList" %>
<%@ page import="zero.market.bean.Admin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page language="java" pageEncoding="GBK" isELIgnored="false" %>
<html>
<body>
       <%--      存为 session 共所有页面共享的数据使用   --%>
       <%--      session.setAttribute("books",books)   --%>

<%--       String o = (String)session.getAttribute("null");--%>
<%--       System.out.println(o.length());--%>
       <%
              SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
              // 使用建造者模式创建模拟管理员数据
              List adminList = new ArrayList();

              // 管理员1：admin账号
              Admin admin1 = Admin.builder()
                      .adminId(1)
                      .adminName("张管理员")
                      .position("超级管理员")
                      .loginName("admin")
                      .password("123456") // 实际项目需加密
                      .birthdate(sdf.parse("1990-01-15 00:00:00"))
                      .updateTime(sdf.parse("1990-01-15 00:00:00"))
                      .telephone("13800138000")
                      .email("admin@letaomall.com")
                      .build();

              // 管理员2
              Admin admin2 = Admin.builder()
                      .adminId(2)
                      .adminName("李经理")
                      .position("运营经理")
                      .loginName("manager_li")
                      .password("li123456")
                      .birthdate(sdf.parse("1995-03-20 00:00:00"))
                      .updateTime(sdf.parse("1995-03-20 00:00:00"))
                      .telephone("13900139000")
                      .email("li@letaomall.com")
                      .build();

              // 管理员3
              Admin admin3 = Admin.builder()
                      .adminId(3)
                      .adminName("王专员")
                      .position("内容专员")
                      .loginName("staff_wang")
                      .password("wang123456")
                      .birthdate(sdf.parse("2000-05-10 00:00:00"))
                      .updateTime(sdf.parse("2000-05-10 00:00:00"))
                      .telephone("13700137000")
                      .email("wang@letaomall.com")
                      .build();

              adminList.add(admin1);
              adminList.add(admin2);
              adminList.add(admin3);
              request.setAttribute("adminList", adminList);
       %>
       <% for (int i = 0; i < adminList.size(); i++) {
              Admin admin = (Admin)adminList.get(i);

       %>
      EL: ${admin.adminName} JSP: <%=admin.getAdminName()%>
       <%
              }
       %>

<%--       <table>--%>
<%--              <tr>--%>
<%--                     <th>ID</th>--%>
<%--                     <th>姓名</th>--%>
<%--                     <th>职位</th>--%>
<%--                     <th>登录名</th>--%>
<%--                     <th>出生日期</th>--%>
<%--                     <th>更新时间</th>--%>
<%--                     <th>电话</th>--%>
<%--                     <th>邮箱</th>--%>
<%--              </tr>--%>

<%--              &lt;%&ndash; 遍历请求域中的adminList &ndash;%&gt;--%>
<%--              <c:forEach items="${adminList}" var="admin">--%>
<%--                     <tr>--%>
<%--                            <td>${admin.adminId}</td>--%>
<%--                            <td>${admin.adminName}</td>--%>
<%--                            <td>${admin.position}</td>--%>
<%--                            <td>${admin.loginName}</td>--%>
<%--                                   &lt;%&ndash; 格式化日期显示 &ndash;%&gt;--%>
<%--                            <td><fmt:formatDate value="${admin.birthdate}" pattern="yyyy-MM-dd"/></td>--%>
<%--                            <td><fmt:formatDate value="${admin.updateTime}" pattern="yyyy-MM-dd HH:mm"/></td>--%>
<%--                            <td>${admin.telephone}</td>--%>
<%--                            <td>${admin.email}</td>--%>
<%--                     </tr>--%>
<%--              </c:forEach>--%>
<%--       </table>--%>
</body>
</html>