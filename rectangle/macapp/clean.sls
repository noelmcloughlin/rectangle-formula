# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rectangle with context %}

rectangle-macos-app-clean-files:
  file.absent:
    - names:
      - {{ rectangle.dir.tmp }}
      - /Applications/{{ rectangle.pkg.name }}.app

    {%- else %}

rectangle-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The rectangle macpackage is only available on MacOS

    {%- endif %}
