Return-Path: <SRS0=rtXS=ZD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD9AC17448
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2672206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X6cJO6j+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfKKVqc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Nov 2019 16:46:32 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:32886 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfKKVqH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Nov 2019 16:46:07 -0500
Received: by mail-pl1-f181.google.com with SMTP id ay6so8389991plb.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2019 13:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q2lZ7Dm1L5aRXMm9XxNsm9WxcGVGFqTOrxf2vwq2v/c=;
        b=X6cJO6j+LuNeFzoMBlJXSpwENsy0YOCb5jmcJTGxZvPS1RV2nWRXEkpU9UtVC0gzU3
         +Skr+AL2+vJk7GunbZi7TcgodFA6q2V5iT3hVRsf4ee2IKQkEKCEGk0zUGnZWZV6us3x
         dsdp/HxQ5DvQXnLDmGpXnTwQRiGC4YdyBTjDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q2lZ7Dm1L5aRXMm9XxNsm9WxcGVGFqTOrxf2vwq2v/c=;
        b=POOIPjYGRwdCKc+OKHau6z7avfskONe6ZXgdAHrLasuIvtg0Td3DS4xAylOmiomDkY
         PFXwlqqTf//doaECPY/lw4G3GsVFD0FbypYJJJlhb5goJu27nQym5EPCDSsvSlmhZb++
         8QY7n3GY+zPjIo1um6DXza4goK33NecPR0iaR/HefTw6OLkGfg+UnxzxO331t+0mN/Vj
         eTrqU3NoyUr1St1UkgzY/UqaiyiiUseqWSyD2Isjcr7hJcRoMmHjihXnj3Ws5cz5ZdS0
         +HviVu4h5+uqqHbhqBkl3Z//rDXwiit9x9LGWGlLsfatUQ9RGaryyYf+tEhzBrm1tr4C
         JVkg==
X-Gm-Message-State: APjAAAUyT4B+GXs7MFp/Iuff1otm4HmZluKkLtXqao8uKUA9y/lysRol
        tVbgDAPGMmJ/pCO5swfwPTakKA==
X-Google-Smtp-Source: APXvYqyte6oJuiojDpH+7VVh1GlXynL4x0mJaAVAGIUiJyoki2Cy/SuhjS+ya0YYXVwQoQZshdRvoA==
X-Received: by 2002:a17:902:b948:: with SMTP id h8mr27221875pls.139.1573508766383;
        Mon, 11 Nov 2019 13:46:06 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w138sm12427189pfc.68.2019.11.11.13.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:46:05 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@lsc.ic.unicamp.br>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v4 7/8] crypto: x86/glue_helper: Remove function prototype cast helpers
Date:   Mon, 11 Nov 2019 13:45:51 -0800
Message-Id: <20191111214552.36717-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all users of the function prototype casting helpers have been
removed, delete the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 5 -----
 include/crypto/xts.h                      | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 2fa4968ab8e2..a9935bbb3eb9 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,11 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 #define CRYPTO_FUNC(func)						\
 asmlinkage void func(void *ctx, u8 *dst, const u8 *src)
 
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1

