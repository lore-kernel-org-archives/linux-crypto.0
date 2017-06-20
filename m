From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 3/7] crypto: x86/aes-ni - switch to generic fallback
Date: Tue, 20 Jun 2017 11:28:56 +0200
Message-ID: <1497950940-24243-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38744 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdFTJ3I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 05:29:08 -0400
Received: by mail-wm0-f53.google.com with SMTP id u195so14357473wmd.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2017 02:29:07 -0700 (PDT)
In-Reply-To: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
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
index b4edea2aed22..1e6e021fda10 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -984,8 +984,7 @@ config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on X86
 	select CRYPTO_AEAD
-	select CRYPTO_AES_X86_64 if 64BIT
-	select CRYPTO_AES_586 if !64BIT
+	select CRYPTO_AES_CORE
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
-- 
2.7.4
