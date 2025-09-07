<%@ page language="java" contentType="text/html;charset=GBK" isELIgnored="false" %>
<html lang="zh-CN">
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<head>
    <meta charset="UTF-8">
    <title>管理员列表</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft Yahei", sans-serif;
        }
        .container {
            width: 100%;
            padding: 20px;
        }
        .search-bar {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .search-bar input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
            margin-right: 10px;
        }
        .search-bar button {
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-group button {
            padding: 8px 15px;
            background-color: #fff;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        .btn-group button:hover {
            background-color: #f5f5f5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f5f5f5;
            font-weight: 600;
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        .operate a {
            margin-right: 10px;
            text-decoration: none;
            color: #007bff;
        }
        .operate a:hover {
            text-decoration: underline;
        }
        .pagination {
            margin-top: 20px;
            text-align: right;
        }
        .pagination span, .pagination a {
            display: inline-block;
            padding: 5px 10px;
            margin: 0 2px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }
        .pagination .active {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
        }
        .pagination-info {
            margin-top: 10px;
            text-align: right;
            color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>管理员列表</h2>
    <div class="search-bar">
        <input type="text" placeholder="输入管理员名称">
        <button>搜索</button>
        <div class="btn-group">
            <button>添加管理员</button>
            <button>批量删除</button>
        </div>
    </div>
    <table>
        <thead>
        <tr>
            <th><input type="checkbox"></th>
            <th>头像</th>
            <th>管理员名称</th>
            <th>权限组</th>
            <th>邮箱</th>
            <th>电话</th>
            <th>添加时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            // 从request中获取管理员列表数据
            ResultSet rs = (ResultSet) request.getAttribute("adminList");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            if (rs != null) {
                while (rs.next()) {
                    // 获取管理员信息（使用表中实际字段名）
                    int adminId = rs.getInt("admin_id");
                    String adminName = rs.getString("admin_name");
                    String position = rs.getString("position"); // 权限组对应表中的position字段
                    String email = rs.getString("email");
                    String telephone = rs.getString("telephone");
                    String avatarUrl = rs.getString("avatar_url");
                    java.util.Date updateTime = rs.getTimestamp("update_time");

                    // 处理电话号码显示（中间四位用*代替）
                    if (telephone != null && telephone.length() == 11) {
                        telephone = telephone.substring(0, 3) + "****" + telephone.substring(7);
                    }
        %>
        <tr>
            <td><input type="checkbox" value="<%= adminId %>"></td>
            <td>
                <%
                    // 显示头像，如无则使用默认占位图
                    if (avatarUrl != null && !avatarUrl.isEmpty()) {
                %>
                <img src="<%= avatarUrl %>" alt="<%= adminName %>的头像" class="avatar">
                <% } else { %>
                <img src="https://via.placeholder.com/40" alt="<%= adminName %>的头像" class="avatar">
                <% } %>
            </td>
            <td><%= adminName %></td>
            <td><%= position != null ? position : "-" %></td>
            <td><%= email != null ? email : "-" %></td>
            <td><%= telephone != null ? telephone : "-" %></td>
            <td><%= updateTime != null ? sdf.format(updateTime) : "-" %></td>
            <td class="operate">
                <a href="editAdmin?id=<%= adminId %>">编辑</a>
                <%
                    // 这里假设"超级管理员"是最高权限，不允许删除
                    if (position == null || !"超级管理员".equals(position)) {
                %>
                <a href="deleteAdmin?id=<%= adminId %>" onclick="return confirm('确定要删除吗？')">删除</a>
                <% } %>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" style="text-align: center;">暂无管理员数据</td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <div class="pagination-info">
        第1-2条 / 总共2条
    </div>
    <div class="pagination">
        <span class="active">1</span>
        <a href="#">></a>
        <select>
            <option>15</option>
            <option>20</option>
            <option>30</option>
        </select>
    </div>
</div>
</body>
</html>