Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851A9C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A5532086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IV0UzQeU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF0K16 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:27:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38992 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfF0K16 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:27:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so5116606wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Oqvcot1yZKpSWtboJ7OjflLCxxMos1RB3yPJW9XMLo=;
        b=IV0UzQeU5nxRPBwgUzmlex0+nuCJuhK1tG6xuTVNNDrs5l8F5NP2aal5QT9p8LmBRl
         31agMe1aPpyGI+ScZ6c7H06SRbRp+Z03pmXGCZZ5ZZImO7hYL+ffNgoXMrL7SM1Y37fd
         HW5NaYoNOp+sq5nmLdpCFYveBbhB9iXI9VpT82bM1/ZdljTclos8ZpYrkvCU75bEJtrV
         3AZofas0KtNQEu0tcl0EE0JCWdA3vCrisj02vKy1Tvjw4jdHyfNMVAmpgIbOym3IejTn
         QJULX9rmoJ1cdcQML8+p6ihG19GjxkWaNCybX787p7bJcpthAE/RgCVfoO2wdAucwg4N
         85/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Oqvcot1yZKpSWtboJ7OjflLCxxMos1RB3yPJW9XMLo=;
        b=srGG581k74g+rULPzrbf+3KufCGBYyc2Dx/J0yR5csB8/IYdv7zkxr3DMQoU3pz3M6
         iXLUchteDDsZthBMxtFGwpinb631zW9h8Dpw80x0zl8j8qbRJxQ6bBzGQ8nfBLQDzBox
         8SiSbD3jLYAXn1LjmRkmM+ArS4m+Brrt01S8Dz5tYZXSKm53L20/Ar11q8Lrd51Lo+10
         DBZZpSfG/xH2ebC4UmvhWXv0sUhKOJxi7ZhCWBKZ6sXPcro86xOcp2VHWR492/HqTkuM
         yPGbKxOcmFh9cZQuNoh3cu2wsrnvVi3EaFh4KNp34JykqzT1ZyzIaLv/a/3n9KG0pg+D
         +98A==
X-Gm-Message-State: APjAAAWRM9gjYX+FMyLJ+PXSg1qzEtsNFs6baKgBoQarT/cT1u1GhSZl
        N+DYC078MOiyLFgDgq/41bpDtYde6sE=
X-Google-Smtp-Source: APXvYqxC4Szcz/bxJgRBVAL+IFzpTr8DvVkDvyNg5HR561frbHERZj5cVjL4XtvpMfi1L2UigjSHPQ==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr2884629wml.124.1561631275846;
        Thu, 27 Jun 2019 03:27:55 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 05/32] crypto: x86/aes-ni - switch to generic for fallback and key routines
Date:   Thu, 27 Jun 2019 12:26:20 +0200
Message-Id: <20190627102647.2992-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

