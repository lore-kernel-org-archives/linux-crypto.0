Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A51D9A63
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038957; cv=none; b=DYf2QgSATGBW3Ax+0sy7HR9zK6YZFVH8dmCjPneECTFD64JyP8UIBCdZRkQVhk5m6okqNYM66bZYOV+jMq2JcT0Q5K5siKQ0rEjiHEnB4l07FkoQWs7RBTa9+XpA9tfr24tqg2hdI9vm3sC3YPD7x3I5I8BxsdrocZdHGSsxCjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038957; c=relaxed/simple;
	bh=O+QDgYdLqxtymmElnvWAzhHkq2WeU2TcPO63cefZkw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUllaQQAcYd8MYqqOHayW+vPebir3G/DLQoY75x57ydjbxUPwT1tpV+Sy7EK2PJY/5UM7f7He71t0a67d0WXKgqx/JM0SiF3wPTNF2bOEVF9QvvMb+EElyZxIgEBcpYfUOu34wb06uUSBzc9kbQP4d85YhCYkjY0Y+/QsPrkXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVGhh4n7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVGhh4n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76FBC4CED0;
	Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038955;
	bh=O+QDgYdLqxtymmElnvWAzhHkq2WeU2TcPO63cefZkw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVGhh4n7j9gpegCVvtk0RmuHla2JjoRLDMsKGboEGhMWOOyb6mlbvMqD3bnTTdJ/9
	 Fxun92adT9Lq35I84LBUJ66kv6VDRkyStaqJom/3yz/XfP2JkHW6Z9w3sD/FNI078B
	 kB0FQTKKyTBc82vcKiIRfYA7rIt/t4T2UX/QN8C/XESxyj3bNGQffwzkTI1MidRD6o
	 Zxl0x3kgqI2Bll8OvgbmgMmL21DaYhX8G6AXwQDSLK2tm8wHBCs2/+uGkGgGIryarK
	 CIPb3fkymhqXBcO+s6zEkvp1HxFWZqspJi/LTPWy+yyieWjMX30QLoPjY6s6enakAh
	 5Usl3ulG0YR9w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 5/8] crypto: x86/aes-xts - improve some comments
Date: Thu, 12 Dec 2024 13:28:42 -0800
Message-ID: <20241212212845.40333-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
References: <20241212212845.40333-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Improve some of the comments in aes-xts-avx-x86_64.S.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 31 ++++++++++++++++++----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index ca69e6480cb6..903b894e5f48 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -341,13 +341,18 @@
 .endif
 .endm
 
 // Do one step in computing the next set of tweaks using the VPCLMULQDQ method
 // (the same method _next_tweakvec uses for VL > 16).  This means multiplying
-// each tweak by x^(4*VL/16) independently.  Since 4*VL/16 is a multiple of 8
-// when VL > 16 (which it is here), the needed shift amounts are byte-aligned,
-// which allows the use of vpsrldq and vpslldq to do 128-bit wide shifts.
+// each tweak by x^(4*VL/16) independently.
+//
+// Since 4*VL/16 is a multiple of 8 when VL > 16 (which it is here), the needed
+// shift amounts are byte-aligned, which allows the use of vpsrldq and vpslldq
+// to do 128-bit wide shifts.  The 128-bit left shift (vpslldq) saves
+// instructions directly.  The 128-bit right shift (vpsrldq) performs better
+// than a 64-bit right shift on Intel CPUs in the context where it is used here,
+// because it runs on a different execution port from the AES instructions.
 .macro	_tweak_step_pclmul	i
 .if \i == 0
 	vpsrldq		$(128 - 4*VL/16) / 8, TWEAK0, NEXT_TWEAK0
 .elseif \i == 2
 	vpsrldq		$(128 - 4*VL/16) / 8, TWEAK1, NEXT_TWEAK1
@@ -378,11 +383,11 @@
 // _tweak_step does one step of the computation of the next set of tweaks from
 // TWEAK[0-3].  To complete all steps, this is invoked with increasing values of
 // \i that include at least 0 through 19, then 1000 which signals the last step.
 //
 // This is used to interleave the computation of the next set of tweaks with the
-// AES en/decryptions, which increases performance in some cases.
+// AES en/decryptions, which increases performance in some cases.  Clobbers V5.
 .macro	_tweak_step	i
 .if VL == 16
 	_tweak_step_mulx	\i
 .else
 	_tweak_step_pclmul	\i
@@ -415,13 +420,14 @@
 	// easy to do AES-128 and AES-192 by skipping irrelevant rounds at the
 	// beginning.  Skipping rounds at the end doesn't work as well because
 	// the last round needs different instructions.
 	//
 	// An alternative approach would be to roll up all the round loops.  We
-	// don't do that because it isn't compatible with caching the round keys
-	// in registers which we do when possible (see below), and also because
-	// it seems unwise to rely *too* heavily on the CPU's branch predictor.
+	// don't do that because (a) it isn't compatible with caching the round
+	// keys in registers which we do when possible (see below), (b) we
+	// interleave the AES rounds with the XTS tweak computation, and (c) it
+	// seems unwise to rely *too* heavily on the CPU's branch predictor.
 	lea		OFFS-16(KEY, KEYLEN64, 4), KEY
 
 	// If all 32 SIMD registers are available, cache all the round keys.
 .if USE_AVX10
 	cmp		$24, KEYLEN
@@ -482,11 +488,11 @@
 .endm
 
 // Do a single round of AES en/decryption on the blocks in registers V0-V3,
 // using the same key for all blocks.  The round key is loaded from the
 // appropriate register or memory location for round \i.  In addition, does two
-// steps of the computation of the next set of tweaks.  May clobber V4.
+// steps of the computation of the next set of tweaks.  May clobber V4 and V5.
 .macro	_vaes_4x	enc, last, i
 .if USE_AVX10
 	_tweak_step	(2*(\i-5))
 	_vaes		\enc, \last, KEY\i, V0
 	_vaes		\enc, \last, KEY\i, V1
@@ -725,10 +731,13 @@
 	jmp		.Ldone\@
 .endm
 
 // void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 //			   u8 iv[AES_BLOCK_SIZE]);
+//
+// Encrypt |iv| using the AES key |tweak_key| to get the first tweak.  Assumes
+// that the CPU supports AES-NI and AVX, but not necessarily VAES or AVX10.
 SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
 	.set	TWEAK_KEY,	%rdi
 	.set	IV,		%rsi
 	.set	KEYLEN,		%eax
 	.set	KEYLEN64,	%rax
@@ -755,13 +764,13 @@ SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
 SYM_FUNC_END(aes_xts_encrypt_iv)
 
 // Below are the actual AES-XTS encryption and decryption functions,
 // instantiated from the above macro.  They all have the following prototype:
 //
-// void (*xts_asm_func)(const struct crypto_aes_ctx *key,
-//			const u8 *src, u8 *dst, unsigned int len,
-//			u8 tweak[AES_BLOCK_SIZE]);
+// void (*xts_crypt_func)(const struct crypto_aes_ctx *key,
+//			  const u8 *src, u8 *dst, unsigned int len,
+//			  u8 tweak[AES_BLOCK_SIZE]);
 //
 // |key| is the data key.  |tweak| contains the next tweak; the encryption of
 // the original IV with the tweak key was already done.  This function supports
 // incremental computation, but |len| must always be >= 16 (AES_BLOCK_SIZE), and
 // |len| must be a multiple of 16 except on the last call.  If |len| is a
-- 
2.47.1

