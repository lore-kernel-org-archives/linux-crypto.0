From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: omap-aes - fix error return code in omap_aes_probe()
Date: Thu, 15 Sep 2016 03:27:32 +0000
Message-ID: <1473910052-31515-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34650 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759550AbcIOD1i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2016 23:27:38 -0400
Received: by mail-pa0-f68.google.com with SMTP id vz6so1542062pab.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2016 20:27:38 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the crypto_engine_alloc_init()
error handling case instead of 0, as done elsewhere in this function.

Fixes: 0529900a01cb ("crypto: omap-aes - Support crypto engine framework")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/omap-aes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 2033769..fe32dd9 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1215,8 +1215,10 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 	/* Initialize crypto engine */
 	dd->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dd->engine)
+	if (!dd->engine) {
+		err = -ENOMEM;
 		goto err_engine;
+	}
 
 	dd->engine->prepare_cipher_request = omap_aes_prepare_req;
 	dd->engine->cipher_one_request = omap_aes_crypt_req;
