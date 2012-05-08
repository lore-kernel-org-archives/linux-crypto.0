From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 0/2] Update for ux500 CRYP and HASH
Date: Tue, 8 May 2012 13:28:31 +0200
Message-ID: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <arnd@arndb.de>,
	<sfr@canb.auug.org.au>, <lee.jones@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:60484 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab2EHL3V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2012 07:29:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This is an update of the core platform support for
ux500 HASH and CRYP driver. Also a small update for DMA
in the drivers.

Note that this does not apply cleanly on the cryptodev tree since it
does not seem to be up to date for ux500.

Herbert, how should we handle this, do you want to ack this and we send
it during the merge window or another way ?

Cheers
Andreas

Andreas Westin (2):
  mach-ux500: Crypto: core support for CRYP/HASH module.
  crypto: ux500: Update DMA handling for 3.4

 arch/arm/mach-ux500/board-mop500.c              |   48 ++++++++++++++++++++
 arch/arm/mach-ux500/clock.c                     |   18 ++++----
 arch/arm/mach-ux500/devices-common.h            |   54 +++++++++++++++++++++++
 arch/arm/mach-ux500/devices-db8500.h            |    4 ++
 arch/arm/mach-ux500/id.c                        |    3 ++
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |    1 +
 arch/arm/mach-ux500/include/mach/devices.h      |    3 ++
 drivers/crypto/ux500/cryp/cryp_core.c           |    5 +--
 drivers/crypto/ux500/hash/hash_core.c           |    2 +-
 9 files changed, 126 insertions(+), 12 deletions(-)

-- 
1.7.10
