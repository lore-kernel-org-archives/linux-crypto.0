Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7288DC54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 12:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIPM6H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiIPM6C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 08:58:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20B7F244
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:58:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so25611699pjm.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=NhrqvZnuCci1IT2EJoYVm3Gz6nKG5qgvgSBl8lC0wuI=;
        b=g8Z8/IKXJOcv5iloSzH+uybTFS1ICtauq+zJ+Z8SCZZ+b2hhbv0i4GVyeF1OZaoHFz
         yRpBsTKu4xUoDs7iNyzLd4w8jDDL5V/CLfd8ZW93gyTthi35H1hgvm5nEx3F0H4wKUHM
         rwgEzWRQHzy+qv9qlm4cqC9H1N4JDekGCUeAAkRvO0asca7V7Gbo+/ffd604+57cY5ng
         UGs823lVNvzP2/Xvu3asSgIOhMGjewR2o7IrX6rL4A/WdTfk+qCzotn3tHrt2VUNNwMl
         OuCyVVwbzg96bqp8CwT/t3SAO1QwaKxdW51rCI7wZO1HnbRUXALq4OL4Wcosc2TV7yVt
         qYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NhrqvZnuCci1IT2EJoYVm3Gz6nKG5qgvgSBl8lC0wuI=;
        b=Z47WgP3cM/rO6e4C7idHtn/SMFfnaKi12oKD0ijC9xiiBORPScL04BSfVkLfzeGmhN
         ebg35ez5OqaKbAMomW4L64KieBFiIEuA0CRWS2vajrOWW9WodoJ0M6hTnHaGRVU3AGlx
         Ff//EGl8MNsjMK1Guyu0M4WqffOAKIv8rZKWGl5vcczGoqZjvE89jLFcn9W9hmZA8crP
         5oyAf3xVescprzBTNJRIh+E7fehw3Zvjejcc0hiYFMM7+ooBQH3PC12KyJaX45CGhaKL
         ggWQ+2D87bnlXIRZkmmgbxjJOoCAYeASNMyFefYm/ec4gKw852ArJjyT8NHRq+yQge9v
         jrNA==
X-Gm-Message-State: ACrzQf0Ub/H29VkyqXgRhvP2YA7/WHiLJga+ZCBFYwVHOQf9RUqb61a/
        Wm6TgUxN5yUi7wfs3BrV/xtdtzlj7LE=
X-Google-Smtp-Source: AMsMyM7RTRg7SpbZTJQ+we3AbL/qvOFwFBHcwSMkpDrJaTXiHZfe0LguJL/PyAWweT10+D+hK/t5Sw==
X-Received: by 2002:a17:902:e742:b0:176:dc6b:eecc with SMTP id p2-20020a170902e74200b00176dc6beeccmr4763422plf.104.1663333079435;
        Fri, 16 Sep 2022 05:57:59 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f20-20020a170902f39400b0017829a3df46sm11941062ple.204.2022.09.16.05.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:57:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com,
        peterz@infradead.org
Cc:     ap420073@gmail.com
Subject: [PATCH v4 1/3] crypto: aria: prepare generic module for optimized implementations
Date:   Fri, 16 Sep 2022 12:57:34 +0000
Message-Id: <20220916125736.23598-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916125736.23598-1-ap420073@gmail.com>
References: <20220916125736.23598-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It renames aria to aria_generic and exports some functions such as
aria_set_key(), aria_encrypt(), and aria_decrypt() to be able to be
used by aria-avx implementation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4:
 - No changes.

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

