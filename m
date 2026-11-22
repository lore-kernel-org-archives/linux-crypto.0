Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314068;
	b=X/qwkffO1YP2KiJ1/cn8RTuPPN6NC7u9hkKbEFo7h8mUvYvQdcenaM6UJXVV6E6pXR3Y
	 Du8/BTR3LKgPpv56ksWM8hz59V4UMtFhh/JGyIUqCWEHgGGWen1c8bYz0bmIeH1l71l4s
	 Xo0in+Cd+9mQ5HfIuq7V4kogHkXxx5Mlp5QDXAEXlSmGXyyafaLLUaULyczWZFHTdx9OS
	 oC5hW3degx8ef0wJKGXgDJm+Ld0Ir2sCH7bT89slU1qzIuJSvqmS2LyQlM81u8M6tdZea
	 Mijo04aID9WHhqQFWj2q+Gjly4N4LVmNfMAv3bgqkkXfpYcjeVeEWjVWK/wbM0NhTEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=x3uCkZfep/XcWzpnJuxfJlGGAX/654FBzv6WyHve0e8=;
	b=D8C3Za7m85BHyeJ7r34thAcwycu//32asDjR+rQvekcl9fYfxLEnDKocUj/5MuIvNoWy
	 PXCJhwUJl9Y6cmPcgZbpIEqW5VFKiBX3DtH5TfXhPwNZQD9WvJLN7OEHoX3so3+Lj9fHA
	 QIkP8FbWnE/Oyakau/KntZfaetYWJl9iXHsAtE0o3ovbiAw7DyOPhUuJ27R3KgS2tyGvP
	 yoVfsGBau8GJ5byXD1GYXbw6+oDKzDfXD0LUCmSnjbzIBbX8KTTpFWKwv2NxD2UCPkuOL
	 N3dINH17+w/+Mktr5WmA4z4zNf0Ldi0+iP8/NThesROIGWsB5+u2cpd5xk0YkphwHuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCtQ2lG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF7E606A334
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCtQ2lG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663371F000CA;
	Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314068;
	bh=x3uCkZfep/XcWzpnJuxfJlGGAX/654FBzv6WyHve0e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCtQ2lG4kjkdwMzia/H54mZi4Ilp0BYcSuWnZngMbI+ZswqlDt31GFYsw5IuUOnGG
	 xEW9Mwsl5cCaM39PVXI+aKIsq/SqlUqm+Buo0JJbdKnwISxFgPGCwARvU4Vg6UIrUU
	 1YScIMOTxqFLYkReUYYS9mS0ObtH9I1rNH/csc8SA311EToqlPABzX+XitktylAyRe
	 IlqXIeyCAPUTKYjjD9NtXWzu5NBt/g65fZxIt+b+woVOBtm5Pvug9ibIVcDSbcVbdm
	 K7qp2atgr+Cup3oPCXsrGRHTU7xngd9xJ5Jg7lNvZzGqEElFdSL/THhVNPVYGW8E6k
	 NR8xwBODGhsqg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/8] lib/crypto: x86/sha512: Keep state in registers across blocks in SSSE3
Date: Sat, 21 Nov 2026 18:20:28 -0800
Message-ID: <20261122022030.296468-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261122022030.296468-1-ebiggers@kernel.org>
References: <20261122022030.296468-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In sha512_transform_ssse3(), each iteration of .Lupdateblock updates the
state in memory using 'add reg, mem' and then immediately reloads all 8
state words from memory at the top of the next iteration.

Hoist the initial state load before .Lupdateblock, and update the state
at the end of each block using 'add mem, reg' followed by 'mov reg, mem'
(via a new 'addm' macro), as sha512-avx2-asm.S, sha256-ssse3-asm.S, and
sha256-avx2-asm.S already do.

This keeps the updated state in registers across blocks, eliminating 8
loads per additional block and avoiding store-to-load forwarding stalls.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index f96ce3c083ea7..f7dade03c6527 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -100,6 +100,12 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 # SHA Constants (static mem)
 #define K_t(i)    8*i+K512(%rip)
 
+# Add \mem to \reg, then copy the result back to \mem.
+.macro addm mem reg
+	add	\mem, \reg
+	mov	\reg, \mem
+.endm
+
 .macro RotateXW
 	# Rotate symbols XW0..XW7 left
 	XWTMP = XW0
@@ -304,8 +310,6 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	movdqa	XMM_QWORD_BSWAP(%rip), XBSWAP
 	movdqa	XMM_QWORD_ROR8(%rip), XROR8
 
-.Lupdateblock:
-
 	# Load state variables
 	mov	DIGEST(0), a_64
 	mov	DIGEST(1), b_64
@@ -316,6 +320,8 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	mov	DIGEST(6), g_64
 	mov	DIGEST(7), h_64
 
+.Lupdateblock:
+
 	# Rounds 0 - 13: BSWAP W[0..15] into XW0..XW7 and compute rounds 0..13.
 	movdqu	MSG(0), XW0
 	pshufb	XBSWAP, XW0	# BSWAP
@@ -375,14 +381,14 @@ SYM_FUNC_START(sha512_transform_ssse3)
 
 	# Update digest
 	mov	0(%rsp), digest
-	add	a_64, DIGEST(0)
-	add	b_64, DIGEST(1)
-	add	c_64, DIGEST(2)
-	add	d_64, DIGEST(3)
-	add	e_64, DIGEST(4)
-	add	f_64, DIGEST(5)
-	add	g_64, DIGEST(6)
-	add	h_64, DIGEST(7)
+	addm	DIGEST(0), a_64
+	addm	DIGEST(1), b_64
+	addm	DIGEST(2), c_64
+	addm	DIGEST(3), d_64
+	addm	DIGEST(4), e_64
+	addm	DIGEST(5), f_64
+	addm	DIGEST(6), g_64
+	addm	DIGEST(7), h_64
 
 	# Decrement msglen, and advance to next message block if needed
 	add	$16*8, msg
-- 
2.56.1

