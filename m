From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 1/4] crypto: skcipher - Consolidate encrypt/decrypt sanity check
Date: Thu,  6 Sep 2018 15:58:51 -0700
Message-ID: <20180906225854.40989-2-keescook@chromium.org>
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

In preparation to adding additional sanity checks before running an
skcipher request, this consolidates the open-coded checks into a single
function. Instead of passing both req and tfm into the new check this
just returns the tfm on success and an ERR_PTR on failure, keeping things
as clean as possible.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/skcipher.h | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f090c3e..6e954d398e0f 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -422,6 +422,27 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
 	return __crypto_skcipher_cast(req->base.tfm);
 }
 
+/**
+ * crypto_skcipher_reqtfm_check() - obtain and check cipher handle from request
+ * @req: skcipher_request out of which the cipher handle is to be obtained
+ *
+ * Return the crypto_skcipher handle when furnishing an skcipher_request
+ * data structure. Check for error conditions that would make it unusable
+ * for an encrypt/decrypt call.
+ *
+ * Return: crypto_skcipher handle, or ERR_PTR on error.
+ */
+static inline struct crypto_skcipher *crypto_skcipher_reqtfm_check(
+	struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return ERR_PTR(-ENOKEY);
+
+	return tfm;
+}
+
 /**
  * crypto_skcipher_encrypt() - encrypt plaintext
  * @req: reference to the skcipher_request handle that holds all information
@@ -435,10 +456,10 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
  */
 static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm_check(req);
 
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
 	return tfm->encrypt(req);
 }
@@ -456,10 +477,10 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
  */
 static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm_check(req);
 
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
 	return tfm->decrypt(req);
 }
-- 
2.17.1
