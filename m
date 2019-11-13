Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232FFC43215
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E715206F0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UaiurrxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfKMSZZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:25:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36550 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfKMSZY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 13:25:24 -0500
Received: by mail-pg1-f196.google.com with SMTP id k13so1887940pgh.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 10:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qi9/NyJEMAI/v/yEt1QBedR/fOWtH+g+t+OXCVVBZWw=;
        b=UaiurrxDV7eCNiFtLqe0b8S9HTI4M1eI6wdxAZ1ftvrn92KRlgVaItkwPIO+ZlPAfN
         ti+O2ZtUesIYO0CVjR+oCiwdrW5+PwSW20W6X+FZCoQEColq6ksIeM4RaKkHaibGC0po
         M7usgsql9ml/NVprhibzkRXtrvx6htC8krF80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qi9/NyJEMAI/v/yEt1QBedR/fOWtH+g+t+OXCVVBZWw=;
        b=dh2oBko7f1Eizw1I2YwHtU/ix/VcPY/aaCpzXwfgXyqdTHLfiWPpgH+UTcQr0Qhqae
         AnJZJ+NVcXqeHIGIv0qwaUq2uBxt/GYmhc7I/uorapVpXc0LCtbuu187AkUu/c9Nlaa5
         aSgbAKkikTHKznPFHzwMnvq4FhGCuaRUeTI99Y6DuSvBOdVaMemj0NJqUmV4BANatLp7
         JhJJpOIleN9D4sQsSFwXeeEIMBXjwZWQGs0DL3c5x3Gn7+L/Tm9rEcEsQ3dKFzHuX0kP
         fq+bpgWOpbLKw57anXWlsPQUombmENJTjFGSt+IFRdVckOIH4EKDOO9/8MG3oPTmg1Kh
         kcuw==
X-Gm-Message-State: APjAAAW3ez6aV5eGba6eaBmAA+oLi4ZgaZ8Ex4sOZBlGGoqChtWHkr7m
        w+X9es/jrBzmE5FogwmC4iiobi8HBhE=
X-Google-Smtp-Source: APXvYqzh4ByHjL3GL653Ot7WEt8CrI2NVmzKGJF+0Zm/LXRtz4wDCGg9LuyYPoUvg2VCcKHiKQktsQ==
X-Received: by 2002:a63:f48:: with SMTP id 8mr5337407pgp.329.1573669523327;
        Wed, 13 Nov 2019 10:25:23 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q1sm2794222pgr.92.2019.11.13.10.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 10:25:21 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v5 1/8] crypto: x86/glue_helper: Regularize function prototypes
Date:   Wed, 13 Nov 2019 10:25:09 -0800
Message-Id: <20191113182516.13545-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113182516.13545-1-keescook@chromium.org>
References: <20191113182516.13545-1-keescook@chromium.org>
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
 arch/x86/crypto/glue_helper.c             | 13 +++++++++----
 arch/x86/include/asm/crypto/glue_helper.h |  6 +++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index d15b99397480..2eb1fc017187 100644
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
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..22d54e8b8375 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -12,10 +12,10 @@
 #include <crypto/b128ops.h>
 
 typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
-typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_cbc_func_t)(void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_ctr_func_t)(void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_xts_func_t)(void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
 #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-- 
2.17.1

