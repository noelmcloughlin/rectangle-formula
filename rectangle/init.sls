# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os == 'MacOS' %}

include:
  - .macapp

    {%- else %}

rectangle-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The rectangle macpackagge is only available on MacOS

    {%- endif %}
