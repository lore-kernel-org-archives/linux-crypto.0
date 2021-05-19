Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F13C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33097611C2
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350095AbhESLYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350009AbhESLYN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1114611BF;
        Wed, 19 May 2021 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621423374;
        bh=OGecJWccp6jMs07NDNYw4HgNuMa3K4h0kRcisuJRhgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPL+JlWP1X076/Yma87Tb2ZQOpb9T+D/YXPYuqfIjKQAI/gAibKdVyQ5yk4rqx3Ig
         JthYo9r6ntpTHKJdxwDsXoQgfVyGlrN2ZFhahnFEH/MDhpk80L0x7ZYxP4vefwAzP8
         Yy1+cS9RYoIQIAlgSaZ3QJqFMfBO93FBnhv6hDTp0wfbiJeZGSCcjalFyPd37i3KW8
         EtV38d/2DNFrlIfE1qexm5XZ9VqIIrMTTgW1v/IKjhsUuRhJoIUesLVze0QXhO7Ll+
         D2bVQvtXb2dOwuWoUmWjkjUvclZZQvcmI/rxq2JJvM5T+oEx8M8Zdwe0GcBx06+57k
         SZMv+n+C5OoFQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 5/7] crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
Date:   Wed, 19 May 2021 13:22:37 +0200
Message-Id: <20210519112239.33664-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210519112239.33664-1-ardb@kernel.org>
References: <20210519112239.33664-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calls into the skcipher API can only occur from contexts where the SIMD
unit is available, so there is no need for the SIMD helper.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/Kconfig           |   2 -
 arch/arm64/crypto/aes-neonbs-glue.c | 122 ++------------------
 2 files changed, 9 insertions(+), 115 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index b8eb0453123d..ed1e8cadeb3a 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -122,8 +122,6 @@ config CRYPTO_AES_ARM64_BS
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_NEON_BLK
-	select CRYPTO_AES_ARM64
 	select CRYPTO_LIB_AES
-	select CRYPTO_SIMD
 
 endif
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index fb507d569922..8df6ad8cb09d 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -63,11 +63,6 @@ struct aesbs_cbc_ctx {
 	u32			enc[AES_MAX_KEYLENGTH_U32];
 };
 
-struct aesbs_ctr_ctx {
-	struct aesbs_ctx	key;		/* must be first member */
-	struct crypto_aes_ctx	fallback;
-};
-
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
 	u32			twkey[AES_MAX_KEYLENGTH_U32];
@@ -207,25 +202,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
-				 unsigned int key_len)
-{
-	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err;
-
-	err = aes_expandkey(&ctx->fallback, in_key, key_len);
-	if (err)
-		return err;
-
-	ctx->key.rounds = 6 + key_len / 4;
-
-	kernel_neon_begin();
-	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
-	kernel_neon_end();
-
-	return 0;
-}
-
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -292,29 +268,6 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return aesbs_setkey(tfm, in_key, key_len);
 }
 
-static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
-{
-	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
-	unsigned long flags;
-
-	/*
-	 * Temporarily disable interrupts to avoid races where
-	 * cachelines are evicted when the CPU is interrupted
-	 * to do something else.
-	 */
-	local_irq_save(flags);
-	aes_encrypt(&ctx->fallback, dst, src);
-	local_irq_restore(flags);
-}
-
-static int ctr_encrypt_sync(struct skcipher_request *req)
-{
-	if (!crypto_simd_usable())
-		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
-
-	return ctr_encrypt(req);
-}
-
 static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		       void (*fn)(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]))
@@ -431,13 +384,12 @@ static int xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-	.base.cra_name		= "__ecb(aes)",
-	.base.cra_driver_name	= "__ecb-aes-neonbs",
+	.base.cra_name		= "ecb(aes)",
+	.base.cra_driver_name	= "ecb-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
@@ -446,13 +398,12 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= ecb_encrypt,
 	.decrypt		= ecb_decrypt,
 }, {
-	.base.cra_name		= "__cbc(aes)",
-	.base.cra_driver_name	= "__cbc-aes-neonbs",
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "cbc-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
@@ -462,13 +413,12 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
 }, {
-	.base.cra_name		= "__ctr(aes)",
-	.base.cra_driver_name	= "__ctr-aes-neonbs",
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct aesbs_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
@@ -479,29 +429,12 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
 }, {
-	.base.cra_name		= "ctr(aes)",
-	.base.cra_driver_name	= "ctr-aes-neonbs",
-	.base.cra_priority	= 250 - 1,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct aesbs_ctr_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= AES_MIN_KEY_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.chunksize		= AES_BLOCK_SIZE,
-	.walksize		= 8 * AES_BLOCK_SIZE,
-	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= aesbs_ctr_setkey_sync,
-	.encrypt		= ctr_encrypt_sync,
-	.decrypt		= ctr_encrypt_sync,
-}, {
-	.base.cra_name		= "__xts(aes)",
-	.base.cra_driver_name	= "__xts-aes-neonbs",
+	.base.cra_name		= "xts(aes)",
+	.base.cra_driver_name	= "xts-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
@@ -512,54 +445,17 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt		= xts_decrypt,
 } };
 
-static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
-
 static void aes_exit(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
-		if (aes_simd_algs[i])
-			simd_skcipher_free(aes_simd_algs[i]);
-
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 static int __init aes_init(void)
 {
-	struct simd_skcipher_alg *simd;
-	const char *basename;
-	const char *algname;
-	const char *drvname;
-	int err;
-	int i;
-
 	if (!cpu_have_named_feature(ASIMD))
 		return -ENODEV;
 
-	err = crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
-	if (err)
-		return err;
-
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
-		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
-			continue;
-
-		algname = aes_algs[i].base.cra_name + 2;
-		drvname = aes_algs[i].base.cra_driver_name + 2;
-		basename = aes_algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
-		err = PTR_ERR(simd);
-		if (IS_ERR(simd))
-			goto unregister_simds;
-
-		aes_simd_algs[i] = simd;
-	}
-	return 0;
-
-unregister_simds:
-	aes_exit();
-	return err;
+	return crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 module_init(aes_init);
-- 
2.20.1

