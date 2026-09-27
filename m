Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4E3D955B;
	Sun, 27 Sep 2026 22:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549081; cv=none; b=ga+ZV3DhNFx76SWO439k4I3zBOI7WkbxE1J+mq9iBK1MqgL/BiuZJppuv45smTE0E96awkL8v7T9rQJblEzG6ipN9KeWfHCN7Ch9/GS5uyL0RYuHihD16rCN+9o68FQ5F+92Dq6PIKw+EhPl+h0jWRBaVxh1maMTnNj58SKBI3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549081; c=relaxed/simple;
	bh=/E5tfEZ2fXqjIdHBeAH2oPvd2/mjsIopePf3ZLdu9cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN/iYm1dncQ7K4zL3LjtRL3JkwDy8WOgdYgTO3VoB8gSyPuB0wBfaKuWpi/XUMpvoryjC07ukCAwF1dgaOu8e0HVYhJxp9gPqY77e+I0FW8UR8019/hsRWzqkwFAtJVXknPCt5QCxO//VHM3rOapFwgDPL/tWLz6gT+7zRuppAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7zsckOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7zsckOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D8E1F00899;
	Sun, 27 Sep 2026 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549079;
	bh=X2FSuOPfyKV6B0ovHEcQOtl6Lk/wICn28dqoaEIyKAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7zsckOiDBAtlRSTQMX+i0KJ0qY8sVc5VeV5l7m7igjS2TwagOr04vwg3X+r4HqUj
	 8UBQ33Gb0TVyo3lCrH5rr5Yi5GlhH2CnPNoiy/RjsMRwuvf4E5wvxOR1x0oLuRZu76
	 nyEdxsdObxjPSbioiH0d9+6fCy3ol6VXqtOl9Ykt/3gCyOxdmUcmzt5WISkTvXv+or
	 9966Cn6oxI7kf3dxgvuDU5cv10NEd3WbeXoNPOO3CepQkgUdeURqzQylEwHJjTqTw0
	 8BYdSFxX33A9VwGVfM4DhnNU27u4kWHdtu652UErvvpUK1oH+QwF+/cRwnp59D7aO/
	 erwHp08rGTE2g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 03/20] lib/crypto: x86/aes: Clean up aes-aesni.S in preparation for AES modes
Date: Sun, 27 Sep 2026 15:42:54 -0700
Message-ID: <20260927224418.109759-4-ebiggers@kernel.org>
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

Various miscellaneous updates to the assembly code in preparation for
adding implementations of AES modes to the same file:

- Define macros for the function argument registers, function prologues,
  and function epilogues to centralize some of the handling of 32-bit vs
  64-bit.

- Refactor the actual AES encryption and AES decryption logic into
  macros _do_aes and _do_aes_ecb so that some of the modes can reuse it.

- Rename mask to expandkey_mask to differentiate it from the bswap_mask
  that will be added.

- Update the prototypes of aes_encrypt_aesni() and aes_decrypt_aesni()
  to be dst, src, key so that they will match the mode functions.

  Note that this means passing a pointer to the key struct instead of a
  (nrounds, rndkeys) pair, similar to what arch/x86/crypto/aes*.S do.
  Although this makes the assembly code depend on the format of the key
  struct, having one fewer argument makes it easier to accommodate
  32-bit mode, and the C glue code becomes slightly simpler.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes-aesni.S | 249 +++++++++++++++++++++++++------------
 lib/crypto/x86/aes.h       |  28 +++--
 2 files changed, 185 insertions(+), 92 deletions(-)

diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index b8c3e104a3be..a56fcb36da18 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -8,25 +8,126 @@
 // AVX.  It does use up to SSE4.1, which all CPUs with AES-NI have.
 #include <linux/linkage.h>
 
-.section .rodata
 #ifdef __x86_64__
 #define RODATA(label)	label(%rip)
-#else
+
+#define ARG0		%rdi
+#define ARG1		%rsi
+#define ARG2		%rdx
+#define ARG2_32		%edx
+#define ARG3		%rcx
+#define ARG4		%r8
+#define TMP		%rax
+#define TMP_32		%eax
+#define TMP_16		%ax
+#define TMP_8		%al
+
+#else // __x86_64__
+
 #define RODATA(label)	label
-#endif
 
+// Caller-save GPRs and the first 3 function arguments, assuming -mregparm=3
+#define ARG0		%eax
+#define ARG1		%edx
+#define ARG2		%ecx
+#define ARG2_32		%ecx
+
+// *Callee*-save GPRs.
+#define ARG3		%edi
+#define ARG4		%esi
+#define TMP		%ebx
+#define TMP_32		%ebx
+#define TMP_16		%bx
+#define TMP_8		%bl
+#endif // !__x86_64__
+
+// Offsets in struct aes_key
+#define OFFSETOF_NROUNDS	4
+#define OFFSETOF_ROUNDKEYS	16
+#define OFFSETOF_INVROUNDKEYS	256
+
+.section .rodata
+.p2align 4
+.Lexpandkey_mask:
 	// A mask for pshufb that extracts the last dword, rotates it right by 8
 	// bits, and copies the result to all four dwords.
-.p2align 4
-.Lmask:
 	.byte	13, 14, 15, 12, 13, 14, 15, 12, 13, 14, 15, 12, 13, 14, 15, 12
 
-	// The AES round constants, used during key expansion
 .Lrcon:
+	// The AES round constants, used during key expansion
 	.long	0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
 
 .text
 
+// In 32-bit mode, push certain callee-saved GPRs and optionally load function
+// arguments from the stack into them.  Do nothing in 64-bit mode.
+//
+// TMP is always made available as a temporary register.
+//
+// \uses_arg3 is 0 to not touch ARG3, 1 to make it available as a temporary
+// register only, or 2 to actually load it as an argument from the stack.
+// Likewise for \uses_arg4 and ARG4.  It's assumed the -mregparm=3 convention is
+// being used and %esp hasn't been modified since function entry.
+.macro _prologue	uses_arg3=0, uses_arg4=0
+#ifdef __i386__
+	.set	ARG3_OFFSET, 4	// Assuming -mregparm=3
+	.set	ARG3_PUSHED, \uses_arg3
+	.set	ARG4_PUSHED, \uses_arg4
+.if \uses_arg3
+	push	ARG3
+	.set	ARG3_OFFSET, ARG3_OFFSET + 4
+  .if \uses_arg3 == 2
+	mov	ARG3_OFFSET(%esp), ARG3
+  .endif
+.endif
+.if \uses_arg4
+	push	ARG4
+	.set	ARG3_OFFSET, ARG3_OFFSET + 4
+  .if \uses_arg4 == 2
+	mov	ARG3_OFFSET+4(%esp), ARG4
+  .endif
+.endif
+	push	TMP
+	.set	ARG3_OFFSET, ARG3_OFFSET + 4
+#endif // __i386__
+.endm
+
+.macro _reload_arg3
+#ifdef __i386__
+	mov	ARG3_OFFSET(%esp), ARG3
+#endif
+.endm
+
+// Undo any pushes that _prologue did, then return.
+.macro _epilogue
+#ifdef __i386__
+	pop	TMP
+.if ARG4_PUSHED
+	pop	ARG4
+.endif
+.if ARG3_PUSHED
+	pop	ARG3
+.endif
+#endif
+	RET
+.endm
+
+.macro	_aesenc		enc, rndkey, data
+.if \enc
+	aesenc		\rndkey, \data
+.else
+	aesdec		\rndkey, \data
+.endif
+.endm
+
+.macro	_aesenclast	enc, rndkeylast, data
+.if \enc
+	aesenclast	\rndkeylast, \data
+.else
+	aesdeclast	\rndkeylast, \data
+.endif
+.endm
+
 // Transform four dwords [a0, a1, a2, a3] in \a into
 // [a0, a0^a1, a0^a1^a2, a0^a1^a2^a3].  \tmp is a temporary xmm register.
 //
@@ -71,32 +172,18 @@
 .endm
 
 .macro	_aes_expandkey_aesni	is_aes128
-#ifdef __x86_64__
 	// Arguments
-	.set	RNDKEYS,	%rdi
-	.set	INV_RNDKEYS,	%rsi
-	.set	IN_KEY,		%rdx
+	.set	RNDKEYS,	ARG0
+	.set	INV_RNDKEYS,	ARG1
+	.set	IN_KEY,		ARG2
 
 	// Other local variables
-	.set	RCON_PTR,	%rcx
-	.set	COUNTER,	%eax
-#else
-	// Arguments, assuming -mregparm=3
-	.set	RNDKEYS,	%eax
-	.set	INV_RNDKEYS,	%edx
-	.set	IN_KEY,		%ecx
-
-	// Other local variables
-	.set	RCON_PTR,	%ebx
-	.set	COUNTER,	%esi
-#endif
+	.set	RCON_PTR,	ARG3
+	.set	COUNTER,	TMP_32
 	.set	RCON,		%xmm6
 	.set	MASK,		%xmm7
 
-#ifdef __i386__
-	push		%ebx
-	push		%esi
-#endif
+	_prologue	uses_arg3=1
 
 .if \is_aes128
 	// AES-128: the first round key is simply a copy of the raw key.
@@ -112,7 +199,7 @@
 .endif
 
 	// Generate the remaining round keys.
-	movdqa		RODATA(.Lmask), MASK
+	movdqa		RODATA(.Lexpandkey_mask), MASK
 .if \is_aes128
 	lea		RODATA(.Lrcon), RCON_PTR
 	mov		$10, COUNTER
@@ -176,11 +263,7 @@
 	movdqu		%xmm0, 16(INV_RNDKEYS)	// => Last inverse round key
 
 .Ldone\@:
-#ifdef __i386__
-	pop		%esi
-	pop		%ebx
-#endif
-	RET
+	_epilogue
 .endm
 
 // void aes128_expandkey_aesni(u32 rndkeys[], u32 *inv_rndkeys,
@@ -195,67 +278,73 @@ SYM_FUNC_START(aes256_expandkey_aesni)
 	_aes_expandkey_aesni	0
 SYM_FUNC_END(aes256_expandkey_aesni)
 
-.macro	_aes_crypt_aesni	enc
-#ifdef __x86_64__
-	.set	RNDKEYS,	%rdi
-	.set	NROUNDS,	%esi
-	.set	OUT,		%rdx
-	.set	IN,		%rcx
-#else
-	// Assuming -mregparm=3
-	.set	RNDKEYS,	%eax
-	.set	NROUNDS,	%edx
-	.set	OUT,		%ecx
-	.set	IN,		%ebx	// Passed on stack
-#endif
-
-#ifdef __i386__
-	push		%ebx
-	mov		8(%esp), %ebx
-#endif
-
-	// Zero-th round
-	movdqu		(IN), %xmm0
-	movdqu		(RNDKEYS), %xmm1
-	pxor		%xmm1, %xmm0
-
-	// Normal rounds
-	add		$16, RNDKEYS
+// AES-encrypt (\enc=1) or AES-decrypt (\enc=0) the AESDATA registers specified
+// in \vecs using the aes_enckey or aes_key pointed to by KEY.  RNDKEY must be
+// set to a temporary XMM register, NROUNDS to a temporary 32-bit GPR, and
+// RNDKEY_PTR to a temporary full-size GPR.
+.macro	_do_aes		enc, vecs:vararg
+	movl		OFFSETOF_NROUNDS(KEY), NROUNDS
 	dec		NROUNDS
-.Lnext_round\@:
-	movdqu		(RNDKEYS), %xmm1
 .if \enc
-	aesenc		%xmm1, %xmm0
+	.set		rndkey0_offs, OFFSETOF_ROUNDKEYS
 .else
-	aesdec		%xmm1, %xmm0
+	.set		rndkey0_offs, OFFSETOF_INVROUNDKEYS
 .endif
-	add		$16, RNDKEYS
+
+	// Do the zero-th AES round.
+	movdqu		rndkey0_offs(KEY), RNDKEY
+.irp i, \vecs
+	pxor		RNDKEY, AESDATA\i
+.endr
+	// Do the regular AES rounds.
+	lea		rndkey0_offs+16(KEY), RNDKEY_PTR
+.Lnext_round\@:
+	movdqu		(RNDKEY_PTR), RNDKEY
+	add		$16, RNDKEY_PTR
+.irp i, \vecs
+	_aesenc		\enc, RNDKEY, AESDATA\i
+.endr
 	dec		NROUNDS
-	jne		.Lnext_round\@
+	jnz		.Lnext_round\@
+	// Do the last AES round.
+	movdqu		(RNDKEY_PTR), RNDKEY
+.irp i, \vecs
+	_aesenclast	\enc, RNDKEY, AESDATA\i
+.endr
+.endm
 
-	// Last round
-	movdqu		(RNDKEYS), %xmm1
-.if \enc
-	aesenclast	%xmm1, %xmm0
-.else
-	aesdeclast	%xmm1, %xmm0
-.endif
-	movdqu		%xmm0, (OUT)
+.macro	_do_aes_ecb	enc, vecs:vararg
+.irp i, \vecs
+	movdqu		\i*16(SRC), AESDATA\i
+.endr
+	_do_aes		\enc, \vecs
+.irp i, \vecs
+	movdqu		AESDATA\i, \i*16(DST)
+.endr
+.endm
 
-#ifdef __i386__
-	pop		%ebx
-#endif
-	RET
+.macro	_aes_crypt_aesni	enc
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	KEY,		ARG2
+	.set	RNDKEY_PTR,	ARG3	// Temporary register for _do_aes
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
+	.set	AESDATA0,	%xmm0
+	.set	RNDKEY,		%xmm1	// Temporary register for _do_aes
+
+	_prologue	uses_arg3=1
+	_do_aes_ecb	\enc, 0
+	_epilogue
 .endm
 
-// void aes_encrypt_aesni(const u32 rndkeys[], int nrounds,
-//			  u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+// void aes_encrypt_aesni(u8 dst[AES_BLOCK_SIZE], const u8 src[AES_BLOCK_SIZE],
+//			  const struct aes_enckey *key);
 SYM_FUNC_START(aes_encrypt_aesni)
 	_aes_crypt_aesni	1
 SYM_FUNC_END(aes_encrypt_aesni)
 
-// void aes_decrypt_aesni(const u32 inv_rndkeys[], int nrounds,
-//			  u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+// void aes_decrypt_aesni(u8 dst[AES_BLOCK_SIZE], const u8 src[AES_BLOCK_SIZE],
+//			  const struct aes_key *key);
 SYM_FUNC_START(aes_decrypt_aesni)
 	_aes_crypt_aesni	0
 SYM_FUNC_END(aes_decrypt_aesni)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index b047dee94f57..06146fef06be 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -7,16 +7,21 @@
 
 #include <asm/fpu/api.h>
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_aes);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_aesni);
+
+/* The assembly code assumes the following offsets. */
+static_assert(offsetof(struct aes_enckey, nrounds) == 4);
+static_assert(offsetof(struct aes_enckey, k.rndkeys) == 16);
+static_assert(offsetof(struct aes_key, inv_k.inv_rndkeys) == 256);
 
 void aes128_expandkey_aesni(u32 rndkeys[], u32 *inv_rndkeys,
 			    const u8 in_key[AES_KEYSIZE_128]);
 void aes256_expandkey_aesni(u32 rndkeys[], u32 *inv_rndkeys,
 			    const u8 in_key[AES_KEYSIZE_256]);
-void aes_encrypt_aesni(const u32 rndkeys[], int nrounds,
-		       u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
-void aes_decrypt_aesni(const u32 inv_rndkeys[], int nrounds,
-		       u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+void aes_encrypt_aesni(u8 dst[AES_BLOCK_SIZE], const u8 src[AES_BLOCK_SIZE],
+		       const struct aes_enckey *key);
+void aes_decrypt_aesni(u8 dst[AES_BLOCK_SIZE], const u8 src[AES_BLOCK_SIZE],
+		       const struct aes_key *key);
 
 /*
  * Expand an AES key using AES-NI if supported and usable or generic code
@@ -36,7 +41,7 @@ static void aes_preparekey_arch(union aes_enckey_arch *k,
 	u32 *rndkeys = k->rndkeys;
 	u32 *inv_rndkeys = inv_k ? inv_k->inv_rndkeys : NULL;
 
-	if (static_branch_likely(&have_aes) && key_len != AES_KEYSIZE_192 &&
+	if (static_branch_likely(&have_aesni) && key_len != AES_KEYSIZE_192 &&
 	    irq_fpu_usable()) {
 		kernel_fpu_begin();
 		if (key_len == AES_KEYSIZE_128)
@@ -53,9 +58,9 @@ static void aes_encrypt_arch(const struct aes_enckey *key,
 			     u8 out[AES_BLOCK_SIZE],
 			     const u8 in[AES_BLOCK_SIZE])
 {
-	if (static_branch_likely(&have_aes) && irq_fpu_usable()) {
+	if (static_branch_likely(&have_aesni) && irq_fpu_usable()) {
 		kernel_fpu_begin();
-		aes_encrypt_aesni(key->k.rndkeys, key->nrounds, out, in);
+		aes_encrypt_aesni(out, in, key);
 		kernel_fpu_end();
 	} else {
 		aes_encrypt_generic(key->k.rndkeys, key->nrounds, out, in);
@@ -66,10 +71,9 @@ static void aes_decrypt_arch(const struct aes_key *key,
 			     u8 out[AES_BLOCK_SIZE],
 			     const u8 in[AES_BLOCK_SIZE])
 {
-	if (static_branch_likely(&have_aes) && irq_fpu_usable()) {
+	if (static_branch_likely(&have_aesni) && irq_fpu_usable()) {
 		kernel_fpu_begin();
-		aes_decrypt_aesni(key->inv_k.inv_rndkeys, key->nrounds,
-				  out, in);
+		aes_decrypt_aesni(out, in, key);
 		kernel_fpu_end();
 	} else {
 		aes_decrypt_generic(key->inv_k.inv_rndkeys, key->nrounds,
@@ -81,5 +85,5 @@ static void aes_decrypt_arch(const struct aes_key *key,
 static void aes_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_AES))
-		static_branch_enable(&have_aes);
+		static_branch_enable(&have_aesni);
 }
-- 
2.55.0

