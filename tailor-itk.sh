#!/bin/sh

cd /darcs/itk
tailor --update --verbose
darcs tag -m `date +%F`


cd /darcs/contrib-itk/WrapITK
darcs dist
cd /tmp
rm -rf /tmp/WrapITK
tar xzf /darcs/contrib-itk/WrapITK/WrapITK.tar.gz
zip /darcs/contrib-itk/WrapITK/WrapITK.zip WrapITK
