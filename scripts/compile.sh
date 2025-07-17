#!/bin/bash

tsc -p ./
flutter build web --no-web-resources-cdn --csp --pwa-strategy none --no-tree-shake-icons
