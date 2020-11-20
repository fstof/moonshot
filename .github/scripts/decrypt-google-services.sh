#!/bin/sh

gpg --quiet --batch --yes --decrypt --passphrase="$GOOGLE_SERVICES_SECRET" --output android/app/src/nonprod/google-services.json android/app/src/nonprod/google-services.json.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$GOOGLE_SERVICES_SECRET" --output android/app/src/prod/google-services.json android/app/src/prod/google-services.json.gpg
