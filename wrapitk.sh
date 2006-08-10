#!/bin/sh

cd /darcs/contrib-itk/WrapITK
darcs dist
cd /tmp
rm -rf /tmp/WrapITK
tar xzf /darcs/contrib-itk/WrapITK/WrapITK.tar.gz
zip /darcs/contrib-itk/WrapITK/WrapITK.zip WrapITK

cd WrapITK/article
make
cp -f *.pdf /darcs/contrib-itk/WrapITK/



# and the same for the unstable version
cd /darcs/contrib-itk/WrapITK-unstable
darcs dist
cd /tmp
rm -rf /tmp/WrapITK-unstable
tar xzf /darcs/contrib-itk/WrapITK-unstable/WrapITK-unstable.tar.gz
zip /darcs/contrib-itk/WrapITK-unstable/WrapITK-unstable.zip WrapITK-unstable

cd WrapITK-unstable/article
make
cp -f *.pdf /darcs/contrib-itk/WrapITK-unstable/
