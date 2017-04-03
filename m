From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix invalid dereference in caam_rsa_init_tfm()
Date: Mon, 3 Apr 2017 18:30:07 +0300
Message-ID: <20170403153007.30455-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Dan Douglass <dan.douglass@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0049.outbound.protection.outlook.com ([104.47.38.49]:35424
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752367AbdDCPa7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 11:30:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case caam_jr_alloc() fails, ctx->dev carries the error code,
thus accessing it with dev_err() is incorrect.

Cc: <stable@vger.kernel.org> # 4.8+
Fixes: 8c419778ab57e ("crypto: caam - add support for RSA algorithm")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 32100c4851dd..49cbdcba7883 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -506,7 +506,7 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 	ctx->dev = caam_jr_alloc();
 
 	if (IS_ERR(ctx->dev)) {
-		dev_err(ctx->dev, "Job Ring Device allocation for transform failed\n");
+		pr_err("Job Ring Device allocation for transform failed\n");
 		return PTR_ERR(ctx->dev);
 	}
 
-- 
2.12.0.264.gd6db3f216544
