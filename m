Return-Path: <SRS0=/v7T=NZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725756AbeKOFlw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Nov 2018 00:41:52 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: remove useless initializations of cra_list
Date: Wed, 14 Nov 2018 11:35:48 -0800
Message-Id: <20181114193548.54811-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Some algorithms initialize their .cra_list prior to registration.
But this is unnecessary since crypto_register_alg() will overwrite
.cra_list when adding the algorithm to the 'crypto_alg_list'.
Apparently the useless assignment has just been copy+pasted around.

So, remove the useless assignments.

Exception: paes_s390.c uses cra_list to check whether the algorithm is
registered or not, so I left that as-is for now.

This patch shouldn't change any actual behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/sparc/crypto/aes_glue.c      | 5 -----
 arch/sparc/crypto/camellia_glue.c | 5 -----
 arch/sparc/crypto/des_glue.c      | 5 -----
 crypto/lz4.c                      | 1 -
 crypto/lz4hc.c                    | 1 -
 drivers/crypto/bcm/cipher.c       | 2 --
 drivers/crypto/omap-aes.c         | 2 --
 drivers/crypto/omap-des.c         | 1 -
 drivers/crypto/qce/ablkcipher.c   | 1 -
 drivers/crypto/qce/sha.c          | 1 -
 drivers/crypto/sahara.c           | 1 -
 11 files changed, 25 deletions(-)

diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 3cd4f6b198b65..a9b8b0b94a8d4 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -476,11 +476,6 @@ static bool __init sparc64_has_aes_opcode(void)
 
 static int __init aes_sparc64_mod_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(algs); i++)
-		INIT_LIST_HEAD(&algs[i].cra_list);
-
 	if (sparc64_has_aes_opcode()) {
 		pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
 		return crypto_register_algs(algs, ARRAY_SIZE(algs));
diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index 561a84d93cf68..900d5c617e83b 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -299,11 +299,6 @@ static bool __init sparc64_has_camellia_opcode(void)
 
 static int __init camellia_sparc64_mod_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(algs); i++)
-		INIT_LIST_HEAD(&algs[i].cra_list);
-
 	if (sparc64_has_camellia_opcode()) {
 		pr_info("Using sparc64 camellia opcodes optimized CAMELLIA implementation\n");
 		return crypto_register_algs(algs, ARRAY_SIZE(algs));
diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 61af794aa2d31..56499ea39fd36 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -510,11 +510,6 @@ static bool __init sparc64_has_des_opcode(void)
 
 static int __init des_sparc64_mod_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(algs); i++)
-		INIT_LIST_HEAD(&algs[i].cra_list);
-
 	if (sparc64_has_des_opcode()) {
 		pr_info("Using sparc64 des opcodes optimized DES implementation\n");
 		return crypto_register_algs(algs, ARRAY_SIZE(algs));
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 2ce2660d3519e..c160dfdbf2e07 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -122,7 +122,6 @@ static struct crypto_alg alg_lz4 = {
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lz4_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(alg_lz4.cra_list),
 	.cra_init		= lz4_init,
 	.cra_exit		= lz4_exit,
 	.cra_u			= { .compress = {
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 2be14f054dafd..583b5e013d7a5 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -123,7 +123,6 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lz4hc_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(alg_lz4hc.cra_list),
 	.cra_init		= lz4hc_init,
 	.cra_exit		= lz4hc_exit,
 	.cra_u			= { .compress = {
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 2d1f1db9f8074..8808eacc65801 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4605,7 +4605,6 @@ static int spu_register_ablkcipher(struct iproc_alg_s *driver_alg)
 	crypto->cra_priority = cipher_pri;
 	crypto->cra_alignmask = 0;
 	crypto->cra_ctxsize = sizeof(struct iproc_ctx_s);
-	INIT_LIST_HEAD(&crypto->cra_list);
 
 	crypto->cra_init = ablkcipher_cra_init;
 	crypto->cra_exit = generic_cra_exit;
@@ -4687,7 +4686,6 @@ static int spu_register_aead(struct iproc_alg_s *driver_alg)
 	aead->base.cra_priority = aead_pri;
 	aead->base.cra_alignmask = 0;
 	aead->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
-	INIT_LIST_HEAD(&aead->base.cra_list);
 
 	aead->base.cra_flags |= CRYPTO_ALG_ASYNC;
 	/* setkey set in alg initialization */
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index a553ffddb11be..4c0ea81429232 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1222,7 +1222,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 				algp = &dd->pdata->algs_info[i].algs_list[j];
 
 				pr_debug("reg alg: %s\n", algp->cra_name);
-				INIT_LIST_HEAD(&algp->cra_list);
 
 				err = crypto_register_alg(algp);
 				if (err)
@@ -1240,7 +1239,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 			algp = &aalg->base;
 
 			pr_debug("reg alg: %s\n", algp->cra_name);
-			INIT_LIST_HEAD(&algp->cra_list);
 
 			err = crypto_register_aead(aalg);
 			if (err)
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index eb95b0d7f1846..6369019219d44 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1069,7 +1069,6 @@ static int omap_des_probe(struct platform_device *pdev)
 			algp = &dd->pdata->algs_info[i].algs_list[j];
 
 			pr_debug("reg alg: %s\n", algp->cra_name);
-			INIT_LIST_HEAD(&algp->cra_list);
 
 			err = crypto_register_alg(algp);
 			if (err)
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 585e1cab9ae34..25c13e26d0128 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -376,7 +376,6 @@ static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = qce_ablkcipher_init;
 	alg->cra_exit = qce_ablkcipher_exit;
-	INIT_LIST_HEAD(&alg->cra_list);
 
 	INIT_LIST_HEAD(&tmpl->entry);
 	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_ABLKCIPHER;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index d8a5db11b7ea1..fc45f5ea6fdd2 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -508,7 +508,6 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
 	base->cra_init = qce_ahash_cra_init;
-	INIT_LIST_HEAD(&base->cra_list);
 
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index bbf166a97ad3a..8c32a3059b4a8 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1321,7 +1321,6 @@ static int sahara_register_algs(struct sahara_dev *dev)
 	unsigned int i, j, k, l;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
-		INIT_LIST_HEAD(&aes_algs[i].cra_list);
 		err = crypto_register_alg(&aes_algs[i]);
 		if (err)
 			goto err_aes_algs;
-- 
2.19.1.930.g4563a0d9d0-goog
