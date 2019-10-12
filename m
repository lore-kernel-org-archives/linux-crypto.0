Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9CAECE58E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A3A2196E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 04:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570855271;
	bh=y0235GUogeMoqZc3owSRi2xbCa6cwfIzCRjmHMUWYdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wWrw70JKJ0jVb7nVuxUXpezbWdBk2ysjOMz9epRkgCMG2MZd9eL3HYg5D4z1UgB0F
	 kKrDFUZoEzYE3afOWfdkW1JOHN9/1NC6PWSRGtcIG/afCE+n6Hj/spMm71AsgDSzCY
	 UolPMH8JUaoej80ALm2FacNYr+gVugoFgd7si4sA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJLElJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 00:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfJLElI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 00:41:08 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771762190F;
        Sat, 12 Oct 2019 04:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570855267;
        bh=y0235GUogeMoqZc3owSRi2xbCa6cwfIzCRjmHMUWYdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2f8eKKNAQ3HbVhcVTRVwfKu2tYk7IaeuDpMzqmWlNlL3WG50HruMwWTdeRcNcwOsJ
         nOECE8GaHoc9Q3LR8zHp9bd+TGx0WIf1PS+8Ib9pdlc2beqbaWv4prCNbsNicOQb9B
         5jgRMoi6io6292nrAYIFnDeZHPuK3BwAUhaxeaJI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     sparclinux@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFT PATCH 3/3] crypto: sparc/des - convert to skcipher API
Date:   Fri, 11 Oct 2019 21:38:50 -0700
Message-Id: <20191012043850.340957-4-ebiggers@kernel.org>
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

Convert the glue code for the SPARC64 DES opcodes implementations of
DES-ECB, DES-CBC, 3DES-ECB, and 3DES-CBC from the deprecated "blkcipher"
API to the "skcipher" API.  This is needed in order for the blkcipher
API to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/sparc/crypto/des_glue.c | 499 ++++++++++++++++-------------------
 crypto/Kconfig               |   1 +
 2 files changed, 228 insertions(+), 272 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index db6010b4e52e..a499102bf706 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -61,6 +62,12 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
+static int des_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	return des_set_key(crypto_skcipher_tfm(tfm), key, keylen);
+}
+
 extern void des_sparc64_crypt(const u64 *key, const u64 *input,
 			      u64 *output);
 
@@ -85,113 +92,90 @@ extern void des_sparc64_load_keys(const u64 *key);
 extern void des_sparc64_ecb_crypt(const u64 *input, u64 *output,
 				  unsigned int len);
 
-#define DES_BLOCK_MASK	(~(DES_BLOCK_SIZE - 1))
-
-static int __ecb_crypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes, bool encrypt)
+static int __ecb_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct des_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	if (encrypt)
 		des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
 	else
 		des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			des_sparc64_ecb_crypt((const u64 *)walk.src.virt.addr,
-					      (u64 *) walk.dst.virt.addr,
-					      block_len);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		des_sparc64_ecb_crypt(walk.src.virt.addr, walk.dst.virt.addr,
+				      round_down(nbytes, DES_BLOCK_SIZE));
+		err = skcipher_walk_done(&walk, nbytes % DES_BLOCK_SIZE);
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
 
 extern void des_sparc64_cbc_encrypt(const u64 *input, u64 *output,
 				    unsigned int len, u64 *iv);
 
-static int cbc_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+extern void des_sparc64_cbc_decrypt(const u64 *input, u64 *output,
+				    unsigned int len, u64 *iv);
+
+static int __cbc_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct des_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
-		if (likely(block_len)) {
-			des_sparc64_cbc_encrypt((const u64 *)walk.src.virt.addr,
-						(u64 *) walk.dst.virt.addr,
-						block_len, (u64 *) walk.iv);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	if (encrypt)
+		des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
+	else
+		des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
+	while ((nbytes = walk.nbytes) != 0) {
+		if (encrypt)
+			des_sparc64_cbc_encrypt(walk.src.virt.addr,
+						walk.dst.virt.addr,
+						round_down(nbytes,
+							   DES_BLOCK_SIZE),
+						walk.iv);
+		else
+			des_sparc64_cbc_decrypt(walk.src.virt.addr,
+						walk.dst.virt.addr,
+						round_down(nbytes,
+							   DES_BLOCK_SIZE),
+						walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % DES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-extern void des_sparc64_cbc_decrypt(const u64 *input, u64 *output,
-				    unsigned int len, u64 *iv);
-
-static int cbc_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+	return __cbc_crypt(req, true);
+}
 
-		if (likely(block_len)) {
-			des_sparc64_cbc_decrypt((const u64 *)walk.src.virt.addr,
-						(u64 *) walk.dst.virt.addr,
-						block_len, (u64 *) walk.iv);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-	fprs_write(0);
-	return err;
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	return __cbc_crypt(req, false);
 }
 
 static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
@@ -227,6 +211,12 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
+static int des3_ede_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	return des3_ede_set_key(crypto_skcipher_tfm(tfm), key, keylen);
+}
+
 extern void des3_ede_sparc64_crypt(const u64 *key, const u64 *input,
 				   u64 *output);
 
@@ -251,241 +241,196 @@ extern void des3_ede_sparc64_load_keys(const u64 *key);
 extern void des3_ede_sparc64_ecb_crypt(const u64 *expkey, const u64 *input,
 				       u64 *output, unsigned int len);
 
-static int __ecb3_crypt(struct blkcipher_desc *desc,
-			struct scatterlist *dst, struct scatterlist *src,
-			unsigned int nbytes, bool encrypt)
+static int __ecb3_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct des3_ede_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	const u64 *K;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	if (encrypt)
 		K = &ctx->encrypt_expkey[0];
 	else
 		K = &ctx->decrypt_expkey[0];
 	des3_ede_sparc64_load_keys(K);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64 = (const u64 *)walk.src.virt.addr;
-			des3_ede_sparc64_ecb_crypt(K, src64,
-						   (u64 *) walk.dst.virt.addr,
-						   block_len);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		des3_ede_sparc64_ecb_crypt(K, walk.src.virt.addr,
+					   walk.dst.virt.addr,
+					   round_down(nbytes, DES_BLOCK_SIZE));
+		err = skcipher_walk_done(&walk, nbytes % DES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static int ecb3_encrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb3_encrypt(struct skcipher_request *req)
 {
-	return __ecb3_crypt(desc, dst, src, nbytes, true);
+	return __ecb3_crypt(req, true);
 }
 
-static int ecb3_decrypt(struct blkcipher_desc *desc,
-		       struct scatterlist *dst, struct scatterlist *src,
-		       unsigned int nbytes)
+static int ecb3_decrypt(struct skcipher_request *req)
 {
-	return __ecb3_crypt(desc, dst, src, nbytes, false);
+	return __ecb3_crypt(req, false);
 }
 
 extern void des3_ede_sparc64_cbc_encrypt(const u64 *expkey, const u64 *input,
 					 u64 *output, unsigned int len,
 					 u64 *iv);
 
-static int cbc3_encrypt(struct blkcipher_desc *desc,
-			struct scatterlist *dst, struct scatterlist *src,
-			unsigned int nbytes)
-{
-	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	const u64 *K;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	K = &ctx->encrypt_expkey[0];
-	des3_ede_sparc64_load_keys(K);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64 = (const u64 *)walk.src.virt.addr;
-			des3_ede_sparc64_cbc_encrypt(K, src64,
-						     (u64 *) walk.dst.virt.addr,
-						     block_len,
-						     (u64 *) walk.iv);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-	fprs_write(0);
-	return err;
-}
-
 extern void des3_ede_sparc64_cbc_decrypt(const u64 *expkey, const u64 *input,
 					 u64 *output, unsigned int len,
 					 u64 *iv);
 
-static int cbc3_decrypt(struct blkcipher_desc *desc,
-			struct scatterlist *dst, struct scatterlist *src,
-			unsigned int nbytes)
+static int __cbc3_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct des3_ede_sparc64_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	const u64 *K;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
-	K = &ctx->decrypt_expkey[0];
+	if (encrypt)
+		K = &ctx->encrypt_expkey[0];
+	else
+		K = &ctx->decrypt_expkey[0];
 	des3_ede_sparc64_load_keys(K);
-	while ((nbytes = walk.nbytes)) {
-		unsigned int block_len = nbytes & DES_BLOCK_MASK;
-
-		if (likely(block_len)) {
-			const u64 *src64 = (const u64 *)walk.src.virt.addr;
-			des3_ede_sparc64_cbc_decrypt(K, src64,
-						     (u64 *) walk.dst.virt.addr,
-						     block_len,
-						     (u64 *) walk.iv);
-		}
-		nbytes &= DES_BLOCK_SIZE - 1;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		if (encrypt)
+			des3_ede_sparc64_cbc_encrypt(K, walk.src.virt.addr,
+						     walk.dst.virt.addr,
+						     round_down(nbytes,
+								DES_BLOCK_SIZE),
+						     walk.iv);
+		else
+			des3_ede_sparc64_cbc_decrypt(K, walk.src.virt.addr,
+						     walk.dst.virt.addr,
+						     round_down(nbytes,
+								DES_BLOCK_SIZE),
+						     walk.iv);
+		err = skcipher_walk_done(&walk, nbytes % DES_BLOCK_SIZE);
 	}
 	fprs_write(0);
 	return err;
 }
 
-static struct crypto_alg algs[] = { {
-	.cra_name		= "des",
-	.cra_driver_name	= "des-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		= DES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_module		= THIS_MODULE,
-	.cra_u	= {
-		.cipher	= {
-			.cia_min_keysize	= DES_KEY_SIZE,
-			.cia_max_keysize	= DES_KEY_SIZE,
-			.cia_setkey		= des_set_key,
-			.cia_encrypt		= sparc_des_encrypt,
-			.cia_decrypt		= sparc_des_decrypt
+static int cbc3_encrypt(struct skcipher_request *req)
+{
+	return __cbc3_crypt(req, true);
+}
+
+static int cbc3_decrypt(struct skcipher_request *req)
+{
+	return __cbc3_crypt(req, false);
+}
+
+static struct crypto_alg cipher_algs[] = {
+	{
+		.cra_name		= "des",
+		.cra_driver_name	= "des-sparc64",
+		.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+		.cra_blocksize		= DES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
+		.cra_alignmask		= 7,
+		.cra_module		= THIS_MODULE,
+		.cra_u	= {
+			.cipher	= {
+				.cia_min_keysize	= DES_KEY_SIZE,
+				.cia_max_keysize	= DES_KEY_SIZE,
+				.cia_setkey		= des_set_key,
+				.cia_encrypt		= sparc_des_encrypt,
+				.cia_decrypt		= sparc_des_decrypt
+			}
 		}
-	}
-}, {
-	.cra_name		= "ecb(des)",
-	.cra_driver_name	= "ecb-des-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= DES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= DES_KEY_SIZE,
-			.max_keysize	= DES_KEY_SIZE,
-			.setkey		= des_set_key,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "cbc(des)",
-	.cra_driver_name	= "cbc-des-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= DES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= DES_KEY_SIZE,
-			.max_keysize	= DES_KEY_SIZE,
-			.ivsize		= DES_BLOCK_SIZE,
-			.setkey		= des_set_key,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "des3_ede",
-	.cra_driver_name	= "des3_ede-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_module		= THIS_MODULE,
-	.cra_u	= {
-		.cipher	= {
-			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
-			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
-			.cia_setkey		= des3_ede_set_key,
-			.cia_encrypt		= sparc_des3_ede_encrypt,
-			.cia_decrypt		= sparc_des3_ede_decrypt
+	}, {
+		.cra_name		= "des3_ede",
+		.cra_driver_name	= "des3_ede-sparc64",
+		.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+		.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
+		.cra_alignmask		= 7,
+		.cra_module		= THIS_MODULE,
+		.cra_u	= {
+			.cipher	= {
+				.cia_min_keysize	= DES3_EDE_KEY_SIZE,
+				.cia_max_keysize	= DES3_EDE_KEY_SIZE,
+				.cia_setkey		= des3_ede_set_key,
+				.cia_encrypt		= sparc_des3_ede_encrypt,
+				.cia_decrypt		= sparc_des3_ede_decrypt
+			}
 		}
 	}
-}, {
-	.cra_name		= "ecb(des3_ede)",
-	.cra_driver_name	= "ecb-des3_ede-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= DES3_EDE_KEY_SIZE,
-			.max_keysize	= DES3_EDE_KEY_SIZE,
-			.setkey		= des3_ede_set_key,
-			.encrypt	= ecb3_encrypt,
-			.decrypt	= ecb3_decrypt,
-		},
-	},
-}, {
-	.cra_name		= "cbc(des3_ede)",
-	.cra_driver_name	= "cbc-des3_ede-sparc64",
-	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
-	.cra_alignmask		= 7,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= DES3_EDE_KEY_SIZE,
-			.max_keysize	= DES3_EDE_KEY_SIZE,
-			.ivsize		= DES3_EDE_BLOCK_SIZE,
-			.setkey		= des3_ede_set_key,
-			.encrypt	= cbc3_encrypt,
-			.decrypt	= cbc3_decrypt,
-		},
-	},
-} };
+};
+
+static struct skcipher_alg skcipher_algs[] = {
+	{
+		.base.cra_name		= "ecb(des)",
+		.base.cra_driver_name	= "ecb-des-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct des_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= DES_KEY_SIZE,
+		.max_keysize		= DES_KEY_SIZE,
+		.setkey			= des_set_key_skcipher,
+		.encrypt		= ecb_encrypt,
+		.decrypt		= ecb_decrypt,
+	}, {
+		.base.cra_name		= "cbc(des)",
+		.base.cra_driver_name	= "cbc-des-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct des_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= DES_KEY_SIZE,
+		.max_keysize		= DES_KEY_SIZE,
+		.ivsize			= DES_BLOCK_SIZE,
+		.setkey			= des_set_key_skcipher,
+		.encrypt		= cbc_encrypt,
+		.decrypt		= cbc_decrypt,
+	}, {
+		.base.cra_name		= "ecb(des3_ede)",
+		.base.cra_driver_name	= "ecb-des3_ede-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct des3_ede_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= DES3_EDE_KEY_SIZE,
+		.max_keysize		= DES3_EDE_KEY_SIZE,
+		.setkey			= des3_ede_set_key_skcipher,
+		.encrypt		= ecb3_encrypt,
+		.decrypt		= ecb3_decrypt,
+	}, {
+		.base.cra_name		= "cbc(des3_ede)",
+		.base.cra_driver_name	= "cbc-des3_ede-sparc64",
+		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
+		.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct des3_ede_sparc64_ctx),
+		.base.cra_alignmask	= 7,
+		.base.cra_module	= THIS_MODULE,
+		.min_keysize		= DES3_EDE_KEY_SIZE,
+		.max_keysize		= DES3_EDE_KEY_SIZE,
+		.ivsize			= DES3_EDE_BLOCK_SIZE,
+		.setkey			= des3_ede_set_key_skcipher,
+		.encrypt		= cbc3_encrypt,
+		.decrypt		= cbc3_decrypt,
+	}
+};
 
 static bool __init sparc64_has_des_opcode(void)
 {
@@ -503,17 +448,27 @@ static bool __init sparc64_has_des_opcode(void)
 
 static int __init des_sparc64_mod_init(void)
 {
-	if (sparc64_has_des_opcode()) {
-		pr_info("Using sparc64 des opcodes optimized DES implementation\n");
-		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	int err;
+
+	if (!sparc64_has_des_opcode()) {
+		pr_info("sparc64 des opcodes not available.\n");
+		return -ENODEV;
 	}
-	pr_info("sparc64 des opcodes not available.\n");
-	return -ENODEV;
+	pr_info("Using sparc64 des opcodes optimized DES implementation\n");
+	err = crypto_register_algs(cipher_algs, ARRAY_SIZE(cipher_algs));
+	if (err)
+		return err;
+	err = crypto_register_skciphers(skcipher_algs,
+					ARRAY_SIZE(skcipher_algs));
+	if (err)
+		crypto_unregister_algs(cipher_algs, ARRAY_SIZE(cipher_algs));
+	return err;
 }
 
 static void __exit des_sparc64_mod_fini(void)
 {
-	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+	crypto_unregister_algs(cipher_algs, ARRAY_SIZE(cipher_algs));
+	crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 }
 
 module_init(des_sparc64_mod_init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index bc97543d1ec2..320548b4dfa9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1355,6 +1355,7 @@ config CRYPTO_DES_SPARC64
 	depends on SPARC64
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_DES
+	select CRYPTO_BLKCIPHER
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3),
 	  optimized using SPARC64 crypto opcodes.
-- 
2.23.0

