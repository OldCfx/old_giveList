# 📦 GiveList for ox_inventory

A simple and practical tool designed for **staff teams** on FiveM servers.  

It allows staff to quickly search items based on a keyword.  

---

## ✨ Features
- **`/givelist` command**
  - Generates a temporary stash filled with items matching a keyword.
- **Smart search**
  - Matches both item names and labels through *ox_inventory*.
- **ACE Permissions**
  - Only users with the proper permission (`givelist.use`) can use the command.
- **Advanced logging**
  - Complete traceability: staff name, items given, timestamp.
- **Temporary stash**
  - No impact on the server’s main database.
- **Auto ReFill (optional)**
  - Inventories automatically regenerate to the quantity defined in the config.

---

## 🔐 Security
- ACE permission checks via `IsPlayerAceAllowed()`.
- logs.

---

## 📀 Installation
1. Place the script folder inside your server’s `resources/` directory.
2. Add the following to your `server.cfg`:
```cfg
   add_ace group.owner givelist.use allow
   ensure givelist
```

## 👨‍💻 Dependencies
- ox_inventory
- ox_lib

## 📄 License

Free to use and modify for your server.

Giving credit is always appreciated 😊