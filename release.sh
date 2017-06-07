#! /usr/bin/env sh

# pip install sphinx
# pip install Sphinx-PyPI-upload

python test_goslate.py
python setup.py build_sphinx
python setup.py upload_sphinx
python setup.py bdist_egg upload
python setup.py sdist upload

# for py3: python setup.py bdist_egg upload
