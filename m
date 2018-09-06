From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 3/4] crypto: skcipher - Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu,  6 Sep 2018 15:58:53 -0700
Message-ID: <20180906225854.40989-4-keescook@chromium.org>
References: <20180906225854.40989-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906225854.40989-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this caps
the non-ASYNC skcipher request size similar to other limits and adds a
sanity check at usage. After a review of all non-ASYNC algorithm callers
of crypto_skcipher_set_reqsize(), the largest appears to be 384:

4       struct sun4i_cipher_req_ctx
96      struct crypto_rfc3686_req_ctx
375     cts:
                160     crypto_skcipher_blocksize(cipher) (max)
                152     struct crypto_cts_reqctx
                63      align_mask (max)
384     struct rctx (lrw, xts)

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/skcipher.h | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 3aabd5d098ed..cca216999bf1 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -144,9 +144,10 @@ struct skcipher_alg {
 /*
  * This must only ever be used with synchronous algorithms.
  */
+#define MAX_SYNC_SKCIPHER_REQSIZE	384
 #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
 	char __##name##_desc[sizeof(struct skcipher_request) + \
-		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR = { 1 }; \
+		MAX_SYNC_SKCIPHER_REQSIZE] CRYPTO_MINALIGN_ATTR = { 1 }; \
 	struct skcipher_request *name = (void *)__##name##_desc
 
 /**
@@ -412,6 +413,17 @@ static inline unsigned int crypto_skcipher_default_keysize(
 	return tfm->keysize;
 }
 
+/**
+ * crypto_skcipher_reqsize() - obtain size of the request data structure
+ * @tfm: cipher handle
+ *
+ * Return: number of bytes
+ */
+static inline unsigned int crypto_skcipher_reqsize(struct crypto_skcipher *tfm)
+{
+	return tfm->reqsize;
+}
+
 /**
  * crypto_skcipher_reqtfm() - obtain cipher handle from request
  * @req: skcipher_request out of which the cipher handle is to be obtained
@@ -446,6 +458,9 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm_check(
 		if (WARN_ON(crypto_skcipher_alg(tfm)->base.cra_flags &
 				CRYPTO_ALG_ASYNC))
 			return ERR_PTR(-EINVAL);
+		if (WARN_ON(crypto_skcipher_reqsize(tfm) >
+				MAX_SYNC_SKCIPHER_REQSIZE))
+			return ERR_PTR(-ENOSPC);
 	}
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
@@ -507,17 +522,6 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
  * skcipher handle to the crypto_skcipher_* API calls.
  */
 
-/**
- * crypto_skcipher_reqsize() - obtain size of the request data structure
- * @tfm: cipher handle
- *
- * Return: number of bytes
- */
-static inline unsigned int crypto_skcipher_reqsize(struct crypto_skcipher *tfm)
-{
-	return tfm->reqsize;
-}
-
 /**
  * skcipher_request_set_tfm() - update cipher handle reference in request
  * @req: request handle to be modified
-- 
2.17.1
