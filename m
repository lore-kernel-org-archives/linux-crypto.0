Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE83D7E
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 19:50:24 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r9H1H-00611o-Qr; Sat, 02 Dec 2023 11:50:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Dec 2023 11:50:29 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Sat, 02 Dec 2023 11:50:29 +0800
Subject: [v3 PATCH 2/4] crypto: skcipher - Make use of internal state
References: <ZWqpPTHXuMvRmWi+@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Message-Id: <E1r9H1H-00611o-Qr@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch adds code to the skcipher/lskcipher API to make use
of the internal state if present.  In particular, the skcipher
lskcipher wrapper will allocate a buffer for the IV/state and
feed that to the underlying lskcipher algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/lskcipher.c        |   34 ++++++++++++++++---
 crypto/skcipher.c         |   80 ++++++++++++++++++++++++++++++++++++++++++++--
 include/crypto/skcipher.h |   33 ++++++++++++++++++
 3 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 51bcf85070c7..e6b87787bd64 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -90,6 +90,7 @@ static int crypto_lskcipher_crypt_unaligned(
 	u8 *iv, int (*crypt)(struct crypto_lskcipher *tfm, const u8 *src,
 			     u8 *dst, unsigned len, u8 *iv, u32 flags))
 {
+	unsigned statesize = crypto_lskcipher_statesize(tfm);
 	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
 	unsigned bs = crypto_lskcipher_blocksize(tfm);
 	unsigned cs = crypto_lskcipher_chunksize(tfm);
@@ -104,7 +105,7 @@ static int crypto_lskcipher_crypt_unaligned(
 	if (!tiv)
 		return -ENOMEM;
 
-	memcpy(tiv, iv, ivsize);
+	memcpy(tiv, iv, ivsize + statesize);
 
 	p = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 	err = -ENOMEM;
@@ -132,7 +133,7 @@ static int crypto_lskcipher_crypt_unaligned(
 	err = len ? -EINVAL : 0;
 
 out:
-	memcpy(iv, tiv, ivsize);
+	memcpy(iv, tiv, ivsize + statesize);
 	kfree_sensitive(p);
 	kfree_sensitive(tiv);
 	return err;
@@ -197,25 +198,45 @@ EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
 static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 				     int (*crypt)(struct crypto_lskcipher *tfm,
 						  const u8 *src, u8 *dst,
-						  unsigned len, u8 *iv,
+						  unsigned len, u8 *ivs,
 						  u32 flags))
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
+	u8 *ivs = skcipher_request_ctx(req);
 	struct crypto_lskcipher *tfm = *ctx;
 	struct skcipher_walk walk;
+	unsigned ivsize;
+	u32 flags;
 	int err;
 
+	ivsize = crypto_lskcipher_ivsize(tfm);
+	ivs = PTR_ALIGN(ivs, crypto_skcipher_alignmask(skcipher) + 1);
+
+	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	if (req->base.flags & CRYPTO_SKCIPHER_REQ_CONT)
+		flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
+	else
+		memcpy(ivs, req->iv, ivsize);
+
+	if (!(req->base.flags & CRYPTO_SKCIPHER_REQ_NOTFINAL))
+		flags |= CRYPTO_LSKCIPHER_FLAG_FINAL;
+
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes) {
 		err = crypt(tfm, walk.src.virt.addr, walk.dst.virt.addr,
-			    walk.nbytes, walk.iv,
-			    walk.nbytes == walk.total ?
-			    CRYPTO_LSKCIPHER_FLAG_FINAL : 0);
+			    walk.nbytes, ivs,
+			    flags & ~(walk.nbytes == walk.total ?
+				      0 : CRYPTO_LSKCIPHER_FLAG_FINAL));
 		err = skcipher_walk_done(&walk, err);
+		flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
 	}
 
+	if (flags & CRYPTO_LSKCIPHER_FLAG_FINAL)
+		memcpy(req->iv, ivs, ivsize);
+
 	return err;
 }
 
@@ -278,6 +299,7 @@ static void __maybe_unused crypto_lskcipher_show(
 	seq_printf(m, "max keysize  : %u\n", skcipher->co.max_keysize);
 	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
 	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
+	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
 }
 
 static int __maybe_unused crypto_lskcipher_report(
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ac8b8c042654..bc70e159d27d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -698,6 +698,64 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
 
+static int crypto_lskcipher_export(struct skcipher_request *req, void *out)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	u8 *ivs = skcipher_request_ctx(req);
+
+	ivs = PTR_ALIGN(ivs, crypto_skcipher_alignmask(tfm) + 1);
+
+	memcpy(out, ivs + crypto_skcipher_ivsize(tfm),
+	       crypto_skcipher_statesize(tfm));
+
+	return 0;
+}
+
+static int crypto_lskcipher_import(struct skcipher_request *req, const void *in)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	u8 *ivs = skcipher_request_ctx(req);
+
+	ivs = PTR_ALIGN(ivs, crypto_skcipher_alignmask(tfm) + 1);
+
+	memcpy(ivs + crypto_skcipher_ivsize(tfm), in,
+	       crypto_skcipher_statesize(tfm));
+
+	return 0;
+}
+
+static int skcipher_noexport(struct skcipher_request *req, void *out)
+{
+	return 0;
+}
+
+static int skcipher_noimport(struct skcipher_request *req, const void *in)
+{
+	return 0;
+}
+
+int crypto_skcipher_export(struct skcipher_request *req, void *out)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+
+	if (alg->co.base.cra_type != &crypto_skcipher_type)
+		return crypto_lskcipher_export(req, out);
+	return alg->export(req, out);
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_export);
+
+int crypto_skcipher_import(struct skcipher_request *req, const void *in)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+
+	if (alg->co.base.cra_type != &crypto_skcipher_type)
+		return crypto_lskcipher_import(req, in);
+	return alg->import(req, in);
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_import);
+
 static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
@@ -713,8 +771,17 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 
 	skcipher_set_needkey(skcipher);
 
-	if (tfm->__crt_alg->cra_type != &crypto_skcipher_type)
+	if (tfm->__crt_alg->cra_type != &crypto_skcipher_type) {
+		unsigned am = crypto_skcipher_alignmask(skcipher);
+		unsigned reqsize;
+
+		reqsize = am & ~(crypto_tfm_ctx_alignment() - 1);
+		reqsize += crypto_skcipher_ivsize(skcipher);
+		reqsize += crypto_skcipher_statesize(skcipher);
+		crypto_skcipher_set_reqsize(skcipher, reqsize);
+
 		return crypto_init_lskcipher_ops_sg(tfm);
+	}
 
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
@@ -756,6 +823,7 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "ivsize       : %u\n", skcipher->ivsize);
 	seq_printf(m, "chunksize    : %u\n", skcipher->chunksize);
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
+	seq_printf(m, "statesize    : %u\n", skcipher->statesize);
 }
 
 static int __maybe_unused crypto_skcipher_report(
@@ -870,7 +938,9 @@ int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
 	struct crypto_istat_cipher *istat = skcipher_get_stat_common(alg);
 	struct crypto_alg *base = &alg->base;
 
-	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8)
+	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
+	    alg->statesize > PAGE_SIZE / 2 ||
+	    (alg->ivsize + alg->statesize) > PAGE_SIZE / 2)
 		return -EINVAL;
 
 	if (!alg->chunksize)
@@ -899,6 +969,12 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 	if (!alg->walksize)
 		alg->walksize = alg->chunksize;
 
+	if (!alg->statesize) {
+		alg->import = skcipher_noimport;
+		alg->export = skcipher_noexport;
+	} else if (!(alg->import && alg->export))
+		return -EINVAL;
+
 	base->cra_type = &crypto_skcipher_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SKCIPHER;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 5302f8f33afc..f881740df194 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -746,6 +746,39 @@ int crypto_skcipher_encrypt(struct skcipher_request *req);
  */
 int crypto_skcipher_decrypt(struct skcipher_request *req);
 
+/**
+ * crypto_skcipher_export() - export partial state
+ * @req: reference to the skcipher_request handle that holds all information
+ *	 needed to perform the operation
+ * @out: output buffer of sufficient size that can hold the state
+ *
+ * Export partial state of the transformation. This function dumps the
+ * entire state of the ongoing transformation into a provided block of
+ * data so it can be @import 'ed back later on. This is useful in case
+ * you want to save partial result of the transformation after
+ * processing certain amount of data and reload this partial result
+ * multiple times later on for multiple re-use. No data processing
+ * happens at this point.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
+int crypto_skcipher_export(struct skcipher_request *req, void *out);
+
+/**
+ * crypto_skcipher_import() - import partial state
+ * @req: reference to the skcipher_request handle that holds all information
+ *	 needed to perform the operation
+ * @in: buffer holding the state
+ *
+ * Import partial state of the transformation. This function loads the
+ * entire state of the ongoing transformation from a provided block of
+ * data so the transformation can continue from this point onward. No
+ * data processing happens at this point.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
+int crypto_skcipher_import(struct skcipher_request *req, const void *in);
+
 /**
  * crypto_lskcipher_encrypt() - encrypt plaintext
  * @tfm: lskcipher handle
