#!/bin/bash

menu_generator="$HOME/.config/labwc/menu-generator.py"
menu_file="$HOME/.config/labwc/menu.xml"
horizontal_menu="$HOME/.config/rofi/horizontal_menu.rasi"

if command -v rofi &> /dev/null; then
    main_options="Yes\nNo"
    main_choice=$(echo -e "$main_options" | rofi -dmenu -mesg "<b>Footer in menu?</b>" -theme "$horizontal_menu")
    
    case "$main_choice" in
        "Yes")
            python3 "$menu_generator" -o "$menu_file"
            if command -v notify-send &> /dev/null; then
                notify-send "SUCCESS" "Desktop menu generated with Footer"
            fi
            ;;
        
        "No")
            python3 "$menu_generator" -f false -o "$menu_file"
            if command -v notify-send &> /dev/null; then
                notify-send "SUCCESS" "Desktop menu generated without Footer"
            fi
            ;;
        
        *)
            exit 0
            ;;
    esac
else
    read -p "Include footer in menu? (y/n): " choice
    case "$choice" in
        y|Y|yes|Yes)
            python3 "$menu_generator" -o "$menu_file"
            if command -v notify-send &> /dev/null; then
                notify-send "SUCCESS" "Desktop menu generated with Footer"
            fi
            ;;
        *)
            python3 "$menu_generator" -f false -o "$menu_file"
            if command -v notify-send &> /dev/null; then
                notify-send "SUCCESS" "Desktop menu generated without Footer"
            fi
            ;;
    esac
fi
