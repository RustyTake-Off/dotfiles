# Browsers configuration

Configurations for browsers and extensions.

## Brave configuration

### Install Brave

To install Brave, use the following PowerShell command:

```powershell
winget install --id Brave.Brave --exact
```

### Brave Extensions

Here are some essential and useful extensions for Brave. Use the `id` in the web store to search for them.

| Extensions                            | IDs                              |
| ------------------------------------- | -------------------------------- |
| uBlock Origin                         | cjpalhdlnbpafiamejdnhcphjbkeiagm |
| Midnight Lizard                       | pbnndmlekkboofhnbonilimejonapojg |
| Extensity                             | jjmflmamggggndanpgfnpelongoepncg |
| User-Agent Switcher and Manager       | bhchdcejhohfmigjafbampogmaanbfkg |
| Volume Master                         | jghecgabfgfdldnmbfkhmffcabddioke |
| GoFullPage - Full Page Screen Capture | fdpohaocaechififmbbbbbknoalclacl |
| BeterTTV                              | ajopnjidmegmdimjlfnijceegpefgped |
| Momentum                              | laookkfknpbbblfpciffpaejjkokdgca |
| Todoist                               | jldhpllghnbhlbpcmnajkpdmadaolakh |
| Dark Reader                           | eimadpbcbfnmbkopoojfekhnkhdbieeh |
| Enhancer for YouTube                  | ponfpcnoihfmfllpaingbgckeeldkhle |

### Useful domains to allow in Brave

Sometimes something breaks so its good to throw them into allowlist.

| Domains                  |
| ------------------------ |
| [*.]microsoft.com        |
| [*.]microsoftonline.com  |
| [*.]teams.skype.com      |
| [*.]teams.microsoft.com  |
| [*.]sfbassets.com        |
| [*.]skypeforbusiness.com |

### Flags (optional)

You can access Brave flags by entering `brave://flags` in the address bar.

The following flags are not necessary but optional:

| Flags                            | Action   |
| -------------------------------- | -------- |
| #native-brave-wallet             | Disabled |
| #brave-news                      | Disabled |
| #brave-news-v2                   | Disabled |
| #brave-news-peek                 | Disabled |
| #smooth-scrolling                | Disabled |
| #enable-parallel-downloading     | Enabled  |
| #sync-autofill-wallet-usage-data | Disabled |

## Firefox configuration

### Install Firefox

To install Firefox, use the following PowerShell command:

```powershell
winget install --id Mozilla.Firefox --exact
```

### Firefox Extensions

Here are some essential and useful extensions for Firefox. Use the `id` in the web store to search for them.

| Extensions                            |
| ------------------------------------- |
| uBlock Origin                         |
| Midnight Lizard                       |
| User-Agent Switcher and Manager       |
| BeterTTV                              |
| Momentum                              |
| Todoist                               |
| Dark Reader                           |
| Enhancer for YouTube                  |

### Useful domains to allow in Firefox

Sometimes something breaks so its good to throw them into allowlist.

| Domains                        |
| ------------------------------ |
| <https://microsoft.com>        |
| <https://microsoftonline.com>  |
| <https://teams.skype.com>      |
| <https://teams.microsoft.com>  |
| <https://sfbassets.com>        |
| <https://skypeforbusiness.com> |

## uBlock Origin filters

Helps with filtering unwanted content but might break some websites or cause unwanted effects so make sure what filters you're adding.

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
