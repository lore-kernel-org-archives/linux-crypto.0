From: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 0/3] Add Broadcom SPU Crypto Driver
Date: Wed, 25 Jan 2017 11:44:46 -0500
Message-ID: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
Cc: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Changes in v3:
- rebase to 4.10-rc3 in cryptodev-2.6 tree
- in bindings doc, list all valid compatibility strings
- rename DT nodes "crypto" rather than "spu-crypto"
- include a separate DT node for each SPU hardware block. Previously,
 there was a single SPU node listing a register range for each
 hw block.
- select hash algos in Kconfig. Driver HMAC implementation uses hash
 sw algos for inner and outer hashes.
- Fix crash for AES CCM decrypt when AAD and data are both empty

Change in v2:
- select CRYPTO_DES in Kconfig

The Broadcom SPU crypto driver provides access to SPU hardware
for symmetric crypto offload. The driver supports ablkcipher,
ahash, and aead operations. The driver supports several
Broadcom SoCs with different revisions of the SPU hardware.
The driver supports SPU-M and SPU2 hardware revisions, and
a couple versions of each hw revision, each version with minor
differences.

Rob Rice (3):
  crypto: brcm: DT documentation for Broadcom SPU hardware
  crypto: brcm: Add Broadcom SPU driver
  arm64: dts: ns2: Add Broadcom SPU driver DT entry.

 .../devicetree/bindings/crypto/brcm,spu-crypto.txt |   22 +
 arch/arm64/boot/dts/broadcom/ns2.dtsi              |   24 +
 drivers/crypto/Kconfig                             |   15 +
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/bcm/Makefile                        |   15 +
 drivers/crypto/bcm/cipher.c                        | 4955 ++++++++++++++++++++
 drivers/crypto/bcm/cipher.h                        |  475 ++
 drivers/crypto/bcm/spu.c                           | 1252 +++++
 drivers/crypto/bcm/spu.h                           |  288 ++
 drivers/crypto/bcm/spu2.c                          | 1402 ++++++
 drivers/crypto/bcm/spu2.h                          |  228 +
 drivers/crypto/bcm/spum.h                          |  174 +
 drivers/crypto/bcm/util.c                          |  581 +++
 drivers/crypto/bcm/util.h                          |  116 +
 14 files changed, 9549 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
 create mode 100644 drivers/crypto/bcm/Makefile
 create mode 100644 drivers/crypto/bcm/cipher.c
 create mode 100644 drivers/crypto/bcm/cipher.h
 create mode 100644 drivers/crypto/bcm/spu.c
 create mode 100644 drivers/crypto/bcm/spu.h
 create mode 100644 drivers/crypto/bcm/spu2.c
 create mode 100644 drivers/crypto/bcm/spu2.h
 create mode 100644 drivers/crypto/bcm/spum.h
 create mode 100644 drivers/crypto/bcm/util.c
 create mode 100644 drivers/crypto/bcm/util.h

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
