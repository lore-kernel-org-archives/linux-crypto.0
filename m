From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 08/12] crypto: caam - don't dma_map key for hash algorithms
Date: Fri, 10 Feb 2017 14:07:21 +0200
Message-ID: <1486728445-13047-9-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:25999
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753299AbdBJMH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:59 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Shared descriptors for hash algorithms are small enough
for (split) keys to be inlined in all cases.
Since driver already does this, all what's left is to remove
unused ctx->key_dma.

Fixes: 045e36780f115 ("crypto: caam - ahash hmac support")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e58639ea53b1..117bbd8c08d4 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -109,7 +109,6 @@ struct caam_hash_ctx {
 	dma_addr_t sh_desc_digest_dma;
 	struct device *jrdev;
 	u8 key[CAAM_MAX_HASH_KEY_SIZE];
-	dma_addr_t key_dma;
 	int ctx_len;
 	struct alginfo adata;
 };
@@ -420,7 +419,6 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *jrdev = ctx->jrdev;
 	int blocksize = crypto_tfm_alg_blocksize(&ahash->base);
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int ret;
@@ -448,28 +446,14 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 	if (ret)
 		goto bad_free_key;
 
-	ctx->key_dma = dma_map_single(jrdev, ctx->key, ctx->adata.keylen_pad,
-				      DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->key_dma)) {
-		dev_err(jrdev, "unable to map key i/o memory\n");
-		ret = -ENOMEM;
-		goto error_free_key;
-	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 		       ctx->adata.keylen_pad, 1);
 #endif
 
-	ret = ahash_set_sh_desc(ahash);
-	if (ret) {
-		dma_unmap_single(jrdev, ctx->key_dma, ctx->adata.keylen_pad,
-				 DMA_TO_DEVICE);
-	}
-
- error_free_key:
 	kfree(hashed_key);
-	return ret;
+	return ahash_set_sh_desc(ahash);
  bad_free_key:
 	kfree(hashed_key);
 	crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-- 
2.4.4
