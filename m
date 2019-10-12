Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2683C10F14
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9163D21929
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570855271;
	bh=GhD01m/xTvX/WPzVPy39fiCkVnGLlpaC1JdZXmvdsq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NYMRqBKTOjtB1ZVrzEnmLDnbbGsg8dnoaUbLtBOAr40bNeK77/0/UUnrARfz7CRgX
	 P5F8NUZpa+AP4W4gr19dP8VZ4uXuPOefOFl86pxI5qTXv970+5vn7HmHU1lcTvZy42
	 jAW017A8Ia8htIUEsrXRUXpLLiR5iuZ+fa94Hodg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfJLElJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 00:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfJLElI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 00:41:08 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2886221850;
        Sat, 12 Oct 2019 04:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570855267;
        bh=GhD01m/xTvX/WPzVPy39fiCkVnGLlpaC1JdZXmvdsq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc52hXNiQabeeNRn8W9FMVUbp6hM3SThlqvvY6Jm1TtpK10IeeJNMengEkibNmhHy
         k8YZvzQFe8tUmRAZHcvYAZ+gY4XCkPReeyT4yI3+HEvcMS8IZMIrpF1P7eJEUX0xQd
         YkU9Qsd41ymUTkjDlmegzekZ9YjSusMVUw8lpUzo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     sparclinux@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFT PATCH 2/3] crypto: sparc/camellia - convert to skcipher API
Date:   Fri, 11 Oct 2019 21:38:49 -0700
Message-Id: <20191012043850.340957-3-ebiggers@kernel.org>
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

Convert the glue code for the SPARC64 Camellia opcodes implementations
of Camellia-ECB and Camellia-CBC from the deprecated "blkcipher" API to
the "skcipher" API.  This is needed in order for the blkcipher API to be
removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/sparc/crypto/camellia_glue.c | 217 +++++++++++++-----------------
 crypto/Kconfig                    |   1 +
 2 files changed, 96 insertions(+), 122 deletions(-)

diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index 3823f9491a72..1700f863748c 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -52,6 +53,12 @@ static int camellia_set_key(struct crypto_tfm *tfm, const u8 *_in_key,
 	return 0;
 }
 
+static int camellia_set_key_skcipher(struct crypto_skcipher *tfm,
+				     const u8 *in_key, unsigned int key_len)
+{
+	return camellia_set_key(crypto_skcipher_tfm(tfm), in_key, key_len);
+}
+
 extern void camellia_sparc64_crypt(const u64 *key, const u32 *input,
 				   u32 *output, unsigned int key_len);
 
@@ -81,61 +88,46 @@ typedef void ecb_crypt_op(const u64 *input, u64 *output, unsigned int len,
 extern ecb_crypt_op camellia_sparc64_ecb_crypt_3_grand_rounds;
 extern ecb_crypt_op camellia_sparc64_ecb_crypt_4_grand_rounds;
 
-#define CAMELLIA_BLOCK_MASK	(~(CAMELLIA_BLOCK_SIZE - 1))
-
-static int __ecb_crypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes, bool encrypt)
+static int __ecb_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct camellia_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	ecb_crypt_op *op;
 	const u64 *key;
+	unsigned int nbytes;
 	int err;
 
 	op = camellia_sparc64_ecb_crypt_3_grand_rounds;
 	if (ctx->key_len != 16)
 		op = camellia_sparc64_ecb_crypt_4_grand_rounds;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	if (encrypt)
 		key = &ctx->encrypt_key[0];
 	else
 		key = &ctx->decrypt_key[0];
 	camellia_sparc64_load_keys(key, ctx->key_len);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64;
-			u64 *dst64;
-
-			src64 = (const u64 *)walk.src.virt.addr;
-			dst64 = (u64 *) walk.dst.virt.addr;
-			op(src64, dst64, block_len, key);
-		}
-		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		op(walk.src.virt.addr, walk.dst.virt.addr,
+		   round_down(nbytes, CAMELLIA_BLOCK_SIZE), key);
+		err = skcipher_walk_done(&walk, nbytes % CAMELLIA_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static int ecb_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb_encrypt(struct skcipher_request *req)
 {
-	return __ecb_crypt(desc, dst, src, nbytes, true);
+	return __ecb_crypt(req, true);
 }
 
-static int ecb_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb_decrypt(struct skcipher_request *req)
 {
-	return __ecb_crypt(desc, dst, src, nbytes, false);
+	return __ecb_crypt(req, false);
 }
 
 typedef void cbc_crypt_op(const u64 *input, u64 *output, unsigned int len,
@@ -146,85 +138,65 @@ extern cbc_crypt_op camellia_sparc64_cbc_encrypt_4_grand_rounds;
 extern cbc_crypt_op camellia_sparc64_cbc_decrypt_3_grand_rounds;
 extern cbc_crypt_op camellia_sparc64_cbc_decrypt_4_grand_rounds;
 
-static int cbc_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct camellia_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	cbc_crypt_op *op;
 	const u64 *key;
+	unsigned int nbytes;
 	int err;
 
 	op = camellia_sparc64_cbc_encrypt_3_grand_rounds;
 	if (ctx->key_len != 16)
 		op = camellia_sparc64_cbc_encrypt_4_grand_rounds;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	key = &ctx->encrypt_key[0];
 	camellia_sparc64_load_keys(key, ctx->key_len);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64;
-			u64 *dst64;
-
-			src64 = (const u64 *)walk.src.virt.addr;
-			dst64 = (u64 *) walk.dst.virt.addr;
-			op(src64, dst64, block_len, key,
-			   (u64 *) walk.iv);
-		}
-		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		op(walk.src.virt.addr, walk.dst.virt.addr,
+		   round_down(nbytes, CAMELLIA_BLOCK_SIZE), key, walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % CAMELLIA_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_decrypt(struct skcipher_request *req)
 {
-	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct camellia_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	cbc_crypt_op *op;
 	const u64 *key;
+	unsigned int nbytes;
 	int err;
 
 	op = camellia_sparc64_cbc_decrypt_3_grand_rounds;
 	if (ctx->key_len != 16)
 		op = camellia_sparc64_cbc_decrypt_4_grand_rounds;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	key = &ctx->decrypt_key[0];
 	camellia_sparc64_load_keys(key, ctx->key_len);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64;
-			u64 *dst64;
-
-			src64 = (const u64 *)walk.src.virt.addr;
-			dst64 = (u64 *) walk.dst.virt.addr;
-			op(src64, dst64, block_len, key,
-			   (u64 *) walk.iv);
-		}
-		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		op(walk.src.virt.addr, walk.dst.virt.addr,
+		   round_down(nbytes, CAMELLIA_BLOCK_SIZE), key, walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % CAMELLIA_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static struct crypto_alg algs[] = { {
+static struct crypto_alg cipher_alg = {
 	.cra_name		= "camellia",
 	.cra_driver_name	= "camellia-sparc64",
 	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
@@ -242,46 +214,37 @@ static struct crypto_alg algs[] = { {
 			.cia_decrypt		= camellia_decrypt
 		}
 	}
-}, {
-	.cra_name		= "ecb(camellia)",
-	.cra_driver_name	= "ecb-camellia-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
-			.max_keysize	= CAMELLIA_MAX_KEY_SIZE,
-			.setkey		= camellia_set_key,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "cbc(camellia)",
-	.cra_driver_name	= "cbc-camellia-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
-			.max_keysize	= CAMELLIA_MAX_KEY_SIZE,
-			.ivsize		= CAMELLIA_BLOCK_SIZE,
-			.setkey		= camellia_set_key,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-}
+};
+
+static struct skcipher_alg skcipher_algs[] = {
+	{
+		.base.cra_name		= "ecb(camellia)",
+		.base.cra_driver_name	= "ecb-camellia-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct camellia_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
+		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
+		.setkey			= camellia_set_key_skcipher,
+		.encrypt		= ecb_encrypt,
+		.decrypt		= ecb_decrypt,
+	}, {
+		.base.cra_name		= "cbc(camellia)",
+		.base.cra_driver_name	= "cbc-camellia-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= CAMELLIA_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct camellia_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
+		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
+		.ivsize			= CAMELLIA_BLOCK_SIZE,
+		.setkey			= camellia_set_key_skcipher,
+		.encrypt		= cbc_encrypt,
+		.decrypt		= cbc_decrypt,
+	}
 };
 
 static bool __init sparc64_has_camellia_opcode(void)
@@ -300,17 +263,27 @@ static bool __init sparc64_has_camellia_opcode(void)
 
 static int __init camellia_sparc64_mod_init(void)
 {
-	if (sparc64_has_camellia_opcode()) {
-		pr_info("Using sparc64 camellia opcodes optimized CAMELLIA implementation\n");
-		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	int err;
+
+	if (!sparc64_has_camellia_opcode()) {
+		pr_info("sparc64 camellia opcodes not available.\n");
+		return -ENODEV;
 	}
-	pr_info("sparc64 camellia opcodes not available.\n");
-	return -ENODEV;
+	pr_info("Using sparc64 camellia opcodes optimized CAMELLIA implementation\n");
+	err = crypto_register_alg(&cipher_alg);
+	if (err)
+		return err;
+	err = crypto_register_skciphers(skcipher_algs,
+					ARRAY_SIZE(skcipher_algs));
+	if (err)
+		crypto_unregister_alg(&cipher_alg);
+	return err;
 }
 
 static void __exit camellia_sparc64_mod_fini(void)
 {
-	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+	crypto_unregister_alg(&cipher_alg);
+	crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 }
 
 module_init(camellia_sparc64_mod_init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7c54a5b9aa2b..bc97543d1ec2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1276,6 +1276,7 @@ config CRYPTO_CAMELLIA_SPARC64
 	depends on SPARC64
 	depends on CRYPTO
 	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
 	  Camellia cipher algorithm module (SPARC64).
 
-- 
2.23.0

