# The Archive Co. - Library Portal

A full-stack **Library Management System** built with Java Servlets, JSP, MySQL, and deployed on Apache Tomcat. Features separate dashboards for **Admins** and **Members** with complete book borrowing, user management, and branch management capabilities.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Setup & Installation (Windows)](#setup--installation-windows)
  - [Step 1 - Install Java JDK 21](#step-1---install-java-jdk-21)
  - [Step 2 - Install Apache Tomcat 10.1](#step-2---install-apache-tomcat-101)
  - [Step 3 - Install MySQL 8.x](#step-3---install-mysql-8x)
  - [Step 4 - Clone the Repository](#step-4---clone-the-repository)
  - [Step 5 - Create the Database](#step-5---create-the-database)
  - [Step 6 - Deploy the App to Tomcat](#step-6---deploy-the-app-to-tomcat)
  - [Step 7 - Add MySQL JDBC Driver](#step-7---add-mysql-jdbc-driver)
  - [Step 8 - Configure Database Connection](#step-8---configure-database-connection)
  - [Step 9 - Compile the Java Servlets](#step-9---compile-the-java-servlets)
  - [Step 10 - Start Tomcat and Open the App](#step-10---start-tomcat-and-open-the-app)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Pages Overview](#pages-overview)
- [Database Schema](#database-schema)
- [Servlets](#servlets)
- [Key Features](#key-features)
- [License](#license)

---

## Tech Stack

| Layer      | Technology                          |
|------------|-------------------------------------|
| Backend    | Java Servlets (Jakarta EE / Servlet 6.0) |
| Frontend   | JSP, HTML5, CSS3, Vanilla JavaScript |
| Database   | MySQL 8.4                           |
| Server     | Apache Tomcat 10.1                  |
| JDBC Driver| MySQL Connector/J                   |

---

## Setup & Installation (Windows)

Follow every step below in order to get this project running on a fresh Windows PC.

---

### Step 1 - Install Java JDK 21

1. Go to [https://adoptium.net/temurin/releases/](https://adoptium.net/temurin/releases/)
2. Download **JDK 21** (Windows x64, `.msi` installer)
3. Run the installer. During installation, **check the option** to set `JAVA_HOME` and add to `PATH`
4. After installation, open **Command Prompt** and verify:

```cmd
java -version
```

You should see something like `openjdk version "21.x.x"`. If not:

5. Manually set the environment variable:
   - Press `Win + S`, search **"Environment Variables"**, click **"Edit the system environment variables"**
   - Click **"Environment Variables"** button
   - Under **System variables**, click **New**:
     - Variable name: `JAVA_HOME`
     - Variable value: `C:\Program Files\Eclipse Adoptium\jdk-21.0.x+x` (your actual JDK path)
   - Find `Path` in System variables, click **Edit**, click **New**, add: `%JAVA_HOME%\bin`
   - Click **OK** on all dialogs
   - **Close and reopen** Command Prompt, then run `java -version` again

---

### Step 2 - Install Apache Tomcat 10.1

1. Go to [https://tomcat.apache.org/download-10.cgi](https://tomcat.apache.org/download-10.cgi)
2. Under **Binary Distributions > Core**, download the **64-bit Windows zip** (e.g., `apache-tomcat-10.1.x-windows-x64.zip`)
3. Extract the zip to a location of your choice, for example:

```
C:\tomcat
```

So the folder structure looks like `C:\tomcat\apache-tomcat-10.1.x\bin\`, `C:\tomcat\apache-tomcat-10.1.x\webapps\`, etc.

4. Verify Tomcat works:
   - Open Command Prompt
   - Run:

```cmd
cd C:\tomcat\apache-tomcat-10.1.x\bin
startup.bat
```

   - A new console window should open with Tomcat logs
   - Open your browser and go to `http://localhost:8080` — you should see the Tomcat welcome page
   - Close the Tomcat console window (or run `shutdown.bat`) to stop it for now

> **Note:** If Tomcat doesn't start, make sure `JAVA_HOME` is set correctly (Step 1).

---

### Step 3 - Install MySQL 8.x

1. Go to [https://dev.mysql.com/downloads/installer/](https://dev.mysql.com/downloads/installer/)
2. Download **MySQL Installer for Windows** (the full installer, not the web one)
3. Run the installer and choose **"Developer Default"** or **"Server only"** setup type
4. During configuration:
   - Keep the default port **3306**
   - Set the **root password** to **empty** (leave both password fields blank), OR set a password and remember it (you'll need it in Step 8)
   - Complete the installation
5. Verify MySQL is running:
   - Open Command Prompt and run:

```cmd
mysql -u root -p
```

   - When prompted for a password, just press **Enter** (if you set an empty password) or type your password
   - You should see the `mysql>` prompt. Type `exit` to quit

> **Alternative:** If you prefer a portable MySQL (no installer), download the **ZIP Archive** from [https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/), extract it, initialize with `mysqld --initialize-insecure`, and start with `mysqld --console`.

---

### Step 4 - Clone the Repository

1. Install Git if you don't have it: [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Open Command Prompt and run:

```cmd
cd C:\
git clone https://github.com/priyansh1210/wp_project.git
cd wp_project
```

This will create the folder `C:\wp_project` with the project files.

---

### Step 5 - Create the Database

1. Open Command Prompt and connect to MySQL:

```cmd
mysql -u root -p
```

2. When prompted for a password, press **Enter** (or type your password)

3. Run the following SQL commands one by one (copy-paste each block):

```sql
CREATE DATABASE IF NOT EXISTS library_portal;
USE library_portal;
```

```sql
CREATE TABLE IF NOT EXISTS admin (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  username VARCHAR(50) UNIQUE,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  contact_no VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  username VARCHAR(50) UNIQUE,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  contact_no VARCHAR(20),
  profile_image LONGBLOB,
  image_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS books (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  author VARCHAR(100),
  isbn VARCHAR(20),
  genre VARCHAR(50),
  language VARCHAR(50) DEFAULT 'English',
  quantity INT DEFAULT 1,
  available INT DEFAULT 1,
  added_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS branches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  contact_no VARCHAR(20),
  location VARCHAR(200),
  added_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS borrow_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  book_id INT NOT NULL,
  borrow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  due_date TIMESTAMP NULL,
  return_date TIMESTAMP NULL,
  status VARCHAR(20) DEFAULT 'BORROWED',
  FOREIGN KEY (member_id) REFERENCES members(id),
  FOREIGN KEY (book_id) REFERENCES books(id)
);
```

```sql
CREATE TABLE IF NOT EXISTS deleted_members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  name VARCHAR(100),
  email VARCHAR(100),
  username VARCHAR(50),
  reason TEXT NOT NULL,
  deleted_by_admin_id INT,
  deleted_by_admin_name VARCHAR(100),
  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS deleted_branches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  branch_id INT NOT NULL,
  name VARCHAR(100),
  contact_no VARCHAR(20),
  location VARCHAR(200),
  reason TEXT NOT NULL,
  deleted_by_admin_id INT,
  deleted_by_admin_name VARCHAR(100),
  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO branches (name, contact_no, location) VALUES
('The Archive Co. - Main', '0412410984', 'Bengaluru');
```

**Seed the first admin.** Since admin self-signup is disabled, you must create the initial admin by hand. Any subsequent admins are added from the Admin Management page:

```sql
INSERT INTO admin (name, first_name, last_name, username, email, password, contact_no)
VALUES ('Library Admin', 'Library', 'Admin', 'admin', 'admin@archive.co', 'admin123', '0000000000');
```

4. Verify the tables were created:

```sql
SHOW TABLES;
```

You should see: `admin`, `books`, `branches`, `borrow_history`, `deleted_branches`, `deleted_members`, `members`

5. Type `exit` to quit MySQL.

---

### Step 6 - Deploy the App to Tomcat

Copy the `LibraryPortal` folder from the cloned repo into Tomcat's `webapps` directory.

1. Open **File Explorer**
2. Navigate to `C:\wp_project\tools\apache-tomcat-10.1.52\webapps\LibraryPortal`
3. **Copy** the entire `LibraryPortal` folder
4. **Paste** it into your Tomcat's webapps folder, for example:

```
C:\tomcat\apache-tomcat-10.1.x\webapps\
```

So the final path looks like:

```
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\login.jsp
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\web.xml
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\classes\com\library\servlets\*.java
...
```

> **Or via Command Prompt:**
> ```cmd
> xcopy /E /I "C:\wp_project\tools\apache-tomcat-10.1.52\webapps\LibraryPortal" "C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal"
> ```

---

### Step 7 - Add MySQL JDBC Driver

The project already includes `mysql-connector-j.jar` inside `LibraryPortal\WEB-INF\lib\`. Verify it's there:

```
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\lib\mysql-connector-j.jar
```

If the file is missing (it's a `.jar` file and may not have been pushed to Git), download it:

1. Go to [https://dev.mysql.com/downloads/connector/j/](https://dev.mysql.com/downloads/connector/j/)
2. Select **Platform Independent**, download the **ZIP Archive**
3. Extract it, find `mysql-connector-j-x.x.x.jar` inside
4. Copy it to:

```
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\lib\
```

Rename it to `mysql-connector-j.jar` (remove the version number).

---

### Step 8 - Configure Database Connection

If your MySQL uses **root with no password on port 3306**, you can skip this step — the default config already matches.

If your MySQL has a **different password, user, or port**, edit the connection file:

1. Open this file in any text editor (Notepad, VS Code, etc.):

```
C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\classes\com\library\servlets\DBConnection.java
```

2. Change these values to match your MySQL setup:

```java
private static final String URL = "jdbc:mysql://localhost:3306/library_portal";
private static final String USER = "root";
private static final String PASSWORD = "";  // put your MySQL root password here
```

3. **Save the file.** If you changed anything, you must recompile (see Step 9).

---

### Step 9 - Compile the Java Servlets

You need to compile the `.java` servlet files into `.class` files so Tomcat can run them.

1. Open **Command Prompt**
2. Navigate to the servlets source directory:

```cmd
cd C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\classes
```

3. Run the following compile command (adjust the Tomcat path if yours is different):

```cmd
javac -cp "C:\tomcat\apache-tomcat-10.1.x\lib\servlet-api.jar;C:\tomcat\apache-tomcat-10.1.x\webapps\LibraryPortal\WEB-INF\lib\mysql-connector-j.jar" com\library\servlets\*.java
```

4. If there are **no errors**, you should now see `.class` files alongside the `.java` files:

```cmd
dir com\library\servlets\*.class
```

You should see files like `DBConnection.class`, `AdminLoginServlet.class`, `MemberLoginServlet.class`, etc.

> **If you get errors:**
> - `'javac' is not recognized` → JAVA_HOME is not set properly. Go back to Step 1.
> - `package jakarta.servlet does not exist` → The path to `servlet-api.jar` is wrong. Find it inside your Tomcat's `lib` folder and fix the path.
> - `cannot find symbol: mysql` → The path to `mysql-connector-j.jar` is wrong. Fix the path in the command.

---

### Step 10 - Start Tomcat and Open the App

1. Make sure MySQL is running (check your Services or start it manually)

2. Start Tomcat:

```cmd
cd C:\tomcat\apache-tomcat-10.1.x\bin
startup.bat
```

3. Wait for the Tomcat console window to show: `Server startup in [xxxx] milliseconds`

4. Open your browser and go to:

```
http://localhost:8080/LibraryPortal
```

5. You should see the **login page**. Since there are no accounts yet:
   - Click **Register**
   - Select **Admin** role
   - Fill in all fields (name, email, username, password, contact)
   - Click **Register**
   - Log in with your new credentials

6. To **stop Tomcat**, run:

```cmd
C:\tomcat\apache-tomcat-10.1.x\bin\shutdown.bat
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **Tomcat won't start** | Make sure `JAVA_HOME` is set and points to your JDK (not JRE). Run `echo %JAVA_HOME%` in cmd to check. |
| **HTTP 404 - Page not found** | Make sure the `LibraryPortal` folder is directly inside Tomcat's `webapps` folder. The URL is case-sensitive. |
| **HTTP 500 - Internal Server Error** | Check Tomcat logs at `C:\tomcat\apache-tomcat-10.1.x\logs\localhost.yyyy-mm-dd.log`. Usually a database connection issue. |
| **Database connection failed** | Verify MySQL is running. Verify the username, password, and port in `DBConnection.java` match your MySQL setup. Make sure you created the `library_portal` database (Step 5). |
| **`mysql-connector-j.jar` not found** | Download it from the MySQL website and place it in `LibraryPortal\WEB-INF\lib\`. See Step 7. |
| **`javac` not recognized** | JDK is not in your PATH. Set `JAVA_HOME` and add `%JAVA_HOME%\bin` to PATH (see Step 1). |
| **Servlets return 404 after deploying** | You forgot to compile. Run the `javac` command from Step 9. |
| **Port 8080 already in use** | Another app is using port 8080. Either stop it, or change Tomcat's port in `conf\server.xml` (search for `8080` and change it to e.g. `8081`). |
| **CSS/images not loading** | Make sure the `css/`, `js/`, and `img/` folders are inside the `LibraryPortal` folder in webapps. |

---

## Project Structure

```
LibraryPortal/
├── WEB-INF/
│   ├── classes/com/library/servlets/   # Java Servlet classes
│   │   ├── DBConnection.java           # Database connection utility
│   │   ├── AdminLoginServlet.java      # Admin authentication
│   │   ├── MemberLoginServlet.java     # Member authentication
│   │   ├── AdminRegisterServlet.java   # Admin registration
│   │   ├── MemberRegisterServlet.java  # Member registration
│   │   ├── AddBookServlet.java         # Add new book
│   │   ├── UpdateBookServlet.java      # Edit book details
│   │   ├── DeleteBookServlet.java      # Remove book
│   │   ├── AddMemberServlet.java       # Admin adds member
│   │   ├── UpdateMemberServlet.java    # Edit member details
│   │   ├── DeleteMemberServlet.java    # Remove member
│   │   ├── AddBranchServlet.java       # Add library branch
│   │   ├── UpdateBranchServlet.java    # Edit branch details
│   │   ├── DeleteBranchServlet.java    # Remove branch (POST, 2-step + reason + audit)
│   │   ├── AddAdminServlet.java        # Admin creates another admin
│   │   ├── UpdateAdminServlet.java     # Admin updates an admin record
│   │   ├── DeleteAdminServlet.java     # Admin deletes an admin (blocks self/last)
│   │   ├── BorrowBookServlet.java      # Member borrows a book
│   │   ├── ReturnBookServlet.java      # Member returns a book
│   │   ├── ChangeCredentialsServlet.java # Change password
│   │   ├── ForgotPasswordServlet.java  # Forgot password flow
│   │   ├── ResetPasswordServlet.java   # Reset password
│   │   └── LogoutServlet.java          # Session invalidation
│   ├── lib/
│   │   └── mysql-connector-j.jar       # MySQL JDBC driver
│   └── web.xml                         # Deployment descriptor
├── includes/
│   ├── adminSidebar.jsp                # Admin navigation sidebar
│   ├── adminTopbar.jsp                 # Admin top header bar
│   ├── memberSidebar.jsp               # Member navigation sidebar
│   └── memberTopbar.jsp                # Member top header bar
├── css/
│   └── style.css                       # Complete application styles
├── js/
│   └── main.js                         # Client-side interactivity
├── img/                                # SVG icons and logos
├── sql/
│   └── schema_update.sql               # Database migration script
├── login.jsp                           # Entry point - login page
├── register.jsp                        # User registration
├── forgotPassword.jsp                  # Password recovery
├── resetPassword.jsp                   # Password reset form
├── adminDashboard.jsp                  # Admin main dashboard
├── adminBooks.jsp                      # Admin book management
├── adminUsers.jsp                      # Admin user management (+ deletion log)
├── adminAdmins.jsp                     # Admin management of other admins
├── adminBranches.jsp                   # Admin branch management (+ deletion log)
├── adminCatalog.jsp                    # Admin borrow/return tracking
├── memberDashboard.jsp                 # Member main dashboard
├── memberBooks.jsp                     # Member book browsing
├── memberBorrows.jsp                   # Member borrow history
└── memberProfile.jsp                   # Member profile page
```

---

## Pages Overview

### Authentication

| Page                 | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| `login.jsp`          | Split-screen login with role toggle (Admin / Member). Entry point. |
| `register.jsp`       | Member-only registration. Requires in-browser camera capture of a face photo to generate a virtual ID. Admin self-signup is disabled. |
| `forgotPassword.jsp` | Username-based password recovery initiation.                       |
| `resetPassword.jsp`  | Enter new password after username verification.                    |

### Admin Panel

| Page                   | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `adminDashboard.jsp`   | Overview with stats (total users, books, branches), donut chart for borrow status, overdue borrowers list, and recent activity. |
| `adminBooks.jsp`       | Full CRUD for books. Deletion is blocked while any copy is borrowed or if the book has prior borrow history (preserves audit trail). |
| `adminUsers.jsp`       | Full CRUD for members. Shows active-borrow count per member. Deletion requires that the member has returned all books, plus a mandatory reason (min 5 chars). A **Deletion Log** tab shows every deletion with reason and acting admin, visible to all admins. |
| `adminAdmins.jsp`      | Admin-only management of other admin accounts. Self-delete blocked; last-admin delete blocked. |
| `adminBranches.jsp`    | Full CRUD for library branches. Deletion uses a **two-step confirmation**: step 1 requires a reason (min 5 chars), step 2 requires typing the branch name exactly. A **Deletion Log** tab shows every deletion with reason and acting admin. |
| `adminCatalog.jsp`     | Tracks all borrow/return activity. Shows due date per borrow and flags overdue items (`due_date < NOW()`). Tab-based interface. |

### Member Panel

| Page                   | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `memberDashboard.jsp`  | Personal overview with stats (total books, available, currently borrowed, total borrows) and recent activity table. |
| `memberBooks.jsp`      | Browse all library books in a card layout. Filter by genre, search by title. Borrow books directly from the card; each card has a **Days** input (1-30) so members can choose the loan duration. |
| `memberBorrows.jsp`    | View currently borrowed books with due dates and full borrowing history. Overdue items are flagged automatically. Return books from the "Currently Borrowed" tab. |
| `memberProfile.jsp`    | Shows a **Virtual ID card** with the member's photo, user ID, name, and registration date. Personal details below the card. Change password via modal. |

### Shared Components

| Component              | Description                                              |
|------------------------|----------------------------------------------------------|
| `includes/adminSidebar.jsp`  | Admin navigation: Dashboard, Catalog, Books, Users, Admins, Branches, Logout. |
| `includes/memberSidebar.jsp` | Member navigation: Dashboard, Browse Books, My Borrows, Profile, Logout. |
| `includes/adminTopbar.jsp`   | Admin header with name, role, live clock, and settings.  |
| `includes/memberTopbar.jsp`  | Member header with name, role, live clock, and settings. |

---

## Database Schema

**Database name:** `library_portal`

### Tables

#### `admin`
| Column        | Type          | Description            |
|---------------|---------------|------------------------|
| id            | INT (PK, AI)  | Admin ID               |
| name          | VARCHAR(100)  | Full name              |
| first_name    | VARCHAR(50)   | First name             |
| last_name     | VARCHAR(50)   | Last name              |
| username      | VARCHAR(50)   | Unique username        |
| email         | VARCHAR(100)  | Email address          |
| password      | VARCHAR(255)  | Password               |
| contact_no    | VARCHAR(20)   | Contact number         |
| created_at    | TIMESTAMP     | Account creation date  |

#### `members`
| Column         | Type          | Description                              |
|----------------|---------------|------------------------------------------|
| id             | INT (PK, AI)  | Member ID                                |
| name           | VARCHAR(100)  | Full name                                |
| username       | VARCHAR(50)   | Unique username                          |
| email          | VARCHAR(100)  | Email address                            |
| password       | VARCHAR(255)  | Password                                 |
| contact_no     | VARCHAR(20)   | Contact number                           |
| profile_image  | LONGBLOB      | Face photo bytes captured at registration |
| image_type     | VARCHAR(50)   | MIME type of the photo (e.g. image/jpeg) |
| created_at     | TIMESTAMP     | Account creation date                    |

#### `books`
| Column        | Type          | Description                   |
|---------------|---------------|-------------------------------|
| id            | INT (PK, AI)  | Book ID                       |
| title         | VARCHAR(200)  | Book title                    |
| author        | VARCHAR(100)  | Author name                   |
| isbn          | VARCHAR(20)   | ISBN number                   |
| genre         | VARCHAR(50)   | Genre/category                |
| language      | VARCHAR(50)   | Language (default: English)   |
| quantity      | INT           | Total copies                  |
| available     | INT           | Currently available copies    |
| added_by      | INT           | Admin who added the book      |
| created_at    | TIMESTAMP     | Date added                    |

#### `branches`
| Column        | Type          | Description            |
|---------------|---------------|------------------------|
| id            | INT (PK, AI)  | Branch ID              |
| name          | VARCHAR(100)  | Branch name            |
| contact_no    | VARCHAR(20)   | Contact number         |
| location      | VARCHAR(200)  | Branch location        |
| added_by      | INT           | Admin who added it     |
| created_at    | TIMESTAMP     | Date added             |

#### `borrow_history`
| Column        | Type          | Description                        |
|---------------|---------------|------------------------------------|
| id            | INT (PK, AI)  | Record ID                          |
| member_id     | INT (FK)      | References `members.id`            |
| book_id       | INT (FK)      | References `books.id`              |
| borrow_date   | TIMESTAMP     | When the book was borrowed         |
| due_date      | TIMESTAMP     | Expected return date (borrow + chosen days) |
| return_date   | TIMESTAMP     | When the book was returned (nullable) |
| status        | VARCHAR(20)   | `BORROWED` or `RETURNED`           |

#### `deleted_members` (audit log)
| Column                  | Type          | Description                     |
|-------------------------|---------------|---------------------------------|
| id                      | INT (PK, AI)  | Log record ID                   |
| member_id               | INT           | Original member ID              |
| name                    | VARCHAR(100)  | Snapshot of name at deletion    |
| email                   | VARCHAR(100)  | Snapshot of email at deletion   |
| username                | VARCHAR(50)   | Snapshot of username            |
| reason                  | TEXT          | Reason provided by admin        |
| deleted_by_admin_id     | INT           | Admin who performed the delete  |
| deleted_by_admin_name   | VARCHAR(100)  | Name of the acting admin        |
| deleted_at              | TIMESTAMP     | When the delete occurred        |

#### `deleted_branches` (audit log)
| Column                  | Type          | Description                     |
|-------------------------|---------------|---------------------------------|
| id                      | INT (PK, AI)  | Log record ID                   |
| branch_id               | INT           | Original branch ID              |
| name                    | VARCHAR(100)  | Snapshot of branch name         |
| contact_no              | VARCHAR(20)   | Snapshot of contact             |
| location                | VARCHAR(200)  | Snapshot of location            |
| reason                  | TEXT          | Reason provided by admin        |
| deleted_by_admin_id     | INT           | Admin who performed the delete  |
| deleted_by_admin_name   | VARCHAR(100)  | Name of the acting admin        |
| deleted_at              | TIMESTAMP     | When the delete occurred        |

---

## Servlets

All servlets are in `com.library.servlets` package and use `@WebServlet` annotations for URL mapping.

| Servlet                    | URL Pattern              | Method | Description                       |
|----------------------------|--------------------------|--------|-----------------------------------|
| AdminLoginServlet          | /AdminLoginServlet       | POST   | Authenticates admin credentials   |
| MemberLoginServlet         | /MemberLoginServlet      | POST   | Authenticates member credentials  |
| AdminRegisterServlet       | /AdminRegisterServlet    | POST   | **Disabled.** Admin self-signup is blocked; redirects with an error. |
| MemberRegisterServlet      | /MemberRegisterServlet   | POST   | Creates a new member account. Requires a base64 face photo captured at signup. |
| LogoutServlet              | /LogoutServlet           | GET    | Invalidates session, redirects to login |
| AddBookServlet             | /AddBookServlet          | POST   | Adds a new book to catalog        |
| UpdateBookServlet          | /UpdateBookServlet       | POST   | Updates book details              |
| DeleteBookServlet          | /DeleteBookServlet       | GET    | Deletes a book by ID. Blocked if the book is currently borrowed or has borrow history. |
| AddMemberServlet           | /AddMemberServlet        | POST   | Admin creates a member account    |
| UpdateMemberServlet        | /UpdateMemberServlet     | POST   | Admin updates member details      |
| DeleteMemberServlet        | /DeleteMemberServlet     | POST   | Admin deletes a member. Requires a reason (logged) and the member must have no active borrows. |
| AddAdminServlet            | /AddAdminServlet         | POST   | Existing admin creates another admin account |
| UpdateAdminServlet         | /UpdateAdminServlet      | POST   | Existing admin updates another admin record |
| DeleteAdminServlet         | /DeleteAdminServlet      | GET    | Deletes an admin. Blocks self-delete and last-admin delete. |
| AddBranchServlet           | /AddBranchServlet        | POST   | Adds a new library branch         |
| UpdateBranchServlet        | /UpdateBranchServlet     | POST   | Updates branch details            |
| DeleteBranchServlet        | /DeleteBranchServlet     | POST   | Deletes a branch. Requires reason + branch name confirmation (server-verified); logged to `deleted_branches`. |
| BorrowBookServlet          | /BorrowBookServlet       | POST   | Records a book borrow. Accepts `days` (1-30) and stores a due date. |
| ReturnBookServlet          | /ReturnBookServlet       | POST   | Records a book return             |
| ChangeCredentialsServlet   | /ChangeCredentialsServlet| POST   | Changes user password             |
| ForgotPasswordServlet      | /ForgotPasswordServlet   | POST   | Initiates password reset          |
| ResetPasswordServlet       | /ResetPasswordServlet    | POST   | Completes password reset          |

---

## Key Features

- **Role-based access** - Separate Admin and Member interfaces
- **Controlled admin provisioning** - Admin self-signup is disabled; new admins are created only by existing admins via the Admin Management page. First admin is seeded by SQL.
- **Member virtual ID** - Face photo is captured in-browser at registration (via `getUserMedia`) and rendered on a virtual ID card in the member profile with name, user ID, and registration date.
- **Configurable borrow duration** - Members pick a loan length of 1-30 days when borrowing; a due date is stored and displayed.
- **Automatic overdue flagging** - Entries with `due_date < NOW()` are shown as Overdue in both member and admin views.
- **Book management** - Full CRUD with genre, language, and availability tracking. Deletion blocked while copies are out or history exists (protects the audit trail).
- **Borrow/Return system** - Members borrow books, admins track current and overdue items from the catalog.
- **Branch management** - Manage multiple library branches. Deletion requires a reason and a two-step confirmation (type the branch name exactly) to prevent accidents.
- **User management** - Admins can add, edit, and remove members. Deletion requires that the member has returned all books plus a written reason.
- **Audit logs** - `deleted_members` and `deleted_branches` tables persist who deleted what, when, and why. Both logs are surfaced as tabs on their respective admin pages and are visible to all admins.
- **Dashboard analytics** - Visual stats with donut charts and activity feeds
- **Responsive design** - Clean black & white theme with CSS variables
- **Live clock** - Real-time clock display in the topbar
- **Search & filter** - Real-time table search and genre-based book filtering
- **Session management** - 30-minute timeout with role-based access control
- **Password recovery** - Forgot password and reset flow

---

## License

This project was built as a Web Programming Lab project at MIT Bengaluru.
