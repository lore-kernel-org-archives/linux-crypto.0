From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v4 0/4] crypto: add driver for Axis ARTPEC crypto accelerator
Date: Thu, 10 Aug 2017 14:53:50 +0200
Message-ID: <cover.1502368677.git.larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series adds a driver for the crypto accelerator in the ARTPEC series of
SoCs from Axis Communications AB.

Changelog v4:
- The skcipher conversion had a mistake where the algos were registered
  instead of unregistered at module unloading.

Changelog v3:
- The patch author added his Signed-off-by on patch 2.

Changelog v2:
- Use xts_check_key() for xts keys.
- Use CRYPTO_ALG_TYPE_SKCIPHER instead of CRYPTO_ALG_TYPE_ABLKCIPHER
  in cra_flags.

Lars Persson (3):
  dt-bindings: crypto: add ARTPEC crypto
  crypto: axis: add ARTPEC-6/7 crypto accelerator driver
  MAINTAINERS: Add ARTPEC crypto maintainer

Rabin Vincent (1):
  crypto: add crypto_(un)register_ahashes()

 .../devicetree/bindings/crypto/artpec6-crypto.txt  |   16 +
 MAINTAINERS                                        |    1 +
 crypto/ahash.c                                     |   29 +
 drivers/crypto/Kconfig                             |   21 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/axis/Makefile                       |    1 +
 drivers/crypto/axis/artpec6_crypto.c               | 3192 ++++++++++++++++++++
 include/crypto/internal/hash.h                     |    2 +
 8 files changed, 3263 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
 create mode 100644 drivers/crypto/axis/Makefile
 create mode 100644 drivers/crypto/axis/artpec6_crypto.c

-- 
2.11.0
