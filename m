From: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] Add Broadcom SPU Crypto Driver
Date: Wed, 30 Nov 2016 15:07:30 -0500
Message-ID: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
Cc: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The Broadcom SPU crypto driver provides access to SPU hardware
for symmetric crypto offload. The driver supports ablkcipher,
ahash, and aead operations. The driver supports several
Broadcom SoCs with different revisions of the SPU hardware.
The driver supports SPU-M and SPU2 hardware revisions, and
a couple versions of each hw revision, each version with minor
differences.

The device tree entries for the SPU depends on device tree entries
for the Broadcom PDC driver. The PDC DT entries have been accepted
upstream, but are not yet included in the crypto repo. See commit
e79249143f468f8d3365dbbd1642c045bdcc98c5.

Rob Rice (3):
  crypto: brcm: DT documentation for Broadcom SPU driver
  crypto: brcm: Add Broadcom SPU driver
  crypto: brcm: Add Broadcom SPU driver DT entry.

 .../devicetree/bindings/crypto/brcm,spu-crypto.txt |   25 +
 arch/arm64/boot/dts/broadcom/ns2.dtsi              |   12 +
 drivers/crypto/Kconfig                             |   10 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/bcm/Makefile                        |   15 +
 drivers/crypto/bcm/cipher.c                        | 4943 ++++++++++++++++++++
 drivers/crypto/bcm/cipher.h                        |  472 ++
 drivers/crypto/bcm/spu.c                           | 1252 +++++
 drivers/crypto/bcm/spu.h                           |  288 ++
 drivers/crypto/bcm/spu2.c                          | 1402 ++++++
 drivers/crypto/bcm/spu2.h                          |  228 +
 drivers/crypto/bcm/spum.h                          |  174 +
 drivers/crypto/bcm/util.c                          |  584 +++
 drivers/crypto/bcm/util.h                          |  117 +
 14 files changed, 9523 insertions(+)
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
