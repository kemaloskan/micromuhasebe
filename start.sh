#!/bin/bash

# Proje dizinine git
cd "$(dirname "$0")"

# Flutter SDK'nın PATH'te olduğunu kontrol et
if ! command -v flutter &> /dev/null; then
    echo "Flutter SDK bulunamadı. Lütfen Flutter'ı yükleyin ve PATH'e ekleyin."
    exit 1
fi

# Bağımlılıkları güncelle
echo "Flutter bağımlılıkları güncelleniyor..."
flutter pub get

# Uygulamayı macOS'ta başlat
echo "Uygulama başlatılıyor..."
flutter run -d macos 