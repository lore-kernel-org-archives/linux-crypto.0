From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH v6 0/3] crypto: ux500 crypto and hash driver
Date: Mon, 23 Apr 2012 10:48:52 +0200
Message-ID: <1335170935-12861-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <kim.phillips@freescale.com>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46236 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab2DWItW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Apr 2012 04:49:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changed HASH driver to use request for writable data instead of
tfm.

This adds a driver for the ST-Ericsson ux500 crypto hardware
module. It supports AES, DES and 3DES, the driver implements
support for AES-ECB,CBC and CTR.

Patches are also available at: http://www.df.lth.se/~triad/ux500-crypto/

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
 drivers/crypto/ux500/Kconfig                    |   30 +
 drivers/crypto/ux500/Makefile                   |    8 +
 drivers/crypto/ux500/cryp/Makefile              |   13 +
 drivers/crypto/ux500/cryp/cryp.c                |  391 +++++
 drivers/crypto/ux500/cryp/cryp.h                |  308 ++++
 drivers/crypto/ux500/cryp/cryp_core.c           | 1785 ++++++++++++++++++++
 drivers/crypto/ux500/cryp/cryp_irq.c            |   45 +
 drivers/crypto/ux500/cryp/cryp_irq.h            |   31 +
 drivers/crypto/ux500/cryp/cryp_irqp.h           |  125 ++
 drivers/crypto/ux500/cryp/cryp_p.h              |  124 ++
 drivers/crypto/ux500/hash/Makefile              |   11 +
 drivers/crypto/ux500/hash/hash_alg.h            |  395 +++++
 drivers/crypto/ux500/hash/hash_core.c           | 2019 +++++++++++++++++++++++
 25 files changed, 5480 insertions(+), 11 deletions(-)
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
 create mode 100644 drivers/crypto/ux500/hash/hash_core.c

-- 
1.7.10
