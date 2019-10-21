#!/bin/bash

FLAG="rot(QCV{9J5Y_7q3a3_jL7DjuuH_15})"

rm -r final.png

cp base.png final.png
exiftool "-Comment=$FLAG" -overwrite_original final.png

