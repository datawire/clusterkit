#!/bin/bash

export TF_VAR_owner=$USER

exec terraform "$@"