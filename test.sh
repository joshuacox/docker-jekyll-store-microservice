#!/bin/bash

export JSM_FRONT_URL=localhost
export JSM_PURCHASES_EMAIL="example@gmail.com"
export JSM_ERRORS_EMAIL=example@gmail.com
export JSM_PAYMENT_METHOD=paymill
export JSM_SMTP_ADDRESS=smtp.gmail.com
export JSM_SMTP_DOMAIN=localhost.localdomain
export JSM_SMTP_HOST=smtp.gmail.com
export JSM_SMTP_PORT=587
export JSM_SMTP_USER="example@gmail.com"
export JSM_SMTP_PASS=singleuseapppass
export JSM_SMTP_AUTH='plain'
export JSM_SMTP_START_TLS_AUTO=True
export JSM_PAYMILL_PRIVATE_KEY=replaceme

ruby app.rb
