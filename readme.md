# 🙍 **old_npcRob – Immersive NPC Robbery**

A complete and immersive script allowing players to **rob NPCs** on your FiveM server.  
Provide your players with a realistic and thrilling criminal experience!

---

## 🔥 Main Features
- 🔫 **Smart Robbery System**:  
  - With a firearm → aim at an NPC to intimidate them.  
  - With a melee weapon → get close and threaten them.  
  - Dynamic progress bar → fills while threatening, drains when you stop → NPC flees if it reaches 0!  

- 🧘‍♀️ **Realistic NPC Reactions**:  
  - NPC raises their hands :raised_hand:  
  - Then goes down on their knees :cold_sweat:  
  - Once searched and the inventory is closed → NPC gets up and runs away :person_running::dash:  

- ⚙️ **Configurable Loot System**:  
  - Easy setup in `config.lua`:  
    - Different rewards depending on weapon type (firearm vs melee).  
    - Ability to define min/max for each loot.  

- 👜 **Immersive Searching**:  
  - Press `[E]` to search the NPC.  
  - Animations and progress bar handled via `ox_lib`.  
  - Loot is generated inside an inventory stash (`ox_inventory`).  

- 🚫 **Anti-Abuse Checks**:  
  - The same NPC cannot be robbed more than once (handled via `stateBag`).  

- 🛰️ **Discord Logging (Webhook)**:  
  - Player ID and Name.  
  - Weapon used for the robbery.  
  - Exact robbery coordinates.  
  - Loot generated (and what was actually taken).  

---

## 🎮 Requirements
- [ox_lib](https://github.com/overextended/ox_lib)  
- [ox_inventory](https://github.com/overextended/ox_inventory)  

---

## 🛠️ Installation
1. Place the `old_npcRob` folder inside your server’s `resources` directory.  
2. Ensure your dependencies (`ox_lib`, `ox_inventory`) are correctly installed.  
3. Configure your loot tables and Discord webhook in `shared/config.lua` `server/main.lua`.  
4. Add the following line to your `server.cfg`:  
   ```
   ensure old_npcRob
   ```

---
