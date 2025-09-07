<%@ page language="java" contentType="text/html;charset=GBK" %>
<html>
<style>
    /* 页面整体样式，设置背景 */
    body {
        margin: 0;
        padding: 0;
        font-family: "Microsoft Yahei", sans-serif;
        background-color: #0f5f7c; /* 参考图的蓝绿色背景 */
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        /*background-image: radial-gradient(circle at 10% 20%, rgba(100, 180, 200, 0.1) 0%, rgba(100, 180, 200, 0) 20%),*/
        background-image: url("img/bg.png");
        radial-gradient(circle at 90% 80%, rgba(100, 180, 200, 0.1) 0%, rgba(100, 180, 200, 0) 20%);
    }

    /* 表单整体 */
    #loginForm {
        background-color: #f0f7f9;
        padding: 35px 40px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        width: 510px;
        margin: 50px auto;
    }

    /* 每组“标签+输入框”的容器 */
    .form-group {
        margin-bottom: 20px;
        position: relative; /* 为绝对定位的标签做参照 */
    }

    /* 标签样式：初始居中，过渡动画 */
    .floating-label {
        position: absolute;
        top: 28%;
        left: 50%;
        transform: translate(-50%, -50%);
        pointer-events: none; /* 避免标签遮挡输入框点击 */
        transition: all 0.3s ease;
        color: #555;
    }

    /* 输入框/选择框样式：统一外观 */
    .form-input {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
        box-sizing: border-box;
        margin-top: 40px; /* 给标签留位置 */
    }

    /* 标签“激活态”：左移、缩小、变色 */
    .form-input:focus + .floating-label,
    .form-input:not(:placeholder-shown) + .floating-label {
        top: 10px;
        left: 15px;
        transform: translate(0, 0);
        font-size: 12px;
        color: #0f5f7c;
    }

    /* 提交按钮样式 */
    .submit-btn {
        width: 100%;
        padding: 12px;
        background-color: #0f5f7c;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        margin-top: 10px;
    }

    /* 注册按钮样式 */
    #loginForm button {
        display: block;
        width: 100%;
        padding: 12px;
        background-color: transparent;
        color: #0f5f7c;
        border: 1px solid #0f5f7c;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        margin-top: 15px;
    }
</style>
<head>
    <link href="css/global.css" rel="stylesheet">
</head>
<body>
<form action="" method="POST" name="loginForm" id="loginForm">
    <h2 class="form-title" style="text-align: center">用户登录</h2>
    <!-- 用户名组 -->
    <div class="form-group">
        <label for="username" class="floating-label">请输入用户名</label>
        <input type="text" name="username" id="username" class="form-input"/>
    </div>
    <!-- 密码组 -->
    <div class="form-group">
        <label for="password" class="floating-label">请输入密码</label>
        <input type="password" name="password" id="password" class="form-input"/>
    </div>
    <!-- 确认密码组 -->
    <div class="form-group">
        <label for="re_password" class="floating-label">请再次输入密码</label>
        <input type="password" name="re_password" id="re_password" class="form-input"/>
    </div>
    <!-- 城市选择组 -->
    <div class="form-group">
        <label for="selectCity" class="floating-label">选择你所在的城市</label>
        <select name="selectCity" id="selectCity" class="form-input">
            <% for (int i = 0; i < 10; i++) {%>
            <option value="城市<%=i%>">城市<%=i%>
            </option>
            <%}%>
        </select>
    </div>
    <input type="submit" value="Submit" class="submit-btn"/>
    <button onclick="window.location.href='MainView.jsp'">Register</button>
</form>
</body>
<script src="js/popupUtil.js"></script>
<script>
    //提交数据到后端，登录验证
    document.getElementById("loginForm").addEventListener("submit", function (e) {
        e.preventDefault(); // 阻止表单默认提交
        if (!validate()) {
            return
        }
        // 获取表单数据
        const formData = new FormData(this);
        const data = {
            username: formData.get("username"),
            password: formData.get("password")
        };

        console.log(data);

        // 发送登录请求到后端
        fetch("/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(response => response.json())
            .then(res => {
                if (res.success) {
                    // 登录成功：存储用户信息到 Cookie（设置有效期，如 7 天）
                    setCookie("token", res.token, 7);
                    setCookie("username", res.username, 7);

                    console.log(res);
                    // 先弹出登录成功的弹窗，点击确定后再跳转
                    showPopup("success", "登录成功", "即将跳转到首页", () => {
                        window.location.href = "MainView.jsp";
                    });
                } else {
                    // 登录失败：显示错误信息（使用之前的自定义弹窗）
                    showPopup("warning", "登录失败", res.msg);
                }
            })
            .catch(error => {
                showPopup("error", "请求失败", "网络错误，请重试");
            });
    });

    //动态过渡效果监听和恢复
    document.querySelectorAll('.form-input').forEach(input => {
        input.addEventListener('focus', () => {
            const label = input.previousElementSibling;
            if (label && label.classList.contains('floating-label')) {
                label.style.top = '10px';
                label.style.left = '15px';
                label.style.transform = 'translate(0, 0)';
                label.style.fontSize = '12px';
                label.style.color = '#0f5f7c';
            }
        });

        input.addEventListener('blur', () => {
            if (!input.value.trim()) { // 输入框为空时，标签回归原位
                const label = input.previousElementSibling;
                if (label && label.classList.contains('floating-label')) {
                    label.style.top = '28%';
                    label.style.left = '50%';
                    label.style.transform = 'translate(-50%, -50%)';
                    label.style.fontSize = ''; // 恢复默认字体大小
                    label.style.color = '#555';
                }
            }
        });
    });

    function validate() {
        // 获取表单元素值
        let username = document.loginForm.username.value.trim();
        let password = document.loginForm.password.value;
        let re_password = document.loginForm.re_password.value; // 注意这里应该是确认密码字段
        let city = document.loginForm.selectCity.value;

        // 验证结果标记
        let isValid = true;
        let errorTitle = "验证失败";
        let errorMessage = "";

        // 用户名验证 (不为空且长度至少3位)
        if (username === "") {
            errorMessage += "用户名不能为空\n";
            isValid = false;
        } else if (username.length < 3) {
            errorMessage += "用户名长度不能少于3位\n";
            isValid = false;
        }

        // 密码验证 (不为空且长度至少6位)
        if (password === "") {
            errorMessage += "密码不能为空\n";
            isValid = false;
        } else if (password.length < 6) {
            errorMessage += "密码长度不能少于6位\n";
            isValid = false;
        }

        // 确认密码验证
        if (re_password === "") {
            errorMessage += "请输入确认密码\n";
            isValid = false;
        } else if (password !== re_password) {
            errorMessage += "两次输入的密码不一致\n";
            isValid = false;
        }

        // 城市选择验证
        if (city === "" || city === "default") { // 假设默认选项值为"default"
            errorMessage += "请选择城市\n";
            isValid = false;
        }

        // 显示验证结果
        if (!isValid) {
            // 调用自定义的 showPopup 方法，类型为 error，标题和信息为对应内容
            showPopup("error", errorTitle, errorMessage);
            // 阻止表单提交（如果在submit事件中）
            return false;
        }
        return true;
    }

    // 设置 Cookie 函数（key: 键名, value: 值, days: 有效期天数）
    function setCookie(key, value, days) {
        const date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000)); // 计算过期时间
        const expires = "expires=" + date.toUTCString();
        document.cookie = key + "=" + encodeURIComponent(value) + ";" + expires + ";path=/";
    }
</script>
</html>
