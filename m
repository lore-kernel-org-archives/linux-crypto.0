Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58801C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB0520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tJXTXngG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFVTeq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53464 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVTeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so9147901wmj.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVlu3R/XDhYHCSEro6NMIXQLAFRHmhGDxGC17BFWD8A=;
        b=tJXTXngGIkeIZQnGKLux/rSvP5U7mbJawhh3jmft7Y/pQGJb+TpzXp780X+OOM65qF
         b6pkJwz8McIRpkJKNLg8KGTlFY7iBxHW9217gC455xLoOqgvsay3Nxhc+pCnM88frjlD
         YmA1ZH8x9jfKzjaXxYMngDCZAnCKSzjoJGeHObQb5UKgDfgtJlC8HPKPAvd9w4rCmvhZ
         JeA+M+3+JsEagV2/ST3lkUV6ZkNHelsfycvBBA0Ar/C/0ak+rHImTzwlLMcOkwda5vFb
         70ny267/gmzXz1Qt4TKuzre6cPikhx9WChKNyVy/rQVMUE5Mfavbu5JzTHERS8yxxKfv
         D+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVlu3R/XDhYHCSEro6NMIXQLAFRHmhGDxGC17BFWD8A=;
        b=NCcFOR2HKdv1yVbsVKKcbQwlxkGfyHS3DtKa2gQA/pbp7a9PE4W8INQpDDnS4hAb1O
         hY8fMwux4gaYKWJjHZcZkNqp6guk7hhgt+1gcY4zkCxnCz6GRe4NX9/Dk+18omMFamCv
         XyQBrgcrArwV2RT0Nkfxg0YhZ4/bRYVRV449nAUc2LrD0OUrBaY2JUACz1ro1dI0PYli
         8VU8S3NqEl9bYKdHdqYmOdIdPQWiaCBpwnyPCLWZvTJXe+yKWcmj8+60Khyxx+IUheao
         cGHQONPQ7B5t471ZkwlybGRNkE2ar3Cfi1anDWi9y5y7KmqN+osotyNwpc7PolZ4LZbn
         i6dA==
X-Gm-Message-State: APjAAAW2ns1Hz6vTV8yPuGHY7tLzbxnTsesuXsDJHA8opY2fpaX59TVX
        /htAw7Pco4Qentg2VO9nJ1O9meAmP0q7n5Wl
X-Google-Smtp-Source: APXvYqzHOoOowibabOzzMo7gGM5C2mckFe5N8rGKIlbWEQfAblah9aly1jjE6MtEz4sqUffMf/QqtA==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr9294082wmi.0.1561232083236;
        Sat, 22 Jun 2019 12:34:43 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 03/26] crypto: aes/fixed-time - align key schedule with other implementations
Date:   Sat, 22 Jun 2019 21:34:04 +0200
Message-Id: <20190622193427.20336-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

