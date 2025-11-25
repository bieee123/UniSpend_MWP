Below is the **fully combined, updated, and corrected plan**, now rewritten so the application uses **Firebase instead of SQLite** as the primary database.
Everything has been merged into **one unified, clean, English project plan**, including:

✔ Your original detailed plan
✔ The unified combined plan
✔ Priority requirements from the Wireless & Mobile Programming project
✔ Full conversion from SQLite → **Firebase Firestore**

---

# **📘 Unified Updated Project Plan — UniSpend (Student Expense Tracker App)**

### _Wireless & Mobile Programming Final Project — Flutter (Firebase Version)_

---

# **1. Project Overview**

**UniSpend** is a mobile financial tracker designed for university students. It helps users manage income and expenses, categorize spending, set monthly budgets, and view spending visually through calendar and analytical charts. The app also supports notifications, exporting financial data, and PIN-based security.

The project satisfies all official requirements of the **Wireless & Mobile Programming course**:

✔ Multiple screens/pages (equivalent to Intent & Activity)
✔ At least one complete form
✔ Uses a **database (Firebase Firestore)**
✔ Clean workflow & UI design
✔ Solves a real-world problem

This version uses:

- **Firebase Firestore** as the main database
- **Firebase Authentication**
- **SharedPreferences (local)** for PIN, theme, notification settings

The design principles:

- Simple
- Fast
- Secure
- Student-friendly
- Modern (Material 3 UI)

---

# **2. Tech Stack**

## **2.1 Mobile Technology**

- Flutter (Dart)
- Material 3 Design
- Responsive UI

## **2.2 State Management**

- Provider or Riverpod

## **2.3 Database (Primary)**

### **Firebase Firestore**

Collections:

- users
- categories
- transactions
- app_settings

## **2.4 Local Storage**

- SharedPreferences (PIN, theme, notification settings)

## **2.5 Authentication**

- Firebase Authentication

  - Email + Password
  - Email Verification
  - Password Reset (email link)

## **2.6 Notifications**

- flutter_local_notifications

  - Daily reminder
  - Weekly summary
  - Budget warning triggers

## **2.7 Export Features**

- PDF generation (pdf package)
- CSV export

## **2.8 Calendar**

- table_calendar

---

# **3. Feature Breakdown**

## **3.1 Authentication**

Enhancement but recommended for better security.

Includes:

- Register (email + password)
- Login
- Email verification
- Password reset
- Logout
- Persistent login using FirebaseAuth

Purpose: Professional and secure user foundation.

---

## **3.2 PIN Lock (Local Security Layer)**

- Set 4–6 digit PIN
- Stored encrypted in SharedPreferences
- Required on app launch or after idle
- Checked before Dashboard

---

## **3.3 Dashboard**

Shows:

- Total spending today
- Total spending this month
- Simple charts
- Buttons: Add Transaction, Calendar, Analytics
- Real-time updates using Firestore streams

---

## **3.4 Transaction System (Core Requirement)**

This satisfies the **mandatory form** required by the course.

### Features:

- Add transaction
- Edit transaction
- Delete transaction
- View transaction detail
- Filter by category and date

### Form Components (meets assignment requirements):

✔ Text input (amount, notes)
✔ Password input (via Login page)
✔ Selection dropdown (category)
✔ Radio button (income/expense)
✔ Button
✔ Date picker

Validation:

- Amount > 0
- Category required
- Date required

---

## **3.5 Category Management**

- Add, edit, delete categories
- Default categories auto-created on first login
- Optional prevention of deleting categories in use

---

## **3.6 Monthly Budget Limit**

- User sets monthly limit
- Dashboard progress indicator
- Thresholds:

  - 75% → yellow
  - 90% → red
  - Over limit → warning popup + optional notification

---

## **3.7 Calendar View**

- Highlight days with transactions
- Tap day → show transactions
- Daily total spending summary

---

## **3.8 Notifications**

- **Daily Reminder:** “Don’t forget to record your spending today!”
- **Weekly Summary:** total weekly expenses
- **Budget Limit Notification:** triggered upon exceeding threshold

---

## **3.9 Export PDF**

Includes:

- Title
- User email
- Date range
- Table of all transactions
- Total income & expenses
  Saved to Downloads folder.

---

## **3.10 Export CSV**

Example:

```
date, category, type, amount, note
2025-11-18, Food, expense, 20000, lunch
```

---

# **4. Page List (20 Pages)**

### **Authentication (6 pages)**

1. Login Page
2. Register Page
3. Email Verification Page
4. Forgot Password Page
5. Set PIN Page
6. Verify PIN Page

### **Dashboard & Transactions (5 pages)**

7. Dashboard
8. Transaction List
9. Add Transaction
10. Edit Transaction
11. Transaction Detail

### **Categories (3 pages)**

12. Category List
13. Add Category
14. Edit Category

### **Settings (4 pages)**

15. Settings Main
16. Budget Limit Settings
17. Notification Settings
18. Export Page (PDF/CSV)

### **Data Views (2 pages)**

19. Calendar View
20. Analytics / Reports

---

# **5. Firebase Database Structure**

## **5.1 Collection: users**

Document ID → Firebase UID
Fields:

| Field | Type   | Description   |
| ----- | ------ | ------------- |
| name  | String | User name     |
| email | String | User email    |
| pin   | String | Encrypted PIN |

---

## **5.2 Collection: categories**

Fields:

| Field   | Type          |
| ------- | ------------- |
| id      | String (auto) |
| user_id | String        |
| name    | String        |
| icon    | String        |

---

## **5.3 Collection: transactions**

Fields:

| Field       | Type                        |
| ----------- | --------------------------- |
| id          | String (auto)               |
| user_id     | String                      |
| category_id | String                      |
| amount      | double                      |
| type        | String ("income"/"expense") |
| note        | String                      |
| date        | Timestamp                   |

Indexes recommended:

- (user_id + date)
- (user_id + category_id)

---

## **5.4 Collection: app_settings**

Fields:

| Key            | Value   |
| -------------- | ------- |
| theme          | String  |
| daily_reminder | Time    |
| weekly_summary | Boolean |
| budget_limit   | double  |

---

# **6. Workflow**

## **6.1 Startup Flow**

1. App loads
2. Check PIN in SharedPreferences
3. If exists → Verify PIN screen
4. Check FirebaseAuth user
5. If not logged in → Login
6. If logged in but unverified → Verification Page
7. Else → Dashboard

---

## **6.2 Add Transaction Flow**

1. User opens Add Transaction page
2. Fills form
3. Validation
4. Saves data to Firestore
5. UI updates via realtime stream
6. Success confirmation

---

## **6.3 Export Flow**

1. User chooses export type
2. Selects date range
3. App retrieves Firestore documents
4. Generates PDF/CSV
5. Saves to device
6. Shows confirmation

---

## **6.4 Notification Flow**

1. Scheduled on first run
2. Daily reminder
3. Weekly summary
4. Trigger budget warning when new transaction is added

---

# **7. Testing Checklist**

## Functional

- Authentication
- PIN verify
- CRUD transactions
- Category CRUD
- Budget limit
- PDF/CSV export
- Notifications
- Calendar
- Analytics

## UI/UX

- Navigation clarity
- Input validation
- Visual consistency
- Responsive layout

## Performance

- Large dataset handling
- Fast export
- Smooth calendar transitions

## Security

- Encrypted PIN
- Secure Firestore rules
- Dashboard locked without authentication

---

# **8. Deliverables**

- GitHub source code
- APK release
- PDF project report
- Presentation slides
- Screenshots of all pages

---

# **9. Priority Development Roadmap (What Must Be Completed First)**

This section defines which features must be prioritized, based on the official course requirements and feasibility within the project timeline.

The priorities ensure the application meets all mandatory grading criteria **even if optional features are not finished**.
This roadmap is specially adapted for the **Firebase version of UniSpend**.

---

# **Priority Level 1 — MUST COMPLETE (Core Requirements)**

These features are required by the official project specification and **must be implemented first**.

---

### **1. Multi-Page Navigation (Intents & Activities Equivalent)**

At least **4–5 working screens** should be implemented with correct navigation:

- Login Page
- Dashboard Page
- Transaction List Page
- Add Transaction Page
- Settings Page (or another functional page)

➡ This directly satisfies **“Intent and Activity must be implemented.”**

---

### **2. Required Form (Mandatory Components)**

The **Add Transaction Form** must include all required UI elements:

✔ Text Input – amount, note
✔ Password Input – available in Login page
✔ Selection – category dropdown
✔ Checkbox or Radio Button – income/expense
✔ Button – save
✔ Date Picker

➡ This fulfills the requirement: **“Must contain at least one complete form.”**

---

### **3. Firebase Firestore Database (Mandatory)**

Since UniSpend uses Firebase (not SQLite), the minimum requirement is:

- Create **transactions** collection
- Implement CRUD operations:

  - Add
  - Edit
  - Delete
  - List

➡ This fulfills **“Must use database (SQLite or Firebase)”** requirement.

---

### **4. Basic Workflow & UI**

Simple UI is acceptable, as long as:

- Navigation is clear
- All pages work without crashing
- Forms validate correctly
- Data flow is logical and consistent

➡ Covers the scoring requirement: **“workflow and design aesthetics are considered.”**

---

# **Priority Level 2 — HIGH PRIORITY (Strongly Recommended)**

These features are not mandatory but will **significantly improve your grade** and overall usability.

---

### **5. Category Management**

- Add category
- Edit category
- Delete category
- Default categories on first login

---

### **6. Edit & Delete Transactions**

Full CRUD makes the app complete, consistent, and useful.

---

### **7. Dashboard Summary**

- Daily spending
- Monthly spending
- Simple chart/graph

These features improve user experience and presentation quality.

---

# **Priority Level 3 — OPTIONAL Enhancements (If Time Allows)**

These features elevate the project but are **not required** to meet minimum conditions.

---

### **8. Firebase Authentication**

- Register / Login
- Email verification
- Password reset

---

### **9. PIN Lock (Local Security)**

### **10. Notifications (Daily, Weekly, Budget)**

### **11. Budget Limit System**

### **12. Calendar View (Table Calendar)**

### **13. Export PDF & CSV**

### **14. Analytics Charts**

### **15. Settings Page & Preferences**

➡ These features should only be implemented **after all Priority Level 1 tasks are completed**.

---

# **Priority Level 4 — BONUS / Extra Polish**

Entirely optional, for extra points or presentation quality.

- Advanced animations
- Custom theming
- Multi-language support
- Dark mode
- Advanced analytics

---

lib/
├── main.dart
├── app/
│ ├── app.dart
│ ├── routes.dart
│ └── theme.dart
├── core/
│ ├── utils/
│ ├── constants/
│ └── widgets/
├── data/
│ ├── models/
│ │ ├── user_model.dart
│ │ ├── category_model.dart
│ │ └── transaction_model.dart
│ ├── services/
│ │ ├── firestore_service.dart
│ │ ├── auth_service.dart
│ │ └── notification_service.dart
│ └── repositories/
│ ├── transaction_repository.dart
│ ├── category_repository.dart
│ └── user_repository.dart
├── features/
│ ├── auth/
│ │ ├── login_page.dart
│ │ ├── register_page.dart
│ │ ├── verify_email_page.dart
│ │ └── forgot_password_page.dart
│ ├── pin/
│ │ ├── set_pin_page.dart
│ │ └── verify_pin_page.dart
│ ├── dashboard/
│ │ └── dashboard_page.dart
│ ├── transactions/
│ │ ├── add_transaction_page.dart
│ │ ├── edit_transaction_page.dart
│ │ ├── transaction_list_page.dart
│ │ └── transaction_detail_page.dart
│ ├── categories/
│ │ ├── category_list_page.dart
│ │ ├── add_category_page.dart
│ │ └── edit_category_page.dart
│ ├── settings/
│ │ ├── settings_page.dart
│ │ ├── budget_limit_page.dart
│ │ ├── notification_settings_page.dart
│ │ └── export_page.dart
│ ├── calendar/
│ │ └── calendar_page.dart
│ └── analytics/
│ └── analytics_page.dart
└── state/
├── auth_provider.dart
├── transaction_provider.dart
├── category_provider.dart
└── settings_provider.dart

Here is the **Priority Development Roadmap** rewritten into clear, well-structured **English TODO items** — ready to use as a development checklist.

---

# ✅ **Priority Development Roadmap — TODO List**

### _For the Firebase Version of UniSpend_

---

## **🔴 Priority Level 1 — MUST COMPLETE (Core Requirements)**

These are **mandatory** to pass the course. Must be completed **first**.

### **1. Multi-Page Navigation (Required Screens)**

- [ ] Implement navigation system (GoRouter / Navigator 2.0 / Navigator.push).
- [ ] Create **Login Page**.
- [ ] Create **Dashboard Page**.
- [ ] Create **Transaction List Page**.
- [ ] Create **Add Transaction Page**.
- [ ] Create **Settings Page** (or another functional page).
- [ ] Ensure each screen navigates properly.

---

### **2. Mandatory Form Requirement (Add Transaction Form)**

- [ ] Create Add Transaction Form with:

  - [ ] Text Input: amount
  - [ ] Text Input: note
  - [ ] Password Input (already covered in Login page)
  - [ ] Dropdown: category selection
  - [ ] Checkbox or Radio Button: income / expense
  - [ ] Button: save transaction
  - [ ] Date picker

- [ ] Add form validation (required fields, number input).

---

### **3. Firebase Firestore Database (Required)**

- [ ] Create Firestore collection: **transactions**
- [ ] Implement CRUD:

  - [ ] Add transaction
  - [ ] Edit transaction
  - [ ] Delete transaction
  - [ ] List transactions

- [ ] Ensure Firestore reads/writes work without errors.

---

### **4. Basic Workflow & UI (Required)**

- [ ] Ensure the UI layout is simple and functional.
- [ ] Make all navigation clear and consistent.
- [ ] Validate all forms (no empty inputs, no crash).
- [ ] Ensure smooth basic workflow:

  - Login → Dashboard → Add Transaction → List Transactions → Settings.

---

## **🟠 Priority Level 2 — HIGH PRIORITY (Recommended)**

Not mandatory, but significantly improves grades & usability.

### **5. Category Management**

- [ ] Create category list page.
- [ ] Create add category form.
- [ ] Create edit category form.
- [ ] Enable delete category.
- [ ] Implement default categories for first-time users.

---

### **6. Full Transaction CRUD**

- [ ] Implement edit transaction page.
- [ ] Implement delete transaction with confirmation.
- [ ] Ensure list updates in real-time (Firebase stream recommended).

---

### **7. Dashboard Summary**

- [ ] Display daily spending summary.
- [ ] Display monthly spending summary.
- [ ] Add simple chart or visual indicators.
- [ ] Calculate total income/expense for the current month.

---

## **🟡 Priority Level 3 — OPTIONAL Enhancements (If Time Allows)**

Enhances the project but **not required** to meet minimum criteria.

### **8. Firebase Authentication Enhancements**

- [ ] Register account
- [ ] Login
- [ ] Email verification
- [ ] Password reset

---

### **9. PIN Lock System**

- [ ] Set PIN page
- [ ] Verify PIN page
- [ ] Local storage security

---

### **10. Notifications**

- [ ] Daily reminder
- [ ] Weekly summary
- [ ] Budget alerts

---

### **11. Budget Limit System**

- [ ] Set budget limit
- [ ] Track remaining budget
- [ ] Trigger alert when near limit

---

### **12. Calendar View**

- [ ] Add calendar page
- [ ] Show transactions by date

---

### **13. Export Features**

- [ ] Export PDF
- [ ] Export CSV

---

### **14. Analytics**

- [ ] Income vs expense chart
- [ ] Category distribution chart
- [ ] Monthly comparison chart

---

### **15. Settings Page Improvements**

- [ ] Notification preferences
- [ ] Theme preferences
- [ ] Account settings

---

## **🟢 Priority Level 4 — BONUS (Extra Polish)**

Optional. Useful only for boosting presentation quality.

- [ ] Smooth animations
- [ ] Custom theme system
- [ ] Multi-language support
- [ ] Dark mode toggle
- [ ] Advanced analytics dashboard
- [ ] Loading skeleton UI

---
