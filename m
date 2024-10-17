Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62176FD5;
	Thu, 17 Oct 2024 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123333; cv=none; b=pbJk1JT9moWag3342Tb3KVaJrN0rzH7ndIFSnbiju4U/NfPkjUmKbL8WM+VPdlenU4J34/sMNxvPgchbws6++/gOmBhrE8I3LGXK/P7pIhn9kR+/D3P7oQiChbZoeUja8G3PuGz9vtAv6tzkRWexJE4e6sBE6XJ3aGyofDAXJww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123333; c=relaxed/simple;
	bh=+IlcoQ78tiRH6TqYz3pDNxBORgQDSbjuYlpc1Mf+M5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3TEyAt39RPM8XLcZIORYWpRBg9TAxK4c2jm5k0lGxSOrswbL2N1uaPWw4pR+/8Pan2ibPgraVWqJr18+vABfbRYOfsBMwO9KAfW3vRv+4x5thIKB/hkjK4DFRklqrIMXuIv1hJU84ONcsDyYOthWj39WiGOa+fSyuyR/WdsYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7u7toA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7u7toA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148CFC4CEC7;
	Thu, 17 Oct 2024 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123333;
	bh=+IlcoQ78tiRH6TqYz3pDNxBORgQDSbjuYlpc1Mf+M5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7u7toA+c7UTTGMsGNxnJmApGFCsgT1efvMFQLnH61y/kIx5J1+tPWO6y3t5+slHV
	 L3DDZegfw0lIY9U3YGputtZlJk7bTmJDUPB1GY1USZSZIAraDBbNB8rI9nLMva7zrM
	 b/PMeDRpMkYOyV2n15vgRfJaql2PTv+ObfVti8CWQZ3zWD74ohRiIIKypG+TkERHzA
	 x+8g7IVWmfuDGUHvnc/hX+5Hb25tkqZP7cw3lsCDv7YBAepxEG+vo6YawXN3m9WKc/
	 N0FvXHFOk2X5RWbriEA4lDHWv14+zHBOte/pw3iwtD5MmIsQSDn87GUB0tAZET42qM
	 7jWS0GlHHRmIw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 01/10] crypto: x86/aegis128 - access 32-bit arguments as 32-bit
Date: Wed, 16 Oct 2024 17:00:42 -0700
Message-ID: <20241017000051.228294-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
References: <20241017000051.228294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix the AEGIS assembly code to access 'unsigned int' arguments as 32-bit
values instead of 64-bit, since the upper bits of the corresponding
64-bit registers are not guaranteed to be zero.

Note: there haven't been any reports of this bug actually causing
incorrect behavior.  Neither gcc nor clang guarantee zero-extension to
64 bits, but zero-extension is likely to happen in practice because most
instructions that operate on 32-bit registers zero-extend to 64 bits.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 29 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index ad7f4c8916256..2de859173940e 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -19,11 +19,11 @@
 #define MSG	%xmm5
 #define T0	%xmm6
 #define T1	%xmm7
 
 #define STATEP	%rdi
-#define LEN	%rsi
+#define LEN	%esi
 #define SRC	%rdx
 #define DST	%rcx
 
 .section .rodata.cst16.aegis128_const, "aM", @progbits, 32
 .align 16
@@ -74,50 +74,50 @@
  */
 SYM_FUNC_START_LOCAL(__load_partial)
 	xor %r9d, %r9d
 	pxor MSG, MSG
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1, %r8
 	jz .Lld_partial_1
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1E, %r8
 	add SRC, %r8
 	mov (%r8), %r9b
 
 .Lld_partial_1:
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x2, %r8
 	jz .Lld_partial_2
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1C, %r8
 	add SRC, %r8
 	shl $0x10, %r9
 	mov (%r8), %r9w
 
 .Lld_partial_2:
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x4, %r8
 	jz .Lld_partial_4
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x18, %r8
 	add SRC, %r8
 	shl $32, %r9
 	mov (%r8), %r8d
 	xor %r8, %r9
 
 .Lld_partial_4:
 	movq %r9, MSG
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x8, %r8
 	jz .Lld_partial_8
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x10, %r8
 	add SRC, %r8
 	pslldq $8, MSG
 	movq (%r8), T0
 	pxor T0, MSG
@@ -137,11 +137,11 @@ SYM_FUNC_END(__load_partial)
  *   %r8
  *   %r9
  *   %r10
  */
 SYM_FUNC_START_LOCAL(__store_partial)
-	mov LEN, %r8
+	mov LEN, %r8d
 	mov DST, %r9
 
 	movq T0, %r10
 
 	cmp $8, %r8
@@ -675,11 +675,11 @@ SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
 
 	movdqa MSG, T0
 	call __store_partial
 
 	/* mask with byte count: */
-	movq LEN, T0
+	movd LEN, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	movdqa .Laegis128_counter(%rip), T1
@@ -700,11 +700,12 @@ SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	RET
 SYM_FUNC_END(crypto_aegis128_aesni_dec_tail)
 
 /*
  * void crypto_aegis128_aesni_final(void *state, void *tag_xor,
- *                                  u64 assoclen, u64 cryptlen);
+ *                                  unsigned int assoclen,
+ *                                  unsigned int cryptlen);
  */
 SYM_FUNC_START(crypto_aegis128_aesni_final)
 	FRAME_BEGIN
 
 	/* load the state: */
@@ -713,12 +714,12 @@ SYM_FUNC_START(crypto_aegis128_aesni_final)
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
 	/* prepare length block: */
-	movq %rdx, MSG
-	movq %rcx, T0
+	movd %edx, MSG
+	movd %ecx, T0
 	pslldq $8, T0
 	pxor T0, MSG
 	psllq $3, MSG /* multiply by 8 (to get bit count) */
 
 	pxor STATE3, MSG
-- 
2.47.0

