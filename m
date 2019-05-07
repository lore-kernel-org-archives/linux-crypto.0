Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFD0C004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B94520825
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EPXA/Hhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEGQNg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 12:13:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41473 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfEGQNg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 12:13:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id d9so8420852pls.8
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 09:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QA3HzzjjvBBxLzgrZcUsI/Ka76WXbPB2jGuemOph6Xg=;
        b=EPXA/HhfhYmNIpyStTLIe0HkJknQfVtp7TmERucT0x6/R3/KPT7QKZ1j8HPBgPNCmH
         PPj6gw/Sa78McVub6La5gCIYi1dmv7wK9IsmDDQvk1p6gCHAVy3tgJaXQoomkmjGWRSe
         9ZlZyEgwZMCzML51PiaHKSel0UM2lPxW9HPDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QA3HzzjjvBBxLzgrZcUsI/Ka76WXbPB2jGuemOph6Xg=;
        b=bkqj6UCCK1Wwl7LmmuEuRjs9hCl+pqzYSMzWsHZ6YAT/MI2KDt5yOhGY6455UhpYI5
         BANM0yFWBE92LJDsM3HakkTalkDlnSflM16Q2WZSkQGQCH2Lbv/3yAZDO2gJ8tFVIX60
         OP4/S0CIWx2cZlrItQNA0/iX8RxZHAn3LF6la2MOeVkEuZLCmihFBD5E4G0uT72xHhqF
         uIVHdcfxiZr9WFTiaG55449bQx+LXyhkc2cTDlt2kp7Tn5ZCyt+k/WB9PMioZ/tEB/zk
         Np0CUhNJG62wfpBeqLOi6J+v1MU36r/CodPnrZmO83pCH5YV9TgLXXHsGkHuoUn4Eefd
         +S4Q==
X-Gm-Message-State: APjAAAV3Hay5KPEgU7NpyNzTgIHbGih58mosqSSgFd/zDJ8mtn5P81hR
        bORV8KNP9oMK+LwrhgSmvNTb2Q==
X-Google-Smtp-Source: APXvYqyeW7D+sPyiZumGQOGNkqWQIR/WsqzmD/UtQYSmmk7rzstgyo+h1xm936mPXzVcBXe1ba+o9g==
X-Received: by 2002:a17:902:b614:: with SMTP id b20mr4001088pls.200.1557245615448;
        Tue, 07 May 2019 09:13:35 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id s11sm25864557pga.36.2019.05.07.09.13.33
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
Subject: [PATCH v3 7/7] crypto: x86/glue_helper: Remove function prototype cast helpers
Date:   Tue,  7 May 2019 09:13:21 -0700
Message-Id: <20190507161321.34611-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all users of the function prototype casting helpers have been
removed, this deletes the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 6 ------
 include/crypto/xts.h                      | 2 --
 2 files changed, 8 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 3b039d563809..2b2d8d4a5081 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,12 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
-
 #define GLUE_CAST(func, context)					\
 asmlinkage void func(struct context *ctx, u8 *dst, const u8 *src);	\
 asmlinkage static inline						\
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

