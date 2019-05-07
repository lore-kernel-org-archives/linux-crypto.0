Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3ABC04AAD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3121520825
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LXVZp/oY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfEGQNw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 12:13:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38848 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfEGQNg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 12:13:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id a59so8417482pla.5
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 09:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GtAkXLbM5Yxh1pZTulaAY8+tvV9X/Wy+g9uQkjsyr7k=;
        b=LXVZp/oYVAOiLUXlPtk8Cd3zcswhBSZ8T4MmKellCTKnIjY9lef+auf5uaAO9y8TQ2
         IcMYBRRSP5EleGlskUJpwWoZAYclBLaX5kC/b9hGmNAgtTFI42RmRSU2BI1I585Z6F3z
         Dzg5Tr4aX7O55rA0WzVImEB+YcERI34IDXOEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GtAkXLbM5Yxh1pZTulaAY8+tvV9X/Wy+g9uQkjsyr7k=;
        b=XceZ01RS/fNqHt8DmCWaunqf1rpJ6rDkPYRnqkNqRFDvEhC+rVho1jvwxtHBfLs3qG
         NX7Q1MdZuZtzS9IphSDV516xn0EaZnPFCURHctAt/+Xd+q/zViJqQtvcHLWAq5dlTkvI
         Jlomgn8o3OxK3B/up6bKF4zzHgSh8P72WXhMES6GQwlvb8LOZ6uXAm7p4lvL7pxzGEJ+
         WSkP9CURl/kfeKqa0ojjVioMEdieAipCkT7/dTMvZXNGiSdCi0bXHMzojmR48UzVabyn
         yn+LAXZqdQHdt6w5igrsmCQFyciRRKVeRtDBdqJeQqET3FbI1UAn/kik9jGTHxkxb0js
         sEIA==
X-Gm-Message-State: APjAAAVaEx/Yxqq+xvAADfhnePd62r/Ovmy7QNb1iOQ39uwzFPspmlRq
        QkX1fZ33PTaGFJrhgAZZpR3qRw==
X-Google-Smtp-Source: APXvYqxei5kL1Syc45BpeHUWyEYcS37yFt+oZEKx+/vNjhefreb0MA6AI8j/KaZun+Wmng/zKKaAiQ==
X-Received: by 2002:a17:902:e213:: with SMTP id ce19mr15457795plb.30.1557245616006;
        Tue, 07 May 2019 09:13:36 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id c14sm591014pgl.43.2019.05.07.09.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 09:13:34 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>,
        Eric Biggers <ebiggers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v3 6/7] crypto: x86/aesni: Use new glue function macros
Date:   Tue,  7 May 2019 09:13:20 -0700
Message-Id: <20190507161321.34611-7-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert to function declaration macros from function prototype casts
to avoid trigger Control-Flow Integrity checks during indirect function
calls.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 31 ++++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 1e3d2102033a..350286235a47 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -39,9 +39,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
-#ifdef CONFIG_X86_64
 #include <asm/crypto/glue_helper.h>
-#endif
 
 
 #define AESNI_ALIGN	16
@@ -52,6 +50,8 @@
 #define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
+#define AESNI_GLUE(func)       GLUE_CAST(func, crypto_aes_ctx)
+
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -89,10 +89,8 @@ struct gcm_context_data {
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
-asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
+AESNI_GLUE(aesni_enc);
+AESNI_GLUE(aesni_dec);
 asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -570,19 +568,14 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 
-static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
-{
-	aesni_enc(ctx, out, in);
-}
-
 static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_enc_glue);
 }
 
 static void aesni_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_dec));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec_glue);
 }
 
 static void aesni_xts_enc8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -601,10 +594,10 @@ static const struct common_glue_ctx aesni_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc8) }
+		.fn_u = { .xts = aesni_xts_enc8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc) }
+		.fn_u = { .xts = aesni_xts_enc }
 	} }
 };
 
@@ -614,10 +607,10 @@ static const struct common_glue_ctx aesni_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec8) }
+		.fn_u = { .xts = aesni_xts_dec8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec) }
+		.fn_u = { .xts = aesni_xts_dec }
 	} }
 };
 
@@ -627,7 +620,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&aesni_enc_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aesni_enc_glue,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
 }
@@ -638,7 +631,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&aesni_dec_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aesni_enc_glue,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
 }
-- 
2.17.1

