#!/bin/bash
echo "Copying .env files for each directory"

cp -n accounts/.env.example accounts/.env
cp -n authentication/.env.example authentication/.env
cp -n bills/.env.example bills/.env
cp -n portal/.env.example portal/.env
cp -n support/.env.example support/.env
cp -n transactions/.env.example transactions/.env
cp -n userbase/.env.example userbase/.env
