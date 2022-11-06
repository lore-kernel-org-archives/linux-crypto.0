Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2985FC4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 14:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiKFOhq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 09:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiKFOhp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 09:37:45 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2102DEBB
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 06:37:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so8500158pfb.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Nov 2022 06:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SYVgbzZfW20HOg79dWMdDLTVaQ7M0D6QCYU5eEmy2dU=;
        b=nyfIpzRa1eEtqKxnJOCLUT66yHljeAVx8NG3ROd5ZGt/yju4PjX+Yzz/ryc58Aqkm4
         WtRwnAKVtdqkNoaLCO2Ai16//agKbeqAbz+EVt3SD8/nC2lHA5WJyfGgwMWCkGYqDPx1
         z3MM2YLH8IXyOsMFMG3Yt4APk8nqY1O7taULjK5LjMuYmahDPBHGL80sRk8PsaEcXMzB
         liTpBGXv91J/jg6D3RCXGuHLlTryVZXdEP6ulDk0xJOVyssvH+ABzhNOJAlqqigk4LN6
         HeUrEPPWBYubzoiK609s7hC9BhtkosVlSaCJA68e5+KZchzGJ3q/1PD9zdkLB5RiTNZx
         3TqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYVgbzZfW20HOg79dWMdDLTVaQ7M0D6QCYU5eEmy2dU=;
        b=w2UcL/FMlXCkcsXWUY4VdLZQFAHmol9vcMEimn4VuwjXzDJBp1TdBdfnpDtVRE0epO
         T1Lw0xSKHZlZ91L//TgYd95Lhcb/ovM3Y/qfQ2tlqAzOiSD9UxGTLTnPsU/tdUf+9Ctn
         y8xPXzt0+e8LpiNTV1E5kTdIcq/8aqQl9yD74+nAHWhnmXSOWk9TADgjrJQgbSE9znhG
         6daA4JnVxf9gdN4uLJWJ1V1q6PiGG4y79PrNqG0CeBf2DSoxywsizN+6Rteb5jhP4QQx
         HGqNkgVycaU93TT0toG5v4vzJc3mWaaGFKN6HcZQtxu7sLpEjsQtXZRrCCckbbVqSK4R
         D/iA==
X-Gm-Message-State: ACrzQf37F2AUut0+pv0c5Rj1pTzjpR4JDMJp0XPq8B1pJ/z7nPaNuLC9
        QFPOlYXko5hXwclbRv90fuYyGqVhWI6R8fCp
X-Google-Smtp-Source: AMsMyM4qyBt12rcuttDhEv6VzzCBj04ePzyKCwyMg2Ez6D9um6HJ0TTK/VY0zYw9gl6qB4dniA1uEQ==
X-Received: by 2002:a05:6a00:1f06:b0:56c:ee8a:29f7 with SMTP id be6-20020a056a001f0600b0056cee8a29f7mr45840655pfb.44.1667745463076;
        Sun, 06 Nov 2022 06:37:43 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7973a000000b0056da2ad6503sm2696580pfg.39.2022.11.06.06.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 06:37:42 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v3 1/4] crypto: aria: add keystream array into struct aria_ctx
Date:   Sun,  6 Nov 2022 14:36:24 +0000
Message-Id: <20221106143627.30920-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221106143627.30920-1-ap420073@gmail.com>
References: <20221106143627.30920-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

avx accelerated aria module used local keystream array.
But, keystream array size is too big.
So, it puts the keystream array into struct aria_ctx.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - No changes.

v2:
 - Patch introduced.

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

