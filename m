From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: amcc: Do a NULL check for pointer
Date: Fri, 14 Aug 2015 00:05:58 -0300
Message-ID: <1439521558-17214-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35074 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbHNDGU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 23:06:20 -0400
Received: by ykek5 with SMTP id k5so6674515yke.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 20:06:20 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Compare pointer-typed values to NULL rather than 0.

The semantic patch that makes this change is available
in scripts/coccinelle/null/badzero.cocci

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3b28e8c..47c4b08 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1113,7 +1113,7 @@ static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
 	struct device *dev = (struct device *)data;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 
-	if (core_dev->dev->ce_base == 0)
+	if (core_dev->dev->ce_base == NULL)
 		return 0;
 
 	writel(PPC4XX_INTERRUPT_CLR,
-- 
1.9.1
