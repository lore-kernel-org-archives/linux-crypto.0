From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH v4 0/3] Add Broadcom SPU Crypto Driver
Date: Fri,  3 Feb 2017 12:55:31 -0500
Message-ID: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
Cc: Rob Rice <rob.rice@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Changes in v4:
- Added Rob Herring's Acked-by to patch 1/3 for bindings doc
- In response to Herbert's comment, in ahash_export() and 
  ahash_import(), only copy the hash state, not state params
  related to cipher or aead algos. 
- Noticed that hmac_offset in iproc_reqctx_s and spu_hash_params
  wasn't really used. So removed.

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
 drivers/crypto/bcm/cipher.c                        | 4964 ++++++++++++++++++++
 drivers/crypto/bcm/cipher.h                        |  483 ++
 drivers/crypto/bcm/spu.c                           | 1251 +++++
 drivers/crypto/bcm/spu.h                           |  287 ++
 drivers/crypto/bcm/spu2.c                          | 1401 ++++++
 drivers/crypto/bcm/spu2.h                          |  228 +
 drivers/crypto/bcm/spum.h                          |  174 +
 drivers/crypto/bcm/util.c                          |  581 +++
 drivers/crypto/bcm/util.h                          |  116 +
 14 files changed, 9563 insertions(+)
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
