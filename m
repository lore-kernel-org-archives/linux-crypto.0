Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD8356770;
	Mon, 21 Sep 2026 05:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967768; cv=none; b=GpHmmlJGsVIvMNDBtJVucDGiPLZY4abuyjAG0MjmwRqGpNSFZcPRcq2UIsIvFMQZQScDNtZ/VQR+Qsj08ff/s2jb1x8K5fwep1vL+l9jQm5sEWxUDeCmZrzte2hFT7q/hvSEiQZWxJQRYHSCuYxlMa3wwE1EHflEcTIvFaWvR20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967768; c=relaxed/simple;
	bh=xZIvNRXxYbj2iqtmLmxjpLgXQra/KLHdMVFsaXJTJw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fONuyNp41yT8zVS6REFGM5od2jEd3LmsLrVupve0akdukT4Qgkjw7TjTCrZkMlVJfpUPDUjeIaCjGPrKd3KP8tKpJ/g+hZLq1ik1OR1ckbLUp9xUhOj1l+BMR/YxTvfiEVim+LqmH/E5WzgQomKkcXoDzi+gEfUBbzR5ihnbQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=az5o6khp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="az5o6khp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A251F0089A;
	Mon, 21 Sep 2026 05:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967765;
	bh=WqHwU9wc0nBnAXv14Y3oqjMJhQv94lehmswMUrPQrGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=az5o6khpTOFV+kkbYyE7+68Rax9Em3N73CTxrNC4UYkI/O3jRfAcP/+4xFB3W4TZ8
	 LqxCVE73PeO9mk9c9ief4q9jxpolFf2vMD2xYzVjNLEjSilxzlxGQr4qCe5EE/udYw
	 SSxqechPBt6jy+uXwSAGngxe+qhsY+1nSng+lEFM4B+MUL8R8xRhGG/kryK04ugQRF
	 yM8/N/qpa2axkzQr5pybXXtylziNa1nuESqoqjYxZpkkeYJ5rKy8F3H5lgiVKdozxZ
	 5JkAHke1f+3C8Z0ok898xEy2WkCJ4KrPCQzoQVR8fG74JRZBRhrNQUUc8iAeJZp2fG
	 wZuQ8+ATrsahQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/20] lib/crypto: x86/aes-ctr: Add AES-NI optimization
Date: Sun, 20 Sep 2026 22:08:52 -0700
Message-ID: <20260921050910.296144-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Optimize the crypto library's AES-CTR support with AES-NI, making its
performance be at least at parity with the "ctr-aes-aesni" skcipher
algorithm that it will supersede.

The new assembly function is written from scratch to fit well into the
crypto library and to be more consistent with aes-ctr-avx-x86_64.S than
the code in arch/x86/crypto/aesni-intel_asm.S that it will supersede.
That includes using the "ctr64" convention, where the assembly code is
simplified by making the C code handle incrementing the high 64 bits of
the counter.  Unlike the ECB, CBC, and XTS code, 32-bit support is *not*
included for this one, as the existing CTR code didn't have it.

Note: the priority of ctr-aes-lib is left unchanged at 110 temporarily.
It will be increased when the AVX-optimized code is migrated too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes-aesni.S | 130 ++++++++++++++++++++++++++++++++++++-
 lib/crypto/x86/aes.h       |  54 +++++++++++++++
 2 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index 17da4d710574..24c53f1a144b 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -4,7 +4,8 @@
 //
 // Copyright 2026 Google LLC
 //
-// The code in this file supports 32-bit and 64-bit CPUs, and it doesn't require
+// The code in this file supports 32-bit and 64-bit CPUs (except for
+// aes_ctr64_crypt_aesni() which supports 64-bit only), and it doesn't require
 // AVX.  It does use up to SSE4.1, which all CPUs with AES-NI have.
 #include <linux/linkage.h>
 
@@ -49,6 +50,12 @@
 
 .section .rodata
 .p2align 4
+#ifdef __x86_64__
+.Lbswap_mask:
+	// A mask for pshufb that byte-reflects the value.
+	.byte	15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+#endif
+
 .Lexpandkey_mask:
 	// A mask for pshufb that extracts the last dword, rotates it right by 8
 	// bits, and copies the result to all four dwords.
@@ -648,3 +655,124 @@ SYM_FUNC_START(aes_cbc_cts_decrypt_aesni)
 
 	_epilogue
 SYM_FUNC_END(aes_cbc_cts_decrypt_aesni)
+
+#ifdef __x86_64__
+// void aes_ctr64_crypt_aesni(u8 *dst, const u8 *src, s64 len,
+//			      const u64 le_ctr[2],
+//			      const struct aes_enckey *key);
+SYM_FUNC_START(aes_ctr64_crypt_aesni)
+	// Arguments
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	LEN,		ARG2
+	.set	LEN32,		ARG2_32	// Used for improved code density
+	.set	LE_CTR_PTR,	ARG3	// Used as temp reg after LE_CTR is loaded
+	.set	KEY,		ARG4
+
+	// Other local variables
+	.set	AESDATA0,	%xmm0
+	.set	AESDATA1,	%xmm1
+	.set	AESDATA2,	%xmm2
+	.set	AESDATA3,	%xmm3
+	.set	LE_CTR,		%xmm4	// Current 128-bit little endian counter
+	.set	LE_CTR_INC,	%xmm5	// Initialized to (u64[])[1, 0]
+	.set	BSWAP_MASK,	%xmm6
+	.set	RNDKEY,		%xmm7
+	.set	RNDKEY_PTR,	LE_CTR_PTR  // Temporary register for _do_aes
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
+
+	// Initialize LE_CTR, BSWAP_MASK, and LE_CTR_INC.
+	movdqu		(LE_CTR_PTR), LE_CTR
+	movdqa		RODATA(.Lbswap_mask), BSWAP_MASK
+	mov		$1, TMP_32
+	movd		TMP_32, LE_CTR_INC
+
+	// Encrypt and XOR four blocks (64 bytes) at a time.
+	sub		$64, LEN
+	jl		.Lctr_loop4_done
+.p2align 5
+.Lctr_loop4:
+.irp i, 0,1,2,3
+	movdqa		LE_CTR, AESDATA\i
+	pshufb		BSWAP_MASK, AESDATA\i	// => big endian counter
+	paddq		LE_CTR_INC, LE_CTR
+.endr
+	_do_aes		1, 0,1,2,3
+	// AESDATA[0-3] now contain four keystream blocks.
+.irp i, 0,1,2,3
+	movdqu		\i*16(SRC), RNDKEY	// Use RNDKEY as temp register.
+	pxor		RNDKEY, AESDATA\i
+	movdqu		AESDATA\i, \i*16(DST)
+.endr
+	add		$64, DST
+	add		$64, SRC
+	sub		$64, LEN
+	jge		.Lctr_loop4
+.Lctr_loop4_done:
+	add		$64, LEN
+	jz		.Lctr_done
+
+	// 1 <= LEN <= 63 bytes remain.  Prepare four more keystream blocks.
+.irp i, 0,1,2,3
+	movdqa		LE_CTR, AESDATA\i
+	pshufb		BSWAP_MASK, AESDATA\i	// => big endian counter
+  .if \i != 3
+	paddq		LE_CTR_INC, LE_CTR
+  .endif
+.endr
+	_do_aes		1, 0,1,2,3
+	// AESDATA[0-3] now contain four keystream blocks.
+
+	// XOR one block (16 bytes) at a time.
+	sub		$16, LEN32
+	jl		.Lctr_partial
+.Lctr_xor1:
+	movdqu		(SRC), RNDKEY		// Use RNDKEY as temp register.
+	pxor		RNDKEY, AESDATA0
+	movdqu		AESDATA0, (DST)
+	movdqa		AESDATA1, AESDATA0
+	movdqa		AESDATA2, AESDATA1
+	movdqa		AESDATA3, AESDATA2
+	add		$16, SRC
+	add		$16, DST
+	sub		$16, LEN32
+	jge		.Lctr_xor1
+
+	// XOR the remaining LEN mod 16 bytes.
+.Lctr_partial:
+	test		$8, LEN32
+	jz		1f
+	movq		AESDATA0, TMP
+	xor		(SRC), TMP	// XOR 8 bytes.
+	mov		TMP, (DST)
+	add		$8, SRC
+	add		$8, DST
+	psrldq		$8, AESDATA0
+1:
+	test		$4, LEN32
+	jz		2f
+	movd		AESDATA0, TMP_32
+	xor		(SRC), TMP_32	// XOR 4 bytes.
+	mov		TMP_32, (DST)
+	add		$4, SRC
+	add		$4, DST
+	psrldq		$4, AESDATA0
+2:
+	test		$2, LEN32
+	jz		3f
+	movd		AESDATA0, TMP_32
+	xor		(SRC), TMP_16	// XOR 2 bytes.
+	mov		TMP_16, (DST)
+	add		$2, SRC
+	add		$2, DST
+	psrldq		$2, AESDATA0
+3:
+	test		$1, LEN32
+	jz		.Lctr_done
+	movd		AESDATA0, TMP_32
+	xor		(SRC), TMP_8	// XOR 1 byte.
+	mov		TMP_8, (DST)
+.Lctr_done:
+	RET
+SYM_FUNC_END(aes_ctr64_crypt_aesni)
+#endif // __x86_64__
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 67a4178b7acd..685b43ce6ef0 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -203,6 +203,60 @@ static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR) && IS_ENABLED(CONFIG_X86_64)
+void aes_ctr64_crypt_aesni(u8 *dst, const u8 *src, s64 len, const u64 le_ctr[2],
+			   const struct aes_enckey *key);
+
+static void aes_ctr64_x86(u8 *dst, const u8 *src, size_t len,
+			  const u64 le_ctr[2], const struct aes_enckey *key)
+{
+	aes_ctr64_crypt_aesni(dst, src, len, le_ctr, key);
+}
+
+#define aes_ctr_arch aes_ctr_arch
+static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
+			 u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
+{
+	u64 le_ctr[2];
+	u64 ctr64;
+	size_t nblocks;
+	size_t part1_len;
+
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+
+	ctr64 = le_ctr[0] = get_unaligned_be64(&ctr[8]);
+	le_ctr[1] = get_unaligned_be64(&ctr[0]);
+
+	kernel_fpu_begin();
+
+	nblocks = DIV_ROUND_UP(len, AES_BLOCK_SIZE);
+	ctr64 += nblocks;
+
+	if (likely(ctr64 >= nblocks)) {
+		/* The low 64 bits of the counter won't overflow. */
+		aes_ctr64_x86(dst, src, len, le_ctr, key);
+	} else {
+		/*
+		 * The low 64 bits of the counter will overflow.  The
+		 * assembly doesn't handle this case, so split the
+		 * operation into two at the point where the overflow
+		 * will occur.  After the first part, add the carry bit.
+		 */
+		part1_len = min(len, (nblocks - ctr64) * AES_BLOCK_SIZE);
+		aes_ctr64_x86(dst, src, part1_len, le_ctr, key);
+		le_ctr[0] = 0;
+		le_ctr[1]++;
+		aes_ctr64_x86(dst + part1_len, src + part1_len, len - part1_len,
+			      le_ctr, key);
+	}
+	kernel_fpu_end();
+	put_unaligned_be64(ctr64, &ctr[8]);
+	put_unaligned_be64(le_ctr[1], &ctr[0]);
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CTR && CONFIG_X86_64 */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

