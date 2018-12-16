Return-Path: <SRS0=HgT6=OZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730719AbeLPXzU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Dec 2018 18:55:20 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: remove remnants of internal IV generators
Date: Sun, 16 Dec 2018 15:55:06 -0800
Message-Id: <20181216235506.8680-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Remove dead code related to internal IV generators, which are no longer
used since they've been replaced with the "seqiv" and "echainiv"
templates.  The removed code includes:

- The "givcipher" (GIVCIPHER) algorithm type.  No algorithms are
  registered with this type anymore, so it's unneeded.

- The "const char *geniv" member of aead_alg, ablkcipher_alg, and
  blkcipher_alg.  A few algorithms still set this, but it isn't used
  anymore except to show via /proc/crypto and CRYPTO_MSG_GETALG.
  Just hardcode "<default>" or "<none>" in those cases.

- The 'skcipher_givcrypt_request' structure, which is never used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/api.rst          |  9 ----
 Documentation/crypto/architecture.rst | 31 ++---------
 crypto/ablkcipher.c                   | 76 +--------------------------
 crypto/blkcipher.c                    |  6 +--
 crypto/cryptd.c                       |  4 +-
 crypto/ctr.c                          |  2 -
 crypto/skcipher.c                     |  6 +--
 drivers/crypto/bcm/cipher.c           |  1 -
 drivers/crypto/chelsio/chcr_algo.c    |  1 -
 drivers/crypto/ixp4xx_crypto.c        |  5 --
 drivers/crypto/nx/nx-aes-ctr.c        |  1 -
 drivers/crypto/omap-aes.c             |  1 -
 drivers/crypto/picoxcell_crypto.c     |  3 +-
 drivers/crypto/talitos.c              |  1 -
 include/crypto/aead.h                 |  3 --
 include/crypto/internal/skcipher.h    |  2 -
 include/crypto/skcipher.h             | 13 -----
 include/linux/crypto.h                | 34 ++----------
 18 files changed, 17 insertions(+), 182 deletions(-)

diff --git a/Documentation/crypto/api.rst b/Documentation/crypto/api.rst
index 2e519193ab4a4..b91b31736df8b 100644
--- a/Documentation/crypto/api.rst
+++ b/Documentation/crypto/api.rst
@@ -1,15 +1,6 @@
 Programming Interface
 =====================
 
-Please note that the kernel crypto API contains the AEAD givcrypt API
-(crypto_aead_giv\* and aead_givcrypt\* function calls in
-include/crypto/aead.h). This API is obsolete and will be removed in the
-future. To obtain the functionality of an AEAD cipher with internal IV
-generation, use the IV generator as a regular cipher. For example,
-rfc4106(gcm(aes)) is the AEAD cipher with external IV generation and
-seqniv(rfc4106(gcm(aes))) implies that the kernel crypto API generates
-the IV. Different IV generators are available.
-
 .. class:: toc-title
 
 	   Table of contents
diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index ca2d09b991f5d..ee8ff0762d7fa 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -157,10 +157,6 @@ applicable to a cipher, it is not displayed:
 
    -  rng for random number generator
 
-   -  givcipher for cipher with associated IV generator (see the geniv
-      entry below for the specification of the IV generator type used by
-      the cipher implementation)
-
    -  kpp for a Key-agreement Protocol Primitive (KPP) cipher such as
       an ECDH or DH implementation
 
@@ -174,16 +170,7 @@ applicable to a cipher, it is not displayed:
 
 -  digestsize: output size of the message digest
 
--  geniv: IV generation type:
-
-   -  eseqiv for encrypted sequence number based IV generation
-
-   -  seqiv for sequence number based IV generation
-
-   -  chainiv for chain iv generation
-
-   -  <builtin> is a marker that the cipher implements IV generation and
-      handling as it is specific to the given cipher
+-  geniv: IV generator (obsolete)
 
 Key Sizes
 ---------
@@ -218,10 +205,6 @@ the aforementioned cipher types:
 
 -  CRYPTO_ALG_TYPE_ABLKCIPHER Asynchronous multi-block cipher
 
--  CRYPTO_ALG_TYPE_GIVCIPHER Asynchronous multi-block cipher packed
-   together with an IV generator (see geniv field in the /proc/crypto
-   listing for the known IV generators)
-
 -  CRYPTO_ALG_TYPE_KPP Key-agreement Protocol Primitive (KPP) such as
    an ECDH or DH implementation
 
@@ -338,18 +321,14 @@ uses the API applicable to the cipher type specified for the block.
 
 The following call sequence is applicable when the IPSEC layer triggers
 an encryption operation with the esp_output function. During
-configuration, the administrator set up the use of rfc4106(gcm(aes)) as
-the cipher for ESP. The following call sequence is now depicted in the
-ASCII art above:
+configuration, the administrator set up the use of seqiv(rfc4106(gcm(aes)))
+as the cipher for ESP. The following call sequence is now depicted in
+the ASCII art above:
 
 1. esp_output() invokes crypto_aead_encrypt() to trigger an
    encryption operation of the AEAD cipher with IV generator.
 
-   In case of GCM, the SEQIV implementation is registered as GIVCIPHER
-   in crypto_rfc4106_alloc().
-
-   The SEQIV performs its operation to generate an IV where the core
-   function is seqiv_geniv().
+   The SEQIV generates the IV.
 
 2. Now, SEQIV uses the AEAD API function calls to invoke the associated
    AEAD cipher. In our case, during the instantiation of SEQIV, the
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index b5e9ce19d324e..b339587073c3e 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -368,8 +368,7 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&rblkcipher, 0, sizeof(rblkcipher));
 
 	strscpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
-		sizeof(rblkcipher.geniv));
+	strscpy(rblkcipher.geniv, "<default>", sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
@@ -399,7 +398,7 @@ static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
-	seq_printf(m, "geniv        : %s\n", ablkcipher->geniv ?: "<default>");
+	seq_printf(m, "geniv        : <default>\n");
 }
 
 const struct crypto_type crypto_ablkcipher_type = {
@@ -411,74 +410,3 @@ const struct crypto_type crypto_ablkcipher_type = {
 	.report = crypto_ablkcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
-
-static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
-				      u32 mask)
-{
-	struct ablkcipher_alg *alg = &tfm->__crt_alg->cra_ablkcipher;
-	struct ablkcipher_tfm *crt = &tfm->crt_ablkcipher;
-
-	if (alg->ivsize > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	crt->setkey = tfm->__crt_alg->cra_flags & CRYPTO_ALG_GENIV ?
-		      alg->setkey : setkey;
-	crt->encrypt = alg->encrypt;
-	crt->decrypt = alg->decrypt;
-	crt->base = __crypto_ablkcipher_cast(tfm);
-	crt->ivsize = alg->ivsize;
-
-	return 0;
-}
-
-#ifdef CONFIG_NET
-static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_blkcipher rblkcipher;
-
-	memset(&rblkcipher, 0, sizeof(rblkcipher));
-
-	strscpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
-		sizeof(rblkcipher.geniv));
-
-	rblkcipher.blocksize = alg->cra_blocksize;
-	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
-	rblkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
-	rblkcipher.ivsize = alg->cra_ablkcipher.ivsize;
-
-	return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
-		       sizeof(rblkcipher), &rblkcipher);
-}
-#else
-static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
-
-	seq_printf(m, "type         : givcipher\n");
-	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
-					     "yes" : "no");
-	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
-	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
-	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
-	seq_printf(m, "geniv        : %s\n", ablkcipher->geniv ?: "<built-in>");
-}
-
-const struct crypto_type crypto_givcipher_type = {
-	.ctxsize = crypto_ablkcipher_ctxsize,
-	.init = crypto_init_givcipher_ops,
-#ifdef CONFIG_PROC_FS
-	.show = crypto_givcipher_show,
-#endif
-	.report = crypto_givcipher_report,
-};
-EXPORT_SYMBOL_GPL(crypto_givcipher_type);
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 193237514e902..c5398bd54942c 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -510,8 +510,7 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	memset(&rblkcipher, 0, sizeof(rblkcipher));
 
 	strscpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
-		sizeof(rblkcipher.geniv));
+	strscpy(rblkcipher.geniv, "<default>", sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
@@ -537,8 +536,7 @@ static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", alg->cra_blkcipher.min_keysize);
 	seq_printf(m, "max keysize  : %u\n", alg->cra_blkcipher.max_keysize);
 	seq_printf(m, "ivsize       : %u\n", alg->cra_blkcipher.ivsize);
-	seq_printf(m, "geniv        : %s\n", alg->cra_blkcipher.geniv ?:
-					     "<default>");
+	seq_printf(m, "geniv        : <default>\n");
 }
 
 const struct crypto_type crypto_blkcipher_type = {
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 7118fb5efbaad..5640e5db7bdbf 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -422,8 +422,6 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
 	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
 
-	inst->alg.cra_ablkcipher.geniv = alg->cra_blkcipher.geniv;
-
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_blkcipher_ctx);
 
 	inst->alg.cra_init = cryptd_blkcipher_init_tfm;
@@ -1174,7 +1172,7 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 		return ERR_PTR(-EINVAL);
 	type = crypto_skcipher_type(type);
 	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	mask |= (CRYPTO_ALG_GENIV | CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
+	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 	tfm = crypto_alloc_base(cryptd_alg_name, type, mask);
 	if (IS_ERR(tfm))
 		return ERR_CAST(tfm);
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 435b75bd619e4..30f3946efc6da 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -233,8 +233,6 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.encrypt = crypto_ctr_crypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_ctr_crypt;
 
-	inst->alg.cra_blkcipher.geniv = "chainiv";
-
 out:
 	crypto_mod_put(alg);
 	return inst;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 41b4f7f27f454..2a969296bc248 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -579,8 +579,7 @@ static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
 	if (alg->cra_type == &crypto_blkcipher_type)
 		return sizeof(struct crypto_blkcipher *);
 
-	if (alg->cra_type == &crypto_ablkcipher_type ||
-	    alg->cra_type == &crypto_givcipher_type)
+	if (alg->cra_type == &crypto_ablkcipher_type)
 		return sizeof(struct crypto_ablkcipher *);
 
 	return crypto_alg_extsize(alg);
@@ -844,8 +843,7 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	if (tfm->__crt_alg->cra_type == &crypto_blkcipher_type)
 		return crypto_init_skcipher_ops_blkcipher(tfm);
 
-	if (tfm->__crt_alg->cra_type == &crypto_ablkcipher_type ||
-	    tfm->__crt_alg->cra_type == &crypto_givcipher_type)
+	if (tfm->__crt_alg->cra_type == &crypto_ablkcipher_type)
 		return crypto_init_skcipher_ops_ablkcipher(tfm);
 
 	skcipher->setkey = skcipher_setkey;
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 2ce3a16d3d10f..c9393ffb70ed8 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -3868,7 +3868,6 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_driver_name = "ctr-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ablkcipher = {
-					   /* .geniv = "chainiv", */
 					   .min_keysize = AES_MIN_KEY_SIZE,
 					   .max_keysize = AES_MAX_KEY_SIZE,
 					   .ivsize = AES_BLOCK_SIZE,
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 497c57803de71..df43abfea256f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3722,7 +3722,6 @@ static struct chcr_alg_template driver_algs[] = {
 				.setkey		= chcr_aes_rfc3686_setkey,
 				.encrypt	= chcr_aes_encrypt,
 				.decrypt	= chcr_aes_decrypt,
-				.geniv          = "seqiv",
 			}
 		}
 	},
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 27f7dad2d45d9..19fba998b86b4 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1194,7 +1194,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
 			.ivsize		= DES_BLOCK_SIZE,
-			.geniv		= "eseqiv",
 			}
 		}
 	},
@@ -1221,7 +1220,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
 			.ivsize		= DES3_EDE_BLOCK_SIZE,
-			.geniv		= "eseqiv",
 			}
 		}
 	},
@@ -1247,7 +1245,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
 			.ivsize		= AES_BLOCK_SIZE,
-			.geniv		= "eseqiv",
 			}
 		}
 	},
@@ -1273,7 +1270,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
 			.ivsize		= AES_BLOCK_SIZE,
-			.geniv		= "eseqiv",
 			}
 		}
 	},
@@ -1287,7 +1283,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
 			.ivsize		= AES_BLOCK_SIZE,
-			.geniv		= "eseqiv",
 			.setkey		= ablk_rfc3686_setkey,
 			.encrypt	= ablk_rfc3686_crypt,
 			.decrypt	= ablk_rfc3686_crypt }
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 898c0a280511d..5a26fcd75d2df 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -159,7 +159,6 @@ struct crypto_alg nx_ctr3686_aes_alg = {
 		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
 		.ivsize      = CTR_RFC3686_IV_SIZE,
-		.geniv       = "seqiv",
 		.setkey      = ctr3686_aes_nx_set_key,
 		.encrypt     = ctr3686_aes_nx_crypt,
 		.decrypt     = ctr3686_aes_nx_crypt,
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4c0ea81429232..0120feb2d7462 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -749,7 +749,6 @@ static struct crypto_alg algs_ctr[] = {
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.geniv		= "eseqiv",
 		.ivsize		= AES_BLOCK_SIZE,
 		.setkey		= omap_aes_setkey,
 		.encrypt	= omap_aes_ctr_encrypt,
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a28f1d18fe01f..17068b55fea53 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1585,8 +1585,7 @@ static struct spacc_alg l2_engine_algs[] = {
 			.cra_name = "f8(kasumi)",
 			.cra_driver_name = "f8-kasumi-picoxcell",
 			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER |
-					CRYPTO_ALG_ASYNC |
+			.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 8,
 			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6988012deca4c..45e20707cef8d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3155,7 +3155,6 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg->cra_ablkcipher.setkey = ablkcipher_setkey;
 		alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
 		alg->cra_ablkcipher.decrypt = ablkcipher_decrypt;
-		alg->cra_ablkcipher.geniv = "eseqiv";
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index b7b8d24cf765f..9ad595f97c65a 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -115,7 +115,6 @@ struct aead_request {
  * @setkey: see struct skcipher_alg
  * @encrypt: see struct skcipher_alg
  * @decrypt: see struct skcipher_alg
- * @geniv: see struct skcipher_alg
  * @ivsize: see struct skcipher_alg
  * @chunksize: see struct skcipher_alg
  * @init: Initialize the cryptographic transformation object. This function
@@ -142,8 +141,6 @@ struct aead_alg {
 	int (*init)(struct crypto_aead *tfm);
 	void (*exit)(struct crypto_aead *tfm);
 
-	const char *geniv;
-
 	unsigned int ivsize;
 	unsigned int maxauthsize;
 	unsigned int chunksize;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index e42f7063f245b..453e867b4bd92 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -70,8 +70,6 @@ struct skcipher_walk {
 	unsigned int alignmask;
 };
 
-extern const struct crypto_type crypto_givcipher_type;
-
 static inline struct crypto_instance *skcipher_crypto_instance(
 	struct skcipher_instance *inst)
 {
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 480f8301a47db..e555294ed77fe 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -39,19 +39,6 @@ struct skcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-/**
- *	struct skcipher_givcrypt_request - Crypto request with IV generation
- *	@seq: Sequence number for IV generation
- *	@giv: Space for generated IV
- *	@creq: The crypto request itself
- */
-struct skcipher_givcrypt_request {
-	u64 seq;
-	u8 *giv;
-
-	struct ablkcipher_request creq;
-};
-
 struct crypto_skcipher {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9850b41e38ae6..c2f5baed522cc 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -49,7 +49,6 @@
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_SKCIPHER	0x00000005
-#define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_KPP		0x00000008
 #define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000a
 #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b
@@ -76,12 +75,6 @@
  */
 #define CRYPTO_ALG_NEED_FALLBACK	0x00000100
 
-/*
- * This bit is set for symmetric key ciphers that have already been wrapped
- * with a generic IV generator to prevent them from being wrapped again.
- */
-#define CRYPTO_ALG_GENIV		0x00000200
-
 /*
  * Set if the algorithm has passed automated run-time testing.  Note that
  * if there is no run-time testing for a given algorithm it is considered
@@ -157,7 +150,6 @@ struct crypto_async_request;
 struct crypto_blkcipher;
 struct crypto_tfm;
 struct crypto_type;
-struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
 
@@ -246,31 +238,16 @@ struct cipher_desc {
  *	     be called in parallel with the same transformation object.
  * @decrypt: Decrypt a single block. This is a reverse counterpart to @encrypt
  *	     and the conditions are exactly the same.
- * @givencrypt: Update the IV for encryption. With this function, a cipher
- *	        implementation may provide the function on how to update the IV
- *	        for encryption.
- * @givdecrypt: Update the IV for decryption. This is the reverse of
- *	        @givencrypt .
- * @geniv: The transformation implementation may use an "IV generator" provided
- *	   by the kernel crypto API. Several use cases have a predefined
- *	   approach how IVs are to be updated. For such use cases, the kernel
- *	   crypto API provides ready-to-use implementations that can be
- *	   referenced with this variable.
  * @ivsize: IV size applicable for transformation. The consumer must provide an
  *	    IV of exactly that size to perform the encrypt or decrypt operation.
  *
- * All fields except @givencrypt , @givdecrypt , @geniv and @ivsize are
- * mandatory and must be filled.
+ * All fields except @ivsize are mandatory and must be filled.
  */
 struct ablkcipher_alg {
 	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
-	int (*givencrypt)(struct skcipher_givcrypt_request *req);
-	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
-
-	const char *geniv;
 
 	unsigned int min_keysize;
 	unsigned int max_keysize;
@@ -284,10 +261,9 @@ struct ablkcipher_alg {
  * @setkey: see struct ablkcipher_alg
  * @encrypt: see struct ablkcipher_alg
  * @decrypt: see struct ablkcipher_alg
- * @geniv: see struct ablkcipher_alg
  * @ivsize: see struct ablkcipher_alg
  *
- * All fields except @geniv and @ivsize are mandatory and must be filled.
+ * All fields except @ivsize are mandatory and must be filled.
  */
 struct blkcipher_alg {
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
@@ -299,8 +275,6 @@ struct blkcipher_alg {
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes);
 
-	const char *geniv;
-
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
@@ -924,14 +898,14 @@ static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
 
 static inline u32 crypto_skcipher_type(u32 type)
 {
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	return type;
 }
 
 static inline u32 crypto_skcipher_mask(u32 mask)
 {
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 	return mask;
 }
-- 
2.19.2
