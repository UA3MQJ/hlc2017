#!/bin/bash
echo "* unzip ./priv/data.zip -d ./priv/data"
/usr/bin/unzip -qq /tmp/data/data.zip -d /app/priv/data
cp /tmp/data/options.txt /app/priv/data/options.txt

echo "* start"
_build/dev/rel/mini_app/bin/mini_app foreground
