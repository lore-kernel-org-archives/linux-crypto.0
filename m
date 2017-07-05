From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 0/3] crypto: introduce Microchip / Atmel ECC driver
Date: Wed, 5 Jul 2017 13:07:57 +0300
Message-ID: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38052 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdGEKII (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2017 06:08:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set introduces Microchip / Atmel ECC driver.

The first patch adds some helpers that will be used by fallbacks to
kpp software implementations.

The second patch adds ECDH support for the ATECC508A (I2C)
cryptographic engine. The I2C interface is designed to operate
at a maximum clock speed of 1MHz.

The device features hardware acceleration for the NIST standard
P256 prime curve and supports the complete key life cycle from
private key generation to ECDH key agreement.

Random private key generation is supported internally within
the device to ensure that the private key can never be known
outside of the device. If the user wants to use its own private
keys, the driver will fallback to the ecdh software implementation.

Tudor Ambarus (3):
  crypto: kpp: add get/set_flags helpers
  crypto: introduce Microchip / Atmel ECC driver
  MAINTAINERS: add a maintainer for Microchip / Atmel ECC driver

 .../devicetree/bindings/crypto/atmel-crypto.txt    |  13 +
 MAINTAINERS                                        |   6 +
 drivers/crypto/Kconfig                             |  14 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/atmel-ecc.c                         | 781 +++++++++++++++++++++
 drivers/crypto/atmel-ecc.h                         | 128 ++++
 include/crypto/kpp.h                               |  10 +
 7 files changed, 953 insertions(+)
 create mode 100644 drivers/crypto/atmel-ecc.c
 create mode 100644 drivers/crypto/atmel-ecc.h

-- 
2.7.4
