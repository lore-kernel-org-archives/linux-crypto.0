From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] crypto: chcr - Fix error handling related to 'chcr_alloc_shash'
Date: Thu, 13 Apr 2017 20:25:15 +0200
Message-ID: <20170413182515.29107-1-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        harsh@chelsio.com, hariprasad@chelsio.com
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Up to now, 'crypto_alloc_shash()' may return a valid pointer, an error
pointer or NULL (in case of invalid parameter)
Update it to always return an error pointer in case of error. It now
returns ERR_PTR(-EINVAL) instead of NULL in case of invalid parameter.

This simplifies error handling.

Also fix a crash in 'chcr_authenc_setkey()' if 'chcr_alloc_shash()'
returns an error pointer and the "goto out" path is taken.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: Modify 'chcr_alloc_shash' to return ERR_PTR(-EINVAL) instead of NULL
    in case of invalid parameter.
---
 drivers/crypto/chelsio/chcr_algo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 41bc7f4f58cd..1fb1ac9d70b1 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -294,7 +294,7 @@ static inline void get_aes_decrypt_key(unsigned char *dec_key,
 
 static struct crypto_shash *chcr_alloc_shash(unsigned int ds)
 {
-	struct crypto_shash *base_hash = NULL;
+	struct crypto_shash *base_hash = ERR_PTR(-EINVAL);
 
 	switch (ds) {
 	case SHA1_DIGEST_SIZE:
@@ -2259,7 +2259,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	int err = 0, i, key_ctx_len = 0;
 	unsigned char ck_size = 0;
 	unsigned char pad[CHCR_HASH_MAX_BLOCK_SIZE_128] = { 0 };
-	struct crypto_shash *base_hash = NULL;
+	struct crypto_shash *base_hash = ERR_PTR(-EINVAL);
 	struct algo_param param;
 	int align;
 	u8 *o_ptr = NULL;
@@ -2351,7 +2351,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	}
 out:
 	aeadctx->enckey_len = 0;
-	if (base_hash)
+	if (!IS_ERR(base_hash))
 		chcr_free_shash(base_hash);
 	return -EINVAL;
 }
-- 
2.11.0

