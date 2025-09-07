<%@ page language="java" pageEncoding="GBK" isErrorPage="true" %>
<html>
<head>
    <title>错误页面</title>
    <style>
        .error-container {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ff4444;
            background-color: #fefefe;
        }

        .error-title {
            color: #cc0000;
            border-bottom: 1px solid #ffdddd;
            padding-bottom: 10px;
        }

        .exception-info {
            margin-top: 15px;
            padding: 10px;
            background-color: #fff8f8;
            border: 1px dashed #ffbbbb;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h2 class="error-title">对不起，操作出错了</h2>

    <%
        // 检查是否有异常发生
        if (exception != null) {
    %>
    <div class="exception-info">
        <p><strong>错误信息：</strong><%= exception.getMessage() %>
        </p>
        <p><strong>异常类型：</strong><%= exception.getClass().getName() %>
        </p>

        <p><strong>堆栈跟踪：</strong></p>
        <pre>
        <%
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            exception.printStackTrace(pw);
            pw.flush();
            String stackTrace = sw.toString();
        %>
        <%=stackTrace%>
        </pre>
    </div>
    <%
    } else {
    %>
    <p>未捕获到具体异常信息</p>
    <%
        }
    %>
</div>
</body>
</html>