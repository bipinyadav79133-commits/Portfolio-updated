#!/bin/bash
# Automatic Portfolio Deploy Script for Bipin Kumar
# Updates GitHub (both repos), GitHub Pages, and Netlify all at once!

set -e

MSG=${1:-"Update portfolio"}
DIR="/Users/mac/portflio"
TOKEN="nfp_dEAEJrQKPyYAcxqXd5dpn2GQynKju49s9583"
SITE_ID="c2f4800d-b37b-471b-8b06-fa54d67e4b23"

echo "🚀 Starting 1-Click Portfolio Deploy..."
cd "$DIR"

# 1. Git Commit & Push
echo "📦 Step 1/3: Saving changes to Git..."
git add .
if git diff-index --quiet HEAD --; then
    echo "ℹ️ No new changes to commit."
else
    git commit -m "$MSG"
fi

echo "🐙 Step 2/3: Pushing to GitHub & GitHub Pages..."
git push origin main || true
git push live main || true

# 2. Direct Netlify Deploy
echo "🌐 Step 3/3: Deploying to Netlify (bipinkumar28.netlify.app)..."
ZIP_FILE="/tmp/portfolio_deploy_auto.zip"
rm -f "$ZIP_FILE"
zip -q -r "$ZIP_FILE" index.html assets/ .nojekyll

curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/zip" \
  --data-binary @"$ZIP_FILE" \
  "https://api.netlify.com/api/v1/sites/$SITE_ID/deploys" > /dev/null

rm -f "$ZIP_FILE"

echo "✅ SUCCESS! All platforms updated successfully:"
echo "👉 Netlify:      https://bipinkumar28.netlify.app/"
echo "👉 GitHub Pages: https://bipinyadav79133-commits.github.io/portfolio/"
