From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: crypto4xx - fix an error code
Date: Sat, 10 Jun 2017 14:54:33 +0200
Message-ID: <20170610125433.26294-1-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:47739 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdFJMyp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 08:54:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If 'kzalloc' fails, we return 0 which means success.
return -ENOMEM instead as already done a few lines above.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/amcc/crypto4xx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index fdc83a2281ca..65dc78b91dea 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1179,6 +1179,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	dev_set_drvdata(dev, core_dev);
 	core_dev->ofdev = ofdev;
 	core_dev->dev = kzalloc(sizeof(struct crypto4xx_device), GFP_KERNEL);
+	rc = -ENOMEM;
 	if (!core_dev->dev)
 		goto err_alloc_dev;
 
-- 
2.11.0
