Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800EE41BA60;
	Sun, 27 Sep 2026 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549083; cv=none; b=agOLQVOFKCStPQWZPieLjvt7rzz6uGo7zuTkZRwL8SWsH8y4lfevVF8u6yqMwwtBlFT1feqNec7MdFa3IeU+YT0wbO76fojyBQRE3vlpA17OD3Z1dB59DKvSYwAMxGvhpvQwzLmhy5rCTUeLGWyW/3KHtPVTEik3lhWND+JvrWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549083; c=relaxed/simple;
	bh=b5ucm/iKBSHPIcfzvrTeea40VY1XaBHFbxqQbzMIoB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLADmfDEf4ZoRCcUisN1kMKKagDKgDeQ7/29BdJ+Zl4XdInqjRZ379JUUNOlrmvtogMhsh+3+m3eqJIXjPeCTKwXXRaI3gGWlbBxHDzjJ5ULAYOxxfL2JdKVO5qUNCqnl6739sLXAY54hPh7MR+bjXbeLGNZYM96MU8Pos82hF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMcGeg+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMcGeg+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C26C1F0089B;
	Sun, 27 Sep 2026 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549081;
	bh=cKPlUTeu+G5Bqr8CZtbIzQ1ZreRm7F/E3gAGuyqpGFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMcGeg+rX7nNrwQEeLUnq6Q71zmZ05FJ6HXSYPq+eNeUlNcKg+JTaPWQBCZod1s5x
	 gV8vYT8nuPxe6gXcCUefp4N22Sqih5TlQfumNxK3tH4pM/GHXxZ5/8uUPAlzWv0VsZ
	 sIAtoANYZp8roipLWXCJhd/+LAuZzgljkDv22Yj7A6GYwCSZy/qKlVrG9rWGPMUDb7
	 pA6DacWGgCQBXUXo3SNLtCcp0REK2ZyTtfW16/ohxvlUcuajoN+3b7geaOeHf84xTm
	 NY6MKNxJn6GqViDhFhyL85/t8FLwF9+jGpU7/Af9fYZ901yQCivbuzv1IDUDex8v+r
	 wYFnzc0wH/0Bg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 07/20] lib/crypto: x86/aes-xts: Add AES-NI optimization
Date: Sun, 27 Sep 2026 15:42:58 -0700
Message-ID: <20260927224418.109759-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Optimize the crypto library's AES-XTS support with AES-NI, bringing its
performance on par with the "xts-aes-aesni" skcipher algorithm it will
supersede.

The new assembly code is written from scratch to fit well into the
crypto library and to be more consistent with aes-xts-avx-x86_64.S than
the code in arch/x86/crypto/aesni-intel_asm.S that it will supersede.
At a high level it is quite similar though, including doing 4 blocks per
iteration and supporting 32-bit mode for parity with the old code.

The new assembly code also fixes the flaw the old code had where the
encrypted tweaks were spilled to the destination buffer, rather than
kept entirely in registers (64-bit mode) or spilled to the stack (32-bit
mode).  The encrypted tweaks are secret values that should not be
exposed to any code that doesn't have access to the key itself.

Note: the priority of xts-aes-lib is left unchanged at 110 temporarily.
It will be increased when the AVX-optimized AES-XTS code is migrated
too.  Most systems use the AVX-optimized code; this commit just deals
with support for older CPUs that have AES-NI but not AVX (and 32-bit).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes-aesni.S | 159 +++++++++++++++++++++++++++++++++++++
 lib/crypto/x86/aes.h       |  44 ++++++++++
 2 files changed, 203 insertions(+)

diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index 297fe21ba830..cbc0cc23f63e 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -49,6 +49,17 @@
 
 .section .rodata
 .p2align 4
+.Lxts_gf_poly:
+	// For XTS: a constant used when advancing the tweak by one block by
+	// multiplying by the polynomial 'x' in GF(2^128).  The low 64 bits of
+	// this value represent the polynomial x^7 + x^2 + x + 1; it is the
+	// value that must be XOR'd into the low 64 bits of the tweak each time
+	// a 1 is carried out of the high 64 bits.
+	//
+	// The high 64 bits of this value is just the internal carry bit that
+	// exists when there's a carry out of the low 64 bits of the tweak.
+	.quad	0x87, 1
+
 #ifdef __x86_64__
 .Lbswap_mask:
 	// A mask for pshufb that byte-reflects the value.
@@ -762,3 +773,151 @@ SYM_FUNC_START(aes_ctr64_crypt_aesni)
 	RET
 SYM_FUNC_END(aes_ctr64_crypt_aesni)
 #endif // __x86_64__
+
+// Given a 128-bit XTS tweak in the xmm register \tweak, compute the next tweak
+// (by multiplying by the polynomial 'x') and write it back to \tweak.
+.macro	_next_tweak	tweak, tmp
+	pshufd		$0x13, \tweak, \tmp
+	paddq		\tweak, \tweak
+	psrad		$31, \tmp
+	pand		GF_POLY, \tmp
+	pxor		\tmp, \tweak
+.endm
+
+.macro	_aes_xts_crypt	enc
+	// Arguments
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	NBLOCKS,	ARG2
+	.set	NBLOCKS32,	ARG2_32	// Used for improved code density
+	.set	TWEAK_PTR,	ARG3
+	.set	KEY,		ARG4
+
+	// Other local variables
+#ifdef __x86_64__
+	.set	RNDKEY_PTR,	%r9
+#else
+	.set	RNDKEY_PTR,	TWEAK_PTR // TWEAK_PTR is clobbered and reloaded later.
+#endif
+	.set	NROUNDS,	TMP_32
+	.set	AESDATA0,	%xmm0
+	.set	AESDATA1,	%xmm1
+	.set	AESDATA2,	%xmm2
+	.set	AESDATA3,	%xmm3
+	.set	GF_POLY,	%xmm4
+	.set	RNDKEY,		%xmm5
+	.set	TWEAK,		%xmm6
+	.set	SAVED_TWEAK0,	%xmm7
+#ifdef __x86_64__
+	.set	SAVED_TWEAK1,	%xmm8
+	.set	SAVED_TWEAK2,	%xmm9
+#endif
+
+	_prologue	uses_arg3=2, uses_arg4=2
+#ifdef __i386__
+	// Reserve 16-byte aligned space to spill two tweaks.
+	push		%ebp
+	mov		%esp, %ebp
+	and		$~15, %esp
+	sub		$32, %esp
+#endif
+
+	movdqu		(TWEAK_PTR), TWEAK
+	movdqa		RODATA(.Lxts_gf_poly), GF_POLY
+
+	sub		$4, NBLOCKS
+	jl		.Lxts_loop4_done\@
+.p2align 5
+.Lxts_loop4\@:
+	// Load the next four source blocks into AESDATA[0-3] and XOR them with
+	// their tweaks, advancing the tweak three times in order to do so.
+	// Save the four tweaks for later; on 64-bit they all fit into
+	// registers, while on 32-bit two tweaks are spilled to the stack.
+.irp i, 0,1,2,3
+	movdqu		\i*16(SRC), AESDATA\i
+	pxor		TWEAK, AESDATA\i
+  .if \i != 3
+#ifdef __x86_64__
+	movdqa		TWEAK, SAVED_TWEAK\i
+#else
+    .if \i == 0
+	movdqa		TWEAK, SAVED_TWEAK0
+    .else
+	movdqa		TWEAK, (\i-1)*16(%esp)
+    .endif
+#endif
+	_next_tweak	TWEAK, RNDKEY
+  .endif
+.endr
+
+	// Encrypt or decrypt the blocks.
+	_do_aes		\enc, 0,1,2,3
+
+	// XOR the blocks with the saved tweaks.
+	pxor		SAVED_TWEAK0, AESDATA0
+#ifdef __x86_64__
+	pxor		SAVED_TWEAK1, AESDATA1
+	pxor		SAVED_TWEAK2, AESDATA2
+#else
+	pxor		(%esp), AESDATA1
+	pxor		16(%esp), AESDATA2
+#endif
+	pxor		TWEAK, AESDATA3
+
+	// Store the encrypted or decrypted blocks.
+.irp i, 0,1,2,3
+	movdqu		AESDATA\i, \i*16(DST)
+.endr
+
+	_next_tweak	TWEAK, RNDKEY
+	add		$64, SRC
+	add		$64, DST
+	sub		$4, NBLOCKS
+	jge		.Lxts_loop4\@
+.Lxts_loop4_done\@:
+	add		$4, NBLOCKS32
+	jz		.Lxts_done\@
+
+.Lxts_loop1\@:
+	movdqu		(SRC), AESDATA0
+	pxor		TWEAK, AESDATA0
+	_do_aes		\enc, 0
+	pxor		TWEAK, AESDATA0
+	movdqu		AESDATA0, (DST)
+	_next_tweak	TWEAK, RNDKEY
+	add		$16, SRC
+	add		$16, DST
+	dec		NBLOCKS32
+	jnz		.Lxts_loop1\@
+
+.Lxts_done\@:
+#ifdef __i386__
+	// Zeroize the stack buffer that tweaks were spilled to.
+	pxor		AESDATA0, AESDATA0
+	movdqa		AESDATA0, (%esp)
+	movdqa		AESDATA0, 16(%esp)
+	mov		%ebp, %esp
+	pop		%ebp
+#endif
+	// Store the next tweak.  On 32-bit, reload TWEAK_PTR from stack first.
+	_reload_arg3
+	movdqu		TWEAK, (TWEAK_PTR)
+	_epilogue
+.endm
+
+// void aes_xts_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      u8 tweak[AES_BLOCK_SIZE],
+//			      const struct aes_key *key);
+// void aes_xts_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      u8 tweak[AES_BLOCK_SIZE],
+//			      const struct aes_key *key);
+//
+// `tweak` must have already been encrypted by the tweak key; `key` is just the
+// main key.  To allow incremental computation, `tweak` is updated to contain
+// the next tweak.
+SYM_FUNC_START(aes_xts_encrypt_aesni)
+	_aes_xts_crypt	1
+SYM_FUNC_END(aes_xts_encrypt_aesni)
+SYM_FUNC_START(aes_xts_decrypt_aesni)
+	_aes_xts_crypt	0
+SYM_FUNC_END(aes_xts_decrypt_aesni)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 2a2b26d10e87..54b599bd2581 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -259,6 +259,50 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CTR && CONFIG_X86_64 */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
+void aes_xts_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   u8 tweak[AES_BLOCK_SIZE], const struct aes_key *key);
+void aes_xts_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   u8 tweak[AES_BLOCK_SIZE], const struct aes_key *key);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+static __always_inline bool
+aes_xts_crypt_x86(u8 *dst, const u8 *src, size_t len, u8 tweak[AES_BLOCK_SIZE],
+		  const struct aes_xts_key *key, bool cont, bool enc)
+{
+	const long nblocks = len / AES_BLOCK_SIZE;
+
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+
+	kernel_fpu_begin();
+	if (!cont)
+		aes_encrypt_aesni(tweak, tweak, &key->tweak_key);
+	if (enc)
+		aes_xts_encrypt_aesni(dst, src, nblocks, tweak, &key->main_key);
+	else
+		aes_xts_decrypt_aesni(dst, src, nblocks, tweak, &key->main_key);
+	kernel_fpu_end();
+	return true;
+}
+
+#define aes_xts_encrypt_arch aes_xts_encrypt_arch
+static bool aes_xts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_x86(dst, src, len, tweak, key, cont, true);
+}
+
+#define aes_xts_decrypt_arch aes_xts_decrypt_arch
+static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_x86(dst, src, len, tweak, key, cont, false);
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

