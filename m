From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH v2 0/3] Add Broadcom SPU Crypto Driver
Date: Fri,  2 Dec 2016 16:34:56 -0500
Message-ID: <1480714499-1476-1-git-send-email-rob.rice@broadcom.com>
Cc: Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33957 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbcLBVfW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 16:35:22 -0500
Received: by mail-pg0-f41.google.com with SMTP id x23so111524259pgx.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Dec 2016 13:35:22 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change in v2:
- select CRYPTO_DES in Kconfig

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
 drivers/crypto/Kconfig                             |   11 +
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
 14 files changed, 9524 insertions(+)
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
