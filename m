From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/3] crypto: ccp - code fixes/cleanup
Date: Tue, 10 Dec 2013 10:38:27 -0600
Message-ID: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:51044
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194Ab3LJQid (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements fixes and cleanup for some reported
errors and suggestions (sparse errors, randconfig build errors and
pr_err usage).

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (3):
      crypto: ccp - Fix sparse warnings in ccp-crypto-sha.c
      crypto: ccp - CCP Kconfig fixes
      crypto: ccp - Remove user triggerable pr_err calls


 drivers/crypto/Kconfig                   |    2 +-
 drivers/crypto/ccp/Kconfig               |    1 +
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-aes.c      |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-sha.c      |    8 ++++----
 drivers/crypto/ccp/ccp-crypto.h          |    2 +-
 7 files changed, 14 insertions(+), 27 deletions(-)

-- 
Tom Lendacky
