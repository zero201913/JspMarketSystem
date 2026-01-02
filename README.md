# JspMarketSystem

A Java-based web application for market system management built with JSP/Servlet technology.

## 📋 Overview

JspMarketSystem is a web-based market management system that provides functionality for product management, user administration, and order processing. The application follows the MVC (Model-View-Controller) architecture pattern and is built using Java EE technologies.

## 🛠️ Technologies Used

- **Backend:**
  - Java 8
  - JSP/Servlet
  - MySQL 8.0.23
  - Redis (for caching)

- **Frontend:**
  - HTML/CSS
  - JavaScript
  - JSP

- **Build & Dependencies:**
  - Maven
  - Lombok
  - FastJSON
  - Logback
  - JUnit (for testing)

## 🚀 Features

- User authentication and authorization
- Product catalog management
- Shopping cart functionality
- Order processing
- Admin dashboard
- Session management
- Database connectivity with connection pooling

## 🏗️ Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── zero/market/
│   │       ├── bean/        # Data models and entities
│   │       ├── filter/      # Servlet filters
│   │       ├── servlet/     # Controllers
│   │       └── util/        # Utility classes
│   ├── resources/          # Configuration files
│   └── webapp/
│       ├── WEB-INF/        # Web configuration
│       ├── common/         # Shared components
│       ├── css/            # Stylesheets
│       ├── img/            # Image assets
│       ├── js/             # JavaScript files
│       ├── AdminList.jsp   # Admin interface
│       ├── MainView.jsp    # Main application view
│       └── index.jsp       # Entry point
```

## 🚀 Getting Started

### Prerequisites

- Java 8 or higher
- Maven 3.8.1
- MySQL 8.0.23
- Tomcat 7 or higher
- Redis (optional, for caching)

### Installation

1. **Clone the repository:**
   ```bash
   git clone [repository-url]
   cd JspMarketSystem
   ```

2. **Database Setup:**
   - Create a MySQL database
   - Update database configuration in `src/main/resources/application.properties`

3. **Build the project:**
   ```bash
   mvn clean install
   ```

4. **Deploy to Tomcat:**
   - Copy the generated `target/JspMarketSystem.war` to your Tomcat's `webapps` directory
   - Start Tomcat server

5. **Access the application:**
   - Open `http://localhost:8080/JspMarketSystem` in your browser

## ⚙️ Configuration

The application can be configured through the following files:

- `src/main/resources/application.properties` - Database and application settings
- `src/main/webapp/WEB-INF/web.xml` - Web application configuration

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For any inquiries, please contact [Your Email].
