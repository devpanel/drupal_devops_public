#!/bin/bash


docker build -t drupal .
ecs-cli push -r ap-northeast-2 drupal