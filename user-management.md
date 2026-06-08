# MySQL User Management Guide
## A Comprehensive Reference for Administration and Security

---

## 1. Introduction
User account management in MySQL is a critical component of database security and administration. It encompasses the creation, modification, and deletion of user accounts, as well as the assignment of privileges and roles that dictate what actions users can perform on which database objects.

This document details all major user management features available in MySQL (up to MySQL 8.0+), providing the necessary SQL statements and practical examples for each operation.

---

## 2. Creating and Managing User Accounts

### 2.1 Creating Users (`CREATE USER`)
The `CREATE USER` statement creates new MySQL accounts. An account consists of a user name and a host name, which defines where the user is allowed to connect from.

**Creating a Local User**

```sql
CREATE USER 'jdoe'@'localhost' IDENTIFIED BY 'SecurePass123!';

```

**Creating a Remote User**
Allow a user to connect from any remote host using the `%` wildcard:

```sql
CREATE USER 'admin'@'%' IDENTIFIED BY 'StrongPassword!';

```

**Creating a User for a Specific IP Address**

```sql
CREATE USER 'app_user'@'192.168.1.50' IDENTIFIED BY 'AppPass456!';

```

### 2.2 Deleting Users (`DROP USER`)

The `DROP USER` statement removes one or more MySQL accounts and their associated privileges.

```sql
DROP USER 'jdoe'@'localhost';

```

```sql
DROP USER 'user1'@'localhost', 'user2'@'%';

```

### 2.3 Renaming Users (`RENAME USER`)

Use the `RENAME USER` statement to change the name or the host part of an existing user account.

```sql
RENAME USER 'jdoe'@'localhost' TO 'john.doe'@'localhost';

```

---

## 3. Password Management and Security

### 3.1 Changing Passwords (`ALTER USER`)

The `ALTER USER` statement is used to change passwords or modify other user attributes.

```sql
ALTER USER 'john.doe'@'localhost' IDENTIFIED BY 'NewSecurePass789!';

```

### 3.2 Password Expiration

You can manually expire a user's password, forcing them to change it upon their next login.

```sql
ALTER USER 'app_user'@'192.168.1.50' PASSWORD EXPIRE;

```

Set a password to expire automatically after a certain number of days:

```sql
ALTER USER 'john.doe'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;

```

To disable automatic expiration for a specific user:

```sql
ALTER USER 'admin'@'%' PASSWORD EXPIRE NEVER;

```

### 3.3 Account Locking and Unlocking

Administrators can lock an account to temporarily prevent a user from logging in without deleting their account or privileges.

**Locking an Account**

```sql
ALTER USER 'john.doe'@'localhost' ACCOUNT LOCK;

```

**Unlocking an Account**

```sql
ALTER USER 'john.doe'@'localhost' ACCOUNT UNLOCK;

```

---

## 4. Privilege Management

MySQL privileges dictate what actions a user is allowed to perform. Privileges can be granted at different levels: Global, Database, Table, Column, and Routine.

### 4.1 Granting Privileges (`GRANT`)

**Global Privileges**
Apply to all databases on a given server. (Use with caution)

```sql
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

```

**Database-Level Privileges**
Apply to all objects within a specific database.

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON sales_db.* TO 'app_user'@'192.168.1.50';

```

**Table-Level Privileges**
Apply to a specific table within a database.

```sql
GRANT SELECT, UPDATE ON sales_db.invoices TO 'finance_user'@'localhost';

```

**Column-Level Privileges**
Apply only to specific columns within a table.

```sql
GRANT SELECT (employee_id, first_name, last_name), UPDATE (phone_number) 
ON hr_db.employees TO 'hr_assistant'@'localhost';

```

**Routine Privileges**
Apply to stored procedures and functions.

```sql
GRANT EXECUTE ON PROCEDURE sales_db.generate_report TO 'report_user'@'%';

```

### 4.2 Revoking Privileges (`REVOKE`)

The `REVOKE` statement removes privileges from a user account.

```sql
REVOKE UPDATE ON sales_db.invoices FROM 'finance_user'@'localhost';

```

To completely revoke all privileges from a user:

```sql
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'john.doe'@'localhost';

```

### 4.3 Viewing User Privileges (`SHOW GRANTS`)

To see what privileges have been assigned to an account:

```sql
SHOW GRANTS FOR 'app_user'@'192.168.1.50';

```

> **Note:** To see the privileges for the currently logged-in user, you can simply run `SHOW GRANTS;`.

---

## 5. Role Management (MySQL 8.0+)

Roles are named collections of privileges. You can grant privileges to a role, and then grant that role to one or more user accounts, simplifying access management.

### 5.1 Creating and Dropping Roles

```sql
CREATE ROLE 'developer', 'read_only_analyst';

```

```sql
DROP ROLE 'read_only_analyst';

```

### 5.2 Assigning Privileges to Roles

Roles are granted privileges exactly like users.

```sql
GRANT SELECT ON reporting_db.* TO 'read_only_analyst';
GRANT ALL PRIVILEGES ON dev_db.* TO 'developer';

```

### 5.3 Assigning Roles to Users

```sql
GRANT 'developer' TO 'john.doe'@'localhost';

```

### 5.4 Activating Roles

When a user logs in, roles are not automatically active unless configured. A user can activate a role during their session:

```sql
SET ROLE 'developer';

```

To ensure a role is always active when a user logs in, set it as the default:

```sql
SET DEFAULT ROLE 'developer' TO 'john.doe'@'localhost';

```

To set all granted roles as default for a user:

```sql
SET DEFAULT ROLE ALL TO 'john.doe'@'localhost';

```

---

## 6. Setting Resource Limits

You can limit the server resources consumed by individual accounts to prevent any single user from overwhelming the database server.

Limits can be set during user creation (`CREATE USER`) or modified later (`ALTER USER`).

```sql
ALTER USER 'report_user'@'%' WITH 
  MAX_QUERIES_PER_HOUR 100
  MAX_UPDATES_PER_HOUR 10
  MAX_CONNECTIONS_PER_HOUR 5
  MAX_USER_CONNECTIONS 2;

```

| Resource Limit Parameter | Description |
| --- | --- |
| `MAX_QUERIES_PER_HOUR` | The number of queries an account can issue per hour. |
| `MAX_UPDATES_PER_HOUR` | The number of updates (modifications) an account can issue per hour. |
| `MAX_CONNECTIONS_PER_HOUR` | The number of times an account can connect to the server per hour. |
| `MAX_USER_CONNECTIONS` | The number of simultaneous connections the account can have open. |

> To remove a limit, set its value to `0`.

---

## 7. Requiring Secure Connections (SSL/TLS)

You can force a user account to connect over an encrypted connection using the `REQUIRE` clause.

```sql
CREATE USER 'secure_user'@'%' IDENTIFIED BY 'Pass123!' REQUIRE SSL;

```

You can also require valid X.509 certificates:

```sql
ALTER USER 'secure_user'@'%' REQUIRE X509;

```

---

> **Best Practice:** Always use the principle of least privilege. Grant only the permissions absolutely necessary for a user or application to perform its function. Utilize Roles heavily in MySQL 8.0+ environments to simplify auditing and management.


