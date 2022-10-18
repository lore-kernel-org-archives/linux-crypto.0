Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685D4C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 21:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJRV4m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJRV4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 17:56:41 -0400
Received: from mail-vk1-xa4a.google.com (mail-vk1-xa4a.google.com [IPv6:2607:f8b0:4864:20::a4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD697D52
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 14:56:40 -0700 (PDT)
Received: by mail-vk1-xa4a.google.com with SMTP id y198-20020a1f32cf000000b003af0002920fso2666974vky.9
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 14:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m7J+/b5/L0nQHPU1N8gvtVOb8AwUDuLMMuB/44yFdGw=;
        b=mEO2pPTxKmNgWoZtl0QxarEGwuWxwB5IlUJOcOiG99LrRsWMdv5m6glj1IUBip4WCN
         5suO/47EjfF9pPx4xUfqzVWXv07PSgNVIFbPKvRfR4OjyQM87lxjnbKfwCEvjquoKZJ6
         J0eviU7IkE+awbL7gWM/iQRVo5YQAFNQdCaFXY1nehdOSxffeuH6RBSX2/OlNSTsCiHS
         WnUKkhIoBHSXMv87CJsewUE/kkuIhsYEqZ9j6aSU73ryyMG6Yce0hc1+tSb00Tq2kRuu
         aWALp+a/U1w13NJXPFLRWgaVoe5yMWNMJVb9ioj2LOy1fTTmTRt9A4wKemWOPLDcrzrf
         8GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7J+/b5/L0nQHPU1N8gvtVOb8AwUDuLMMuB/44yFdGw=;
        b=7oNwK+sH8kMWHfsa/G0yYgkjPFt9l9QhZDyUK8+xIjAkn/L1YSUoglJtfCnMsdE/dG
         5lcrqI9rwGGSBSQEhzbJCpnbICAf6KnZmzjKnpNQRK27wDyuJKEmLJNgbO3cIDhLsLcG
         dU0+OXJOTn0YgS2rS7gCYJjGq4Ti9L03PlPFAsLpZXTo6WkiErl9XLoy8C4xf+Az+GOh
         C0oMuhCQmy9Pqoou58InWSm+E/t56yZLlLaZ1yWidmscQHuvK9FOxLOp/tEHqB61CKBN
         J3qG19yyuUvrWyHOcT1EdMqi6IluoeuXV33f4RxUyTgvQJAhAURHAhsXLas1r6GDYtEC
         6RPw==
X-Gm-Message-State: ACrzQf3FamyaA602FpRpy4lU79UsGPZdvkPqQB36bmvE1lX2Zfj798Mi
        qDvtkn3J5yp6N++Pb3JC+1iwfASlOg==
X-Google-Smtp-Source: AMsMyM6swT74DF3e/aSs3KGk5NJODczWqA8x54vzE4y3j/+jMsMvWGFakKgx7XSQB8uYv/1BgYP+tWrgCQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6122:4f8:b0:3ae:21f7:28da with SMTP id
 s24-20020a05612204f800b003ae21f728damr2502221vkf.33.1666130199389; Tue, 18
 Oct 2022 14:56:39 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:56:23 -0700
In-Reply-To: <Y04lhwMechdfBkUU@gondor.apana.org.au>
Mime-Version: 1.0
References: <Y04lhwMechdfBkUU@gondor.apana.org.au>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018215623.866014-1-nhuck@google.com>
Subject: [PATCH v2] crypto: x86/polyval - Fix crashes when keys are not
 16-byte aligned
From:   Nathan Huckleberry <nhuck@google.com>
To:     herbert@gondor.apana.org.au
Cc:     ardb@kernel.org, bgoncalv@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, davem@davemloft.net,
        ebiggers@kernel.org, hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, nhuck@google.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_tfm::__crt_ctx is not guaranteed to be 16-byte aligned on x86-64.
This causes crashes due to movaps instructions in clmul_polyval_update.

Add logic to align polyval_tfm_ctx to 16 bytes if required.

Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/polyval-clmulni_glue.c | 29 ++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
index b7664d018851..79ad497c32b5 100644
--- a/arch/x86/crypto/polyval-clmulni_glue.c
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -27,13 +27,17 @@
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
+#define POLYVAL_ALIGN	16
+#define POLYVAL_ALIGN_ATTR __aligned(POLYVAL_ALIGN)
+#define POLYVAL_ALIGN_EXTRA ((POLYVAL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+#define POLYVAL_CTX_SIZE (sizeof(struct polyval_tfm_ctx) + POLYVAL_ALIGN_EXTRA)
 #define NUM_KEY_POWERS	8
 
 struct polyval_tfm_ctx {
 	/*
 	 * These powers must be in the order h^8, ..., h^1.
 	 */
-	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
+	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE] POLYVAL_ALIGN_ATTR;
 };
 
 struct polyval_desc_ctx {
@@ -45,9 +49,20 @@ asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator);
 asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
 
-static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
+static inline struct polyval_tfm_ctx *polyval_tfm_ctx(const void *raw_ctx)
+{
+	unsigned long addr = (unsigned long)raw_ctx;
+	unsigned long align = POLYVAL_ALIGN;
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+	return (struct polyval_tfm_ctx *)ALIGN(addr, align);
+}
+
+static void internal_polyval_update(const void *raw_keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
+	const struct polyval_tfm_ctx *keys = polyval_tfm_ctx(raw_keys);
 	if (likely(crypto_simd_usable())) {
 		kernel_fpu_begin();
 		clmul_polyval_update(keys, in, nblocks, accumulator);
@@ -72,7 +87,7 @@ static void internal_polyval_mul(u8 *op1, const u8 *op2)
 static int polyval_x86_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
-	struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+	struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(crypto_shash_ctx(tfm));
 	int i;
 
 	if (keylen != POLYVAL_BLOCK_SIZE)
@@ -102,7 +117,8 @@ static int polyval_x86_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx =
+	    polyval_tfm_ctx(crypto_shash_ctx(desc->tfm));
 	u8 *pos;
 	unsigned int nblocks;
 	unsigned int n;
@@ -143,7 +159,8 @@ static int polyval_x86_update(struct shash_desc *desc,
 static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx =
+	    polyval_tfm_ctx(crypto_shash_ctx(desc->tfm));
 
 	if (dctx->bytes) {
 		internal_polyval_mul(dctx->buffer,
@@ -167,7 +184,7 @@ static struct shash_alg polyval_alg = {
 		.cra_driver_name	= "polyval-clmulni",
 		.cra_priority		= 200,
 		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
+		.cra_ctxsize		= POLYVAL_CTX_SIZE,
 		.cra_module		= THIS_MODULE,
 	},
 };
-- 
2.38.0.413.g74048e4d9e-goog

