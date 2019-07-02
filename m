Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724E4C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D4D21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j0cjnk38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBTmQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42319 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBTmQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id x144so12265013lfa.9
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pFttl+7mb3vlqjJiXTJxAK+LxJsUUATYj2v8abg1GY4=;
        b=j0cjnk38DJZNlyZr0cmMtPWv/0AjLcJBcNbJqZp5molS9GAhnNjoOaYuG93vDUDSl+
         ugTF+1mRM+yyo2Y4zeWPd3RshDA9Fyivzy14e0zmHp0hAxel58NPIQC1m+8g/5JVuhso
         AQe1EJNMgQbYYuHjqWOkSYDB7kZvOQElUYKTFc4LJ1xOS9YT26/1QUczclgvfmmO2HV/
         kJ2hKtF8WGuLCz7qhnttgp5Onyfc8nOekaohAl7RxULopkRpFS2KlN3hcDnw/WpPsZxW
         zwPtGUrODx8241JB61TUv3spof8OYwNG9db2giSddAtVanWijb/Xtq43a6ASFtE6HZDX
         WEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pFttl+7mb3vlqjJiXTJxAK+LxJsUUATYj2v8abg1GY4=;
        b=Q6EEDkocNrTFzbmqoTwavUOHaYYZ4hFESQpEsnTq0VU0vNaPXGf21SLEkg1bTx1KSz
         9cLdHfrX1mVQgGdDAnbqa2I+CUiQW8dTiUftXrFzQ5YTzs4xNwSpPneJVqHLCna6caiD
         Z7QR/copvmjpxEYxJa2aJiUDEzsF2YIiI/T7296z+1Hll8JKs+V5weqvrlPU19Hlnj2N
         PrnLkauLR7LeG0SjyofA1Bnkq5NorgDwpXTZCURyhQcra8+g85ABFwW+MBXBj2XjIwbq
         YPDNvluVMkiZruqGYJ4++7hg9tRXuaTeSMXWt58wAckYYi9y0fBnwVK8a812HgRAINjE
         X97w==
X-Gm-Message-State: APjAAAVC/EWMMUG9xo7cNapxWlNxRnKB3OxjkX/I2wR/mcDHiAYj8kdQ
        MrDEn4ddPBLKJMTztePKoGd+guUpuogAe1Mg
X-Google-Smtp-Source: APXvYqxNLGVH52fwgZTRh0uQXIGRTrsDVa4GAvxzpqS3Jxt3oS2+N0JD8IKqAFVU0tSSPePA0PZniw==
X-Received: by 2002:a19:5e4e:: with SMTP id z14mr12899379lfi.11.1562096534300;
        Tue, 02 Jul 2019 12:42:14 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 03/32] crypto: aes/fixed-time - align key schedule with other implementations
Date:   Tue,  2 Jul 2019 21:41:21 +0200
Message-Id: <20190702194150.10405-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

