Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CB3C17
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577392; cv=none; b=ZoQSJP/YflRYx+ylDYaduAInjcDKbrfF8jCBr+sxV06DWgjRiM5k26A+pGLjL4MrlwsGDl/ECrIhEdwwRXGUZW3494xYRHTfC2N5uGgPyUYZKD2dzAuSc8JQ0U5lYd9OLcgX2L6KuikkrKOoGU9/TrPH6HuapaYM2pbpqIC3LpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577392; c=relaxed/simple;
	bh=tF6whJezEEc3TL25s7l2ut3QgCCoxd4fvKzQ6fikzFo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fKQGbHGQOhTqxZnGj8lEhzN27jgolc73Mv9cc5eKLQN68s51Hr4ist21GFvyjknGbT6gs2ELUHZCeyMj4j7+q67/lXOQb2PXycqbHzDV0T2+V1PEoxoy7dBIYMvDpjpo14LrwkEupNJyJhGbZmNyRtMU9R4W2uvC7RkzpaW/eyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iuk2g80A; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iuk2g80A"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39c142d4909so2206303f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2025 00:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743577389; x=1744182189; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0mGb3opwhhZJQd4PF+IUTJMwu9jA7SEufHNbpsIO17s=;
        b=Iuk2g80AWSRkUFErZkF0vPlqxVK82uXwHsD6J5/pKrT/CoO7RAApi+GdF0VAmdfQcB
         K2WwvdfdnovNsU0riJ5yTWYpvRZ7hUNIdtlhwiQS7WSEeR74eApUU7zd/y/8Connpvv+
         0rZwpxvKdpasET6J1zoAPiq/Mh3ONInNvh6O25vJoCmRrJ+tubrljVmdtzyplG/NrlDt
         t8k/VrYyw9kjRhpkWVGFfqVASjaWj6oDnh2RmGJZgmEG6lYzvO7hv/lKkNxHrDHNqyn0
         yGZ11XsRyiNJ4HLgs61JK6S/NwU5oF4JcOGZk2AcrmyDijzTUDH0EDRDkEgLZbPMvqod
         dPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743577389; x=1744182189;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0mGb3opwhhZJQd4PF+IUTJMwu9jA7SEufHNbpsIO17s=;
        b=p8glj1jlaGZ3HWxAGVg14FRv/pWjhc+ECS/lq4Q7rlAOImwvEuGhGR+yRhje20uGD4
         aOGq+S5/wGDDSuaAFOdKY3XvvzsnFNKtiGPMJzNB1WXGbsZxuP1bS3ZBCIvevn4edvbh
         wuLLPPCOc/CfZfc5mIyH1VbwpiZMmSkVn0tYuW4p6QdD1xmnE4cqLLHewuIebP50YCNP
         Y2DdTILhAjA3C2jzTqORITpuW8Sy6s8C/XNsBagAx6yGD9TJ2VdO8HD8beiIOYKBHZzY
         9byocKDW3gAOP2aQdOwKrz9d4Gq2PwBwCiPvmOAfpFQ/BIfLUHJC6okya6AoOH05iWpr
         LylQ==
X-Gm-Message-State: AOJu0YwbgHnikWVFF/vVBPvIIGNc/KjWYEak4Rj/+qUOP+447BvvMqft
	LgpdKaqiSZJUNLUFxlMS43FZcbR1hUuVIJJcAMct3tDCuMphq9UbqMMI6FM49aImitco5BjAQK6
	8uFJpP6JJwVADmo3WvV/9SF4v1kTjQPk7SA8oL9Z62QonfXB3Sf2LjpVlP84LyJpCgMujx8hCX+
	/w0tpONMvFrPdRFRv1dt1ep3p+/zqtOg==
X-Google-Smtp-Source: AGHT+IFmAWS2GrdB0Yu8U27qZ5tPEaQxVLmiIK9XJfRe3GgNAOZOlsLj8EqQAxVljCRCfvCUYutyEUzc
X-Received: from wrpy3.prod.google.com ([2002:adf:f6c3:0:b0:39a:c9a1:ca5d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1ace:b0:391:47d8:de23
 with SMTP id ffacd0b85a97d-39c120e3ce1mr12840819f8f.31.1743577389102; Wed, 02
 Apr 2025 00:03:09 -0700 (PDT)
Date: Wed,  2 Apr 2025 09:02:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6346; i=ardb@kernel.org;
 h=from:subject; bh=OlkWsGOIIIBk8gLUx7h9D7s2W3yDh9dpKLgQtWRpnpo=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf3NQ+kn9dLq4k/zX4c82348butyxvwtjhMbnh66fb53z
 fGLu2uqOkpZGMQ4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBE5JsYGf4/9Eqz6uR3bo2x
 2rNm9Uklg7LD7k6F9tb2ic2rJq7z1gWqEJrueYP1+OFd2zjWveHzya1gcyqdnTnH6vTFfZMk5y5 gBQA=
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250402070251.1762692-3-ardb+git@google.com>
Subject: [PATCH 1/2] crypto: arm/aes-ce - stop using the SIMD helper
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au, 
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that ARM permits use of the NEON unit in softirq context as well as
task context, there is no longer a need to rely on the SIMD helper
module to construct async skciphers wrapping the sync ones, as the
latter can always be called directly.

So remove these wrappers and the dependency on the SIMD helper. This
permits the use of these algorithms by callers that only support
synchronous use.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/Kconfig       |   1 -
 arch/arm/crypto/aes-ce-glue.c | 102 ++++------------------------------
 2 files changed, 11 insertions(+), 92 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 32650c8431d9..2fa8aba8dc12 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -197,7 +197,6 @@ config CRYPTO_AES_ARM_CE
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
-	select CRYPTO_SIMD
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	   with block cipher modes:
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 21df5e7f51f9..c17d9e4ad8e6 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -418,29 +418,6 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
-{
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
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
-static int ctr_encrypt_sync(struct skcipher_request *req)
-{
-	if (!crypto_simd_usable())
-		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
-
-	return ctr_encrypt(req);
-}
-
 static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -586,10 +563,9 @@ static int xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-	.base.cra_name		= "__ecb(aes)",
-	.base.cra_driver_name	= "__ecb-aes-ce",
+	.base.cra_name		= "ecb(aes)",
+	.base.cra_driver_name	= "ecb-aes-ce",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -600,10 +576,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= ecb_encrypt,
 	.decrypt		= ecb_decrypt,
 }, {
-	.base.cra_name		= "__cbc(aes)",
-	.base.cra_driver_name	= "__cbc-aes-ce",
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "cbc-aes-ce",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -615,10 +590,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
 }, {
-	.base.cra_name		= "__cts(cbc(aes))",
-	.base.cra_driver_name	= "__cts-cbc-aes-ce",
+	.base.cra_name		= "cts(cbc(aes))",
+	.base.cra_driver_name	= "cts-cbc-aes-ce",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -631,10 +605,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= cts_cbc_encrypt,
 	.decrypt		= cts_cbc_decrypt,
 }, {
-	.base.cra_name		= "__ctr(aes)",
-	.base.cra_driver_name	= "__ctr-aes-ce",
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-ce",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -647,25 +620,9 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
 }, {
-	.base.cra_name		= "ctr(aes)",
-	.base.cra_driver_name	= "ctr-aes-ce-sync",
-	.base.cra_priority	= 300 - 1,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= AES_MIN_KEY_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.ivsize			= AES_BLOCK_SIZE,
-	.chunksize		= AES_BLOCK_SIZE,
-	.setkey			= ce_aes_setkey,
-	.encrypt		= ctr_encrypt_sync,
-	.decrypt		= ctr_encrypt_sync,
-}, {
-	.base.cra_name		= "__xts(aes)",
-	.base.cra_driver_name	= "__xts-aes-ce",
+	.base.cra_name		= "xts(aes)",
+	.base.cra_driver_name	= "xts-aes-ce",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct crypto_aes_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -679,51 +636,14 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt		= xts_decrypt,
 } };
 
-static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
-
 static void aes_exit(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(aes_simd_algs) && aes_simd_algs[i]; i++)
-		simd_skcipher_free(aes_simd_algs[i]);
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
-		simd = simd_skcipher_create_compat(aes_algs + i, algname, drvname, basename);
-		err = PTR_ERR(simd);
-		if (IS_ERR(simd))
-			goto unregister_simds;
-
-		aes_simd_algs[i] = simd;
-	}
-
-	return 0;
-
-unregister_simds:
-	aes_exit();
-	return err;
+	return crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 module_cpu_feature_match(AES, aes_init);
-- 
2.49.0.472.ge94155a9ec-goog

