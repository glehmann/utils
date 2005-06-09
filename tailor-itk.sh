#!/bin/sh

cd /darcs/itk
tailor --update --verbose
darcs tag -m `date +%F`


