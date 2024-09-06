# Browsers configuration

**<p align="center">📄 Configurations and settings for browser things 🛠️</p>**

- [Browsers configuration](#browsers-configuration)
  - [Current settings files](#current-settings-files)
  - [Brave configuration](#brave-configuration)
    - [Install Brave](#install-brave)
    - [Brave Extensions](#brave-extensions)
    - [Useful domains to allow in Brave](#useful-domains-to-allow-in-brave)
    - [Brave `brave://flags` (optional)](#brave-braveflags-optional)
  - [Firefox configuration](#firefox-configuration)
    - [Install Firefox](#install-firefox)
    - [Firefox Extensions](#firefox-extensions)
    - [Useful domains to allow in Firefox](#useful-domains-to-allow-in-firefox)
    - [Firefox `about:config` (optional)](#firefox-aboutconfig-optional)
  - [uBlock Origin filters](#ublock-origin-filters)

## Current settings files

| Name                                                | Description                            |
| :-------------------------------------------------- | :------------------------------------- |
| [ublock-origin](./ublock-origin.json)               | Settings file for uBlock Origin        |
| [midnight-lizard](./midnight-lizard.json)           | Settings file for Midnight Lizard      |
| [enhancer-for-youtube](./enhancer-for-youtube.json) | Settings file for Enhancer for YouTube |
| [betterttv](./betterttv.json)                       | Settings file for BetterTTV            |

## Brave configuration

### Install Brave

To install Brave ⛑️, use the following command:

```powershell
winget install --exact --id Brave.Brave
```

### Brave Extensions

Here are some essential and useful extensions 📎 for Brave ⛑️. Use the name of the extension or the `id` in the web store to search for them.

| Extension                             | ID                               | Description                          |
| ------------------------------------- | -------------------------------- | ------------------------------------ |
| uBlock Origin                         | cjpalhdlnbpafiamejdnhcphjbkeiagm | Ad and content blocker               |
| Enhancer for YouTube                  | ponfpcnoihfmfllpaingbgckeeldkhle | Addition features for YouTube        |
| Midnight Lizard                       | pbnndmlekkboofhnbonilimejonapojg | Dark mode                            |
| Dark Reader                           | eimadpbcbfnmbkopoojfekhnkhdbieeh | Dark mode                            |
| BetterTTV                             | ajopnjidmegmdimjlfnijceegpefgped | Additional features for Twitch       |
| GoFullPage - Full Page Screen Capture | fdpohaocaechififmbbbbbknoalclacl | Full page screenshot                 |
| Volume Master                         | jghecgabfgfdldnmbfkhmffcabddioke | Manage volume beyound default values |
| CSSViewer                             | ggfgijbpiheegefliciemofobhmofgce | Simple CSS property viewer           |
| Extensity                             | jjmflmamggggndanpgfnpelongoepncg | Manage all extensions                |
| Fake Filler                           | bnjjngeaknajbdcgpfkgnonkmififhfo | Fill forms with fake data            |
| JSON Formatter                        | bcjindcccaagfpapjjmafapmmgkkhgoa | Makes JSON easy to read              |
| Quick source viewer                   | cfmcghennfbpmhemnnfjhkdmnbidpanb | Beautify current page sourcecode     |
| Similarweb                            | hoklmmgfnpapgjgcpechhaamimifchmp | Website traffic & SEO checker        |
| Todoist                               | jldhpllghnbhlbpcmnajkpdmadaolakh | Todo tracker                         |
| User-Agent Switcher and Manager       | bhchdcejhohfmigjafbampogmaanbfkg | User-agent switcher                  |
| Wappalyzer                            | gppongmhjkpfnbhagpmjfkannfbllamg | Identify tech stack use on a website |
| Check My Links                        | aajoalonednamcpodaeocebfgldhcpbe | Check for broken links               |
| ColorZilla                            | bhlhnicpbhignbdhedgjhgdocnmhomnp | Color selector                       |
| WhatFont                              | jabopobgcpjmedljpbcaablpmlmfcogm | Identify fonts on web pages          |
| Lorem Ipsum Generator                 | pglahbfamjiifnafcicdibiiabpakkkb | Quickly generate lorem ipsum text    |

### Useful domains to allow in Brave

For when something with Teams in the browser breaks its good to throw these into allowlist ✔️.

| Domains                  |
| ------------------------ |
| [*.]microsoft.com        |
| [*.]microsoftonline.com  |
| [*.]teams.skype.com      |
| [*.]teams.microsoft.com  |
| [*.]sfbassets.com        |
| [*.]skypeforbusiness.com |

### Brave `brave://flags` (optional)

You can access Brave ⛑️ flags 🏁 by entering `brave://flags` in the address bar.

The following flags are not necessary but optional:

| Flag                         | Action   |
| ---------------------------- | -------- |
| #native-brave-wallet         | Disabled |
| #brave-ai-chat               | Disabled |
| #brave-ai-chat-history       | Disabled |
| #enable-parallel-downloading | Enabled  |

[back to top ☝️](#browsers-configuration)

## Firefox configuration

### Install Firefox

To install Firefox 🔥🦊, use the following command:

```powershell
winget install --exact --id Mozilla.Firefox
```

### Firefox Extensions

Here are some essential and useful extensions 📎 for Firefox 🔥🦊. Use the name of the extension in the web store to search for them.

| Extension                        |
| -------------------------------- |
| uBlock Origin                    |
| Firefox Multi-Account Containers |
| Midnight Lizard                  |
| User-Agent Switcher and Manager  |
| BetterTTV                        |
| Todoist                          |
| Dark Reader                      |
| Enhancer for YouTube             |

### Useful domains to allow in Firefox

For when something with Teams in the browser breaks its good to throw these into allowlist ✔️.

| Domain                         |
| ------------------------------ |
| <https://microsoft.com>        |
| <https://microsoftonline.com>  |
| <https://teams.skype.com>      |
| <https://teams.microsoft.com>  |
| <https://sfbassets.com>        |
| <https://skypeforbusiness.com> |

### Firefox `about:config` (optional)

Some changes to the 🛠️ `about:config` in Firefox 🔥🦊.

| Flag                          | Action   |
| ----------------------------- | -------- |
| browser.cache.disk.enable     | false    |
| browser.cache.memory.capacity | 524288   |
| browser.sessionstore.interval | 15000000 |
| browser.urlbar.maxRichResults | 0        |

[back to top ☝️](#browsers-configuration)

## uBlock Origin filters

Helps with ☕ filtering unwanted content but might break some websites or cause 😩 unwanted effects so make sure what filters you're adding.

| Filter                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------- |
| <https://raw.githubusercontent.com/FiltersHeroes/KAD/master/KAD.txt>                                                |
| <https://raw.githubusercontent.com/FiltersHeroes/KADhosts/master/KADhosts.txt>                                      |
| <https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/adblock_social_filters/adblock_social_list.txt> |
| <https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/polish-adblock-filters/adblock_ublock.txt>      |
| <https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/polish-adblock-filters/adblock_adguard.txt>     |
| <https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt>                                 |
| <https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin-ublock.txt>                          |
| <https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt>                                  |
| <https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt>                        |
| <https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt>     |
| <https://alleblock.pl/alleblock/alleblock.txt>                                                                      |
| <https://secure.fanboy.co.nz/fanboy-annoyance_ubo.txt>                                                              |
| <https://filters.adtidy.org/extension/ublock/filters/14.txt>                                                        |

[back to top ☝️](#browsers-configuration)
