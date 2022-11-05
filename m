Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9629EC433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 08:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiKEIUz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 04:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKEIUy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 04:20:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4632BB26
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 01:20:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so9007192pjh.1
        for <linux-crypto@vger.kernel.org>; Sat, 05 Nov 2022 01:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hpNEWYBuuMyfJRMtYuzqcVYVfNG+SwCQTcYtD7LMpt4=;
        b=Tjl7j5X2PfxA6VDLNOo8hF8sIJjBiJqJ7yKfHcsEkhMR01hlzIVdr/WD3C5/oLSbve
         PGVQpXoojUs38P2QO/L41ti1pDrzvTAzHg4CWrpp+kI8COLizqFCf373PNHOMQvYqKUL
         PhIw1ELX3a6HxMrhDqKuSzXgFAkZPbt3z6d/U61yqrU0sakecAcc8N8Ahc7gNfTuOVK7
         F2bXJnzaRWtZMJncAMx+/IU7PCe9EUTaASr9SOdUUdy6Ov+xzBIXJOdsexRuMTFoIslB
         cEtk72hTGdzH0QrT5YxpOowq87lTfnBNqEQMqApVUDjLpj8PxbeM8729njHfe9K2khcX
         a6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hpNEWYBuuMyfJRMtYuzqcVYVfNG+SwCQTcYtD7LMpt4=;
        b=SRyt2n7wx2Vz9cIF1NAjfIWG70yRcO0K5A6hZHhlBKhKtho/h9HzUW2GgdH+etXkHn
         9OEo22oIHw3TNd2aCQwCJdTXDSGCGPSPCbNNO8XZY/o/3Addq7DeG+En+bg+Wage1KAD
         ll3b7q2s1ypksgIkAfRo6WnAajNZNpHotlz3swhBogJtFUGP1j+uYLnagfnH3XAJqrbU
         9yYvek61OLu6BmF42lvjJ4R9+FaV7TKGKqbaLgxCTfv6B6sS2EJ3SeGGCgUOb2zuaPho
         up0NsUtecyUgp6n5BWwgtC153ze7oLgmhu0hnkgRzvj5Nbbf3jlDPDaBqqr5g/EYHMHI
         +R6A==
X-Gm-Message-State: ACrzQf3DAkWQ5LI5dlPSDVl4uqUBxYSihfjpA5KY+iUghEhqycRBrI6q
        8A/RJ+Z9+2l1Api1XyrFoVdC5qE1d9qQVsnj
X-Google-Smtp-Source: AMsMyM6eybBVlGHCHz12p1mNpu1XQY6LfT8xow39ez9Khrr1cbYnFBMBJW3gXQpYhbk7fioSoTxBDQ==
X-Received: by 2002:a17:902:aa46:b0:186:e220:11d4 with SMTP id c6-20020a170902aa4600b00186e22011d4mr39893897plr.163.1667636448829;
        Sat, 05 Nov 2022 01:20:48 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id pv7-20020a17090b3c8700b00213c7cf21c0sm837648pjb.5.2022.11.05.01.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 01:20:48 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v2 1/3] crypto: aria: add keystream array into struct aria_ctx
Date:   Sat,  5 Nov 2022 08:20:19 +0000
Message-Id: <20221105082021.17997-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221105082021.17997-1-ap420073@gmail.com>
References: <20221105082021.17997-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

avx accelerated aria module used local keystream array.
But, keystream array size is too big.
So, it puts the keystream array into struct aria_ctx.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - patch introduced

 arch/x86/crypto/aria-avx.h            |  3 ---
 arch/x86/crypto/aria_aesni_avx_glue.c | 24 +++++++++++-------------
 include/crypto/aria.h                 | 11 +++++++++++
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/aria-avx.h b/arch/x86/crypto/aria-avx.h
index 01e9a01dc157..afd37af95e58 100644
--- a/arch/x86/crypto/aria-avx.h
+++ b/arch/x86/crypto/aria-avx.h
@@ -4,9 +4,6 @@
 
 #include <linux/types.h>
 
-#define ARIA_AESNI_PARALLEL_BLOCKS 16
-#define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 16)
-
 struct aria_avx_ops {
 	void (*aria_encrypt_16way)(const void *ctx, u8 *dst, const u8 *src);
 	void (*aria_decrypt_16way)(const void *ctx, u8 *dst, const u8 *src);
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index c561ea4fefa5..b122482d0c9d 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -86,10 +86,9 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 
 		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
-			u8 keystream[ARIA_AESNI_PARALLEL_BLOCK_SIZE];
-
 			kernel_fpu_begin();
-			aria_ops.aria_ctr_crypt_16way(ctx, dst, src, keystream,
+			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
+						      &ctx->keystream[0],
 						      walk.iv);
 			kernel_fpu_end();
 			dst += ARIA_AESNI_PARALLEL_BLOCK_SIZE;
@@ -98,28 +97,27 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 		}
 
 		while (nbytes >= ARIA_BLOCK_SIZE) {
-			u8 keystream[ARIA_BLOCK_SIZE];
-
-			memcpy(keystream, walk.iv, ARIA_BLOCK_SIZE);
+			memcpy(&ctx->keystream[0], walk.iv, ARIA_BLOCK_SIZE);
 			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
 
-			aria_encrypt(ctx, keystream, keystream);
+			aria_encrypt(ctx, &ctx->keystream[0],
+				     &ctx->keystream[0]);
 
-			crypto_xor_cpy(dst, src, keystream, ARIA_BLOCK_SIZE);
+			crypto_xor_cpy(dst, src, &ctx->keystream[0],
+				       ARIA_BLOCK_SIZE);
 			dst += ARIA_BLOCK_SIZE;
 			src += ARIA_BLOCK_SIZE;
 			nbytes -= ARIA_BLOCK_SIZE;
 		}
 
 		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[ARIA_BLOCK_SIZE];
-
-			memcpy(keystream, walk.iv, ARIA_BLOCK_SIZE);
+			memcpy(&ctx->keystream[0], walk.iv, ARIA_BLOCK_SIZE);
 			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
 
-			aria_encrypt(ctx, keystream, keystream);
+			aria_encrypt(ctx, &ctx->keystream[0],
+				     &ctx->keystream[0]);
 
-			crypto_xor_cpy(dst, src, keystream, nbytes);
+			crypto_xor_cpy(dst, src, &ctx->keystream[0], nbytes);
 			dst += nbytes;
 			src += nbytes;
 			nbytes = 0;
diff --git a/include/crypto/aria.h b/include/crypto/aria.h
index 254da46cc385..f5c7a87378cd 100644
--- a/include/crypto/aria.h
+++ b/include/crypto/aria.h
@@ -31,11 +31,22 @@
 #define ARIA_MAX_RD_KEYS	17
 #define ARIA_RD_KEY_WORDS	(ARIA_BLOCK_SIZE / sizeof(u32))
 
+#define ARIA_AESNI_PARALLEL_BLOCKS 16
+#define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 16)
+#if defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) ||	\
+	defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64_MODULE)
+#define ARIA_KEYSTREAM_SIZE ARIA_AESNI_PARALLEL_BLOCK_SIZE
+#endif
+
 struct aria_ctx {
 	u32 enc_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 	u32 dec_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 	int rounds;
 	int key_length;
+#if defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) ||	\
+	defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64_MODULE)
+	u8 keystream[ARIA_KEYSTREAM_SIZE];
+#endif
 };
 
 static const u32 s1[256] = {
-- 
2.17.1

