# Brave Configuration

## Install Brave

To install Brave, use the following PowerShell command:

```powershell
winget install --id Brave.Brave --exact
```

## Extensions

Here are some essential and useful extensions for Brave. Use the `id` in the web store to search for them.

| Extension                             | ID                               |
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

## Some uBlock Origin filter lists

Helps with filtering unwanted content. May break some websites or cause unwanted effects so make sure what filters you're adding.

| Filter list                                                                                                         |
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

## Useful domains to allow

Sometimes something breaks so its good to throw it into the allowlist.

| Domain                   |
| ------------------------ |
| [*.]microsoft.com        |
| [*.]microsoftonline.com  |
| [*.]teams.skype.com      |
| [*.]teams.microsoft.com  |
| [*.]sfbassets.com        |
| [*.]skypeforbusiness.com |

## Flags

You can access Brave Flags by entering `brave://flags` in the address bar of your Brave browser.

The following flags are not necessary but optional:

| Flag                             | Action   |
| -------------------------------- | -------- |
| #native-brave-wallet             | Disabled |
| #brave-news                      | Disabled |
| #brave-news-v2                   | Disabled |
| #brave-news-peek                 | Disabled |
| #smooth-scrolling                | Disabled |
| #enable-parallel-downloading     | Enabled  |
| #sync-autofill-wallet-usage-data | Disabled |
