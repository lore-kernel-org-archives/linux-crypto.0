Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5DFC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6097B206CB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c62IQrA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKVBEZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 20:04:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37544 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfKVBDm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 20:03:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so2633624pfn.4
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2019 17:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ogInRXGt+sPw2HEZ3/J86GV8yEDJ13ZF9JZ3hZT/kGM=;
        b=c62IQrA7WMubIKMG7YRJfYNOmH5PP3OT90j5iiPtbjViBXxNeoyI+rV6BqUpCESkc3
         0Z6S2kc1Ccjd6okULsJZlYzzpEAwEx8F/2cRVCPCVqWdvIarQggraQ6MQJ93WsAdkTYK
         QnmRcZuTUPTjhbIA8tmlOW7wJi47t97BFMcK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ogInRXGt+sPw2HEZ3/J86GV8yEDJ13ZF9JZ3hZT/kGM=;
        b=AK0RzwQrHsaaDHC96ddN8u2K3HjvudCR3VIabRyMKwEH8Cc6wJFY/3AP6bGEGxfOkS
         Z7UpRJQ/sxUyRUrblIemkzTnKffQo62ssfMB/5Id7lGFiZYXWTLfSQQsR+d/aGM/aajf
         z9Y0vXxVjMh0Q8nF5jz8hrl3Wv2Jo+FnJH0b2KwHMUhB38Jmk850XLxZ7ehhC2EuSHTe
         pGhTaoJ7+psULTqZuxu5lOBwhfK8JdoxXnjnJ//Pzh+xNeLJuQ9xmFX5X37lQ5FxwpZb
         6YmEvGXvfySjDkDdZKgzYY8sIMGnuh19XzPX4/B/Jr9ttRx/pcGI+OkaBNag5gYx1iaU
         gzqQ==
X-Gm-Message-State: APjAAAUeCxK+iOrKr56TehCaZi2sWEU5BnWAYYvdvtQW+FuczHEVp65r
        vy2X9AAvIf4NlCPcnzGPiPQnkw==
X-Google-Smtp-Source: APXvYqwkm/Hnnfz9l9HjiwV4ZZkTNJsjp7ESPfZDQZlb++3cENihjkIQMXfvttuJWXLyWpE9Hd+A3A==
X-Received: by 2002:a63:5f04:: with SMTP id t4mr12527616pgb.73.1574384621641;
        Thu, 21 Nov 2019 17:03:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a12sm4355040pga.11.2019.11.21.17.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 17:03:38 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v6 1/8] crypto: x86/glue_helper: Regularize function prototypes
Date:   Thu, 21 Nov 2019 17:03:27 -0800
Message-Id: <20191122010334.12081-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
References: <20191122010334.12081-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto glue performed function prototype casting to make indirect
calls to assembly routines. Instead of performing casts at the call
sites (which trips Control Flow Integrity prototype checking), switch
each prototype to a common standard set of arguments which allows the
incremental removal of the existing macros. In order to keep pointer
math unchanged, internal casting between u128 pointers and u8 pointers
is added.

Co-developed-by: João Moreira <joao.moreira@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/glue_helper.c             | 23 ++++++++++++++---------
 arch/x86/include/asm/crypto/glue_helper.h | 13 +++++++------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index d15b99397480..d3d91a0abf88 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -134,7 +134,8 @@ int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 				src -= num_blocks - 1;
 				dst -= num_blocks - 1;
 
-				gctx->funcs[i].fn_u.cbc(ctx, dst, src);
+				gctx->funcs[i].fn_u.cbc(ctx, (u8 *)dst,
+							(const u8 *)src);
 
 				nbytes -= func_bytes;
 				if (nbytes < bsize)
@@ -188,7 +189,9 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 
 			/* Process multi-block batch */
 			do {
-				gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);
+				gctx->funcs[i].fn_u.ctr(ctx, (u8 *)dst,
+							(const u8 *)src,
+							&ctrblk);
 				src += num_blocks;
 				dst += num_blocks;
 				nbytes -= func_bytes;
@@ -210,7 +213,8 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 
 		be128_to_le128(&ctrblk, (be128 *)walk.iv);
 		memcpy(&tmp, walk.src.virt.addr, nbytes);
-		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, &tmp, &tmp,
+		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, (u8 *)&tmp,
+							  (const u8 *)&tmp,
 							  &ctrblk);
 		memcpy(walk.dst.virt.addr, &tmp, nbytes);
 		le128_to_be128((be128 *)walk.iv, &ctrblk);
@@ -240,7 +244,8 @@ static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 
 		if (nbytes >= func_bytes) {
 			do {
-				gctx->funcs[i].fn_u.xts(ctx, dst, src,
+				gctx->funcs[i].fn_u.xts(ctx, (u8 *)dst,
+							(const u8 *)src,
 							walk->iv);
 
 				src += num_blocks;
@@ -354,8 +359,8 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
 
-void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
-			       common_glue_func_t fn)
+void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst, const u8 *src,
+			       le128 *iv, common_glue_func_t fn)
 {
 	le128 ivblk = *iv;
 
@@ -363,13 +368,13 @@ void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
 	gf128mul_x_ble(iv, &ivblk);
 
 	/* CC <- T xor C */
-	u128_xor(dst, src, (u128 *)&ivblk);
+	u128_xor((u128 *)dst, (const u128 *)src, (u128 *)&ivblk);
 
 	/* PP <- D(Key2,CC) */
-	fn(ctx, (u8 *)dst, (u8 *)dst);
+	fn(ctx, dst, dst);
 
 	/* P <- T xor PP */
-	u128_xor(dst, dst, (u128 *)&ivblk);
+	u128_xor((u128 *)dst, (u128 *)dst, (u128 *)&ivblk);
 }
 EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit_one);
 
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..ba48d5af4f16 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -11,11 +11,11 @@
 #include <asm/fpu/api.h>
 #include <crypto/b128ops.h>
 
-typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
-typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
 #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
@@ -116,7 +116,8 @@ extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
 			       void *crypt_ctx, bool decrypt);
 
-extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
-				      le128 *iv, common_glue_func_t fn);
+extern void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst,
+				      const u8 *src, le128 *iv,
+				      common_glue_func_t fn);
 
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

