From: Simon Baatz <gmbnomis@gmail.com>
Subject: [PATCH 1/2] mv_dma: fix mv_init_engine() error case
Date: Sat, 16 Jun 2012 02:20:20 +0200
Message-ID: <1339806021-14271-2-git-send-email-gmbnomis@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Cc: linux-crypto@vger.kernel.org
To: phil.sutter@viprinet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35346 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2FPAVA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2012 20:21:00 -0400
Received: by eaak11 with SMTP id k11so1081133eaa.19
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jun 2012 17:20:59 -0700 (PDT)
In-Reply-To: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix wrongly placed free_irq in mv_init_engine() error recovery. In fact, we
can remove the respective label, since request_irq() is the last thing the
function does anyway.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
---
 drivers/crypto/mv_dma.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/mv_dma.c b/drivers/crypto/mv_dma.c
index b84ff80..125dfee 100644
--- a/drivers/crypto/mv_dma.c
+++ b/drivers/crypto/mv_dma.c
@@ -296,7 +296,7 @@ static int mv_init_engine(struct platform_device *pdev,
 	if (init_dma_desclist(&tpg.desclist, tpg.dev,
 			sizeof(struct mv_dma_desc), MV_DMA_ALIGN, 0)) {
 		rc = -ENOMEM;
-		goto out_free_irq;
+		goto out_unmap_reg;
 	}
 	if (set_dma_desclist_size(&tpg.desclist, MV_DMA_INIT_POOLSIZE)) {
 		rc = -ENOMEM;
@@ -330,8 +330,6 @@ out_free_all:
 	platform_set_drvdata(pdev, NULL);
 out_free_desclist:
 	fini_dma_desclist(&tpg.desclist);
-out_free_irq:
-	free_irq(tpg.irq, &tpg);
 out_unmap_reg:
 	iounmap(tpg.reg);
 	tpg.dev = NULL;
-- 
1.7.9.5
