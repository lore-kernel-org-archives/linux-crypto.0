From: Vakul Garg <vakul@freescale.com>
Subject: [PATCHv1] crypto: caam - set RDB bit in security configuration register
Date: Mon, 11 Mar 2013 16:13:26 +0530
Message-ID: <1362998606-14522-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30720
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab3CKKq6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Mar 2013 06:46:58 -0400
Received: from mail192-ch1 (localhost [127.0.0.1])	by
 mail192-ch1-R.bigfish.com (Postfix) with ESMTP id 262E5260132	for
 <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2013 10:46:57 +0000 (UTC)
Received: from CH1EHSMHS002.bigfish.com (snatpool3.int.messaging.microsoft.com
 [10.43.68.225])	by mail192-ch1.bigfish.com (Postfix) with ESMTP id 001B2E005D
	for <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2013 10:46:54 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with ESMTP id r2BAkkuK009034	for
 <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2013 03:46:47 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This change is required for post SEC-5.0 devices which have RNG4.
Setting RDB in security configuration register allows CAAM to use the
"Random Data Buffer" to be filled by a single request. The Random Data
Buffer is large enough for ten packets to get their IVs from a single
request. If the Random Data Buffer is not enabled, then each IV causes a
separate request, and RNG4 hardware cannot keep up resulting in lower
IPSEC throughput if random IVs are used.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
Changes in v1: Addressed Kim Philip's comments.
(a) Limit commit message to 75 characters.
(b) Relocated code to set RDB bit in RNG4 initialisation section

 drivers/crypto/caam/ctrl.c |    3 +++
 drivers/crypto/caam/regs.h |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bf20dd8..79278d5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -304,6 +304,9 @@ static int caam_probe(struct platform_device *pdev)
 			caam_remove(pdev);
 			return ret;
 		}
+
+		/* Enable RDB bit so that RNG works faster */
+		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
 	}
 
 	/* NOTE: RTIC detection ought to go here, around Si time */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3223fc6..cd6feda 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -252,7 +252,8 @@ struct caam_ctrl {
 	/* Read/Writable					        */
 	u32 rsvd1;
 	u32 mcr;		/* MCFG      Master Config Register  */
-	u32 rsvd2[2];
+	u32 rsvd2;
+	u32 scfgr;		/* SCFGR, Security Config Register */
 
 	/* Bus Access Configuration Section			010-11f */
 	/* Read/Writable                                                */
@@ -299,6 +300,7 @@ struct caam_ctrl {
 #define MCFGR_WDFAIL		0x20000000 /* DECO watchdog force-fail */
 #define MCFGR_DMA_RESET		0x10000000
 #define MCFGR_LONG_PTR		0x00010000 /* Use >32-bit desc addressing */
+#define SCFGR_RDBENABLE		0x00000400
 
 /* AXI read cache control */
 #define MCFGR_ARCACHE_SHIFT	12
-- 
1.7.7.6
