From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] crypto: mv_cesa - Use resource_size
Date: Tue, 11 May 2010 08:57:44 +0200
Message-ID: <1273561064-3530-1-git-send-email-tklauser@distanz.ch>
Cc: davem@davemloft.net, kernel-janitors@vger.kernel.org,
	Tobias Klauser <tklauser@distanz.ch>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.zhaw.ch ([160.85.104.50]:52885 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0EKHFl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 May 2010 03:05:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the resource_size function instead of manually calculating the
resource size. This reduces the chance of introducing off-by-one errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/crypto/mv_cesa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 18a436c..e095422 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1023,7 +1023,7 @@ static int mv_probe(struct platform_device *pdev)
 
 	spin_lock_init(&cp->lock);
 	crypto_init_queue(&cp->queue, 50);
-	cp->reg = ioremap(res->start, res->end - res->start + 1);
+	cp->reg = ioremap(res->start, resource_size(res));
 	if (!cp->reg) {
 		ret = -ENOMEM;
 		goto err;
@@ -1034,7 +1034,7 @@ static int mv_probe(struct platform_device *pdev)
 		ret = -ENXIO;
 		goto err_unmap_reg;
 	}
-	cp->sram_size = res->end - res->start + 1;
+	cp->sram_size = resource_size(res);
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) {
-- 
1.6.3.3

