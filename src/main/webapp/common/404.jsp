<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>404 Not Found</title>
    <style>
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
            background-image: url("../img/bg.png");
        radial-gradient(circle at 90 % 80 %, rgba(100, 180, 200, 0.1) 0 %, rgba(100, 180, 200, 0) 20 %);
        }

        h1 {
            color: #dc3545;
            font-size: 36px;
            text-align: center;
        }

        a {
            color: #0d6efd;
            text-decoration: none;
        }
        .container {
            position: relative; /* 作为子元素的定位容器 */
            width: 500px;
            height: 300px;
            /* 确保内容层在最上方 */
        }

        /* 背景层：单独应用模糊 */
        .bg-blur {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.9); /* 半透明白色背景 */
            filter: blur(3px); /* 仅模糊背景 */
            z-index: 1; /* 背景层层级 */
        }

        /* 内容层：文字不模糊 */
        .content {
            position: relative;
            z-index: 2; /* 内容层层级高于背景层 */
            text-align: center;
            padding: 50px;
            /* 文字样式 */
            color: #333;
            font-size: 18px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 背景层（仅用于模糊效果） -->
    <div class="bg-blur"></div>
    <!-- 内容层（文字清晰显示） -->
    <div class="content">
        <h1>404 - 页面不存在</h1>
        <p>您访问的页面无法找到</p>
        <a href="../index.jsp">跳转回主页</a>
    </div>
</div>
</body>
</html>