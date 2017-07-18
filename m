From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 4/8] crypto: x86/aes-ni - switch to generic fallback
Date: Tue, 18 Jul 2017 13:06:41 +0100
Message-ID: <20170718120645.15880-5-ard.biesheuvel@linaro.org>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34400 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdGRMHG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:07:06 -0400
Received: by mail-wr0-f171.google.com with SMTP id 12so26322894wrb.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:07:05 -0700 (PDT)
In-Reply-To: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The time invariant AES-NI implementation is SIMD based, and so it needs
a fallback in case the code is called from a context where SIMD is not
allowed. On x86, this is really only when executing in the context of an
interrupt taken while in kernel mode, since SIMD is allowed in all other
cases.

There is very little code in the kernel that actually performs AES in
interrupt context, and the code that does (mac80211) only does so when
running on 802.11 devices that have no support for AES in hardware, and
those are rare these days.

So switch to the new AES core code as a fallback. It is much smaller, as
well as more resistant to cache timing attacks, and removing the
dependency allows us to disable the time variant drivers altogether if
desired.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 4 ++--
 crypto/Kconfig                     | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 4a55cdcdc008..1734e6185800 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -334,7 +334,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
 	if (!irq_fpu_usable())
-		crypto_aes_encrypt_x86(ctx, dst, src);
+		crypto_aes_encrypt(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
 		aesni_enc(ctx, dst, src);
@@ -347,7 +347,7 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
 	if (!irq_fpu_usable())
-		crypto_aes_decrypt_x86(ctx, dst, src);
+		crypto_aes_decrypt(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
 		aesni_dec(ctx, dst, src);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7766fea9c18e..8f4b9f3381e2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -956,8 +956,7 @@ config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on X86
 	select CRYPTO_AEAD
-	select CRYPTO_AES_X86_64 if 64BIT
-	select CRYPTO_AES_586 if !64BIT
+	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
-- 
2.9.3
