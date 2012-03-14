From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 0/3 v3] crypto: ux500 crypto and hash driver
Date: Wed, 14 Mar 2012 09:45:45 +0100
Message-ID: <1331714748-25136-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:46942 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759381Ab2CNIqJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Mar 2012 04:46:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I've split the driver into two parts one for hash and one
for crypto, hopefully it gets through this time.

This adds a driver for the ST-Ericsson ux500 hardware
crypto and hash module.

It supports:
* AES with 128, 192 and 256bit keysize and ECB, CBC and CTR modes.
* DES and 3DES
* SHA-1 and SHA-256

Two patches for the driver and one for core support.

/Andreas


Andreas Westin (3):
  crypto: ux500: Add driver for CRYP hardware.
  crypto: ux500: Add driver for HASH hardware
  mach-ux500: Crypto: core support for CRYP/HASH module.

 arch/arm/mach-ux500/board-mop500.c              |   48 +
 arch/arm/mach-ux500/board-u5500.c               |   48 +
 arch/arm/mach-ux500/clock.c                     |   18 +-
 arch/arm/mach-ux500/devices-common.c            |   16 +
 arch/arm/mach-ux500/devices-common.h            |   23 +
 arch/arm/mach-ux500/devices-db5500.h            |    4 +
 arch/arm/mach-ux500/devices-db8500.h            |    4 +
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |   21 +
 arch/arm/mach-ux500/include/mach/devices.h      |    3 +
 arch/arm/mach-ux500/ste-dma40-db5500.h          |    9 +-
 drivers/crypto/Kconfig                          |   11 +
 drivers/crypto/Makefile                         |    1 +
 drivers/crypto/ux500/Kconfig                    |   29 +
 drivers/crypto/ux500/Makefile                   |    8 +
 drivers/crypto/ux500/cryp/Makefile              |   13 +
 drivers/crypto/ux500/cryp/cryp.c                |  418 +++++
 drivers/crypto/ux500/cryp/cryp.h                |  308 +++
 drivers/crypto/ux500/cryp/cryp_core.c           | 2276 +++++++++++++++++++++++
 drivers/crypto/ux500/cryp/cryp_irq.c            |   45 +
 drivers/crypto/ux500/cryp/cryp_irq.h            |   31 +
 drivers/crypto/ux500/cryp/cryp_irqp.h           |  125 ++
 drivers/crypto/ux500/cryp/cryp_p.h              |  124 ++
 drivers/crypto/ux500/hash/Makefile              |   11 +
 drivers/crypto/ux500/hash/hash_alg.h            |  387 ++++
 drivers/crypto/ux500/hash/hash_alg_p.h          |   20 +
 drivers/crypto/ux500/hash/hash_core.c           | 2036 ++++++++++++++++++++
 26 files changed, 6026 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mach-ux500/include/mach/crypto-ux500.h
 create mode 100644 drivers/crypto/ux500/Kconfig
 create mode 100644 drivers/crypto/ux500/Makefile
 create mode 100644 drivers/crypto/ux500/cryp/Makefile
 create mode 100644 drivers/crypto/ux500/cryp/cryp.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_core.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irq.c
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irq.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_irqp.h
 create mode 100644 drivers/crypto/ux500/cryp/cryp_p.h
 create mode 100644 drivers/crypto/ux500/hash/Makefile
 create mode 100644 drivers/crypto/ux500/hash/hash_alg.h
 create mode 100644 drivers/crypto/ux500/hash/hash_alg_p.h
 create mode 100644 drivers/crypto/ux500/hash/hash_core.c

-- 
1.7.9
