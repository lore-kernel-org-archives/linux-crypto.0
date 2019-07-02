Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BB8C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5208D21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fdjFlEQE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGBTmT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:19 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39107 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGBTmT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:19 -0400
Received: by mail-lf1-f67.google.com with SMTP id p24so12264347lfo.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nWt11EyVqqg4tMlaa7Rrh/54/0WBS7GqXZGnOHalCUs=;
        b=fdjFlEQE1xzcolJvutPoxozOxZTrtdgx9EtUZBqOQrW89Qg1Uw/T+KtAK5LugFEcrY
         jx7RI9pRVYlPM68Mw/FOiUdoquk6lSc6k7qcke7lhTFMfwo/T6pVUn7pg8FkwveiHgR5
         yuC0hSyXtW9uvMjLe661Mw9dux14G3RLLJyU9U58L+3PlusSBMeEGmIb/jnexhebKgbS
         8jZJOrIAOJa8l4tlVTEIafjhztSdis4QLRK6S/lCOLdfr+e81jIMZ4pxFKTK6rL0ET/J
         y4weDt3pZu3pOK2s9UL22Ys6Lglo6eMZu11Dzr5VIYG5QWNkfoML4H2onUYkJ/DLn/Rk
         0Vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nWt11EyVqqg4tMlaa7Rrh/54/0WBS7GqXZGnOHalCUs=;
        b=XScPXsTVMvA9uy+8O+4ufV+0+nux4Nz84gn3e5qSa6ols3mjyddPn+ocJiV0FlNkTm
         XcPqv0MIdiAJ5Decdbo/dAxKLSJUhbfrT9vBD1tJthUh+YfRPg+yvYtHrrsmo6bfEyJX
         +CkgrIqRZNZ1BgWn0w4xxrc5dCjyimiqz7X+6w+L6F4k+w90AX/B4zOXbFFMK/iClmBS
         tT+/m9cF9vyRy+ctU/r4syRANtX6evinfiTT7pnRCv9ZJsQKjAub2940Xkus2skxZZhb
         bk7xNbPW9/+SzDIQsJxSzaRq68lTfQ5L1ispfOawKyMt/MyWz8+aoI8Zr0q0Uondq00l
         PHkA==
X-Gm-Message-State: APjAAAVMAhQhG8OJPf/LXT21SQVmWMYqkqy0uoBnzoPT4GqJk+1pA1Ao
        zXt7ygsoxHWuNkn4jG+h+nSxQbMqinNLGbO1
X-Google-Smtp-Source: APXvYqyS2oshJT0gMyhHUrQ5fmniSr2pU9VpDTdWkX3fSPOX1Lc/jmN5p3crdpL7BCpbVZk8cEOtcw==
X-Received: by 2002:ac2:4d1c:: with SMTP id r28mr14866508lfi.159.1562096537400;
        Tue, 02 Jul 2019 12:42:17 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 05/32] crypto: x86/aes-ni - switch to generic for fallback and key routines
Date:   Tue,  2 Jul 2019 21:41:23 +0200
Message-Id: <20190702194150.10405-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
index 836d50bd096f..42873c1f6bb4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -30,7 +30,6 @@
 #include <crypto/gcm.h>
 #include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
-#include <asm/crypto/aes.h>
 #include <asm/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -333,7 +332,7 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 	}
 
 	if (!crypto_simd_usable())
-		err = crypto_aes_expand_key(ctx, in_key, key_len);
+		err = aes_expandkey(ctx, in_key, key_len);
 	else {
 		kernel_fpu_begin();
 		err = aesni_set_key(ctx, in_key, key_len);
@@ -353,9 +352,9 @@ static void aesni_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
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
@@ -366,9 +365,9 @@ static void aesni_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
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
index 091ebbbc9655..20af58068e6b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1156,8 +1156,7 @@ config CRYPTO_AES_NI_INTEL
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
2.17.1

