# 💸 Expense Tracker

A simple, clean, and interactive **Flutter Expense Tracker** app to help users log their daily expenses, view summaries by category, and visualize data with a pie chart.

![Flutter Expense Tracker Screenshot](https://via.placeholder.com/800x400?text=App+Screenshot)

---

## 🚀 Features

- Add and delete daily expenses with amount and description
- View real-time summary of expenses by category
- Beautiful pie chart visualization using `fl_chart`
- Persistent local storage with `Hive`
- Works on Android, Web, and Desktop (if configured)

---

## 🛠️ Tech Stack

- **Flutter** (UI framework)
- **Hive** (local NoSQL database)
- **Hive Flutter** (integration with Flutter)
- **fl_chart** (for drawing pie chart)

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  fl_chart: ^0.45.1
