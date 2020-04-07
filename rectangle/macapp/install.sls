# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rectangle with context %}

rectangle-macos-app-install-curl:
  file.directory:
    - name: {{ rectangle.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ rectangle.dir.tmp }}/rectangle-{{ rectangle.version }} {{ rectangle.pkg.macapp.source }}
    - unless: test -f {{ rectangle.dir.tmp }}/rectangle-{{ rectangle.version }}
    - require:
      - file: rectangle-macos-app-install-curl
      - pkg: rectangle-macos-app-install-curl
    - retry: {{ rectangle.retry_option }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
rectangle-macos-app-install-checksum:
  module.run:
    - onlyif: {{ rectangle.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ rectangle.dir.tmp }}/rectangle-{{ rectangle.version }}
    - file_hash: {{ rectangle.pkg.macapp.source_hash }}
    - require:
      - cmd: rectangle-macos-app-install-curl
    - require_in:
      - macpackage: rectangle-macos-app-install-macpackage
  file.absent:
    - name: {{ rectangle.dir.tmp }}/rectangle-{{ rectangle.version }}
    - onfail:
      - module: rectangle-macos-app-install-checksum

rectangle-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ rectangle.dir.tmp }}/rectangle-{{ rectangle.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: rectangle-macos-app-install-curl
  file.append:
    - name: '/Users/{{ rectangle.rootuser }}/.bash_profile'
    - text: 'export PATH=$PATH:/Applications/Rectangle.app/Contents/MacOS/Rectangle'
    - require:
      - macpackage: rectangle-macos-app-install-macpackage

    {%- else %}

rectangle-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The rectangle macpackagge is only available on MacOS

    {%- endif %}
