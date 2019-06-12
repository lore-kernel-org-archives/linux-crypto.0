Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1E4C46477
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3590C20684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M+2h4fD4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409160AbfFLMsz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40633 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409157AbfFLMsz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so6389255wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYNNbe+mFt8Q+RY9DxwwFbhQEO3KEw5kT4vc21gIvDg=;
        b=M+2h4fD46HUC4cJ4KOuokanGoNSZ7xsT1Q+jGhMcs61l2SOksGa3I5dHZJ786fc1qX
         hwWLnCna9N+1lAxU3P9SSJn8TKRYJxcyR9J6luCq5uqa+ygm7ntsNvI+jDsfVTh4wuO7
         zLE28BI+hzPxUPqD4vUvwEXFBseb3e31yDKoID1mSHjLQa3Tl8iQZQHALHnCA0AjKWgX
         SAgnb6jlklnhZemcReGewK60rQ1ilAj72SyvQVQ35FgVVKPpAV+BYMtkHEOLnVCkUw0w
         C3t3tpAJqsEyHzbbjEelLLw/QJ8s+1v8JuGhRkVHs7D2rYPWmbLqi5m8rcPZLpUPDtUo
         3jTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYNNbe+mFt8Q+RY9DxwwFbhQEO3KEw5kT4vc21gIvDg=;
        b=cdxOuqOeL9ETOjOaO0ZvATtonhw8PB0vud7+W5Z20sXcXbL1tGDoWejy3/rPAUwMo8
         Q2jui4WHjGZjUlti5RFc8YkZ9+iU51VbsiYcWurE4AHgkxxy50UdFpU6pMgE1k7yCsOD
         rS6NoprcIjAN6h92P+zTY96C91y7DujfT7UDWTyaXPRPYTj7YGp27FilyM5GqfJrlA2p
         Yk/26SK1C5xrbKNr4xwP9ETpyXrZ9kT4Plm5HfIkNTG7PDIBo1aFPq5JsI+fxZshBXci
         y/4A0kzZwGpv82Y2zwkUmjJhDU6Q1aZ2fH0FZr4ygL2FOhDmp5WUNb/hMV5S6hO6Erx+
         J3wA==
X-Gm-Message-State: APjAAAV9FD5I1Wafj+GfuvowXtJcuNJ2rt1Z4t1NUufXG0s3elcAY5B1
        civF4xp9MkQP+1cYSQlPJVuHfY8rEoRzrA==
X-Google-Smtp-Source: APXvYqyF+C7SiBexU0MkQMJuAdUdezZFptyfoBb6DdReSF88CbWJsNt8wcl33GCpfJk6fqWFCLmSMQ==
X-Received: by 2002:a05:600c:2243:: with SMTP id a3mr21220424wmm.83.1560343732621;
        Wed, 12 Jun 2019 05:48:52 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 05/20] crypto: x86/aes-ni - switch to generic for fallback and key routines
Date:   Wed, 12 Jun 2019 14:48:23 +0200
Message-Id: <20190612124838.2492-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES-NI code contains fallbacks for invocations that occur from a
context where the SIMD unit is unavailable, which really only occurs
when running in softirq context that was entered from a hard IRQ that
was taken while running kernel code that was already using the FPU.

That means performance is not really a consideration, and we can just
use the new library code for this use case, which has a smaller
footprint and is believed to be time invariant. This will allow us to
drop the non-SIMD asm routines in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 15 +++++++--------
 arch/x86/include/asm/crypto/aes.h  | 12 ------------
 crypto/Kconfig                     |  3 +--
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e9b866e87d48..9952bd312ddc 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -26,7 +26,6 @@
 #include <crypto/gcm.h>
 #include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
-#include <asm/crypto/aes.h>
 #include <asm/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -329,7 +328,7 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 	}
 
 	if (!crypto_simd_usable())
-		err = crypto_aes_expand_key(ctx, in_key, key_len);
+		err = aes_expandkey(ctx, in_key, key_len);
 	else {
 		kernel_fpu_begin();
 		err = aesni_set_key(ctx, in_key, key_len);
@@ -349,9 +348,9 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (!crypto_simd_usable())
-		crypto_aes_encrypt_x86(ctx, dst, src);
-	else {
+	if (!crypto_simd_usable()) {
+		aes_encrypt(ctx, dst, src);
+	} else {
 		kernel_fpu_begin();
 		aesni_enc(ctx, dst, src);
 		kernel_fpu_end();
@@ -362,9 +361,9 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (!crypto_simd_usable())
-		crypto_aes_decrypt_x86(ctx, dst, src);
-	else {
+	if (!crypto_simd_usable()) {
+		aes_decrypt(ctx, dst, src);
+	} else {
 		kernel_fpu_begin();
 		aesni_dec(ctx, dst, src);
 		kernel_fpu_end();
diff --git a/arch/x86/include/asm/crypto/aes.h b/arch/x86/include/asm/crypto/aes.h
deleted file mode 100644
index c508521dd190..000000000000
--- a/arch/x86/include/asm/crypto/aes.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef ASM_X86_AES_H
-#define ASM_X86_AES_H
-
-#include <linux/crypto.h>
-#include <crypto/aes.h>
-
-void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
-			    const u8 *src);
-void crypto_aes_decrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
-			    const u8 *src);
-#endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index dc6f93ef3ead..0d80985016bf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1149,8 +1149,7 @@ config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on X86
 	select CRYPTO_AEAD
-	select CRYPTO_AES_X86_64 if 64BIT
-	select CRYPTO_AES_586 if !64BIT
+	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
-- 
2.20.1

