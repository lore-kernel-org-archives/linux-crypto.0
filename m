From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 1/7] crypto: caam - fix RNG state handle instantiation descriptor
Date: Mon, 9 Sep 2013 18:56:28 +0300
Message-ID: <1378742194-32194-2-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:2637
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab3IIP7R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:17 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way the DECO runs a descriptor through the direct (debug)
interface is different from the JRI interface: the DECO will
continue to try and execute the next commands, after the descriptor
buffer has ended. This leads to unpredictable results and possibly
to locking up of the DECO. This patch adds a halt command at the
end of the descriptor to ensure the DECO halts when it reaches
the end of the descriptor buffer.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b010d42..11c7f29 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -73,6 +73,8 @@ static void build_instantiation_desc(u32 *desc)
 	/* generate secure keys (non-test) */
 	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
 			 OP_ALG_RNG4_SK);
+
+	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
 
 static int instantiate_rng(struct device *ctrldev)
@@ -83,7 +85,7 @@ static int instantiate_rng(struct device *ctrldev)
 	u32 *desc;
 	int i, ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 6, GFP_KERNEL | GFP_DMA);
+	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
 		dev_err(ctrldev, "can't allocate RNG init descriptor memory\n");
 		return -ENOMEM;
-- 
1.7.7.6
