From: Vakul Garg <vakul@freescale.com>
Subject: [PATCHv1] crypto: caam - set RDB bit in security configuration register
Date: Tue, 12 Mar 2013 13:55:21 +0530
Message-ID: <1363076721-21315-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:23901
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039Ab3CLI24 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Mar 2013 04:28:56 -0400
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
Sorry for repeated sending.
Resending as suggested by Herbert.

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
