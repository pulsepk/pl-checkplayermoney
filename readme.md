[![youtube preview](https://r2.fivemanage.com/sg0WhTDFbEhB957nFhh9t/checkplayermoney-thumbnailyt.png)](https://youtu.be/9lldlXt-wK0)

A Very Simple Script for People who want to check the amount of money their players have in their City. No need to enter Complex query in the database I got you covered with this Script.

[![ZAP-Hosting Gameserver and Webhosting](https://r2.fivemanage.com/JEc8nqRsuJODhwqwkKd7o/zap-hosting-banner-pulsescripts.png)](https://zap-hosting.com/pulsescripts?voucher=pulse-20)


## Features
######
- Supports ESX, QBCore, and QBox frameworks (auto-detected via pl_lib — no manual config)
- Check Players with Highest Money
- Check Top number of Players Money
- Supports Player Bank, Cash, Black Money and Crypto
- ACE Permissions
- Notify and UI system auto-detected via pl_lib (ox_lib, lation_ui, and more)

######

##
## Support, Scripts & More
- [Script Store](https://pulsescripts.com/)
- [Join the Discord For Support](https://discord.gg/c6gXmtEf3H)
######

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- [oxmysql](https://github.com/overextended/oxmysql/releases)
- [pl_lib](https://github.com/pulsepk/pl_lib/releases)
##

## Installation Guide
1. Ensure `ox_lib`, `oxmysql`, and `pl_lib` are installed and started **before** this resource.
2. Drop `pl-checkplayermoney` into your resources folder and add `ensure pl-checkplayermoney` to your `server.cfg`.
3. Grant the ACE permission to allow access:
   ```
   add_ace group.admin checkplayermoney allow
   ```
4. Restart the resource or reboot the server.

> Framework, notify system, and UI components are all **auto-detected by pl_lib** — no `Config.Framework` or `Config.Notify` settings needed.

### `config.lua`
| Option | Default | Description |
|---|---|---|
| `Config.Command` | `'checkplayermoney'` | The chat command used to open the money overview menu |

## Paid Scripts
If you liked our free scripts and want to contribute, please check out our paid scripts

* 🍔 [BurgerShot](https://pulsescripts.com/product/burgershot)
* 🐱 [UwU Cat Cafe](https://pulsescripts.com/product/uwucatcafe)
* 🍕 [Pizza This](https://pulsescripts.com/product/6707931)
* ☕ [Bean Machine](https://pulsescripts.com/product/6741732)
* 🐟 [KOI](https://pulsescripts.com/product/6994012)
* 🍽️ [Diner](https://pulsescripts.com/product/7007587)
* 🌮 [Taco Farmer](https://pulsescripts.com/product/6707937)
* 🐚 [Pearls](https://pulsescripts.com/product/6707935)
* 🍔 [Horny Burgers + UpnAtom](https://pulsescripts.com/product/6749404)
* 🍩 [Rusty Browns](https://pulsescripts.com/product/6707942)
* 🍬 [Bubble Gum Cafe](https://pulsescripts.com/product/6707950)
* 💊 [Drug Selling](https://pulsescripts.com/product/drugsellingv2)
* 🛑 [Wheel Clamper](https://pulsescripts.com/product/6805299)
