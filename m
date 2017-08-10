From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH 00/10] crypto: caam - add DPAA2 (DPSECI) driver
Date: Thu, 10 Aug 2017 20:42:43 +0300
Message-ID: <20170810174253.20951-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devel@driverdev.osuosl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0071.outbound.protection.outlook.com ([104.47.38.71]:52768
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753126AbdHJRnb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 13:43:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set adds the CAAM crypto engine driver for DPAA2
(Data Path Acceleration Architecture v2) found on ARMv8-based SoCs
like LS1088A, LS2088A.

Driver consists of:
-DPSECI (Data Path SEC Interface) backend - low-level API that allows
to manage DPSECI devices (DPAA2 objects) that sit on
the Management Complex (MC) fsl-mc bus
-algorithms frontend - AEAD and ablkcipher algorithms implementation

Patches 1-4 include DPIO object dependencies.
I am aware that DPIO is currently in staging, however I don't consider
these to be a large feature set. Anyhow, please let me know if going
with the patches through staging is acceptable.

Patches 5-9 are the core of the patch set, adding the driver.
For symmetric encryption the legacy ablkcipher interface is used; the
plan is to convert to skcipher all CAAM frontends at once at a certain
point in time.

Patch 10 enables driver on arm64. It will be built only if dependency
on DPIO (CONFIG_FSL_MC_DPIO) is satisfied.

Thanks,
Horia

Horia Geantă (9):
  staging: fsl-mc: dpio: add frame list format support
  staging: fsl-mc: dpio: add congestion notification support
  staging: fsl-dpaa2/eth: move generic FD defines to DPIO
  crypto: caam/qi - prepare for gcm(aes) support
  crypto: caam - add DPAA2-CAAM (DPSECI) backend API
  crypto: caam - add Queue Interface v2 error codes
  crypto: caam/qi2 - add DPAA2-CAAM driver
  crypto: caam/qi2 - add ablkcipher algorithms
  arm64: defconfig: enable CAAM crypto engine on QorIQ DPAA2 SoCs

Radu Alexe (1):
  staging: fsl-mc: dpio: add order preservation support

 arch/arm64/configs/defconfig                   |    1 +
 drivers/crypto/Makefile                        |    2 +-
 drivers/crypto/caam/Kconfig                    |   57 +-
 drivers/crypto/caam/Makefile                   |    9 +-
 drivers/crypto/caam/caamalg.c                  |   19 +-
 drivers/crypto/caam/caamalg_desc.c             |  165 +-
 drivers/crypto/caam/caamalg_desc.h             |   24 +-
 drivers/crypto/caam/caamalg_qi2.c              | 3949 ++++++++++++++++++++++++
 drivers/crypto/caam/caamalg_qi2.h              |  243 ++
 drivers/crypto/caam/compat.h                   |    1 +
 drivers/crypto/caam/dpseci.c                   |  858 +++++
 drivers/crypto/caam/dpseci.h                   |  395 +++
 drivers/crypto/caam/dpseci_cmd.h               |  261 ++
 drivers/crypto/caam/error.c                    |   75 +-
 drivers/crypto/caam/error.h                    |    6 +-
 drivers/crypto/caam/key_gen.c                  |   30 -
 drivers/crypto/caam/key_gen.h                  |   30 +
 drivers/crypto/caam/regs.h                     |    2 +
 drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c |    8 +-
 drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.h |   19 +-
 drivers/staging/fsl-mc/include/dpaa2-fd.h      |  255 ++
 drivers/staging/fsl-mc/include/dpaa2-io.h      |   43 +
 drivers/staging/fsl-mc/include/dpopr.h         |  110 +
 23 files changed, 6463 insertions(+), 99 deletions(-)
 create mode 100644 drivers/crypto/caam/caamalg_qi2.c
 create mode 100644 drivers/crypto/caam/caamalg_qi2.h
 create mode 100644 drivers/crypto/caam/dpseci.c
 create mode 100644 drivers/crypto/caam/dpseci.h
 create mode 100644 drivers/crypto/caam/dpseci_cmd.h
 create mode 100644 drivers/staging/fsl-mc/include/dpopr.h

-- 
2.12.0.264.gd6db3f216544
