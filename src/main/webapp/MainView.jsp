<%--
  Created by IntelliJ IDEA.
  User: Zero02
  Date: 2025/9/5
  Time: 14:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Main View</title>
    <!-- 引入 Axios CDN -->
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <style>
        /* 简单样式，用于布局展示，实际需结合 CSS 框架或详细样式调整 */
        body, html {
            margin: 0;
            padding: 0;
            font-family: "Microsoft Yahei", sans-serif;
        }

        .top-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #f8f9fa;
            padding: 10px 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .top-left {
            display: flex;
            align-items: center;
        }

        .logo {
            font-size: 20px;
            font-weight: bold;
            margin-right: 20px;
        }

        .search-box {
            width: 200px;
            padding: 5px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }

        .top-right {
            display: flex;
            align-items: center;
        }

        .top-icon {
            margin: 0 10px;
            cursor: pointer;
            position: relative;
        }

        .badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: red;
            color: white;
            font-size: 10px;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-area {
            display: flex;
            align-items: center;
            margin-left: 10px;
            cursor: pointer;
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            background-color: #ced4da;
            border-radius: 50%;
            margin-right: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-dropdown {
            position: absolute;
            top: 50px;
            right: 20px;
            background-color: white;
            border: 1px solid #e9ecef;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 10px;
            display: none;
        }

        .user-area:hover .user-dropdown {
            display: block;
        }

        .sidebar {
            width: 200px;
            background-color: #212529;
            color: white;
            height: calc(100vh - 50px);
            float: left;
            padding: 20px 0;
        }

        .sidebar-item {
            padding: 10px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .sidebar-item:hover {
            background-color: #495057;
        }

        .sidebar-item.active {
            background-color: #0d6efd;
        }

        .content {
            margin-left: 210px;
            padding: 20px;
            min-height: 500px;
            border: 1px solid #eee;
        }
    </style>
    <link href="css/global.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<div class="top-bar">
    <div class="top-left">
        <div class="logo">LeTaoShop</div>
        <div class="search-box">在这里查找功能，一键直达</div>
    </div>
    <div class="top-right">
        <div class="top-icon">
            <img src="img/auth.png" title="乐淘公司企业授权" width="50px" height="50px"/>
        </div>
        <div class="top-icon">
            <div>📥</div>
            <div class="badge">21</div>
            <div>消息</div>
        </div>
        <div class="top-icon">
            <div>🏪</div>
            <div>查看店铺</div>
        </div>
        <div class="user-area">
            <div class="user-avatar">👤</div>
            <div id="usernameDisplay">demo</div>
            <div class="user-dropdown">
                <div>管理</div>
                <div>退出登录</div>
            </div>
        </div>
    </div>
</div>
<div class="sidebar">
    <div class="sidebar-item active">面板</div>
    <div class="sidebar-item">商品</div>
    <div class="sidebar-item">订单</div>
    <div class="sidebar-item">营销</div>
    <div class="sidebar-item">装修</div>
    <div class="sidebar-item">内容</div>
    <div class="sidebar-item">财务</div>
    <div class="sidebar-item">会员</div>
    <div class="sidebar-item" data-target="adminList">权限</div>
    <div class="sidebar-item">设置</div>
</div>
<div class="content" id="content">
    <!-- 这里可以填充右侧具体内容，如概览、待办事项等 -->
    <h2>面板 / 概览</h2>
    <div>待办事项、实时数据等组件可在此区域添加</div>
</div>
</body>
<script>
    window.onload = function () {
        // 修正：getCookie 函数接收 cookie 名称作为参数
        function getCookie(name) {
            let cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                let cookie = cookies[i].trim();
                if (cookie.indexOf(name + '=') === 0) {
                    return cookie.substring(name.length + 1);
                }
            }
            return null;
        }

        let username = getCookie("username");
        console.log("当前登录的用户为：" + username);
        if (username) {
            // 更新页面上显示用户名的元素（元素 id 为 usernameDisplay）
            document.getElementById("usernameDisplay").innerText = username;
        }
    };
    document.addEventListener('DOMContentLoaded', function () {
        const sidebarItems = document.querySelectorAll('.sidebar-item');
        const contentArea = document.querySelector('.content');

        sidebarItems.forEach(sidebarItem => {
            sidebarItem.addEventListener('click', function () {
                // 切换激活状态
                sidebarItems.forEach(i => i.classList.remove('active'));
                this.classList.add('active');

                const target = this.getAttribute('data-target');
                if (target === 'adminList') {
                    // 使用axios请求/adminList接口
                    axios.get('/adminList')
                        .then(res => {
                            // axios自动处理了200-300状态码的成功判断
                            contentArea.innerHTML = res.data;
                        })
                        .catch(err => {
                            console.error('加载权限列表失败：', err);
                            contentArea.innerHTML = '<div style="color: red">加载权限页面失败，请稍后重试</div>';
                        });
                } else {
                    contentArea.innerHTML = `<h2>面板 / ${this.textContent}</h2><div>待补充 ${this.textContent} 相关内容</div>`;
                }
            });
        });
    });
</script>
</html>
