From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/2] crypto: caam: remove unused local variable
Date: Wed, 21 Jan 2015 11:53:31 +0200
Message-ID: <1421834011-29565-2-git-send-email-cristian.stoica@freescale.com>
References: <1421834011-29565-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <tudor.ambarus@freescale.com>,
	<alexandru.porosanu@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:9632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752336AbbAUJx6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jan 2015 04:53:58 -0500
In-Reply-To: <1421834011-29565-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 70f1e6f..efba4cc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -175,13 +175,10 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 {
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
 	struct caam_ctrl __iomem *ctrl;
-	struct rng4tst __iomem *r4tst;
 	u32 *desc, status, rdsta_val;
 	int ret = 0, sh_idx;
 
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	r4tst = &ctrl->r4tst[0];
-
 	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
@@ -209,8 +206,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		 * without any error (HW optimizations for later
 		 * CAAM eras), then try again.
 		 */
-		rdsta_val =
-			rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
+		rdsta_val = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
 		if (status || !(rdsta_val & (1 << sh_idx)))
 			ret = -EAGAIN;
 		if (ret)
-- 
2.2.0
