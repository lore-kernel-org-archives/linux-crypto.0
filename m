Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF33AECAAD2
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 05:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbiHZFby (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHZFbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 01:31:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67039CD78A
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo7056318pjd.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=/1g73bWzU15F7/7ds3diVHaLTH0CEk0tnk1nL3e8bCI=;
        b=LgZmBpk+v5KlUBupFKGd/6hJzvp833j5kEHoOWqFIdoIjTM2xu6SXPWpXtPWXrZA3f
         IgtABw3laHhX/6umVZ3y8fhJrK/tQ/Tvno4rP/4CeLBlIr7xcatEMnytpAJP7/3x9mKN
         rM3vpB+yT1TzbPJlCfY5ISsxE6w6XpsbHgpqFyBhD+uwvjZAz0LQyf9MS3paeBul21MG
         2T1YaLeIiD6Mn6+U+633dodM199cF8sJFMXD7Az3FiH3Nsxoqy8rx2JGVAg8WB76juOG
         j4eB+wAavF0VhmgNnYtPptTlRcBInJr1mDhVgHMAI8wntWC+uGs+7d3k3bPNJa+exYKt
         Gkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=/1g73bWzU15F7/7ds3diVHaLTH0CEk0tnk1nL3e8bCI=;
        b=nUefDf+GxCVTq991ZllzOXe5A1X3GKYSOKTUPZgzuegTSh6UBjvhbCt54KMScLw6OD
         hvA8CTJTSlWEr+UIbz0Gtsqz1Pk5qFVCDwyd2uNOBCP2TNu3zWPooFUVRrEFkodwB/FF
         ZFeh6Fs3Xt/LFyqOB94KXjU9rOkn/driDmN7ZQCNfkUdHWetz4Pud15MKr6rZSPvJBcQ
         Pi1Q77ELn121vt0OpZjRCKORZFNW7bNil841h1Hdv8rUf1Pe7nWewdTm35rOJVqAF5Iw
         VckjsgOreY7OUwAbDdRPcwM8raPnTygrmitaWr5uqx1XvUcScK/V2rlgYn7YJsipmW6C
         CrDA==
X-Gm-Message-State: ACgBeo231sWoFA9R40AuLaECPqljtsGDk7s3Dwi2SW7dUbID4zf3dSV3
        a5v90mV2qd5LG7gMECsVi7xfIa+CbqE=
X-Google-Smtp-Source: AA6agR5li4Xl5+Ghdjobh0dbCu2g0t6W8u4l3vCW5X8ao642InyW78zYMRccoCpH/62d6bXmE9EiEA==
X-Received: by 2002:a17:902:e5c2:b0:172:f66b:c760 with SMTP id u2-20020a170902e5c200b00172f66bc760mr2327352plf.92.1661491910625;
        Thu, 25 Aug 2022 22:31:50 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b00172925f3c79sm545726pla.153.2022.08.25.22.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 22:31:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     elliott@hpe.com, ap420073@gmail.com
Subject: [PATCH v2 1/3] crypto: aria: prepare generic module for optimized implementations
Date:   Fri, 26 Aug 2022 05:31:29 +0000
Message-Id: <20220826053131.24792-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220826053131.24792-1-ap420073@gmail.com>
References: <20220826053131.24792-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It renames aria to aria_generic and exports some functions such as
aria_set_key(), aria_encrypt(), and aria_decrypt() to be able to be
used by aria-avx implementation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes

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

