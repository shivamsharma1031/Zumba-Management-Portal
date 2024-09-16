# Zumba Management Portal

## Objective
The Zumba Management Portal is designed to efficiently manage participant enrollment and batch scheduling for Zumba classes. The system allows users to register, view available slots, and manage their class schedules, while administrators can oversee all class registrations and participant details.

## Technology Stack
- **Backend:** Java, JSP, JDBC
- **Frontend:** JSP
- **Database:** MySQL
- **Version Control:** Git, GitHub
- **Build Tool:** Maven

## Problem Statement and Motivation

### Problem Statement
This project aims to create a robust backend system for managing Zumba sessions using Java, JSP, and JDBC. The solution enables CRUD operations on participants and batch details, implements user authentication, session management, and provides specific functionalities for administrators.

### Real-World Scenario
Rohit, a Zumba instructor conducting multiple sessions daily, needs a software solution to manage participant details, batch assignments, and available slots. This system automates these tasks, simplifying participant and batch management, and provides an efficient way to monitor and control class registrations.

## Project Overview

### Functionalities

1. **Landing/Main JSP Page:**
   - Displays available Zumba slots with details such as Date, Time, Max Capacity, and Available Slots.
   - Provides "Register" and "Deregister" buttons for users to manage their class registrations.
   - Fetches slot data dynamically from the database.

2. **User Registration & Authentication:**
   - **Login Page:** Authenticates users against the database. Redirects unauthenticated users to the login page when they attempt to register.
   - **Sign-Up Page:** Allows new users to register by providing their details. The data is stored in the database using secure practices.
   
3. **Admin Control:**
   - Admins (e.g., Rohit) have enhanced access with additional functionalities. An `isAdmin` field in the Users table identifies admin accounts.
   - Admins can view all Zumba sessions and participant details through the "Show All Entries" button, which is available only to logged-in admins.

### Execution Plan

1. **Landing Page (`index.jsp`):**
   - Displays all Zumba slots, including the available count and registration actions.
   - Integrates navigation to the login page upon clicking the "Register" button if not logged in.

2. **User Authentication:**
   - Implements a login page for user authentication against the Users table in MySQL.
   - Manages user sessions to display the logged-in user's name and provide a "Logout" button.

3. **Admin Dashboard:**
   - Accessible only to admins with `isAdmin=true`.
   - Allows viewing and management of Zumba sessions and participant information.

## Database Schema

### `users` Table:
- **ID:** (Primary Key, INT, Auto-Increment)
- **Name:** (VARCHAR, NOT NULL)
- **Phone:** (VARCHAR, NOT NULL)
- **Email:** (VARCHAR, NOT NULL, Unique)
- **Password:** (VARCHAR, NOT NULL)
- **Weight:** (DECIMAL, NOT NULL)
- **Height:** (DECIMAL, NOT NULL)
- **isAdmin:** (BOOLEAN, Default FALSE)

### `zumba_slots` Table:
- **ID:** (Primary Key, INT, Auto-Increment)
- **SlotDate:** (DATE, NOT NULL)
- **SlotTime:** (TIME, NOT NULL)
- **MaxCapacity:** (INT, NOT NULL)
- **AvailableSlots:** (INT, NOT NULL)

### `zumba_registrations` Table:
- **ID:** (Primary Key, INT, Auto-Increment)
- **UserID:** (INT, Foreign Key references users.ID, NOT NULL)
- **SlotID:** (INT, Foreign Key references zumba_slots.ID, NOT NULL)
- **Unique Constraint:** Ensures no duplicate registrations for the same slot by the same user.
