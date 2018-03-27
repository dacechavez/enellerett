#!/bin/bash -e

# Test production
curl -d "noun=vattenkran" -X POST https://enellerett.se/substantiv

# Test locally
declare -a arr=("crêpe"
  "læstadianism"
  "moçambikier"
  "müsli"
  "Ängelholmsbo"
  "pietà"
  "salladsbuffé"
  "struktur"
  "bord"
  "cyklop"
  "crème de la crème"
  "crème fraiche"
)

for i in "${arr[@]}"; do
  curl -d "noun=$i" -X POST http://localhost:5000/substantiv
  echo ""
done


