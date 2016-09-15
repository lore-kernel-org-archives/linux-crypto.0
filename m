From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: omap-des - fix error return code in omap_des_probe()
Date: Thu, 15 Sep 2016 03:27:15 +0000
Message-ID: <1473910035-31283-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36537 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933658AbcIOD10 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2016 23:27:26 -0400
Received: by mail-pf0-f195.google.com with SMTP id n24so1608124pfb.3
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2016 20:27:21 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the crypto_engine_alloc_init()
error handling case instead of 0, as done elsewhere in this function.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto
engine framework")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/omap-des.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 2b20d96..a6f6553 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1081,8 +1081,10 @@ static int omap_des_probe(struct platform_device *pdev)
 
 	/* Initialize des crypto engine */
 	dd->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dd->engine)
+	if (!dd->engine) {
+		err = -ENOMEM;
 		goto err_engine;
+	}
 
 	dd->engine->prepare_cipher_request = omap_des_prepare_req;
 	dd->engine->cipher_one_request = omap_des_crypt_req;
