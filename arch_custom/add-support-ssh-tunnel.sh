#!/bin/bash

# add support systemd service
cp systemd/secure-tunnel@.service /etc/systemd/system/

# add config for support service
cp systemd/service-tunnel@grozours.fr /etc/default/
