Locales['pl'] = {
    -- Name
    ['name'] = 'TigoAntiCheat',

    -- General
    ['unknown'] = 'Nieznany',
    ['fatal_error'] = 'FATAL ERROR',

    -- Resource strings
    ['callback_not_found'] = '[%s] nie zosta艂 znaleziony',
    ['trigger_not_found'] = '[%s] nie zosta艂 znaleziony',

    -- Ban strings
    ['checking'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Jeste艣 obecnie sprawdzany...',
    ['user_ban_reason'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Zosta艂e艣 zbanowany ( 饾棬饾榾饾棽饾椏饾椈饾棶饾椇饾棽: %s )',
    ['user_kick_reason'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Zosta艂e艣 wyrzucony z serwera ( 饾棩饾棽饾棶饾榾饾椉饾椈: %s )',
    ['banlist_ban_reason'] = 'Gracz pr贸bowa艂 wywo艂a膰 \'%s\' event',
    ['banlist_not_loaded_kick_player'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Nasza baza ban贸w nie zosta艂a za艂adowana, poczekaj par臋 sekund. Spr贸buj ponownie p贸藕niej!',
    ['ip_not_found'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Nie mogli艣my znale藕膰 twojego IP',
    ['ip_blocked'] = '馃懏 饾棫饾椂饾棿饾椉饾棓饾椈饾榿饾椂饾棖饾椀饾棽饾棶饾榿 | Masz aktywny VPN, wy艂膮cz go, aby do艂膮czy膰 do serwera. | B艂膮d? Skontaktuj si臋 z w艂a艣cicielami serwer贸w',
    ['new_identifiers_found'] = '%s, nowe identyfikatory znalezione - oryginalny ban %s',
    ['failed_to_load_banlist'] = '[TigoAntiCheat] B艂膮d wczytywania ban listy!',
    ['failed_to_load_tokenlist'] = '[TigoAntiCheat] B艂膮d wczytywania token listy!',
    ['failed_to_load_ips'] = '[TigoAntiCheat] B艂膮d wczytywania ips listy!',
    ['failed_to_load_check'] = '[TigoAntiCheat] Sprawd藕 b艂膮d p贸藕niej, bany *nie b臋d膮* dzia艂a膰!',
    ['ban_type_godmode'] = 'Godmode zosta艂 wykryty u gracza',
    ['lua_executor_found'] = 'Lua executor wykryty u gracza',
    ['ban_type_injection'] = 'Gracz zainjectowa艂 komendy (Injection)',
    ['ban_type_blacklisted_weapon'] = 'Player mia艂 bro艅 z blacklisty: %s',
    ['ban_type_blacklisted_key'] = 'Player nacisn膮艂 klawisz z blacklisty %s',
    ['ban_type_hash'] = 'Gracz zmodyfikowa艂 hash',
    ['ban_type_esx_shared'] = 'Gracz pr贸bowa艂 wywo艂a膰 \'esx:getSharedObject\'',
    ['ban_type_superjump'] = 'Gracz zmodyfikowa艂 wysoko艣膰 skoku',
    ['ban_type_client_files_blocked'] = 'Gracz nie odpowiada po 5 razach requesting je偶eli jest dost臋pny (Client Files Blocked)',
    ['kick_type_security_token'] = 'Nie mo偶emy stworzy膰 nowego security token',
    ['kick_type_security_mismatch'] = 'Tw贸j security token nie pasuje',

    -- Commands
    ['command'] = 'Komenda',
    ['available_commands'] = 'Dost臋pne komendy ',
    ['command_reload'] = 'Prze艂aduj list臋 ban贸w',
    ['ips_command_reload'] = 'Prze艂adowanie listy bia艂ej listy IP',
    ['ips_command_add'] = 'Dodaj IP do listy bia艂ej listy IP',
    ['command_help'] = 'Zwr贸膰 wszystkie komendy anticheata',
    ['command_total'] = 'Zwr贸膰 liczb臋 ban贸w w li艣cie',
    ['total_bans'] = 'Mamy %s ban(贸w) na naszej li艣cie',
    ['command_not_found'] = 'nie istnieje',
    ['banlist_reloaded'] = 'Wszystkie bany anticheata zosta艂y prze艂adowane z banlist.json',
    ['ips_reloaded'] = 'Wszystkie IP zosta艂y prze艂adowane z ignore-ips.json',
    ['ip_added'] = 'IP: %s, zosta艂 dodany do bia艂ej listy',
    ['ip_invalid'] = 'IP: %s, nie jest prawid艂owym IP, powinien wygl膮da膰 tak, na przyk艂ad: 0.0.0.0',
    ['not_allowed'] = 'Nie masz wystarczaj膮cych uprawnie艅 do %s',

    -- Discord
    ['discord_title'] = '[TigoAntiCheat] Zablokowa艂 gracza za oszukiwanie',
    ['discord_description'] = '**Nazwa:** %s\n **Pow贸d:** %s\n **Identifiers:**\n %s'
}
