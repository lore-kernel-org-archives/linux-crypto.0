Return-Path: <SRS0=rtXS=ZD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA7AC17447
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E24221783
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 21:46:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ihuN695K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfKKVqb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Nov 2019 16:46:31 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38035 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfKKVqH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Nov 2019 16:46:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id w8so8381290plq.5
        for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2019 13:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scnPY7Vttw3RyzZhL4W5SpA/avMnImyUTQ0YId03ujs=;
        b=ihuN695KvOIYvShEFrPb/mLsRgCB+jsW+Zf4zcpsRLeZ6gUH29xLpLoEaSZENcxesD
         aRXnINDZpo+dHBayJhowwxsHQmmjO8KhdQEmxw/osNEkLnDYkkGzE3mUznjodnxBXuKd
         g40VBnd7TXFKmXIgxwQAsBGGRxfPHa+cNQYBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scnPY7Vttw3RyzZhL4W5SpA/avMnImyUTQ0YId03ujs=;
        b=sjBdDQKaZouGUAcQyh8oEPJzRUKZq0LVL5cwyH8KTecpB1wPckXR6sHKEkWGoHMMZk
         3TlQswFA14wEPqJll5T6XykNDXr+UhjsUNXKF/gvj4g0ycQu7n4mAjsQp0KTAO4Y/B11
         G/jaWvincfLbmiUCXt7cVcad+0JEpR494mc/jSA/vAcMk+PgNYs1q4ba5Ni5QKTSxics
         rtMBa50hSOGamw6GFcfNc6ss4zDxsA5Q15c1fQQkpwvlUh9+y3+vtbaTmwtJZvjFOZQE
         oRzs2qJ5gcOiNDP13UppftX4r3AoN3I72O8ckcXOn+FH/Eue9CBVb4BWbj0kcKD9UKzV
         uCLQ==
X-Gm-Message-State: APjAAAXuWOvp2Nyl5fMwNu//zNWKXs2akzvgYGiW2cWUV+WQnGMCHzEM
        8xgY6FLxa6xzZMnIBV6Y0ioVXQ==
X-Google-Smtp-Source: APXvYqzVIxtt5GEKdaDXPQ+xj7Wjby90TrRdmpa51OGLsU2O2Qj1q3F+9zcZ2rKrY4+kA2/QVptBBg==
X-Received: by 2002:a17:902:7c8f:: with SMTP id y15mr27046980pll.341.1573508764932;
        Mon, 11 Nov 2019 13:46:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y11sm19317170pfq.1.2019.11.11.13.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:46:00 -0800 (PST)
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
Subject: [PATCH v4 1/8] crypto: x86/glue_helper: Add function glue macros
Date:   Mon, 11 Nov 2019 13:45:45 -0800
Message-Id: <20191111214552.36717-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto glue performed function prototype casting to make indirect
calls to assembly routines. Instead of performing casts at the call
sites (which trips Control Flow Integrity prototype checking), create a
set of macros to either declare the prototypes to avoid the need for
casts, or build inline helpers to allow for various aliased functions.

Co-developed-by: João Moreira <joao.moreira@lsc.ic.unicamp.br>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..2fa4968ab8e2 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -23,6 +23,30 @@ typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 #define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
 #define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
 
+#define CRYPTO_FUNC(func)						\
+asmlinkage void func(void *ctx, u8 *dst, const u8 *src)
+
+#define CRYPTO_FUNC_CBC(func)						\
+asmlinkage void func(void *ctx, u128 *dst, const u128 *src)
+
+#define CRYPTO_FUNC_WRAP_CBC(func)					\
+static inline void func ## _cbc(void *ctx, u128 *dst, const u128 *src)	\
+{ func(ctx, (u8 *)dst, (u8 *)src); }
+
+#define CRYPTO_FUNC_CTR(func)						\
+asmlinkage void func(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+
+#define CRYPTO_FUNC_XTS(func)	CRYPTO_FUNC_CTR(func)
+
+#define CRYPTO_FUNC_XOR(func)						\
+asmlinkage void __ ## func(void *ctx, u8 *dst, const u8 *src, bool y);	\
+asmlinkage static inline						\
+void func(void *ctx, u8 *dst, const u8 *src)				\
+{ __ ## func(ctx, dst, src, false); }					\
+asmlinkage static inline						\
+void func ## _xor(void *ctx, u8 *dst, const u8 *src)			\
+{ __ ## func(ctx, dst, src, true); }
+
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
-- 
2.17.1

