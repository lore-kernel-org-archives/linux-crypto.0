Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2976BECAAD3
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 09:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiIEJpZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 05:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbiIEJpX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 05:45:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2203928708
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 02:45:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3216645pjd.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Sep 2022 02:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=jAbnR1WcOSr7dNDmSjNm0bAiSuQBdY0XKPiGezt/ASo=;
        b=DxEoSuQ00aBGWW1vGzvyFWNijFxRnFoKSmIh6DnGhRLg8lqnazJl3Gp9yy4PoW4z1q
         PJt/OjXMjq7MZOT2KttVwbLe41Tz4HPKsSvxhbgptp7h3hrDABQ37tz3qJ2IU/E7kPK/
         hdMQ7spgfxXJIt+RFHkfO7+gN0oH72GS84S6v5ZcDgFa6wIGZfV7NiSG9S0tWXWJIov3
         2GvJOp6HTgWnDTKvLiB/RkJzKCovTeJ0Yt4wGOS/avvfvq8h1hFa3OSwyivMg4whbRHP
         IW/UgW6BNgKila5qliOzTVNKFrX94dIfF8ckcMZbdUZD5GXeipneNeTc0CRkQ/wrdPB6
         +9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jAbnR1WcOSr7dNDmSjNm0bAiSuQBdY0XKPiGezt/ASo=;
        b=hm270YSc2n7tBEoXAgpv5FbSa1DViIPhXgQmsFnNEVRi6Lb6EZ7CDQm+TsBKMKchxs
         LOqV9L6LqspnjW6hVgVOoVHPfgyRgEcZsv3H0dpF9L6+HyQHSqpJ+fO4NaSoING0dG5B
         LLWMIrUf6sxQuuu2R3gZxFi+GeNLX//Q3hlj5JximsfmNVWV9JX7dJ3BS5tr3BmsjgRA
         DFEX9OKMggrGNDvsUNpTSITquBM46lCbYsawA5KSG+WrhW+DhWOyQlkXNaduN7fqBG9/
         M/1utjDsgrrXoEw9lUJz19TfQOFFx0946gEjJKO7uHoz7WtWyCpYruih/tWSpyvwFS4D
         ZVkA==
X-Gm-Message-State: ACgBeo04mEjZoQYKvq879dyjyOQdsx/wC7DMBG0UYvFuez2Avef0GG7I
        15fqwHZryKvv3ZV7EgE5duYdwXmC6dQ=
X-Google-Smtp-Source: AA6agR6+3+uicvrBxWtRwyLaqAzF86VQ3sBS7YXqcCFmmXHjgMY0YwLRVARRFiQ9gtdxArurawkZmg==
X-Received: by 2002:a17:902:f641:b0:172:e2f8:7efb with SMTP id m1-20020a170902f64100b00172e2f87efbmr46801346plg.140.1662371121507;
        Mon, 05 Sep 2022 02:45:21 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b3-20020a170903228300b00176bfd3b6bdsm545617plh.132.2022.09.05.02.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 02:45:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com
Cc:     ap420073@gmail.com
Subject: [PATCH v3 1/3] crypto: aria: prepare generic module for optimized implementations
Date:   Mon,  5 Sep 2022 09:45:01 +0000
Message-Id: <20220905094503.25651-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220905094503.25651-1-ap420073@gmail.com>
References: <20220905094503.25651-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It renames aria to aria_generic and exports some functions such as
aria_set_key(), aria_encrypt(), and aria_decrypt() to be able to be
used by aria-avx implementation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - No changes.

v2:
 - No changes.

 crypto/Makefile                   |  2 +-
 crypto/{aria.c => aria_generic.c} | 39 +++++++++++++++++++++++++------
 include/crypto/aria.h             | 17 ++++++--------
 3 files changed, 40 insertions(+), 18 deletions(-)
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
index 4a86661788e8..254da46cc385 100644
--- a/include/crypto/aria.h
+++ b/include/crypto/aria.h
@@ -32,18 +32,10 @@
 #define ARIA_RD_KEY_WORDS	(ARIA_BLOCK_SIZE / sizeof(u32))
 
 struct aria_ctx {
-	int key_length;
-	int rounds;
 	u32 enc_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 	u32 dec_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
-};
-
-static const u32 key_rc[5][4] = {
-	{ 0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0 },
-	{ 0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0 },
-	{ 0xdb92371d, 0x2126e970, 0x03249775, 0x04e8c90e },
-	{ 0x517cc1b7, 0x27220a94, 0xfe13abe8, 0xfa9a6ee0 },
-	{ 0x6db14acc, 0x9e21c820, 0xff28b1d5, 0xef5de2b0 }
+	int rounds;
+	int key_length;
 };
 
 static const u32 s1[256] = {
@@ -458,4 +450,9 @@ static inline void aria_gsrk(u32 *rk, u32 *x, u32 *y, u32 n)
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

