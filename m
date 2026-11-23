Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403624;
	b=IvU5fDybPyLKJB/paDDbDUNU6abs0gCP+AphAVDTGpC2WBjSxJNLm7+z+av19xSxNErW
	 fDpvITnZHA2oJKL70ZMpixKCeUtn0Ghwbq2+McolbKVew+Cd5F15oWCKG2ZnCqof5ZmiE
	 bMgMzlLcbnzDlqSnbqUbvW57YQQ6IM+oAojH4uMlQpfgJUVrFN5N/m4pJnW6LOyi6kDt6
	 AlXf561iwf2tfmz7r0ZGGraHGmMhqzxR4Z7hPs1JyD7+npgZ0ojxLjvcqiaLQUrtatwGf
	 bGZsR60a0QGaWIlhL1b0KnXWPj61OlIl3jFdDjQBL0lWTjOs2w/sHM2xZA0DBnj0OdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=euir+7KJPxsdy0fA0X97R+6+p9jxMcu/rNBsSTTMVew=;
	b=t0QbPIH4qQrdV9aD02WuX0KJlhYV/OuwE+9rDGMCjK8OnQDryukJEaPM2N2GZkxh4Qv3
	 hHkzsNlL3QPo8x5TQay1cWpDLQpFw7Sp2E8/IIqx+tKBz36zfZN85cppy/49dI4h8CB6C
	 jlTlsZmhQyT+njsEMtz1orFf3zi0PzkDEqI+Jb9mvlL2eVI59q6bQR4ICAcZPptxFsm+U
	 BqnFv2+vRoj62HK4l/O4iUo+IFs3u76brunIzHLG+2QmyZ/bNbuZGRgdf3XpxAvQTMV9c
	 1fAfJsDERLgSrXJJpXvtD6Z4CN6qJy6MjxFlfx0yns86WblF6UfIAofOZewSmvDLd7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XPnotVY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B7606A320
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XPnotVY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4D71F000CA;
	Mon, 23 Nov 2026 03:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795403624;
	bh=euir+7KJPxsdy0fA0X97R+6+p9jxMcu/rNBsSTTMVew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPnotVY3G2QFGdWm5TSvHTFbHPqK4pAVL07rGSzO/dn3njBar6BNjalBtziDFGGO/
	 kjdLcBNJSbBaGMZzagvd94Dmop0YyfNhAZ/A3mlwVE5ame35yPlF0vSTL9MFzUgSuS
	 oLuAIS7ro/rd8YpE57ep7AVmn+wQDNE8nUGSXRCzqb1AB/XfZmooXoZRpygo3AQKD5
	 9qh4ei84gdPk5btI60pzzzUc3FDRjT5FK9dBLm8TJKdCc0qHoJx8lqgZ5AJCPO+f99
	 9uE7VSObTfL5dkQNd0W/VpL4tI2j9PwLDfax+t9N8gWienV29+17rv6k3ohos12pM6
	 3pL0TBWeBtoeg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/4] lib/crypto: x86/sha512-avx2: Clean up loading and byte-swapping the data
Date: Sun, 22 Nov 2026 19:13:18 -0800
Message-ID: <20261123031321.403308-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123031321.403308-1-ebiggers@kernel.org>
References: <20261123031321.403308-1-ebiggers@kernel.org>
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

When used on YMM registers, the vpshufb instruction does a shuffle
independently within each 128-bit lane, using the low 4 bits of each
byte in the corresponding 128-bit shuffle mask.  Yet,
sha512_transform_rorx() executed vpshufb using a mask containing indices
from 0 to 31, as if it expected the shuffle to be across the entire YMM
register.  That made the code misleading, though still correct.

Make the code clearer, eliminate 16 bytes of rodata, and increase
consistency with other asm files (e.g., AES-GCM) by broadcasting the
proper 128-bit shuffle mask into both halves of the YMM register.

Also apply a few related cleanups:
- Eliminate the unhelpful COPY_YMM_AND_BSWAP and VMOVDQ macros.
- Rename the register "alias" to YBSWAP to be consistent with the
  naming convention used elsewhere in this file (and sha512-ssse3-asm.S)
- Make the data label local.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx2-asm.S | 34 +++++++++++---------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index 2256d51297e18..d5f3c0bcee653 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -65,8 +65,7 @@ YTMP2 = %ymm2
 YTMP3 = %ymm3
 YTMP4 = %ymm8
 XFER  = YTMP0
-
-BYTE_FLIP_MASK  = %ymm9
+YBSWAP = %ymm9
 
 # 1st arg is %rdi, which is saved to the stack and accessed later via %r12
 CTX1        = %rdi
@@ -110,9 +109,6 @@ frame_INPEND = frame_INP + INP_SIZE
 frame_CTX = frame_INPEND + INPEND_SIZE
 frame_size = frame_CTX + CTX_SIZE
 
-## assume buffers not aligned
-#define	VMOVDQ vmovdqu
-
 # addm [mem], reg
 # Add reg to mem using reg-mem add and store
 .macro addm p1 p2
@@ -120,13 +116,6 @@ frame_size = frame_CTX + CTX_SIZE
 	mov	\p2, \p1
 .endm
 
-
-# COPY_YMM_AND_BSWAP ymm, [mem], byte_flip_mask
-# Load ymm with mem and byte swap each dword
-.macro COPY_YMM_AND_BSWAP p1 p2 p3
-	VMOVDQ \p2, \p1
-	vpshufb \p3, \p1, \p1
-.endm
 # rotate_Ys
 # Rotate values of symbols Y0...Y3
 .macro rotate_Ys
@@ -599,16 +588,16 @@ SYM_FUNC_START(sha512_transform_rorx)
 	# save %rdi (CTX) before it gets clobbered
 	mov	%rdi, frame_CTX(%rsp)
 
-	vmovdqa	PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
+	vbroadcasti128	.L_XMM_QWORD_BSWAP(%rip), YBSWAP
 
 .Lloop0:
 	lea	K512(%rip), TBL
 
-	## byte swap first 16 dwords
-	COPY_YMM_AND_BSWAP	Y_0, (INP), BYTE_FLIP_MASK
-	COPY_YMM_AND_BSWAP	Y_1, 1*32(INP), BYTE_FLIP_MASK
-	COPY_YMM_AND_BSWAP	Y_2, 2*32(INP), BYTE_FLIP_MASK
-	COPY_YMM_AND_BSWAP	Y_3, 3*32(INP), BYTE_FLIP_MASK
+	# Load and byte-swap W[0..15]
+.irp i, 0,1,2,3
+	vmovdqu	\i*32(INP), Y_\i
+	vpshufb	YBSWAP, Y_\i, Y_\i
+.endr
 
 	mov	INP, frame_INP(%rsp)
 
@@ -735,12 +724,11 @@ K512:
 	.quad	0x4cc5d4becb3e42b6,0x597f299cfc657e2a
 	.quad	0x5fcb6fab3ad6faec,0x6c44198c4a475817
 
-.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
-.align 32
-# Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
-PSHUFFLE_BYTE_FLIP_MASK:
+.section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
+.align 16
+# Mask for byte-swapping each qword using vpshufb
+.L_XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
-	.octa 0x18191a1b1c1d1e1f1011121314151617
 
 .section	.rodata.cst32.MASK_YMM_LO, "aM", @progbits, 32
 .align 32
-- 
2.56.1

