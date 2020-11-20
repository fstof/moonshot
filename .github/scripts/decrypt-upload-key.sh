#!/bin/sh

gpg --quiet --batch --yes --decrypt --passphrase="$UPLOAD_KEY_SECRET" --output android/upload_key.jks android/upload_key.jks.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$UPLOAD_KEY_SECRET" --output android/key.properties android/key.properties.gpg
