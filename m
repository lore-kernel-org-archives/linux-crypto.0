From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/6] crypto: arm64/aes-ce - fix for big endian
Date: Sun,  9 Oct 2016 18:42:20 +0100
Message-ID: <1476034945-9186-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35450 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbcJIRmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:38 -0400
Received: by mail-lf0-f52.google.com with SMTP id l131so84192308lfl.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:37 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The core AES cipher implementation that uses ARMv8 Crypto Extensions
instructions erroneously loads the round keys as 64-bit quantities,
which causes the algorithm to fail when built for big endian. In
addition, the key schedule generation routine fails to take endianness
into account as well, when loading the combining the input key with
the round constants. So fix both issues.

Fixes: 12ac3efe74f8 ("arm64/crypto: use crypto instructions to generate AES key schedule")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-cipher.c | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
index f7bd9bf0bbb3..50d9fe11d0c8 100644
--- a/arch/arm64/crypto/aes-ce-cipher.c
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -47,24 +47,24 @@ static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	kernel_neon_begin_partial(4);
 
 	__asm__("	ld1	{v0.16b}, %[in]			;"
-		"	ld1	{v1.2d}, [%[key]], #16		;"
+		"	ld1	{v1.16b}, [%[key]], #16		;"
 		"	cmp	%w[rounds], #10			;"
 		"	bmi	0f				;"
 		"	bne	3f				;"
 		"	mov	v3.16b, v1.16b			;"
 		"	b	2f				;"
 		"0:	mov	v2.16b, v1.16b			;"
-		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	ld1	{v3.16b}, [%[key]], #16		;"
 		"1:	aese	v0.16b, v2.16b			;"
 		"	aesmc	v0.16b, v0.16b			;"
-		"2:	ld1	{v1.2d}, [%[key]], #16		;"
+		"2:	ld1	{v1.16b}, [%[key]], #16		;"
 		"	aese	v0.16b, v3.16b			;"
 		"	aesmc	v0.16b, v0.16b			;"
-		"3:	ld1	{v2.2d}, [%[key]], #16		;"
+		"3:	ld1	{v2.16b}, [%[key]], #16		;"
 		"	subs	%w[rounds], %w[rounds], #3	;"
 		"	aese	v0.16b, v1.16b			;"
 		"	aesmc	v0.16b, v0.16b			;"
-		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	ld1	{v3.16b}, [%[key]], #16		;"
 		"	bpl	1b				;"
 		"	aese	v0.16b, v2.16b			;"
 		"	eor	v0.16b, v0.16b, v3.16b		;"
@@ -92,24 +92,24 @@ static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	kernel_neon_begin_partial(4);
 
 	__asm__("	ld1	{v0.16b}, %[in]			;"
-		"	ld1	{v1.2d}, [%[key]], #16		;"
+		"	ld1	{v1.16b}, [%[key]], #16		;"
 		"	cmp	%w[rounds], #10			;"
 		"	bmi	0f				;"
 		"	bne	3f				;"
 		"	mov	v3.16b, v1.16b			;"
 		"	b	2f				;"
 		"0:	mov	v2.16b, v1.16b			;"
-		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	ld1	{v3.16b}, [%[key]], #16		;"
 		"1:	aesd	v0.16b, v2.16b			;"
 		"	aesimc	v0.16b, v0.16b			;"
-		"2:	ld1	{v1.2d}, [%[key]], #16		;"
+		"2:	ld1	{v1.16b}, [%[key]], #16		;"
 		"	aesd	v0.16b, v3.16b			;"
 		"	aesimc	v0.16b, v0.16b			;"
-		"3:	ld1	{v2.2d}, [%[key]], #16		;"
+		"3:	ld1	{v2.16b}, [%[key]], #16		;"
 		"	subs	%w[rounds], %w[rounds], #3	;"
 		"	aesd	v0.16b, v1.16b			;"
 		"	aesimc	v0.16b, v0.16b			;"
-		"	ld1	{v3.2d}, [%[key]], #16		;"
+		"	ld1	{v3.16b}, [%[key]], #16		;"
 		"	bpl	1b				;"
 		"	aesd	v0.16b, v2.16b			;"
 		"	eor	v0.16b, v0.16b, v3.16b		;"
@@ -173,7 +173,12 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		u32 *rki = ctx->key_enc + (i * kwords);
 		u32 *rko = rki + kwords;
 
+#ifndef CONFIG_CPU_BIG_ENDIAN
 		rko[0] = ror32(aes_sub(rki[kwords - 1]), 8) ^ rcon[i] ^ rki[0];
+#else
+		rko[0] = rol32(aes_sub(rki[kwords - 1]), 8) ^ (rcon[i] << 24) ^
+			 rki[0];
+#endif
 		rko[1] = rko[0] ^ rki[1];
 		rko[2] = rko[1] ^ rki[2];
 		rko[3] = rko[2] ^ rki[3];
-- 
2.7.4
