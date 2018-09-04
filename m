From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] crypto: skcipher: Allow crypto_skcipher_set_reqsize() to fail
Date: Tue,  4 Sep 2018 11:16:28 -0700
Message-ID: <20180904181629.20712-2-keescook@chromium.org>
References: <20180904181629.20712-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
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
In-Reply-To: <20180904181629.20712-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], we must
put an upper limit on how large an skcipher's reqsize can grow. In order
to cleanly handle this limit, crypto_skcipher_set_reqsize() must report
whether the desired reqsize is allowed. This means all callers need to
check the new return value and handle any cleanup now. This patch adds
the return value and updates all the callers to check the result and
act appropriately. A followup patch will add the new bounds checking to
crypto_skcipher_set_reqsize().

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/cryptd.c                                |  7 +++++--
 crypto/ctr.c                                   |  7 +++++--
 crypto/cts.c                                   |  7 +++++--
 crypto/lrw.c                                   |  9 ++++++---
 crypto/simd.c                                  |  7 +++++--
 crypto/xts.c                                   | 11 ++++++++---
 drivers/crypto/amcc/crypto4xx_core.c           |  8 +++++++-
 drivers/crypto/cavium/nitrox/nitrox_algs.c     |  9 +++++++--
 drivers/crypto/ccree/cc_cipher.c               |  6 ++++--
 drivers/crypto/hisilicon/sec/sec_algs.c        |  5 ++++-
 drivers/crypto/inside-secure/safexcel_cipher.c |  5 ++++-
 drivers/crypto/marvell/cipher.c                |  4 +---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c      |  4 +---
 include/crypto/internal/skcipher.h             |  4 +++-
 14 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index addca7bae33f..e0131907a537 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -563,15 +563,18 @@ static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	struct crypto_skcipher_spawn *spawn = &ictx->spawn;
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *cipher;
+	int ret;
 
 	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
-	crypto_skcipher_set_reqsize(
+	ret = crypto_skcipher_set_reqsize(
 		tfm, sizeof(struct cryptd_skcipher_request_ctx));
-	return 0;
+	if (ret)
+		crypto_free_skcipher(ctx->child);
+	return ret;
 }
 
 static void cryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 435b75bd619e..70b8496ee569 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -319,6 +319,7 @@ static int crypto_rfc3686_init_tfm(struct crypto_skcipher *tfm)
 	struct crypto_skcipher *cipher;
 	unsigned long align;
 	unsigned int reqsize;
+	int ret;
 
 	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
@@ -330,9 +331,11 @@ static int crypto_rfc3686_init_tfm(struct crypto_skcipher *tfm)
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	reqsize = align + sizeof(struct crypto_rfc3686_req_ctx) +
 		  crypto_skcipher_reqsize(cipher);
-	crypto_skcipher_set_reqsize(tfm, reqsize);
+	ret = crypto_skcipher_set_reqsize(tfm, reqsize);
+	if (ret)
+		crypto_free_skcipher(ctx->child);
 
-	return 0;
+	return ret;
 }
 
 static void crypto_rfc3686_exit_tfm(struct crypto_skcipher *tfm)
diff --git a/crypto/cts.c b/crypto/cts.c
index 4e28d83ae37d..f04c29f4197f 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -289,6 +289,7 @@ static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
 	unsigned reqsize;
 	unsigned bsize;
 	unsigned align;
+	int ret;
 
 	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
@@ -303,9 +304,11 @@ static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
 			crypto_tfm_ctx_alignment()) +
 		  (align & ~(crypto_tfm_ctx_alignment() - 1)) + bsize;
 
-	crypto_skcipher_set_reqsize(tfm, reqsize);
+	ret = crypto_skcipher_set_reqsize(tfm, reqsize);
+	if (ret)
+		crypto_free_skcipher(ctx->child);
 
-	return 0;
+	return ret;
 }
 
 static void crypto_cts_exit_tfm(struct crypto_skcipher *tfm)
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 393a782679c7..dc344046b637 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -426,6 +426,7 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
 	struct priv *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *cipher;
+	int ret;
 
 	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
@@ -433,10 +434,12 @@ static int init_tfm(struct crypto_skcipher *tfm)
 
 	ctx->child = cipher;
 
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(cipher) +
-					 sizeof(struct rctx));
+	ret = crypto_skcipher_set_reqsize(tfm,
+			crypto_skcipher_reqsize(cipher) + sizeof(struct rctx));
+	if (ret)
+		crypto_free_skcipher(ctx->child);
 
-	return 0;
+	return ret;
 }
 
 static void exit_tfm(struct crypto_skcipher *tfm)
diff --git a/crypto/simd.c b/crypto/simd.c
index ea7240be3001..bf1a27057e92 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -112,6 +112,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 	struct simd_skcipher_alg *salg;
 	struct skcipher_alg *alg;
 	unsigned reqsize;
+	int ret;
 
 	alg = crypto_skcipher_alg(tfm);
 	salg = container_of(alg, struct simd_skcipher_alg, alg);
@@ -127,9 +128,11 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 	reqsize = sizeof(struct skcipher_request);
 	reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
 
-	crypto_skcipher_set_reqsize(tfm, reqsize);
+	ret = crypto_skcipher_set_reqsize(tfm, reqsize);
+	if (ret)
+		cryptd_free_skcipher(ctx->cryptd_tfm);
 
-	return 0;
+	return ret;
 }
 
 struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
diff --git a/crypto/xts.c b/crypto/xts.c
index ccf55fbb8bc2..d7a85abb9723 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -364,6 +364,7 @@ static int init_tfm(struct crypto_skcipher *tfm)
 	struct priv *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
+	int ret;
 
 	child = crypto_spawn_skcipher(&ictx->spawn);
 	if (IS_ERR(child))
@@ -379,10 +380,14 @@ static int init_tfm(struct crypto_skcipher *tfm)
 
 	ctx->tweak = tweak;
 
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
-					 sizeof(struct rctx));
+	ret = crypto_skcipher_set_reqsize(tfm,
+			crypto_skcipher_reqsize(child) + sizeof(struct rctx));
+	if (ret) {
+		crypto_free_cipher(ctx->tweak);
+		crypto_free_skcipher(ctx->child);
+	}
 
-	return 0;
+	return ret;
 }
 
 static void exit_tfm(struct crypto_skcipher *tfm)
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 6eaec9ba0f68..de41bc35629c 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -951,6 +951,8 @@ static int crypto4xx_sk_init(struct crypto_skcipher *sk)
 	struct crypto4xx_ctx *ctx =  crypto_skcipher_ctx(sk);
 
 	if (alg->base.cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
+		int ret;
+
 		ctx->sw_cipher.cipher =
 			crypto_alloc_skcipher(alg->base.cra_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK |
@@ -958,9 +960,13 @@ static int crypto4xx_sk_init(struct crypto_skcipher *sk)
 		if (IS_ERR(ctx->sw_cipher.cipher))
 			return PTR_ERR(ctx->sw_cipher.cipher);
 
-		crypto_skcipher_set_reqsize(sk,
+		ret = crypto_skcipher_set_reqsize(sk,
 			sizeof(struct skcipher_request) + 32 +
 			crypto_skcipher_reqsize(ctx->sw_cipher.cipher));
+		if (ret) {
+			crypto_free_skcipher(ctx->sw_cipher.cipher);
+			return ret;
+		}
 	}
 
 	amcc_alg = container_of(alg, struct crypto4xx_alg, alg.u.cipher);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_algs.c b/drivers/crypto/cavium/nitrox/nitrox_algs.c
index 2ae6124e5da6..f0e688d37da6 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_algs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_algs.c
@@ -74,6 +74,7 @@ static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(tfm);
 	void *fctx;
+	int ret;
 
 	/* get the first device */
 	nctx->ndev = nitrox_get_first_device();
@@ -87,9 +88,13 @@ static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 		return -ENOMEM;
 	}
 	nctx->u.ctx_handle = (uintptr_t)fctx;
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
+	ret = crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
 				    sizeof(struct nitrox_kcrypt_request));
-	return 0;
+	if (ret) {
+		crypto_free_context(fctx);
+		nitrox_put_device(nctx->ndev);
+	}
+	return ret;
 }
 
 static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 7623b29911af..ec8e9506f4c5 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -136,13 +136,15 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 				     skcipher_alg.base);
 	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
-	int rc = 0;
+	int rc;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
 
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+	rc = crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct cipher_req_ctx));
+	if (rc)
+		return rc;
 
 	ctx_p->cipher_mode = cc_alg->cipher_mode;
 	ctx_p->flow_mode = cc_alg->flow_mode;
diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index f7d6d690116e..b10ff7202718 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -880,10 +880,13 @@ static int sec_alg_skcipher_decrypt(struct skcipher_request *req)
 static int sec_alg_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	mutex_init(&ctx->lock);
 	INIT_LIST_HEAD(&ctx->backlog);
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_request));
+	ret = crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_request));
+	if (ret)
+		return ret;
 
 	ctx->queue = sec_queue_alloc_start_safe();
 	if (IS_ERR(ctx->queue))
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 3aef1d43e435..b64a245a00fb 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -782,9 +782,12 @@ static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
 	struct safexcel_alg_template *tmpl =
 		container_of(tfm->__crt_alg, struct safexcel_alg_template,
 			     alg.skcipher.base);
+	int ret;
 
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+	ret = crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct safexcel_cipher_req));
+	if (ret)
+		return ret;
 
 	ctx->priv = tmpl->priv;
 
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 0ae84ec9e21c..41a2e047beb6 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -241,10 +241,8 @@ static int mv_cesa_skcipher_cra_init(struct crypto_tfm *tfm)
 
 	ctx->ops = &mv_cesa_skcipher_req_ops;
 
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+	return crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct mv_cesa_skcipher_req));
-
-	return 0;
 }
 
 static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 5cf64746731a..d01fb1054b77 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -465,10 +465,8 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 			    alg.crypto.base);
 	op->ss = algt->ss;
 
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+	return crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct sun4i_cipher_req_ctx));
-
-	return 0;
 }
 
 /* check and set the AES key, prepare the mode to be used */
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index e42f7063f245..d2926ecae2ac 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -127,10 +127,12 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-static inline void crypto_skcipher_set_reqsize(
+static inline int crypto_skcipher_set_reqsize(
 	struct crypto_skcipher *skcipher, unsigned int reqsize)
 {
 	skcipher->reqsize = reqsize;
+
+	return 0;
 }
 
 int crypto_register_skcipher(struct skcipher_alg *alg);
-- 
2.17.1
