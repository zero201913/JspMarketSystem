// popupUtil.js 中修改后的 showPopup 方法
function showPopup(type, title, message, callback) {
    // 先移除已存在的弹窗（避免重复创建）
    const existingOverlay = document.getElementById('customPopupOverlay');
    const existingPopup = document.getElementById('customPopup');
    if (existingOverlay) existingOverlay.remove();
    if (existingPopup) existingPopup.remove();

    // 创建遮罩层
    const overlay = document.createElement('div');
    overlay.id = 'customPopupOverlay';
    overlay.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    opacity: 0;
    transition: opacity 0.3s ease;
`;

    // 创建弹窗容器
    const popup = document.createElement('div');
    popup.id = 'customPopup';
    popup.style.cssText = `
    background: white;
    border-radius: 8px;
    width: 90%;
    max-width: 400px;
    padding: 24px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    transform: translateY(-20px);
    transition: transform 0.3s ease;
`;

    // 设置图标（根据类型）
    const icon = document.createElement('div');
    let iconClass = '';
    let iconColor = '';

    switch (type) {
        case 'error':
            iconClass = '?';
            iconColor = '#dc3545'; // 红色
            break;
        case 'success':
            iconClass = '$';
            iconColor = '#28a745'; // 绿色
            break;
        case 'warning':
            iconClass = '!';
            iconColor = '#ffc107'; // 黄色
            break;
        default:
            iconClass = 'i';
            iconColor = '#007bff'; // 蓝色
    }

    icon.style.cssText = `
    font-size: 40px;
    color: ${iconColor};
    text-align: center;
    margin-bottom: 16px;
`;
    icon.textContent = iconClass;

    // 设置标题
    const titleElement = document.createElement('h3');
    titleElement.style.cssText = `
    margin: 0 0 12px 0;
    color: #333;
    font-size: 18px;
    text-align: center;
`;
    titleElement.textContent = title;

    // 设置消息
    const messageElement = document.createElement('p');
    messageElement.style.cssText = `
    margin: 0 0 20px 0;
    color: #666;
    font-size: 14px;
    text-align: center;
    line-height: 1.5;
`;
    messageElement.textContent = message;

    // 设置确认按钮
    const confirmBtn = document.createElement('button');
    confirmBtn.style.cssText = `
    width: 100%;
    padding: 10px;
    background: ${iconColor};
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: background 0.2s;
`;
    confirmBtn.textContent = '确定';
    confirmBtn.onclick = () => {
        overlay.style.opacity = '0';
        popup.style.transform = 'translateY(-20px)';
        setTimeout(() => {
            overlay.remove();
            popup.remove();
            // 如果有回调函数，执行回调
            if (callback) {
                callback();
            }
        }, 300);
    };

    // 组装弹窗
    popup.appendChild(icon);
    popup.appendChild(titleElement);
    popup.appendChild(messageElement);
    popup.appendChild(confirmBtn);
    overlay.appendChild(popup);
    document.body.appendChild(overlay);

    // 触发动画
    setTimeout(() => {
        overlay.style.opacity = '1';
        popup.style.transform = 'translateY(0)';
    }, 10);

    // 点击遮罩层关闭
    overlay.onclick = (e) => {
        if (e.target === overlay) {
            confirmBtn.click();
        }
    };
}