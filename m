From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 0/2] crypto: ux500 crypto and hash driver
Date: Thu, 23 Feb 2012 13:58:55 +0100
Message-ID: <1330001937-2108-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:36247 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab2BWNE3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Feb 2012 08:04:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This adds a driver for the ST-Ericsson ux500 hardware
crypto and hash module.

It supports:
* AES with 128, 192 and 256bit keysize and ECB, CBC and CTR modes.
* DES and 3DES
* SHA-1 and SHA-256

One patch for the driver and one for core support.

/Andreas

Andreas Westin (2):
  crypto: ux500 - Add driver for CRYP/HASH hardware.
  mach-ux500: Crypto: core support for CRYP/HASH module.

 arch/arm/mach-ux500/board-mop500.c              |   48 +
 arch/arm/mach-ux500/board-u5500.c               |   48 +
 arch/arm/mach-ux500/clock.c                     |   18 +-
 arch/arm/mach-ux500/devices-common.c            |   16 +
 arch/arm/mach-ux500/devices-common.h            |   23 +
 arch/arm/mach-ux500/devices-db5500.h            |    5 +
 arch/arm/mach-ux500/devices-db8500.h            |    5 +
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
 drivers/crypto/ux500/hash/hash_alg_p.h          |   26 +
 drivers/crypto/ux500/hash/hash_core.c           | 2036 ++++++++++++++++++++
 26 files changed, 6034 insertions(+), 11 deletions(-)
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
