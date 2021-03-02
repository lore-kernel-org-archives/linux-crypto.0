Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6415AC43331
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABC064E09
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhCCBbX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378885AbhCBJFl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ECF61494;
        Tue,  2 Mar 2021 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675749;
        bh=Ly/lmVS1QjZ7fNRVAZRVxfMooCRKtYIc6q90rwd41s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahWRnpcMnc895vwQmYMdW8uiFyevJhzoXU5sLkhUFPLoCinvZQ12o/bStc9LYVG4u
         nXjDNNALFtcSbXTJq+XyImJNXSjBvP4An1xiSyrkpXm2FYg2OnpxUSqL+LPyijFShl
         QvK+uo6y9ShDtJTRp2GoGj/t2SSlgA7yU5AqCnz/X17SA2dM8dL7IIHW1HQCqG0rAh
         AsOqsXODY6phaPQuHMoa4mfy/vrf5IT3WWQTfg0Vtr/mBanWBsBIH0HEnUqdRU6Op6
         dLlAnrp0efJyU+TZzFjyjGXJBumEcUWhH+K3ismxx+3VwTB37/cqRjOqgnTg5aCEuL
         hO199v1M3WOWQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 8/9] crypto: arm64/aes-ce - stop using SIMD helper for skciphers
Date:   Tue,  2 Mar 2021 10:01:17 +0100
Message-Id: <20210302090118.30666-9-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calls into the skcipher API can only occur from contexts where the SIMD
unit is available, so there is no need for the SIMD helper.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/Kconfig    |   2 -
 arch/arm64/crypto/aes-glue.c | 102 +++-----------------
 2 files changed, 13 insertions(+), 91 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index b8eb0453123d..1a4374ed70fa 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -89,7 +89,6 @@ config CRYPTO_AES_ARM64_CE_BLK
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_CE
 	select CRYPTO_AES_ARM64
-	select CRYPTO_SIMD
 
 config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
@@ -97,7 +96,6 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64
 	select CRYPTO_LIB_AES
-	select CRYPTO_SIMD
 
 config CRYPTO_CHACHA20_NEON
 	tristate "ChaCha20, XChaCha20, and XChaCha12 stream ciphers using NEON instructions"
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 17e735931a0c..30b7cc6a7079 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -444,7 +444,7 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
 	return err ?: cbc_decrypt_walk(req, &walk);
 }
 
-static int ctr_encrypt(struct skcipher_request *req)
+static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -485,29 +485,6 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
-{
-	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	unsigned long flags;
-
-	/*
-	 * Temporarily disable interrupts to avoid races where
-	 * cachelines are evicted when the CPU is interrupted
-	 * to do something else.
-	 */
-	local_irq_save(flags);
-	aes_encrypt(ctx, dst, src);
-	local_irq_restore(flags);
-}
-
-static int __maybe_unused ctr_encrypt_sync(struct skcipher_request *req)
-{
-	if (!crypto_simd_usable())
-		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
-
-	return ctr_encrypt(req);
-}
-
 static int __maybe_unused xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -656,10 +633,9 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 static struct skcipher_alg aes_algs[] = { {
 #if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 	.base = {
-		.cra_name		= "__ecb(aes)",
-		.cra_driver_name	= "__ecb-aes-" MODE,
+		.cra_name		= "ecb(aes)",
+		.cra_driver_name	= "ecb-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
@@ -671,10 +647,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= ecb_decrypt,
 }, {
 	.base = {
-		.cra_name		= "__cbc(aes)",
-		.cra_driver_name	= "__cbc-aes-" MODE,
+		.cra_name		= "cbc(aes)",
+		.cra_driver_name	= "cbc-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
@@ -687,10 +662,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= cbc_decrypt,
 }, {
 	.base = {
-		.cra_name		= "__ctr(aes)",
-		.cra_driver_name	= "__ctr-aes-" MODE,
+		.cra_name		= "ctr(aes)",
+		.cra_driver_name	= "ctr-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
@@ -704,26 +678,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= ctr_encrypt,
 }, {
 	.base = {
-		.cra_name		= "ctr(aes)",
-		.cra_driver_name	= "ctr-aes-" MODE,
-		.cra_priority		= PRIO - 1,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.chunksize	= AES_BLOCK_SIZE,
-	.setkey		= skcipher_aes_setkey,
-	.encrypt	= ctr_encrypt_sync,
-	.decrypt	= ctr_encrypt_sync,
-}, {
-	.base = {
-		.cra_name		= "__xts(aes)",
-		.cra_driver_name	= "__xts-aes-" MODE,
+		.cra_name		= "xts(aes)",
+		.cra_driver_name	= "xts-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
 		.cra_module		= THIS_MODULE,
@@ -738,10 +695,9 @@ static struct skcipher_alg aes_algs[] = { {
 }, {
 #endif
 	.base = {
-		.cra_name		= "__cts(cbc(aes))",
-		.cra_driver_name	= "__cts-cbc-aes-" MODE,
+		.cra_name		= "cts(cbc(aes))",
+		.cra_driver_name	= "cts-cbc-aes-" MODE,
 		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
@@ -755,10 +711,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= cts_cbc_decrypt,
 }, {
 	.base = {
-		.cra_name		= "__essiv(cbc(aes),sha256)",
-		.cra_driver_name	= "__essiv-cbc-aes-sha256-" MODE,
+		.cra_name		= "essiv(cbc(aes),sha256)",
+		.cra_driver_name	= "essiv-cbc-aes-sha256-" MODE,
 		.cra_priority		= PRIO + 1,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= AES_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct crypto_aes_essiv_cbc_ctx),
 		.cra_module		= THIS_MODULE,
@@ -997,28 +952,15 @@ static struct shash_alg mac_algs[] = { {
 	.descsize		= sizeof(struct mac_desc_ctx),
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
 	crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 static int __init aes_init(void)
 {
-	struct simd_skcipher_alg *simd;
-	const char *basename;
-	const char *algname;
-	const char *drvname;
 	int err;
-	int i;
 
 	err = crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 	if (err)
@@ -1028,26 +970,8 @@ static int __init aes_init(void)
 	if (err)
 		goto unregister_ciphers;
 
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
-
 	return 0;
 
-unregister_simds:
-	aes_exit();
-	return err;
 unregister_ciphers:
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 	return err;
-- 
2.30.1

