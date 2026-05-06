# 🍽️ Restaurant Management System

<div align="center">
  <p>A robust backend and full-stack application built with Spring Boot. It manages restaurant operations securely and efficiently.</p>
  
  <!-- Tech Stack Badges -->
  <img src="https://img.shields.io/badge/Java_17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java 17" />
  <img src="https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white" alt="Spring Boot" />
  <img src="https://img.shields.io/badge/Spring_Security-6DB33F?style=for-the-badge&logo=spring-security&logoColor=white" alt="Spring Security" />
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
  <img src="https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=json-web-tokens&logoColor=white" alt="JWT" />
</div>

---

## ✨ Features

- **Secure Authentication & Authorization:** Implemented using Spring Security and JSON Web Tokens (JWT) for secure, stateless API access.
- **Data Persistence:** Robust database interaction using Spring Data JPA with a MySQL backend.
- **Server-Side Rendering:** Integrated with JSP (JavaServer Pages) and Apache Tiles for dynamic and modular frontend views.
- **Real-Time Communication:** Support for WebSocket integration to enable real-time features.
- **Input Validation:** Strict payload validation using Spring Boot Validation.
- **Reduced Boilerplate:** Utilizes Lombok to keep Java classes clean and concise.

---

## 🛠️ Technologies Used

- **Core Framework:** Spring Boot 2.5.14
- **Language:** Java 17
- **Database:** MySQL 8
- **ORM:** Hibernate (Spring Data JPA)
- **Security:** Spring Security, JWT (io.jsonwebtoken)
- **View Layer:** JSP, JSTL, Apache Tiles
- **Build Tool:** Maven

---

## 💻 Local Setup & Development

Follow these instructions to get the project up and running on your local machine.

### Prerequisites
- [Java Development Kit (JDK) 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- [MySQL Server 8.0+](https://dev.mysql.com/downloads/mysql/)
- Maven (Optional, as the project includes the Maven Wrapper)

### 1. Database Configuration
1. Open your MySQL client (e.g., MySQL Workbench or CLI).
2. Create the required database schema:
   ```sql
   CREATE DATABASE resturant;
   ```
3. The application is configured to connect using the following credentials by default (see `src/main/resources/application.properties`):
   - **Database Name:** `resturant`
   - **Username:** `root`
   - **Password:** `@#New7890`
   *(Update these credentials in `application.properties` if your local MySQL setup differs).*

### 2. Clone the Repository
```bash
git clone https://github.com/yourusername/restaurant.git
cd restaurant
```

### 3. Build and Run
You can run the application directly using the Maven Wrapper included in the project.

**Using Windows:**
```cmd
mvnw.cmd clean install
mvnw.cmd spring-boot:run
```

**Using Linux/macOS:**
```bash
./mvnw clean install
./mvnw spring-boot:run
```

The application will start on port **9090**. You can access it at `http://localhost:9090`.

---

## 📁 Project Structure

```text
restaurant/
├── src/
│   ├── main/
│   │   ├── java/com/restaurant/    # Core Java Application Code (Controllers, Models, Repositories, Security)
│   │   ├── resources/              # Configuration files (application.properties) and static assets
│   │   └── webapp/                 # JSP files and Tiles configuration
│   └── test/                       # Unit and Integration Tests
├── pom.xml                         # Maven Dependencies and Build Configuration
└── mvnw / mvnw.cmd                 # Maven Wrapper scripts
```

---

## ⚙️ Application Properties (Key Configurations)

Located at `src/main/resources/application.properties`:
- **Server Port:** `9090`
- **Database Strategy:** `update` (Hibernate automatically updates the database schema based on your entity classes)
- **SQL Logging:** Enabled for debugging (`spring.jpa.show-sql=true`)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
