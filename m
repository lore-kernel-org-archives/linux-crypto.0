Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2D619CD1D;
	Tue, 31 Mar 2026 02:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774925136; cv=none; b=ExFnZsBUmSWH1KV9OdvvOLA3v4DrR5c7AE1q+u5c+/CJvGinPrQ0px3l77J2QHSmTBGLon24amUPBo5CuKbWf/tJmtEkkEXPB1DvL/79gxZ24zagp+nOOIs2w3XL1GkHu3z3RkP2a64X1zPaG3K1AqvVkP2TviVasiXGFv9tfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774925136; c=relaxed/simple;
	bh=cITE7sLpK0CtWqStCEjMcIzT8mXsvR4Cmls0lRmjhQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SVQhi4t1Q+vOkOym7/n3PmYe6iStxpwXxZWuxA4WaVUqrgL/t1TxlfEPjFqsFAyipxR+tVG62sjXb6PhOxnc+mh3/jTMSVu/rGaSbgfrK3e4qmLc829kIaY7g8Fqs/VWxLXgtruiFcWRVl/fqBCRFMXA25Qrei/KDYMQ7Wom8B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSHf+vvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSHf+vvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7319C4CEF7;
	Tue, 31 Mar 2026 02:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774925135;
	bh=cITE7sLpK0CtWqStCEjMcIzT8mXsvR4Cmls0lRmjhQI=;
	h=From:To:Cc:Subject:Date:From;
	b=DSHf+vvOQUrppckolhI1Putjjpri5KrrcB/ekvfQ6mZ4+SX1lXNxLa1jJGVc027im
	 /xs6ErEryOD6/NGeNgOoN2LMkjxI8o/SZ/gi1eUv14WL5764e4yjCJq7bmS3PlEQSw
	 EYQGDVzdq8H1AUCriPT8vpNj1YP7GTPCPfFIj6HbdefF1L8RNM1wDgbwu+RV4AoUG0
	 Cd94A+fDmd+LGqBzUE2y+Cur2f+7JvEHTG8pqBjbcDzzWveVi1GzRJAoswyeS8QiyQ
	 StNdg6tBoDQ+WF9L0euyT3kmNfgsr8w+2Yb3pniW6FzPNqEfcmmd6borZiZidi43Yk
	 8Y5obaG5B6c7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: aescfb: Don't disable IRQs during AES block encryption
Date: Mon, 30 Mar 2026 19:44:14 -0700
Message-ID: <20260331024414.51545-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aes_encrypt() now uses AES instructions when available instead of always
using table-based code.  AES instructions are constant-time and don't
benefit from disabling IRQs as a constant-time hardening measure.

In fact, on two architectures (arm and riscv) disabling IRQs is
counterproductive because it prevents the AES instructions from being
used.  (See the may_use_simd() implementation on those architectures.)

Therefore, let's remove the IRQ disabling/enabling and leave the choice
of constant-time hardening measures to the AES library code.

Note that currently the arm table-based AES code (which runs on arm
kernels that don't have ARMv8 CE) disables IRQs, while the generic
table-based AES code does not.  So this does technically regress in
constant-time hardening when that generic code is used.  But as
discussed in commit a22fd0e3c495 ("lib/crypto: aes: Introduce improved
AES library") I think just leaving IRQs enabled is the right choice.
Disabling them is slow and can cause problems, and AES instructions
(which modern CPUs have) solve the problem in a much better way anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aescfb.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 147e5211728f..e38848d101e3 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -7,29 +7,10 @@
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/export.h>
 #include <linux/module.h>
-#include <asm/irqflags.h>
-
-static void aescfb_encrypt_block(const struct aes_enckey *key, void *dst,
-				 const void *src)
-{
-	unsigned long flags;
-
-	/*
-	 * In AES-CFB, the AES encryption operates on known 'plaintext' (the IV
-	 * and ciphertext), making it susceptible to timing attacks on the
-	 * encryption key. The AES library already mitigates this risk to some
-	 * extent by pulling the entire S-box into the caches before doing any
-	 * substitutions, but this strategy is more effective when running with
-	 * interrupts disabled.
-	 */
-	local_irq_save(flags);
-	aes_encrypt(key, dst, src);
-	local_irq_restore(flags);
-}
 
 /**
  * aescfb_encrypt - Perform AES-CFB encryption on a block of data
  *
  * @key:	The AES-CFB key schedule
@@ -43,11 +24,11 @@ void aescfb_encrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 {
 	u8 ks[AES_BLOCK_SIZE];
 	const u8 *v = iv;
 
 	while (len > 0) {
-		aescfb_encrypt_block(key, ks, v);
+		aes_encrypt(key, ks, v);
 		crypto_xor_cpy(dst, src, ks, min(len, AES_BLOCK_SIZE));
 		v = dst;
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;
@@ -70,20 +51,20 @@ EXPORT_SYMBOL(aescfb_encrypt);
 void aescfb_decrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 		    int len, const u8 iv[AES_BLOCK_SIZE])
 {
 	u8 ks[2][AES_BLOCK_SIZE];
 
-	aescfb_encrypt_block(key, ks[0], iv);
+	aes_encrypt(key, ks[0], iv);
 
 	for (int i = 0; len > 0; i ^= 1) {
 		if (len > AES_BLOCK_SIZE)
 			/*
 			 * Generate the keystream for the next block before
 			 * performing the XOR, as that may update in place and
 			 * overwrite the ciphertext.
 			 */
-			aescfb_encrypt_block(key, ks[!i], src);
+			aes_encrypt(key, ks[!i], src);
 
 		crypto_xor_cpy(dst, src, ks[i], min(len, AES_BLOCK_SIZE));
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;

base-commit: d2a68aba8505ce88b39c34ecb3b707c776af79d4
-- 
2.53.0

