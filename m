Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBC7C3F6B0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 15:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiHXP7O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiHXP7N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 11:59:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FC77D1D5
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso1916676pjr.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=1qu5V0DP8HWjRSqLnBYWB7NCHdOr6P94AQoSSZBfjm8=;
        b=k08zxUkY2+PMiHxVKHFwTgtjwTrZQjwub/107VYobleCDXuZX7Sm4vgRQXH7CP3Q1n
         InO2jvZPCsI9ukL+EexJZvnTcIJ2DBnWfvlH7u/9K/CeEQ58OvEeWqxtCpwCntADx5gJ
         Mj8bVeLC7hPW5aWKvkr8m5rYyR8uyIHASblkHUdprQMXrVWxyJZwocf6Dfv2k9x7P9RM
         jhSlxFPFVMGhd9hrQBY3SZvlR7m9LzhiuvhTJcwl2UDMnBQB/h/niNYP8RJzR7lATokZ
         HJeN11ZEmX7BIVspNNbUDOE13V9HwkNPhT5G1PCfX4/V6NT87CaPOs9EcpNRr3Lnp9Lf
         G41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=1qu5V0DP8HWjRSqLnBYWB7NCHdOr6P94AQoSSZBfjm8=;
        b=COsQ5AxodQcCII8L9/piUizmAulLOB6I/YCE6gdmBD9BCfUFmsll4a3edCaeaTe1Yr
         7Dt9meNvAL01wwOusI3n3H0cJkKI+vZxkUFM/H4WCpqTAeCIP1y99/FkCSA4wj7WZQjZ
         uGBph44g1ybzVbWGiWPCVmQjPrymF2qfv+FsVOJ07He/HszNGAlTdqFf7EcAJ2aDNEAT
         AHwDXKjbqPrmTTOBsO4vw/4WVuXmrQOqKUlzFAJxephC2vjGTINPN1BI0y/eiR51s7ws
         THn8QXikIR/sFdxsJtmbbNSUe6lbkHCp1PtAKXsxJd6BjH+WATEWg73xfYJf6pZm897l
         eWEQ==
X-Gm-Message-State: ACgBeo1E0gQPXiGxCCKC7xeqh2pgTdmgHw/vuVZ+Hq7yKrAeJHjTXUhC
        BAnB1T9wmZLB0PFBLCXe4L0a9943HP4=
X-Google-Smtp-Source: AA6agR48vXIldc5uzvmPmqD6oO3b2DersqQbluu4CHQRWdj1kfaQ8FOUU2ixzY78/raFgytIfjqjow==
X-Received: by 2002:a17:902:ef45:b0:170:8b19:4e0f with SMTP id e5-20020a170902ef4500b001708b194e0fmr29717127plx.120.1661356751253;
        Wed, 24 Aug 2022 08:59:11 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a034c00b001fb438fb772sm1540318pjf.56.2022.08.24.08.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:59:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     ap420073@gmail.com
Subject: [PATCH 1/3] crypto: aria: prepare generic module for optimized implementations
Date:   Wed, 24 Aug 2022 15:58:50 +0000
Message-Id: <20220824155852.12671-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220824155852.12671-1-ap420073@gmail.com>
References: <20220824155852.12671-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It renames aria to aria_generic and exports some functions such as
aria_set_key(), aria_encrypt(), and aria_decrypt() to be able to be
used by aria-avx implementation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 crypto/Makefile                   |  2 +-
 crypto/{aria.c => aria_generic.c} | 39 +++++++++++++++++++++++++------
 include/crypto/aria.h             | 14 +++++------
 3 files changed, 39 insertions(+), 16 deletions(-)
 rename crypto/{aria.c => aria_generic.c} (86%)

diff --git a/crypto/Makefile b/crypto/Makefile
index a6f94e04e1da..303b21c43df0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -149,7 +149,7 @@ obj-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
-obj-$(CONFIG_CRYPTO_ARIA) += aria.o
+obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
diff --git a/crypto/aria.c b/crypto/aria_generic.c
similarity index 86%
rename from crypto/aria.c
rename to crypto/aria_generic.c
index ac3dffac34bb..4cc29b82b99d 100644
--- a/crypto/aria.c
+++ b/crypto/aria_generic.c
@@ -16,6 +16,14 @@
 
 #include <crypto/aria.h>
 
+static const u32 key_rc[20] = {
+	0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0,
+	0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0,
+	0xdb92371d, 0x2126e970, 0x03249775, 0x04e8c90e,
+	0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0,
+	0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0
+};
+
 static void aria_set_encrypt_key(struct aria_ctx *ctx, const u8 *in_key,
 				 unsigned int key_len)
 {
@@ -25,7 +33,7 @@ static void aria_set_encrypt_key(struct aria_ctx *ctx, const u8 *in_key,
 	const u32 *ck;
 	int rkidx = 0;
 
-	ck = &key_rc[(key_len - 16) / 8][0];
+	ck = &key_rc[(key_len - 16) / 2];
 
 	w0[0] = be32_to_cpu(key[0]);
 	w0[1] = be32_to_cpu(key[1]);
@@ -163,8 +171,7 @@ static void aria_set_decrypt_key(struct aria_ctx *ctx)
 	}
 }
 
-static int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-			unsigned int key_len)
+int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key, unsigned int key_len)
 {
 	struct aria_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -179,6 +186,7 @@ static int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(aria_set_key);
 
 static void __aria_crypt(struct aria_ctx *ctx, u8 *out, const u8 *in,
 			 u32 key[][ARIA_RD_KEY_WORDS])
@@ -235,14 +243,30 @@ static void __aria_crypt(struct aria_ctx *ctx, u8 *out, const u8 *in,
 	dst[3] = cpu_to_be32(reg3);
 }
 
-static void aria_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+void aria_encrypt(void *_ctx, u8 *out, const u8 *in)
+{
+	struct aria_ctx *ctx = (struct aria_ctx *)_ctx;
+
+	__aria_crypt(ctx, out, in, ctx->enc_key);
+}
+EXPORT_SYMBOL_GPL(aria_encrypt);
+
+void aria_decrypt(void *_ctx, u8 *out, const u8 *in)
+{
+	struct aria_ctx *ctx = (struct aria_ctx *)_ctx;
+
+	__aria_crypt(ctx, out, in, ctx->dec_key);
+}
+EXPORT_SYMBOL_GPL(aria_decrypt);
+
+static void __aria_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aria_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	__aria_crypt(ctx, out, in, ctx->enc_key);
 }
 
-static void aria_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void __aria_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aria_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -263,8 +287,8 @@ static struct crypto_alg aria_alg = {
 			.cia_min_keysize	=	ARIA_MIN_KEY_SIZE,
 			.cia_max_keysize	=	ARIA_MAX_KEY_SIZE,
 			.cia_setkey		=	aria_set_key,
-			.cia_encrypt		=	aria_encrypt,
-			.cia_decrypt		=	aria_decrypt
+			.cia_encrypt		=	__aria_encrypt,
+			.cia_decrypt		=	__aria_decrypt
 		}
 	}
 };
@@ -286,3 +310,4 @@ MODULE_DESCRIPTION("ARIA Cipher Algorithm");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Taehee Yoo <ap420073@gmail.com>");
 MODULE_ALIAS_CRYPTO("aria");
+MODULE_ALIAS_CRYPTO("aria-generic");
diff --git a/include/crypto/aria.h b/include/crypto/aria.h
index 4a86661788e8..5b9fe2a224df 100644
--- a/include/crypto/aria.h
+++ b/include/crypto/aria.h
@@ -28,6 +28,7 @@
 #define ARIA_MIN_KEY_SIZE	16
 #define ARIA_MAX_KEY_SIZE	32
 #define ARIA_BLOCK_SIZE		16
+#define ARIA_AVX_BLOCK_SIZE	(ARIA_BLOCK_SIZE * 16)
 #define ARIA_MAX_RD_KEYS	17
 #define ARIA_RD_KEY_WORDS	(ARIA_BLOCK_SIZE / sizeof(u32))
 
@@ -38,14 +39,6 @@ struct aria_ctx {
 	u32 dec_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 };
 
-static const u32 key_rc[5][4] = {
-	{ 0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0 },
-	{ 0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0 },
-	{ 0xdb92371d, 0x2126e970, 0x03249775, 0x04e8c90e },
-	{ 0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0 },
-	{ 0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0 }
-};
-
 static const u32 s1[256] = {
 	0x00636363, 0x007c7c7c, 0x00777777, 0x007b7b7b,
 	0x00f2f2f2, 0x006b6b6b, 0x006f6f6f, 0x00c5c5c5,
@@ -458,4 +451,9 @@ static inline void aria_gsrk(u32 *rk, u32 *x, u32 *y, u32 n)
 		((y[(q + 2) % 4]) << (32 - r));
 }
 
+void aria_encrypt(void *ctx, u8 *out, const u8 *in);
+void aria_decrypt(void *ctx, u8 *out, const u8 *in);
+int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		 unsigned int key_len);
+
 #endif
-- 
2.17.1

