From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/12] crypto: arm64/aes-ce-cipher: add non-SIMD generic fallback
Date: Sat, 10 Jun 2017 16:22:54 +0000
Message-ID: <1497111778-4210-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36064 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdFJQXY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:24 -0400
Received: by mail-wr0-f173.google.com with SMTP id v111so58817631wrc.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:24 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 kernel will shortly disallow nested kernel mode NEON, so
add a fallback to scalar code that can be invoked in that case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig         |  3 ++-
 arch/arm64/crypto/aes-ce-cipher.c | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 8cd145f9c1ff..772801f263d9 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -50,8 +50,9 @@ config CRYPTO_AES_ARM64
 
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
-	depends on ARM64 && KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES_ARM64
 
 config CRYPTO_AES_ARM64_CE_CCM
 	tristate "AES in CCM mode using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
index a0a0e5e3a8b5..6a75cd75ed11 100644
--- a/arch/arm64/crypto/aes-ce-cipher.c
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
 #include <linux/cpufeature.h>
@@ -21,6 +22,9 @@ MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
+asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+
 struct aes_block {
 	u8 b[AES_BLOCK_SIZE];
 };
@@ -45,7 +49,12 @@ static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	void *dummy0;
 	int dummy1;
 
-	kernel_neon_begin_partial(4);
+	if (!may_use_simd()) {
+		__aes_arm64_encrypt(ctx->key_enc, dst, src, num_rounds(ctx));
+		return;
+	}
+
+	kernel_neon_begin();
 
 	__asm__("	ld1	{v0.16b}, %[in]			;"
 		"	ld1	{v1.4s}, [%[key]], #16		;"
@@ -90,7 +99,12 @@ static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	void *dummy0;
 	int dummy1;
 
-	kernel_neon_begin_partial(4);
+	if (!may_use_simd()) {
+		__aes_arm64_decrypt(ctx->key_dec, dst, src, num_rounds(ctx));
+		return;
+	}
+
+	kernel_neon_begin();
 
 	__asm__("	ld1	{v0.16b}, %[in]			;"
 		"	ld1	{v1.4s}, [%[key]], #16		;"
@@ -170,7 +184,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 	for (i = 0; i < kwords; i++)
 		ctx->key_enc[i] = get_unaligned_le32(in_key + i * sizeof(u32));
 
-	kernel_neon_begin_partial(2);
+	kernel_neon_begin();
 	for (i = 0; i < sizeof(rcon); i++) {
 		u32 *rki = ctx->key_enc + (i * kwords);
 		u32 *rko = rki + kwords;
-- 
2.7.4
