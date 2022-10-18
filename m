Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E47C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 23:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiJRXFU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJRXE5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 19:04:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C56A22BC2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 16:04:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349423f04dbso154700687b3.13
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 16:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/k50xcora8SusgWH3PC14s9L2Ta+3apzzJKJhsds4aQ=;
        b=Ex5XMJrkse9STYw9ZDiUFUgkqKcQV7UAnfL8qqxPTT7wSILe1Pd9egosOfYxh0shn8
         sjrmCZqKm4fAk+PZBqqMNvAZ/O8oRDilep2AOwiQPbsfzuG7uAdWOEo99mPbpPfPN5IQ
         hrIypZ+r27+++zVjtnL6v7AAPq4nBJThSYMpsQLhCF5BMWbALoZZnNcBvhbQ338gvima
         GKiMB4usiu6YqkWgHYYV+qcj9+h/XWLWBnO+0XcHw4Tj3outSR86xz93g++zepNrYuoj
         4ZT4ADUS4Md6xJhXE7PbCmpXevqP993WJ/Phmc1ak3nv5GJNH1hAw1YTrkNpNhajP+yE
         f4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/k50xcora8SusgWH3PC14s9L2Ta+3apzzJKJhsds4aQ=;
        b=NA2sy5qYAhunVf2/ZdkMHkEh4c4X20Q9DtzydM9SZd/9a6RV3yF2ZPotjvdUxsGH36
         Et4miKaMNKfetAnec3vYi7vOnm+nZeaFQedeampfIJ/YpIKPqlUGgcpJCPFp26rLCmSH
         yDSQLyICaeogM/XagLh5hRge74xnayiGLtC0i1FW18pNcp0h0AMrLTDVSJJF5HKInEYd
         rqswgB7Xr7XEOWxseux8FDv14jwBrLEEqxMra/Eg20NBJdK1ooMdz/7ic/ZxPKqt7GxC
         yKXMoaNqM1en0qYX+Iya98/nhHowsW3ykt8pVluJCRnQdQPfnGowSSL+WuGOojXuyQJj
         jv5Q==
X-Gm-Message-State: ACrzQf3qsrb2aLs3yKqqMIiw/eUF6DH0efvTxHyyTnjXKuWYg7C8fd9O
        sVsGWG8Iz/CTE4Z03pye1f25WuYIJQ==
X-Google-Smtp-Source: AMsMyM42OmmsI248GW1q6Cx2tnJLcApQITiriyV5uHtjNqgqP/EHV7at+rjrjiCxXNjcNIf8GTBMt3cYUA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:8e0a:0:b0:6be:fb9a:9027 with SMTP id
 p10-20020a258e0a000000b006befb9a9027mr4585013ybl.8.1666134280586; Tue, 18 Oct
 2022 16:04:40 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:04:12 -0700
In-Reply-To: <Y08rHF09/qxCVK+K@sol.localdomain>
Mime-Version: 1.0
References: <Y08rHF09/qxCVK+K@sol.localdomain>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018230412.886349-1-nhuck@google.com>
Subject: [PATCH v3] crypto: x86/polyval - Fix crashes when keys are not
 16-byte aligned
From:   Nathan Huckleberry <nhuck@google.com>
To:     ebiggers@kernel.org
Cc:     ardb@kernel.org, bgoncalv@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, nhuck@google.com, tglx@linutronix.de,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_tfm::__crt_ctx is not guaranteed to be 16-byte aligned on x86-64.
This causes crashes due to movaps instructions in clmul_polyval_update.

Add logic to align polyval_tfm_ctx to 16 bytes.

Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/polyval-clmulni_glue.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
index b7664d018851..8fa58b0f3cb3 100644
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
@@ -45,6 +49,11 @@ asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator);
 asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
 
+static inline struct polyval_tfm_ctx *polyval_tfm_ctx(struct crypto_shash *tfm)
+{
+	return PTR_ALIGN(crypto_shash_ctx(tfm), POLYVAL_ALIGN);
+}
+
 static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
@@ -72,7 +81,7 @@ static void internal_polyval_mul(u8 *op1, const u8 *op2)
 static int polyval_x86_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
-	struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+	struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(tfm);
 	int i;
 
 	if (keylen != POLYVAL_BLOCK_SIZE)
@@ -102,7 +111,7 @@ static int polyval_x86_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
 	u8 *pos;
 	unsigned int nblocks;
 	unsigned int n;
@@ -143,7 +152,7 @@ static int polyval_x86_update(struct shash_desc *desc,
 static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
 
 	if (dctx->bytes) {
 		internal_polyval_mul(dctx->buffer,
@@ -167,7 +176,7 @@ static struct shash_alg polyval_alg = {
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

