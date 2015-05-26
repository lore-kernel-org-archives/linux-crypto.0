From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 0/3] crypto: ccp - CCP driver updates 2015-05-26
Date: Tue, 26 May 2015 13:06:13 -0500
Message-ID: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:50967
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378AbbEZSGb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 14:06:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patches are included in this driver update series:

- Remove the checking and setting of the device dma_mask field
- Remove an unused field from a structure to help avoid any confusion
- Protect against poorly marked end of scatter-gather list
 
This patch series is based on cryptodev-2.6.

---

Tom Lendacky (3):
      crypto: ccp - Remove manual check and set of dma_mask pointer
      crypto: ccp - Remove unused structure field
      crypto: ccp - Protect against poorly marked end of sg list


 drivers/crypto/ccp/ccp-ops.c      |   20 +++++++++++++++++---
 drivers/crypto/ccp/ccp-platform.c |    2 --
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
Tom Lendacky
