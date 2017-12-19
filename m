From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 2/4] crypto: caam - remove needless ablkcipher key copy
Date: Tue, 19 Dec 2017 12:16:05 +0200
Message-ID: <20171219101607.15323-2-horia.geanta@nxp.com>
References: <20171219101607.15323-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0058.outbound.protection.outlook.com ([104.47.34.58]:40509
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758745AbdLSKQ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 05:16:28 -0500
In-Reply-To: <20171219101607.15323-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ablkcipher shared descriptors are relatively small, thus there is enough
space for the key to be inlined.
Accordingly, there is no need to copy the key in ctx->key.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c    | 8 ++------
 drivers/crypto/caam/caamalg_qi.c | 8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index baa8dd52472d..f5666e50c1e7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -625,7 +625,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	const bool is_rfc3686 = (ctr_mode &&
 				 (strstr(alg_name, "rfc3686") != NULL));
 
-	memcpy(ctx->key, key, keylen);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -648,9 +647,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		keylen -= CTR_RFC3686_NONCE_SIZE;
 	}
 
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.keylen = keylen;
-	ctx->cdata.key_virt = ctx->key;
+	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
 
 	/* ablkcipher_encrypt shared descriptor */
@@ -691,10 +689,8 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		return -EINVAL;
 	}
 
-	memcpy(ctx->key, key, keylen);
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.keylen = keylen;
-	ctx->cdata.key_virt = ctx->key;
+	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
 
 	/* xts_ablkcipher_encrypt shared descriptor */
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ad14b69a052e..b45401786530 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -272,7 +272,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	const bool is_rfc3686 = (ctr_mode && strstr(alg_name, "rfc3686"));
 	int ret = 0;
 
-	memcpy(ctx->key, key, keylen);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @" __stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -295,9 +294,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		keylen -= CTR_RFC3686_NONCE_SIZE;
 	}
 
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.keylen = keylen;
-	ctx->cdata.key_virt = ctx->key;
+	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
 
 	/* ablkcipher encrypt, decrypt, givencrypt shared descriptors */
@@ -356,10 +354,8 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		return -EINVAL;
 	}
 
-	memcpy(ctx->key, key, keylen);
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.keylen = keylen;
-	ctx->cdata.key_virt = ctx->key;
+	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
 
 	/* xts ablkcipher encrypt, decrypt shared descriptors */
-- 
2.12.0.264.gd6db3f216544
