#!/bin/bash

# export vars excluding comment lines
export $(grep -v '^#' .env | xargs)
