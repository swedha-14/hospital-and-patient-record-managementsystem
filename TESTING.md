# TEST EXECUTION REPORT & TEST CASES

**Project Title:** Patient Record Management System  
**Test Date:** October 25, 2026  
**Environment:** OpenJDK 25 (compiled with `--release 8`), Apache Maven 3.9.6, JUnit 4.13.2, H2 2.2.224 In-Memory DB (MySQL Compatibility Mode), W3C XML Validator  
**Overall Automated Test Result:** **20 PASSED / 0 FAILED / 0 SKIPPED**  
**WAR Build Result:** **SUCCESS (`patient-management-system.war` generated)**

---

## 1. Automated Test Suite Execution Summary

The following test suites were executed directly within the Antigravity build environment using Apache Maven:

```text
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.patientmanagement.DaoH2IntegrationTest
Oct 25, 2026 com.patientmanagement.dao.UserDAO initDefaultAdminIfEmpty
INFO: Default admin user initialized successfully.
Tests run: 4, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 1.849 s -- in com.patientmanagement.DaoH2IntegrationTest

Running com.patientmanagement.ModelTest
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.001 s -- in com.patientmanagement.ModelTest

Running com.patientmanagement.PasswordUtilTest
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.291 s -- in com.patientmanagement.PasswordUtilTest

Running com.patientmanagement.ValidationUtilTest
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.062 s -- in com.patientmanagement.ValidationUtilTest

Running com.patientmanagement.XmlUtilTest
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.581 s -- in com.patientmanagement.XmlUtilTest

Results:
Tests run: 20, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

---

## 2. Test Cases and Execution Results

| Test ID | Module | Test Description | Input / Condition | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| **TC-SEC-01** | Security | Password BCrypt Hashing | Plain text `admin123` | Salted hash generated starting with `$2a$` | Salted hash generated; verifies with `checkpw` | **PASSED** |
| **TC-SEC-02** | Security | Password Verification | Valid plain text password vs hash | `checkPassword` returns `true` | Returned `true` | **PASSED** |
| **TC-SEC-03** | Security | Invalid Password Rejection | `admin123` vs `wrongpassword` | `checkPassword` returns `false` | Returned `false` | **PASSED** |
| **TC-SEC-04** | Security | Malformed Hash Handling | `admin123` vs `invalid-hash` | `checkPassword` safely returns `false` without crashing | Safely returned `false` | **PASSED** |
| **TC-VAL-01** | Validation | Empty / Blank String Detection | `""`, `"   "`, `null` | Returns `false` | Returned `false` | **PASSED** |
| **TC-VAL-02** | Validation | Valid Phone Number | `9876543210`, `+919876543210`, `(987) 654-3210` | Returns `true` | Returned `true` | **PASSED** |
| **TC-VAL-03** | Validation | Invalid Phone Number | `12345` (too short), letters | Returns `false` | Returned `false` | **PASSED** |
| **TC-VAL-04** | Validation | Valid Email Address | `john@example.com`, empty (optional) | Returns `true` | Returned `true` | **PASSED** |
| **TC-VAL-05** | Validation | Invalid Email Address | `user@.com`, `not-an-email` | Returns `false` | Returned `false` | **PASSED** |
| **TC-VAL-06** | Validation | Past Date for DOB | Date 5 days in past | Returns `true` for `isPastDate` | Returned `true` | **PASSED** |
| **TC-VAL-07** | Validation | Future/Today for Appointment | Today or 5 days in future | Returns `true` for `isFutureOrToday` | Returned `true` | **PASSED** |
| **TC-XML-01** | XML | XML Entity Escaping | `Smith & Sons <Pvt> "Ltd" 'Health'` | `Smith &amp; Sons &lt;Pvt&gt; &quot;Ltd&quot; &apos;Health&apos;` | Exactly matched expected entity replacements | **PASSED** |
| **TC-XML-02** | XML | XML Generation | List of Patient models | Well-formed XML string with declaration & root `<patients>` | Well-formed XML produced containing all patient fields | **PASSED** |
| **TC-XML-03** | XML | XSD Schema Validation | Generated XML vs `patients.xsd` | W3C XML Schema validator passes with zero validation errors | Validated successfully against `patients.xsd` | **PASSED** |
| **TC-XML-04** | XML | XSLT Stylesheet Transformation | Patient XML vs `patients.xsl` | HTML document produced containing styled table and data | Produced HTML with table containing patient names and badges | **PASSED** |
| **TC-DAO-01** | Database | Default Admin Auto-Seeding | Empty `users` table | `UserDAO.initDefaultAdminIfEmpty()` inserts `admin` / `admin123` | Admin inserted and successfully authenticated | **PASSED** |
| **TC-DAO-02** | Database | User Authentication | Valid username and password | Returns populated `User` model | Returns `User` object with role `ADMIN` | **PASSED** |
| **TC-DAO-03** | Database | Patient ID Generation | Sequence query on DB | Next ID formatted as `PAT-xxxx` (e.g. `PAT-1001`) | Returned `PAT-1001` | **PASSED** |
| **TC-DAO-04** | Database | Patient Insertion & Query | Insert `Patient` model | Patient stored and retrievable by ID | Added and fetched with exact demographic fields | **PASSED** |
| **TC-DAO-05** | Database | Patient Multi-Field Search | Search keyword `"Grace"` | Matches `full_name`, `patient_id`, or `phone` | Returned matching patient record | **PASSED** |
| **TC-DAO-06** | Database | Patient Update | Modify name and address | Record updated in database | Database reflects new name and address | **PASSED** |
| **TC-DAO-07** | Database | Doctor ID Generation | Sequence query on DB | Formatted as `DOC-xxx` (e.g. `DOC-101`) | Generated `DOC-101` | **PASSED** |
| **TC-DAO-08** | Database | Doctor Insertion | Insert `Doctor` model | Doctor record stored in database | Doctor saved and retrieved by ID | **PASSED** |
| **TC-DAO-09** | Database | Appointment Scheduling | Insert `Appointment` with patient & doctor | Appointment stored with status `SCHEDULED` | Saved with status `SCHEDULED` | **PASSED** |
| **TC-DAO-10** | Database | Appointment Status Transition | Update status from `SCHEDULED` to `COMPLETED` | Status changed to `COMPLETED` in database | Status updated and verified | **PASSED** |
| **TC-DAO-11** | Database | Dashboard Aggregation | Count queries across tables | Metrics DTO populated with accurate counts | Counts match inserted records | **PASSED** |
| **TC-WAR-01** | Packaging | Maven WAR Packaging | `mvn package` execution | Single executable deployable WAR file generated | `patient-management-system.war` generated (4.58 MB) | **PASSED** |

---

## 3. Manual Live Testing Instructions (For Local Tomcat & MySQL Server)

When you deploy `patient-management-system.war` to Apache Tomcat 9:

| Scenario | Steps to Execute | Expected UI Behavior |
|---|---|---|
| **Unauthenticated Access** | Open `http://localhost:8080/patient-management-system/dashboard` directly in an Incognito window | Redirected to `/login?msg=auth_required` with an informational banner |
| **Remember Username** | Check "Remember username", log in as `admin`, log out, refresh login page | Username field is pre-filled with `admin` |
| **Empty Record Search** | In Patient Directory, search for `NonExistentName123` | Empty-state message appears: "No patients match your search criteria" |
| **Client Validation** | In Registration form, submit blank name or invalid phone | Form is halted on client side; fields highlighted in red with descriptive tooltips |
| **Past Date Appointment Check** | In Appointment booking, select yesterday's date | Server and client reject booking: "Appointment date cannot be in the past" |
| **XML Browser Rendering** | Navigate to `/export-xml?mode=raw` | Browser loads raw XML with linked `patients.xsl` and presents formatted HTML table |
| **XML Server Transformation** | Navigate to `/export-xml?mode=transform` | Server-rendered HTML table displays directly in browser |
