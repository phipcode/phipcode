#!/bin/bash

echo "Starting Jekyll development server..."
echo

echo "Installing dependencies if needed..."
bundle install
echo

echo "Starting server with live reload..."
echo

echo "Your site will be available at: http://localhost:4000"
echo "Press Ctrl+C to stop the server"
echo

bundle exec jekyll serve --config _config.yml,_config_dev.yml --livereload 