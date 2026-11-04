# PATIENT RECORD MANAGEMENT SYSTEM

A full-stack, enterprise-style Java Web Technology Assignment-II web application designed for hospital patient registration, physician scheduling, clinical records management, and XML/XSD/XSLT data transformation.

---

## 1. Project Overview & Objectives

The **Patient Record Management System (RMS)** is a dynamic healthcare information portal built with native Java Servlets, JavaServer Pages (JSP), JDBC, and MySQL. It adheres to the classic Model-View-Controller (MVC) architectural pattern without relying on heavy external frameworks, making it optimal for college academic submissions and practical lab examinations.

### Key Objectives:
- Provide hospital receptionists and medical staff with a secure authentication gateway using BCrypt password encryption.
- Maintain comprehensive patient demographic profiles and clinical history records with validation.
- Maintain a medical doctor registry categorized by departments and availability schedules.
- Facilitate appointment scheduling with validation ensuring appointments cannot be booked in the past.
- Demonstrate XML-based clinical interoperability by exporting live patient records into well-formed XML, enforcing structural validation through an XML Schema (XSD), and rendering formatted HTML tables using an XSLT stylesheet.

---

## 2. Technology Stack

| Component | Technology | Version / Specification |
|---|---|---|
| **Programming Language** | Java (JDK) | Java 8+ compatible (compiled with `--release 8`) |
| **Web Tier** | Java Servlets & JSP | Servlet 4.0 (`javax.servlet`), JSP 2.3 (`javax.servlet.jsp`) |
| **Web Server / Servlet Container** | Apache Tomcat | Tomcat 9.0.x (Java EE 8 standard) |
| **Database** | MySQL / MariaDB | MySQL 8.0+ / 5.7+ (`patient_record_db`) |
| **Persistence Layer** | JDBC | Prepared Statements, try-with-resources safe cleanup |
| **Security / Hashing** | BCrypt (jBCrypt) | 10-round salted password hashing |
| **XML Processing** | Java XML / JAXP | W3C XML Schema (XSD), XSLT 1.0 (Xalan / Saxon) |
| **Frontend / Styling** | Semantic HTML5 & CSS3 | Custom Healthcare Blue-White theme (no external CDN required) |
| **Client Validation** | Vanilla JavaScript | Regex phone/email validation, date checks |
| **Session Management** | HttpSession & Cookies | 30-minute timeout, "Remember Username" cookie preference |
| **Build & Packaging Tool** | Apache Maven | Maven 3.9+, WAR packaging |

> **Tomcat Compatibility Note:** This project strictly uses `javax.servlet` APIs compatible with **Apache Tomcat 9**. It does NOT use `jakarta.servlet` APIs which are meant for Tomcat 10+.

---

## 3. Functional Modules

### A. Authentication & Session Management
- **Database-Backed Users:** Staff credentials stored in `users` table with BCrypt hashed passwords.
- **Session Filter (`AuthenticationFilter`):** Protects private servlets and JSP views (`/dashboard`, `/patients*`, `/doctors*`, `/appointments*`, `/export-xml`). Unauthenticated visits are intercepted and redirected to `/login?msg=auth_required`.
- **Remember Username Cookie:** Allows users to remember their username across browser restarts without compromising security (passwords are never saved in cookies).
- **Session Expiry & Logout:** Inactivates HTTP sessions after 30 minutes or explicitly via `/logout`.

### B. Hospital Dashboard
- Displays live aggregate counts: Total Patients, Active Doctors, Scheduled Visits, and Completed Visits.
- Provides 8 intuitive action cards linking directly to all hospital workflows.
- Surfaces recent patients and upcoming consultations in responsive overview tables.

### C. Patient Registration & Management
- Auto-generates unique sequential identifiers (e.g. `PAT-1001`, `PAT-1002`).
- Captures full demographic records: Full Name, DOB, Gender, Phone, Email, Address, Blood Group, and Medical History / Clinical Notes.
- Validates required fields on both client (JavaScript) and server (Java).
- Prevents accidental duplicates and ensures Date of Birth is in the past.

### D. Patient Records Directory & Search
- Formatted tabular view with responsive typography and blood group badges.
- Dynamic multi-column search by **Patient ID**, **Patient Name**, or **Phone Number**.
- Modal-style inline updating (`update-patient.jsp`) and safe record deletion with user confirmation.
- Displays friendly empty-state illustration when query returns zero records.

### E. Medical Doctor Roster
- Maintains physician directory: Doctor ID (e.g. `DOC-101`), Full Name, Specialization, Department, Phone, Email, and Consultation Availability.
- Dedicated doctor registration interface (`doctor-form.jsp`).

### F. Appointment Scheduling
- Appointment booking interface (`appointment-form.jsp`) dynamically populated with active patients and doctors from the database.
- Validates appointment dates ensuring past dates cannot be selected.
- Allows staff to transition appointment status (`SCHEDULED` &rarr; `COMPLETED` or `CANCELLED`).

### G. XML, XSD & XSLT Transformation Center
- **XML Export Servlet (`/export-xml`):** Generates well-formed XML with standard declaration `<?xml version="1.0" encoding="UTF-8"?>`, root element `<patients>`, and rigorous XML entity escaping (`&`, `<`, `>`, `"`, `'`).
- **XSD Schema (`patients.xsd`):** Enforces data contracts, data types, and required elements.
- **XSLT Stylesheet (`patients.xsl`):** Automatically transforms patient XML data into a styled HTML table with summary statistics.
- **Interactive UI (`xml-view.jsp`):** Provides single-click actions to download XML, view browser-rendered XML with stylesheet links, trigger server-side XSLT transformation, and inspect the raw XML payload.

---

## 4. Complete Project Directory Structure

```text
patient-management-system/
├── pom.xml                               # Maven project configuration & dependencies
├── database.sql                          # MySQL schema, table definitions & seed data
├── build.bat                             # Windows automated build script
├── .gitignore                            # Git exclusion rules
├── README.md                             # Comprehensive project documentation
├── TESTING.md                            # Test case specifications and execution results
├── PROJECT_REPORT.md                     # Academic project report & system architecture
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/patientmanagement/
│   │   │       ├── config/
│   │   │       │   └── DBConnection.java       # Configurable JDBC connection manager
│   │   │       ├── dao/
│   │   │       │   ├── UserDAO.java            # User authentication & auto-seeding
│   │   │       │   ├── PatientDAO.java         # Patient CRUD & multi-field search
│   │   │       │   ├── DoctorDAO.java          # Doctor directory & ID generation
│   │   │       │   └── AppointmentDAO.java     # Appointment scheduling & metrics
│   │   │       ├── filter/
│   │   │       │   └── AuthenticationFilter.java # Protected endpoint security filter
│   │   │       ├── model/
│   │   │       │   ├── User.java               # Staff user entity
│   │   │       │   ├── Patient.java            # Patient health record entity
│   │   │       │   ├── Doctor.java             # Consulting physician entity
│   │   │       │   ├── Appointment.java        # Scheduled visit entity
│   │   │       │   └── DashboardStats.java     # Dashboard summary metrics DTO
│   │   │       ├── servlet/
│   │   │       │   ├── LoginServlet.java       # User authentication controller
│   │   │       │   ├── LogoutServlet.java      # Session termination controller
│   │   │       │   ├── DashboardServlet.java   # Central statistics controller
│   │   │       │   ├── PatientServlet.java     # Patient lifecycle controller
│   │   │       │   ├── DoctorServlet.java      # Doctor directory controller
│   │   │       │   ├── AppointmentServlet.java # Appointment scheduling controller
│   │   │       │   └── XmlExportServlet.java   # XML/XSD/XSLT transformation controller
│   │   │       └── util/
│   │   │           ├── PasswordUtil.java       # BCrypt password hashing & matching
│   │   │           ├── ValidationUtil.java     # Server-side input validation rules
│   │   │           └── XmlUtil.java            # XML escaping, XSD check & XSLT engine
│   │   ├── resources/
│   │   │   └── db.properties                   # External database configuration
│   │   └── webapp/
│   │       ├── index.jsp                       # Root entry point router
│   │       ├── login.jsp                       # Healthcare authentication view
│   │       ├── dashboard.jsp                   # Main metrics & navigation cards
│   │       ├── patient-form.jsp                # Patient registration form
│   │       ├── patients.jsp                    # Patient directory table & search
│   │       ├── update-patient.jsp              # Patient record modification form
│   │       ├── doctors.jsp                     # Medical doctor directory table
│   │       ├── doctor-form.jsp                 # Doctor registration form
│   │       ├── appointment-form.jsp            # Appointment scheduling form
│   │       ├── appointments.jsp                # Appointment schedule & status table
│   │       ├── xml-view.jsp                    # XML/XSD/XSLT demonstration center
│   │       ├── error.jsp                       # Friendly user notice & error view
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                     # Servlet 4.0 deployment descriptor
│   │       │   └── fragments/
│   │       │       ├── navbar.jspf             # Universal responsive navigation bar
│   │       │       └── footer.jspf             # Footer with JavaScript links
│   │       ├── assets/
│   │       │   ├── css/
│   │       │   │   └── style.css               # Responsive medical design stylesheet
│   │       │   └── js/
│   │       │       └── validation.js           # Client-side form validation scripts
│   │       └── xml/
│   │           ├── patients.xsd                # XML Schema definition
│   │           ├── patients.xsl                # XSLT transformation stylesheet
│   │           └── sample-patients.xml         # Pre-packaged sample XML document
│   └── test/
│       └── java/
│           └── com/patientmanagement/
│               ├── PasswordUtilTest.java       # BCrypt hashing unit tests
│               ├── ValidationUtilTest.java     # Validation utility unit tests
│               ├── XmlUtilTest.java            # XML, XSD & XSLT transformation tests
│               ├── ModelTest.java              # Entity & DTO unit tests
│               └── DaoH2IntegrationTest.java   # Full in-memory SQL integration tests
```

---

## 5. Database Setup Instructions

The application requires a MySQL or MariaDB database named `patient_record_db`.

### Option A: Using MySQL Workbench
1. Open **MySQL Workbench** and connect to your local MySQL instance.
2. Click **File** &rarr; **Open SQL Script...** and select `database.sql` from the project root.
3. Click the **Execute (Lightning Bolt)** icon to execute the entire script.
4. In the left Navigator sidebar, right-click and choose **Refresh All**. You will see `patient_record_db` with tables `users`, `patients`, `doctors`, and `appointments`.

### Option B: Using MySQL Command Line Client
1. Open PowerShell or Command Prompt.
2. Execute the database script using the MySQL client:
   ```cmd
   mysql -u root -p < "database.sql"
   ```
3. Enter your MySQL root password when prompted.

### Database Credentials Configuration
Database connection settings are configured in `src/main/resources/db.properties`:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/patient_record_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=root123
```
*Modify `db.user` and `db.password` if your local MySQL uses different credentials.*

Alternatively, you can set Environment Variables without changing code:
```cmd
set DB_URL=jdbc:mysql://localhost:3306/patient_record_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
set DB_USER=root
set DB_PASSWORD=your_password
```

---

## 6. How to Run the Project (Instant 1-Click Execution)

### Option 1: Instant 1-Click Run (Recommended)
Simply double-click:
```cmd
run.bat
```
*(Or in Command Prompt / PowerShell, run `.\run.bat`)*.

**What `run.bat` does automatically:**
1. Verifies Java 8+ environment.
2. Checks that the pre-packaged Apache Tomcat 9 server is ready.
3. Automatically launches the Tomcat 9 server on port 8080.
4. Automatically opens your default web browser to `http://localhost:8080/patient-management-system/`.
5. Connects to MySQL if running on localhost:3306, OR automatically activates the persistent embedded database with all sample records loaded if MySQL is not running!

To stop the server at any time, run `stop.bat` or press `Ctrl + C` in the console window.

---

### Option 2: Build with Maven & Deploy to External Tomcat 9

1. Run the build script or Maven:
   ```cmd
   mvn clean package
   ```
   *(Or double-click `build.bat`)*.
2. Copy `target/patient-management-system.war` into your Tomcat installation directory's `webapps/` folder:
   ```cmd
   copy target\patient-management-system.war "C:\apache-tomcat-9.0.xx\webapps\"
   ```
3. Start Tomcat using `bin\startup.bat`.
4. Open your browser and navigate to:
   ```text
   http://localhost:8080/patient-management-system/
   ```

---

## 7. Demo Login Credentials

The database script and application automatically initialize the default administrator account:

| Field | Value | Notes |
|---|---|---|
| **Portal URL** | `http://localhost:8080/patient-management-system/login` | Redirects automatically from root |
| **Username** | `admin` | Case-insensitive match |
| **Password** | `admin123` | Verified against BCrypt salted hash |
| **Role** | `ADMIN` | System Administrator privileges |

*(An additional staff demo account is also available: Username `nurse_sarah`, Password `admin123`)*.

---

## 8. How to Demonstrate Each Feature to an Examiner

### 1. Login & Security Demonstration:
- Go to `http://localhost:8080/patient-management-system/login`.
- Attempt logging in with incorrect credentials (e.g. `admin` / `wrongpass`) &rarr; Note the red warning alert.
- Check the **"Remember username"** checkbox and log in with `admin` / `admin123`.
- After successful login, you will land on the Hospital Dashboard.
- Try copying a protected URL (e.g. `/patients`), logging out, and pasting that URL in an incognito window &rarr; Note automatic redirect to login with `msg=auth_required`.

### 2. Patient Registration & Validation:
- Click **"Register Patient"** in the navigation bar.
- Note the auto-generated Patient ID (e.g. `PAT-1006`).
- Submit with empty fields &rarr; Client-side validation outlines invalid fields in red.
- Enter a future Date of Birth &rarr; Error alert states date must be in the past.
- Enter valid patient information and save &rarr; Green success banner confirms registration.

### 3. Patient Search & Update:
- Click **"Patients"** in the navigation bar.
- In the search bar, type a patient's name, phone, or ID (e.g. `Jenkins` or `PAT-1002`) and click **Search**.
- Click **"Edit / Update"** on any record, modify the address or medical history, and save &rarr; Record updates immediately.

### 4. Doctor Management:
- Click **"Doctors"** in the navigation bar.
- View registered physicians, departments, and consultation availability hours.
- Click **"+ Add New Doctor"** to enroll a new specialist.

### 5. Appointment Scheduling:
- Click **"Appointments"** &rarr; **"+ Book Appointment"**.
- Select a registered patient and doctor from the dynamic dropdowns.
- Select a date in the past &rarr; System flags that appointment date cannot be in the past.
- Select a valid future date/time, provide a visit reason, and confirm &rarr; Appointment is scheduled.
- On the appointments list, click **"Complete"** to transition status from `SCHEDULED` to `COMPLETED`.

### 6. XML, XSD & XSLT Demonstration:
- Click **"XML Center"** in the navigation bar (`/export-xml`).
- **Schema Validation:** Note the green badge indicating the live XML passes `patients.xsd` schema validation.
- **Download XML:** Click "Download XML File" to download `patient_records.xml`. Open it in Notepad to verify UTF-8 XML declaration, `<patients>` root, and XML entity escaping (e.g. `&amp;`, `&lt;`).
- **Server-Side XSLT Transformation:** Click **"View Server-Transformed HTML Table"** &rarr; The servlet applies `patients.xsl` on the fly to render a formatted HTML report.
- **Client/Browser XSLT Transformation:** Click **"View Raw XML with Browser XSLT Link"** &rarr; Demonstrates client-side XML stylesheet processing in the browser.

---

## 9. Common Troubleshooting & Solutions

| Issue | Root Cause | Solution |
|---|---|---|
| **Port 8080 already in use** | Another service (e.g. Jenkins, Oracle, IIS) is bound to 8080 | Change `<Connector port="8080"...` to `8081` in Tomcat's `conf/server.xml`. |
| **`Communications link failure` / `Connection refused`** | MySQL server is stopped or port 3306 is blocked | Ensure MySQL service is running via Windows Services (`services.msc` &rarr; MySQL80). |
| **`Access denied for user 'root'@'localhost'`** | Incorrect MySQL root password in `db.properties` | Open `src/main/resources/db.properties` and update `db.password` to match your local MySQL installation. |
| **HTTP 404 on opening application** | WAR file was not deployed or Tomcat failed to extract | Ensure WAR is placed in `webapps/` and check `logs/catalina.out` for deployment logs. |
| **JSP Compilation Error on Tomcat 10** | Using Tomcat 10+ (`jakarta.servlet`) instead of Tomcat 9 (`javax.servlet`) | Deploy on **Apache Tomcat 9.0.x**. Tomcat 10 uses Jakarta EE 9 package namespaces. |

---

## 10. Known Limitations

- **Email Dispatch:** Email addresses are captured and validated, but direct SMTP mailing is not integrated to maintain offline self-containment for college labs.
- **Single Currency/Language:** The user interface is rendered in English and standard ISO date formats (`YYYY-MM-DD`).
- **Offline Self-Contained Design:** To ensure zero dependencies on third-party cloud CDNs during viva demonstrations, all styles and scripts are local.
