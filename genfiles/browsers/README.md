# Browsers configuration

📄 Configurations and settings for browser things. 🛠️

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

| Name                                                | Description                             |
| :-------------------------------------------------- | :-------------------------------------- |
| [ublock-origin](./ublock-origin.json)               | Settings file for uBlock Origin.        |
| [midnight-lizard](./midnight-lizard.json)           | Settings file for Midnight Lizard.      |
| [enhancer-for-youtube](./enhancer-for-youtube.json) | Settings file for Enhancer for YouTube. |

## Brave configuration

### Install Brave

To install Brave ⛑️, use the following command:

```powershell
winget install --exact --id Brave.Brave
```

### Brave Extensions

Here are some essential and useful extensions 📎 for Brave ⛑️. Use the name of the extension or the `id` in the web store to search for them.

| Extensions                            | IDs                              |
| ------------------------------------- | -------------------------------- |
| uBlock Origin                         | cjpalhdlnbpafiamejdnhcphjbkeiagm |
| Midnight Lizard                       | pbnndmlekkboofhnbonilimejonapojg |
| Enhancer for YouTube                  | ponfpcnoihfmfllpaingbgckeeldkhle |
| Extensity                             | jjmflmamggggndanpgfnpelongoepncg |
| User-Agent Switcher and Manager       | bhchdcejhohfmigjafbampogmaanbfkg |
| Volume Master                         | jghecgabfgfdldnmbfkhmffcabddioke |
| GoFullPage - Full Page Screen Capture | fdpohaocaechififmbbbbbknoalclacl |
| BetterTTV                             | ajopnjidmegmdimjlfnijceegpefgped |
| Todoist                               | jldhpllghnbhlbpcmnajkpdmadaolakh |
| Dark Reader                           | eimadpbcbfnmbkopoojfekhnkhdbieeh |
| CSSViewer                             | ggfgijbpiheegefliciemofobhmofgce |
| JSON Formatter                        | bcjindcccaagfpapjjmafapmmgkkhgoa |
| Quick source viewer                   | cfmcghennfbpmhemnnfjhkdmnbidpanb |
| Fake Filler                           | bnjjngeaknajbdcgpfkgnonkmififhfo |
| Wappalyzer                            | gppongmhjkpfnbhagpmjfkannfbllamg |

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

| Flags                        | Action   |
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

| Extensions                       |
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

| Domains                        |
| ------------------------------ |
| <https://microsoft.com>        |
| <https://microsoftonline.com>  |
| <https://teams.skype.com>      |
| <https://teams.microsoft.com>  |
| <https://sfbassets.com>        |
| <https://skypeforbusiness.com> |

### Firefox `about:config` (optional)

Some changes to the 🛠️ `about:config` in Firefox 🔥🦊.

| Flags                         | Action   |
| ----------------------------- | -------- |
| browser.cache.disk.enable     | false    |
| browser.cache.memory.capacity | 524288   |
| browser.sessionstore.interval | 15000000 |
| browser.urlbar.maxRichResults | 0        |

[back to top ☝️](#browsers-configuration)

## uBlock Origin filters

Helps with ☕ filtering unwanted content but might break some websites or cause 😩 unwanted effects so make sure what filters you're adding.

| Filters                                                                                                             |
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
