Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E1022C378
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875150; cv=none; b=fKwsMycCRRJeTMbJ69eLNKPwJaJ8/2hUKP3jL9I0CWOEZl4n7mocCN/xBqdDjSHAUHTTifJGEB2lZXgkihJDSWzQN8xwVjkA1DnV+8r84HwblUrqpWrgrTIL336tnDNUsmrfWQ62DsHblVqI14YNi7NwjvC2N/mn1glgG+F0TP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875150; c=relaxed/simple;
	bh=A72zRASK2MIJnbhzpyRnOy5EtDb49NEbzfCzkwETwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjNysuSDwUh+YOW5IEEiPT1hJPFXDUNf6UMMmkRzrExwb6WCOvybFk57AIdq8thI5XCi83m2D/PUjPiC1ywaff/BU+3z0d3hbd7QBRgBAUAxhOylTpn9y28VJSy522L8INaQiytV0sP7RUnQ7wJJKgTrSgePMErEBMTUkNg4bZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbjO7xVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbjO7xVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1E4C4CEE2;
	Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875150;
	bh=A72zRASK2MIJnbhzpyRnOy5EtDb49NEbzfCzkwETwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbjO7xVJMRBVEpjfiKewFgCIZ/mBbTA43owVSOynDC4yj0VuWyBJoYJekZcsCOLQd
	 CYn7VJYoHhWtwhnZX40wn0XFJsFLb0PuSBFe/otNlgj+HBYVkHVMPbSwFGXcRYGLzv
	 hbSfhmeWmWF7qT9FBScD3xT39DmS4cQG4gp5nsFMQH9SRYBmCPrlxXr8MkTp9d7Qa3
	 WhlfdpQkOnDgXp3o0dwZNoHATZEiEP89kuWKEGWNmJn/05xoEULNEA8JMXPfPuxcaD
	 U3ybGjdCqaCERHXb27yP+8ADXGnKksllT0NrV/vc6pjpN0e6340i3Yes28ijYlzrcC
	 7HaxAigAaYMpw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 5/7] crypto: x86/aes-xts - improve some comments
Date: Tue, 10 Dec 2024 15:58:32 -0800
Message-ID: <20241210235834.40862-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210235834.40862-1-ebiggers@kernel.org>
References: <20241210235834.40862-1-ebiggers@kernel.org>
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
 arch/x86/crypto/aes-xts-avx-x86_64.S | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 77b3c265be30b..a94f02b7c5b47 100644
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
@@ -731,10 +737,13 @@
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
@@ -767,13 +776,13 @@ SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
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

