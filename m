Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48FBC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A36F52086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UJ27Ao12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF0K14 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:27:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34849 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF0K14 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:27:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id f15so1937981wrp.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVlu3R/XDhYHCSEro6NMIXQLAFRHmhGDxGC17BFWD8A=;
        b=UJ27Ao12RucOZXSw7oZqhFXuwtj3+u7hH2ANLe2rfHQwRMH/1ldc0qpLpuS4eP9iya
         zBtTzoESXoo1f52xoW7FCSaJv2m77g6Hk7g3nuR13HKWQmI2D++4OxHewIuI4zGP5vjv
         akUUab84w915ev/cn/DxbVI/Pu1z93Qlu6xDF2+HREYKDghT5TkGKTNd1sKjoiF+Jqld
         wt/qpE3LXtQ+FTFiyn3kK8qGb7TSwRowCwRd9hBgMAwz/kXeOZU8yJjVyyOOsXESu0dr
         MRopa9SEmtJ9evKMw3yQ5LLNH2l2imot8rhSFikNlm0qS+DzwIbnEUx2OsiwHUqC1Ndh
         JVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVlu3R/XDhYHCSEro6NMIXQLAFRHmhGDxGC17BFWD8A=;
        b=JjfDvGdXo74HEdPI59FCWE09FGz5hfy6OheMU8bEPnR5KRZjxS5X3so7BwYdAhEJk7
         ln4L7mFeyEEzopzoBZ1fVGqx36Q7Z9bQpdngxAIOoc5J7J+77AodQQzH/JDXQ41pAvEo
         p2Wy49fbuwvkj5BNC6dmNoBI5nV3HhfhY7D4rxXa8dpRVm5pGod/LefHfI6NfJwU/yg2
         2tAmSUUT5xWMgrpaEcopQPghJiX0VTVGWYmXW9aU46p/1COBD3CQhE+E6KYl2K905rAj
         JeG4cL8oGEScuXpk2QavR/1M4vrR69+EGWaV/S1r8vLPfZcl8LlpfNChXreGDzho+84Y
         3xlQ==
X-Gm-Message-State: APjAAAUG9K2q6531sv8TEp70RWySB/a2QMJaT5rhol+tlNINPwdrcQB0
        spwf9fNYa2c2pUGdU9uTspKulSGB/ao=
X-Google-Smtp-Source: APXvYqyEHGKEeyuCU2487HGPtbS5OZkTPSdqXRvNtkAZl9AenZ2lytd3x8xhJCMxSUp6bzpcMGmASA==
X-Received: by 2002:adf:c654:: with SMTP id u20mr2782163wrg.271.1561631273149;
        Thu, 27 Jun 2019 03:27:53 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 03/32] crypto: aes/fixed-time - align key schedule with other implementations
Date:   Thu, 27 Jun 2019 12:26:18 +0200
Message-Id: <20190627102647.2992-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The fixed time AES code mangles the key schedule so that xoring the
first round key with values at fixed offsets across the Sbox produces
the correct value. This primes the D-cache with the entire Sbox before
any data dependent lookups are done, making it more difficult to infer
key bits from timing variances when the plaintext is known.

The downside of this approach is that it renders the key schedule
incompatible with other implementations of AES in the kernel, which
makes it cumbersome to use this implementation as a fallback for SIMD
based AES in contexts where this is not allowed.

So let's tweak the fixed Sbox indexes so that they add up to zero under
the xor operation. While at it, increase the granularity to 16 bytes so
we cover the entire Sbox even on systems with 16 byte cachelines.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aes_ti.c | 52 ++++++++------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 1ff9785b30f5..fd70dc322634 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -237,30 +237,8 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err;
 
-	err = aesti_expand_key(ctx, in_key, key_len);
-	if (err)
-		return err;
-
-	/*
-	 * In order to force the compiler to emit data independent Sbox lookups
-	 * at the start of each block, xor the first round key with values at
-	 * fixed indexes in the Sbox. This will need to be repeated each time
-	 * the key is used, which will pull the entire Sbox into the D-cache
-	 * before any data dependent Sbox lookups are performed.
-	 */
-	ctx->key_enc[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
-	ctx->key_enc[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
-	ctx->key_enc[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
-	ctx->key_enc[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224];
-
-	ctx->key_dec[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
-	ctx->key_dec[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
-	ctx->key_dec[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
-	ctx->key_dec[3] ^= __aesti_inv_sbox[96] ^ __aesti_inv_sbox[224];
-
-	return 0;
+	return aesti_expand_key(ctx, in_key, key_len);
 }
 
 static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -283,10 +261,16 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	 */
 	local_irq_save(flags);
 
-	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
-	st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
-	st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
-	st0[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224];
+	/*
+	 * Force the compiler to emit data independent Sbox references,
+	 * by xoring the input with Sbox values that are known to add up
+	 * to zero. This pulls the entire Sbox into the D-cache before any
+	 * data dependent lookups are done.
+	 */
+	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[ 64] ^ __aesti_sbox[134] ^ __aesti_sbox[195];
+	st0[1] ^= __aesti_sbox[16] ^ __aesti_sbox[ 82] ^ __aesti_sbox[158] ^ __aesti_sbox[221];
+	st0[2] ^= __aesti_sbox[32] ^ __aesti_sbox[ 96] ^ __aesti_sbox[160] ^ __aesti_sbox[234];
+	st0[3] ^= __aesti_sbox[48] ^ __aesti_sbox[112] ^ __aesti_sbox[186] ^ __aesti_sbox[241];
 
 	for (round = 0;; round += 2, rkp += 8) {
 		st1[0] = mix_columns(subshift(st0, 0)) ^ rkp[0];
@@ -331,10 +315,16 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	 */
 	local_irq_save(flags);
 
-	st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
-	st0[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
-	st0[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
-	st0[3] ^= __aesti_inv_sbox[96] ^ __aesti_inv_sbox[224];
+	/*
+	 * Force the compiler to emit data independent Sbox references,
+	 * by xoring the input with Sbox values that are known to add up
+	 * to zero. This pulls the entire Sbox into the D-cache before any
+	 * data dependent lookups are done.
+	 */
+	st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[ 64] ^ __aesti_inv_sbox[129] ^ __aesti_inv_sbox[200];
+	st0[1] ^= __aesti_inv_sbox[16] ^ __aesti_inv_sbox[ 83] ^ __aesti_inv_sbox[150] ^ __aesti_inv_sbox[212];
+	st0[2] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[ 96] ^ __aesti_inv_sbox[160] ^ __aesti_inv_sbox[236];
+	st0[3] ^= __aesti_inv_sbox[48] ^ __aesti_inv_sbox[112] ^ __aesti_inv_sbox[187] ^ __aesti_inv_sbox[247];
 
 	for (round = 0;; round += 2, rkp += 8) {
 		st1[0] = inv_mix_columns(inv_subshift(st0, 0)) ^ rkp[0];
-- 
2.20.1

