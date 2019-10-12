Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36349C4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A0421929
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570855272;
	bh=1hlzgq2LYH5GVOkMkyG2e2fWkA8zR4XPX+VOzIVFiO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=19g6/ssdQ4em5y9naOU799EjwfVTMr1i4bCOBY/KDXIDdPsFQJ6hb2ZOVrvJtd73Y
	 nzAkiB97PiwggKSHefysDUQVQpYlrUD4x1dU9PiytrqGFPeU34xhQaka7eq/04JjXA
	 yFdJeSNh+FnkSW9llrtGSV3YNasjcDQZglJZ88Eo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJLElJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 00:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfJLElI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 00:41:08 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE4B2087E;
        Sat, 12 Oct 2019 04:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570855267;
        bh=1hlzgq2LYH5GVOkMkyG2e2fWkA8zR4XPX+VOzIVFiO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ova5JKAYOTvzewHMSa9w6eT7NacOL8lF8orC02QjoOEPSKdYol8mA9jNPb1QwndEi
         qkLzQcAqCsPMqLrVOmdaVDiccUWjs1pTdxqM85Zj1LTKvvFyiCCl7/GaLg4oC812NQ
         76jyMud757NS3L4zsg7BKw1yRwEPGMSk+h6yTTo8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     sparclinux@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFT PATCH 1/3] crypto: sparc/aes - convert to skcipher API
Date:   Fri, 11 Oct 2019 21:38:48 -0700
Message-Id: <20191012043850.340957-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191012043850.340957-1-ebiggers@kernel.org>
References: <20191012043850.340957-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the glue code for the SPARC64 AES opcodes implementations of
AES-ECB, AES-CBC, and AES-CTR from the deprecated "blkcipher" API to the
"skcipher" API.  This is needed in order for the blkcipher API to be
removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/sparc/crypto/aes_glue.c | 310 ++++++++++++++++-------------------
 crypto/Kconfig               |   3 +-
 2 files changed, 144 insertions(+), 169 deletions(-)

diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 7b946b3dee9d..0f5a501c95a9 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -197,6 +198,12 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
+static int aes_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
+				unsigned int key_len)
+{
+	return aes_set_key(crypto_skcipher_tfm(tfm), in_key, key_len);
+}
+
 static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -211,131 +218,108 @@ static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	ctx->ops->decrypt(&ctx->key[0], (const u32 *) src, (u32 *) dst);
 }
 
-#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
-
-static int ecb_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb_encrypt(struct skcipher_request *req)
 {
-	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & AES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			ctx->ops->ecb_encrypt(&ctx->key[0],
-					      (const u64 *)walk.src.virt.addr,
-					      (u64 *) walk.dst.virt.addr,
-					      block_len);
-		}
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		ctx->ops->ecb_encrypt(&ctx->key[0], walk.src.virt.addr,
+				      walk.dst.virt.addr,
+				      round_down(nbytes, AES_BLOCK_SIZE));
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static int ecb_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb_decrypt(struct skcipher_request *req)
 {
-	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	u64 *key_end;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const u64 *key_end;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & AES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			ctx->ops->ecb_decrypt(key_end,
-					      (const u64 *) walk.src.virt.addr,
-					      (u64 *) walk.dst.virt.addr, block_len);
-		}
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		ctx->ops->ecb_decrypt(key_end, walk.src.virt.addr,
+				      walk.dst.virt.addr,
+				      round_down(nbytes, AES_BLOCK_SIZE));
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 
 	return err;
 }
 
-static int cbc_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & AES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			ctx->ops->cbc_encrypt(&ctx->key[0],
-					      (const u64 *)walk.src.virt.addr,
-					      (u64 *) walk.dst.virt.addr,
-					      block_len, (u64 *) walk.iv);
-		}
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		ctx->ops->cbc_encrypt(&ctx->key[0], walk.src.virt.addr,
+				      walk.dst.virt.addr,
+				      round_down(nbytes, AES_BLOCK_SIZE),
+				      walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_decrypt(struct skcipher_request *req)
 {
-	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	u64 *key_end;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const u64 *key_end;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & AES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			ctx->ops->cbc_decrypt(key_end,
-					      (const u64 *) walk.src.virt.addr,
-					      (u64 *) walk.dst.virt.addr,
-					      block_len, (u64 *) walk.iv);
-		}
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		ctx->ops->cbc_decrypt(key_end, walk.src.virt.addr,
+				      walk.dst.virt.addr,
+				      round_down(nbytes, AES_BLOCK_SIZE),
+				      walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 
 	return err;
 }
 
-static void ctr_crypt_final(struct crypto_sparc64_aes_ctx *ctx,
-			    struct blkcipher_walk *walk)
+static void ctr_crypt_final(const struct crypto_sparc64_aes_ctx *ctx,
+			    struct skcipher_walk *walk)
 {
 	u8 *ctrblk = walk->iv;
 	u64 keystream[AES_BLOCK_SIZE / sizeof(u64)];
@@ -349,40 +333,35 @@ static void ctr_crypt_final(struct crypto_sparc64_aes_ctx *ctx,
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
-static int ctr_crypt(struct blkcipher_desc *desc,
-		     struct scatterlist *dst, struct scatterlist *src,
-		     unsigned int nbytes)
+static int ctr_crypt(struct skcipher_request *req)
 {
-	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		unsigned int block_len = nbytes & AES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			ctx->ops->ctr_crypt(&ctx->key[0],
-					    (const u64 *)walk.src.virt.addr,
-					    (u64 *) walk.dst.virt.addr,
-					    block_len, (u64 *) walk.iv);
-		}
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		ctx->ops->ctr_crypt(&ctx->key[0], walk.src.virt.addr,
+				    walk.dst.virt.addr,
+				    round_down(nbytes, AES_BLOCK_SIZE),
+				    walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 	if (walk.nbytes) {
 		ctr_crypt_final(ctx, &walk);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = skcipher_walk_done(&walk, 0);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static struct crypto_alg algs[] = { {
+static struct crypto_alg cipher_alg = {
 	.cra_name		= "aes",
 	.cra_driver_name	= "aes-sparc64",
 	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
@@ -400,66 +379,53 @@ static struct crypto_alg algs[] = { {
 			.cia_decrypt		= crypto_aes_decrypt
 		}
 	}
-}, {
-	.cra_name		= "ecb(aes)",
-	.cra_driver_name	= "ecb-aes-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "cbc(aes)",
-	.cra_driver_name	= "cbc-aes-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "ctr(aes)",
-	.cra_driver_name	= "ctr-aes-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ctr_crypt,
-			.decrypt	= ctr_crypt,
-		},
-	},
-} };
+};
+
+static struct skcipher_alg skcipher_algs[] = {
+	{
+		.base.cra_name		= "ecb(aes)",
+		.base.cra_driver_name	= "ecb-aes-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.setkey			= aes_set_key_skcipher,
+		.encrypt		= ecb_encrypt,
+		.decrypt		= ecb_decrypt,
+	}, {
+		.base.cra_name		= "cbc(aes)",
+		.base.cra_driver_name	= "cbc-aes-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= aes_set_key_skcipher,
+		.encrypt		= cbc_encrypt,
+		.decrypt		= cbc_decrypt,
+	}, {
+		.base.cra_name		= "ctr(aes)",
+		.base.cra_driver_name	= "ctr-aes-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= aes_set_key_skcipher,
+		.encrypt		= ctr_crypt,
+		.decrypt		= ctr_crypt,
+		.chunksize		= AES_BLOCK_SIZE,
+	}
+};
 
 static bool __init sparc64_has_aes_opcode(void)
 {
@@ -477,17 +443,27 @@ static bool __init sparc64_has_aes_opcode(void)
 
 static int __init aes_sparc64_mod_init(void)
 {
-	if (sparc64_has_aes_opcode()) {
-		pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
-		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	int err;
+
+	if (!sparc64_has_aes_opcode()) {
+		pr_info("sparc64 aes opcodes not available.\n");
+		return -ENODEV;
 	}
-	pr_info("sparc64 aes opcodes not available.\n");
-	return -ENODEV;
+	pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
+	err = crypto_register_alg(&cipher_alg);
+	if (err)
+		return err;
+	err = crypto_register_skciphers(skcipher_algs,
+					ARRAY_SIZE(skcipher_algs));
+	if (err)
+		crypto_unregister_alg(&cipher_alg);
+	return err;
 }
 
 static void __exit aes_sparc64_mod_fini(void)
 {
-	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+	crypto_unregister_alg(&cipher_alg);
+	crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 }
 
 module_init(aes_sparc64_mod_init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 03699657fb5d..7c54a5b9aa2b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1098,8 +1098,7 @@ config CRYPTO_AES_NI_INTEL
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
-	select CRYPTO_CRYPTD
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
 	  Use SPARC64 crypto opcodes for AES algorithm.
 
-- 
2.23.0

