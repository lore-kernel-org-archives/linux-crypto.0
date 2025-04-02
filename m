Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF120CCE8
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 07:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577394; cv=none; b=WevvlK6IkCCWsNIN3yvg+LU9ltTsQlMPHyiPaeaF71qjA1BN4wQhZ4bYEChPlfBBRPuG/XYxe5UnPkqskamuwv5JROzJOCKp/wayQsZXW9Ui7zN8ewWqF1FdGGBncx5dvjg+c2LbB5rfNUAL8DqVcsgkqs3c62wvQSqvv8+eBIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577394; c=relaxed/simple;
	bh=p/DtHCAdOtcwcGJP6yhpMj1XdQ3nJkUb3clxtYinQDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bikaUozXX92ADH/Z1BcvT3P5vUc2u9zz1/fQk7UHI5DD13TwfG+6JvBZKqXA/Mu4Hoi2LcOQfWxfZ6fzExhzYMACJ5LrqpmyjAmyXIV8d/CbZBRAhq0G3QKf6a2N9ig9V6QOIJwIZMnTp07uqjUwlOq/ksaqyO+zbIV8qRxZiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FVlp57sq; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVlp57sq"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so45811195e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2025 00:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743577391; x=1744182191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKRPojsxaQDO03CgkqK3e3BHcGhaiQlF/OIeMqrNjTQ=;
        b=FVlp57sqBbLGlehIToVAyYr/+oW/wWwZu9KwuzSN83Cngmdl4jxvJsEM0/d5lm5dsR
         tLq+OeevBxA8FNxGzEJNtBpPvxKTydqG/ZlQ0Dl5ef+xNQOMkj+qjrJnUJHxrd7Z1M+R
         6Zn1XVSNj//hYmHKoXNjJsC6P1ueCwiwlUxQrgBhw9vpwWUfIBHRGkWW2QwRc6Ynk5yh
         kKsH4uyVoB2PJ1NI0zQ+QprKbmmRry+oFKGqOjmKaDeUrNf6YPzrU6bD/xwX1kak0SRu
         rPMky1pMllAgdwrVlUzLX3oQPG5dgJATX7Uqp++zCCyLmymHsZCxJBeCgkwII29xbhtt
         8z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743577391; x=1744182191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKRPojsxaQDO03CgkqK3e3BHcGhaiQlF/OIeMqrNjTQ=;
        b=LlfBR2gbFQ0cN+vYRv9HlAusUKOeg4zCFI0LeNfoYLTYoM8nV4UW5HH9Qqum8uN2HA
         9gZ9hma5cht8JSrlnv2ouzfGQd9GOBzRBuDhfcHJovlioebyk7mYzScwHL3P5uuhWYf1
         zE3YHHheRa2J3I1y58vLCZdupsauaC90s/CpPbdlQanIpKqsqNkf8nGSVk92XFmwVnXR
         rC9/NkznDlP+rxTwabCZnYVelyltoLFPoJJMiz+uLogr6od+k+I/IS5zBa7occ7yy1Y2
         vGlD8Gn+rzaJijiB4VTMmeIPcI2GlcwXGb5HGsAixXG1AttRW0PZX4YR8MZ68JNLVz5a
         HVlg==
X-Gm-Message-State: AOJu0YwAx93wJ1vKYORlQ/GQdCqD60umnsKbNUDFN5cTCYA1hkQid/2G
	PdnB8aXfAlGqoGQW7/kM5pWGPLzAvzh9WP2rIk251Ufvsnjjp/DP4FIEZgsh7+W/um8T2l2MbLe
	POUhjhl3dnS3GeGmlIOARa8v2qr0I34ok+56QzpuEcBF+MSA5Wnp2+vrV0rpoybKJ6nRzbAva57
	FYFbMgLHzQdf/YgFYFcNCJzh31uAWpag==
X-Google-Smtp-Source: AGHT+IHa5X8o705u1/f64pxi+Foq8RCIP9kM4r7Ol24dBp7MJZ9/r3Py+42pNiYEzcPNS3cW7BSW0OqE
X-Received: from wmcq16.prod.google.com ([2002:a05:600c:c110:b0:43d:44cf:11f8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d06:b0:43d:42b:e186
 with SMTP id 5b1f17b1804b1-43eb5c18562mr11074965e9.8.1743577391358; Wed, 02
 Apr 2025 00:03:11 -0700 (PDT)
Date: Wed,  2 Apr 2025 09:02:53 +0200
In-Reply-To: <20250402070251.1762692-3-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250402070251.1762692-3-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=7064; i=ardb@kernel.org;
 h=from:subject; bh=wzLJrUxq/hi24HmoA0GzToJQevLkd8ODP/D5cLckYWI=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf3NQ/mw2/s2hU2u+m/PnBunGRLWczCI7cDiZ1tEpXrP3
 3n52OZyRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZgI92GGf7ZmO74c1DITzZy6
 co5QyjRXlnlyfAt83LQnPJrUpaZ+6gkjwy1B23XH+Ncu77ZbOsX5m0idSMqyTYvY/5YKCq0pcDr LxwAA
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250402070251.1762692-4-ardb+git@google.com>
Subject: [PATCH 2/2] crypto: arm/aes-neonbs - stop using the SIMD helper
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
 arch/arm/crypto/Kconfig           |   1 -
 arch/arm/crypto/aes-neonbs-glue.c | 114 +++---------------------------
 2 files changed, 9 insertions(+), 106 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 2fa8aba8dc12..ba1d1b67c727 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -169,7 +169,6 @@ config CRYPTO_AES_ARM_BS
 	select CRYPTO_AES_ARM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
-	select CRYPTO_SIMD
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	  with block cipher modes:
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f6be80b5938b..63800257a7ea 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -59,11 +59,6 @@ struct aesbs_xts_ctx {
 	struct crypto_aes_ctx	tweak_key;
 };
 
-struct aesbs_ctr_ctx {
-	struct aesbs_ctx	key;		/* must be first member */
-	struct crypto_aes_ctx	fallback;
-};
-
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
@@ -200,25 +195,6 @@ static int cbc_decrypt(struct skcipher_request *req)
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
@@ -254,21 +230,6 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
-{
-	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	__aes_arm_encrypt(ctx->fallback.key_enc, ctx->key.rounds, src, dst);
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
 static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
@@ -374,13 +335,12 @@ static int xts_decrypt(struct skcipher_request *req)
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
@@ -389,13 +349,12 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -405,13 +364,12 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -422,29 +380,12 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
 }, {
-	.base.cra_name		= "ctr(aes)",
-	.base.cra_driver_name	= "ctr-aes-neonbs-sync",
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
@@ -455,54 +396,17 @@ static struct skcipher_alg aes_algs[] = { {
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
 	if (!(elf_hwcap & HWCAP_NEON))
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
-		simd = simd_skcipher_create_compat(aes_algs + i, algname, drvname, basename);
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
 
 late_initcall(aes_init);
-- 
2.49.0.472.ge94155a9ec-goog

