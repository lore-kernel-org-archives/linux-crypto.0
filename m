From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/6] crypto-caamhash: Rename jump labels in ahash_setkey()
Date: Thu, 15 Sep 2016 16:41:18 +0200
Message-ID: <18b28eb8-f683-9181-8de9-f6288533ff66@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 13:54:49 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f19df8f..6017470 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -533,7 +533,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		ret = hash_digest_key(ctx, key, &keylen, hashed_key,
 				      digestsize);
 		if (ret)
-			goto badkey;
+			goto bad_free_key;
 		key = hashed_key;
 	}
 
@@ -551,14 +551,14 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 
 	ret = gen_split_hash_key(ctx, key, keylen);
 	if (ret)
-		goto badkey;
+		goto bad_free_key;
 
 	ctx->key_dma = dma_map_single(jrdev, ctx->key, ctx->split_key_pad_len,
 				      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->key_dma)) {
 		dev_err(jrdev, "unable to map key i/o memory\n");
 		ret = -ENOMEM;
-		goto map_err;
+		goto error_free_key;
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
@@ -571,11 +571,10 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		dma_unmap_single(jrdev, ctx->key_dma, ctx->split_key_pad_len,
 				 DMA_TO_DEVICE);
 	}
-
-map_err:
+ error_free_key:
 	kfree(hashed_key);
 	return ret;
-badkey:
+ bad_free_key:
 	kfree(hashed_key);
 	crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
-- 
2.10.0

