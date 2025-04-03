Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3E241136
	for <linux-crypto@vger.kernel.org>; Thu,  3 Apr 2025 07:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743664811; cv=none; b=NAFeNaiOTiSiHt8zFrsL/oq1TH5dieqxoJ6BOCepMmoIXn2Jm+lLG8UGcB5z+cJ3ocGX1dYtByvRf2Bno25xjjgoFuh7LtNzt5SK6MsQaCIpBPs+6HvOv4sEFJm3ygCNEWy3XiSouqgymPAZAQ1z6N2ryYtUHwPXvCYL4jWO8uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743664811; c=relaxed/simple;
	bh=wBnjVuJa9QUtHkXEjuy7xmOkDM8zSKZ8lNKp975ENlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WbyPrC/ja0AngZJcOshBcYzr14Kv+SJ+Zpd2awH7uwWOdbIlMpU7AXPPLk0ARqXbp2lEGh+X51FGL1eNTUVMl+B+UnUI2zigOyMpnqobKbXDjP6cLJ+JjOl/+ZzuXF8Wsy8vT1scLdFRTZEixQ0eb1AL/utv0vwdVshrTmlrOqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NvVtpiRN; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NvVtpiRN"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39c184b20a2so286172f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 03 Apr 2025 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743664808; x=1744269608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PcFZk+cTBpCiBUySXbXFUd4zh3qawFC29H5nrbpKhJc=;
        b=NvVtpiRNHVw1TAf1fsunSO9puz0vFlBIp/4xEPjGmOpdo4pk3pFBioEC2NGMmpt0bm
         p3gkTe/4/Yq/NGWoIYsk17gBGrAzfyxIqDVbuJEXJKrL1xaMgTdIaU2NkG8NgyU1LyBa
         qX85lJbTq+NPL7cOCxNjgAZRSiJqt4g5XW3cwTLDdIVkCroryZ5mAVISiZ2BB5IiTUvp
         mpCMuQ470uemoklo0lj32qBsVH5LaD52I3YZEax9ukVr1aURc90ZTYfV/QC7TSgA7G/i
         kbdLkwjTSD9JzsOgoroP6AEzJ59gCD/QKOzjvyE274alVXDUlA7XilAzZHyGP+aZriAs
         Zb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743664808; x=1744269608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PcFZk+cTBpCiBUySXbXFUd4zh3qawFC29H5nrbpKhJc=;
        b=Jic8iJPT2Nvpf1tMevbdlhnIqE3hoJKla5rNrBDxpzN2mgioOZkGh4Q7JKVMp7Fllc
         F8eC4Hhoj7Qoxt4kjK+I7+HJFc53t0qAVqW8tvlkowRiZ5MudW689T2B4Gb+r6+FboqZ
         xzGsYS3l/y2mUgXh0W9mSD6+pixftpKkNriO9YzzBBYb4ludoaS47SnkX0kRR075VLkj
         qC7EYzkxLKxExM8m6YleHtxsC3cbq7FE8lntKDk61X+2KZpLwnX4Kxv09nxP0LCuAm73
         OC4ipfGmlhy6GhQPi4We2L3mjUnCamk2gy11B/KKGfx0Px6umV644dX+dy7gaw2hNCuh
         g+kA==
X-Gm-Message-State: AOJu0YytXCzxExse1N7e7Z1MNn9d8Ojkf1NkKuXqNAOF6P8KRelPf+zw
	SWUSYAEjXvwxIY9P9UrW4sNvd0Gnbw26aXB8Y2k32Qib/9Pg+jD/jYk5pdYIph+JUvm4YcXAru7
	7Zq0+Ez02bybMbmWsoTqMCAI3NXp25CDLDCVwha2YEpCO173lbkjhlipB6Vxe4boRGUffCY/s6/
	D/I36hNtxYagkw5LNKfHjHaOiAPEd9FQ==
X-Google-Smtp-Source: AGHT+IE+UGU2lxSa+0dYxVwsac6dAuqnT+W910JV+Ov6KJP2ZKeedHZ4gtKXHLmEunkrrWcgfGdBr+Q4
X-Received: from wmbfl9.prod.google.com ([2002:a05:600c:b89:b0:43c:f03d:18aa])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2287:b0:39c:11c0:eb95
 with SMTP id ffacd0b85a97d-39c2f8d28cbmr1045995f8f.17.1743664808229; Thu, 03
 Apr 2025 00:20:08 -0700 (PDT)
Date: Thu,  3 Apr 2025 09:19:55 +0200
In-Reply-To: <20250403071953.2296514-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250403071953.2296514-5-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6600; i=ardb@kernel.org;
 h=from:subject; bh=2nAo/Tnu187qbmrnZyKTrYR/qO/zBrfZ9e5zFBj1pIc=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf2d2TyPr1cWfpE4sWfK+9vbW2KufdjYeehn/6fCWzbrj
 ffJOX2401HKwiDGwSArpsgiMPvvu52nJ0rVOs+ShZnDygQyhIGLUwAmUq3G8L9qslLLwy8t6l7/
 WQ5/F1x1wOnM5dw/JTF3f6nviuD7/lyf4a+YVHL81zi/mNQHmyM43i0y2vyP42h8nkDoz9SQSUY JBZwA
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250403071953.2296514-6-ardb+git@google.com>
Subject: [PATCH v2 1/3] crypto: arm/aes-ce - stop using the SIMD helper
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
 arch/arm/crypto/aes-ce-glue.c | 104 +++-----------------
 2 files changed, 11 insertions(+), 94 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 23e4ea067ddb..2e73200b930a 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -200,7 +200,6 @@ config CRYPTO_AES_ARM_CE
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
-	select CRYPTO_SIMD
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	   with block cipher modes:
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 1cf61f51e766..00591895d540 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,8 +10,6 @@
 #include <asm/simd.h>
 #include <linux/unaligned.h>
 #include <crypto/aes.h>
-#include <crypto/ctr.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
@@ -418,29 +416,6 @@ static int ctr_encrypt(struct skcipher_request *req)
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
@@ -586,10 +561,9 @@ static int xts_decrypt(struct skcipher_request *req)
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
@@ -600,10 +574,9 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -615,10 +588,9 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -631,10 +603,9 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -647,25 +618,9 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -679,51 +634,14 @@ static struct skcipher_alg aes_algs[] = { {
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

