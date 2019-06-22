Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF2AC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25D320657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pTL9q9uQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVTes (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33739 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFVTes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so11351617wme.0
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Oqvcot1yZKpSWtboJ7OjflLCxxMos1RB3yPJW9XMLo=;
        b=pTL9q9uQWGDoEDBmSirmxQxs1RKz+z9+olTB1MNYmmYhAR764ygt7Hfbtnioif+CTO
         wbpdJch9/BLv6CLdXAg7flE9434mH9Si1UpokHFmutWE7sZ2xRyR15dfKjAEBBG5IRWR
         ub+6GhcU0dvQO2QvblFqove/vzIFBt823QaWQ9Hk/XJx6f1YcX2p3KRZzCOMtCBcKgM6
         f8raGMHokHvX67dn6ftXUPtZ8DBSUr4+nzMIoM/yOttOn3qOgCi2MGHVQWNoMl0Dn4f8
         5UXcrpfNwCOrQrOkJEbcMlb86292qtKz1/sgxoaOyA+RNJh2FmkP8bBu0EzonvtQWu24
         NtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Oqvcot1yZKpSWtboJ7OjflLCxxMos1RB3yPJW9XMLo=;
        b=TWTd6FtugXmuBlaqC+3i559EELuPu/App1Ip0h2hcIqfuOY/ZVSGlQv1UA9+aXbznB
         2XK2WZcr3tb4Xps5vS06DXxJrY6rduUlpzoct97rn12H5MRuagwvYPdlvGTVb2sgCnHv
         h2MfPS4ql2xvCKukhnwVQgo5ay6D1KoxNNwzJnrbQGrhf2q3j3Uv8m3JyubGEAEtTFks
         ZGFDjDxO4vquuAGZzhiCuS9CsSQIpma8qCLBG6UhFlbl4VMcTTXnhGxeCuEDDT5yhEH0
         p5czKK/LSA4fJnaReGTY+j4Db1qgIrde8ouuUUemrlaAD57xv8ghkG7+Yf0u96Jw3cQe
         mJFw==
X-Gm-Message-State: APjAAAX5g1qeCH4NVclN2yYlDHA3OFNVyuSoA7U09Sudbjow5edQ9gAD
        Aa85eABA0HU6Bh3+ImDicHpO11zGxj+4Hzpy
X-Google-Smtp-Source: APXvYqxgNIc2WZakCCL7NxagYnytZ2wCefE4I4qezW0lMAmqtXXLOFiODPBts19W0oFSqgVCOXPu0A==
X-Received: by 2002:a05:600c:20d:: with SMTP id 13mr8680233wmi.141.1561232085469;
        Sat, 22 Jun 2019 12:34:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 05/26] crypto: x86/aes-ni - switch to generic for fallback and key routines
Date:   Sat, 22 Jun 2019 21:34:06 +0200
Message-Id: <20190622193427.20336-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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
2.20.1

