#!/usr/bin/env bash

sleep 3
systemctl --user import-environment PATH
systemctl --user restart xdg-desktop-portal.service