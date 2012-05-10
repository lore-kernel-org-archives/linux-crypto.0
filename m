From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH v2 0/3] Update for ux500 CRYP and HASH
Date: Thu, 10 May 2012 10:14:05 +0200
Message-ID: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <arnd@arndb.de>,
	<sfr@canb.auug.org.au>, <lee.jones@linaro.org>,
	<linus.walleij@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:57435 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741Ab2EJIOh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 04:14:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

V2 of the patches.

* Removed symbol export
* Removed usage of SOC specific functions in the drivers.
* Readded overlooked config for DMA in mach-ux500.

After some internal discussion we felt that the now implemented
hardware identification solution is cleaner than the suggested
solution.

The hardware identification patch applies cleanly to
the cryptodev tree.

Regards
Andreas

Andreas Westin (3):
  mach-ux500: Crypto: core support for CRYP/HASH module.
  crypto: ux500: Update DMA handling for 3.4
  crypto: ux500: Cleanup hardware identification

 arch/arm/mach-ux500/board-mop500.c              |   48 ++++++++++++++++++++
 arch/arm/mach-ux500/clock.c                     |   18 ++++----
 arch/arm/mach-ux500/devices-common.h            |   54 +++++++++++++++++++++++
 arch/arm/mach-ux500/devices-db8500.c            |    3 ++
 arch/arm/mach-ux500/devices-db8500.h            |    4 ++
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |    1 +
 arch/arm/mach-ux500/include/mach/devices.h      |    3 ++
 arch/arm/mach-ux500/include/mach/hardware.h     |    3 ++
 drivers/crypto/ux500/cryp/cryp.c                |   10 ++---
 drivers/crypto/ux500/cryp/cryp_core.c           |    5 +--
 drivers/crypto/ux500/cryp/cryp_p.h              |    1 -
 drivers/crypto/ux500/hash/hash_core.c           |   12 +----
 12 files changed, 133 insertions(+), 29 deletions(-)

-- 
1.7.10
