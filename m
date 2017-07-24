From: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH v2 0/4] crypto: add driver for Axis ARTPEC crypto accelerator
Date: Mon, 24 Jul 2017 09:07:28 +0200
Message-ID: <cover.1500879613.git.larper@axis.com>
Cc: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This series adds a driver for the crypto accelerator in the ARTPEC series of
SoCs from Axis Communications AB.

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
 drivers/crypto/axis/artpec6_crypto.c               | 3193 ++++++++++++++++++++
 include/crypto/internal/hash.h                     |    2 +
 8 files changed, 3264 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
 create mode 100644 drivers/crypto/axis/Makefile
 create mode 100644 drivers/crypto/axis/artpec6_crypto.c

-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
