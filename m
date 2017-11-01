From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/4] crypto: qat - fix double free of ctx->p
Date: Wed,  1 Nov 2017 15:25:16 -0700
Message-ID: <20171101222517.41602-4-ebiggers3@gmail.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
Cc: keyrings@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:55524 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933526AbdKAW23 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 18:28:29 -0400
In-Reply-To: <20171101222517.41602-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When setting the secret with the "qat-dh" Diffie-Hellman implementation,
if allocating 'g' failed, then 'p' was freed twice: once immediately,
and once later when the crypto_kpp tfm was destroyed.  Fix it by using
qat_dh_clear_ctx() in the error paths, as that sets the pointers to
NULL.

Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 6f5dd68449c6..7655fdb499de 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -462,11 +462,8 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
 	}
 
 	ctx->g = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_g, GFP_KERNEL);
-	if (!ctx->g) {
-		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
-		ctx->p = NULL;
+	if (!ctx->g)
 		return -ENOMEM;
-	}
 	memcpy(ctx->g + (ctx->p_size - params->g_size), params->g,
 	       params->g_size);
 
@@ -507,18 +504,22 @@ static int qat_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
 	ret = qat_dh_set_params(ctx, &params);
 	if (ret < 0)
-		return ret;
+		goto err_clear_ctx;
 
 	ctx->xa = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_xa,
 				      GFP_KERNEL);
 	if (!ctx->xa) {
-		qat_dh_clear_ctx(dev, ctx);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_clear_ctx;
 	}
 	memcpy(ctx->xa + (ctx->p_size - params.key_size), params.key,
 	       params.key_size);
 
 	return 0;
+
+err_clear_ctx:
+	qat_dh_clear_ctx(dev, ctx);
+	return ret;
 }
 
 static unsigned int qat_dh_max_size(struct crypto_kpp *tfm)
-- 
2.15.0.403.gc27cc4dac6-goog
