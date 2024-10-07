Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CC5C156;
	Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264296; cv=none; b=XP9gYtrq2p2P+Hsi3iiTwPGAPfzDcDDVZa2sFU/Tec11x+XOPBHAaRYxQvCp9qAYEI2tlce37Hz3CXkyv98GrVwbGG/aCE642pFaqxG4yfJlNtN12ZNw2jMeZBZ2oL7RxTdI9Q8dLBbACBtTfv6BoVJ/COk1O9noIAKqiCML8NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264296; c=relaxed/simple;
	bh=WCm/xfTBodlqj4bAKzAchL/blZIThgBRMTL2D1XRc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgMUSyKQWRByXdiSPyTSfneRgt5Np3RvdQ+bDkyfjCb1VSMiWYHBqkbKXW3B5ynkQcE4ZpYZfjhjVPeqej1J3VyBl0yNzDO883i/XT3eCHriF1hgbLTAQB6JkUc4nsjIp/XK4ZOiDINmdO+FTulQqUMWsJW09yuM1TepUR2R8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHCH8QY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHCH8QY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34E6C4CECC;
	Mon,  7 Oct 2024 01:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264295;
	bh=WCm/xfTBodlqj4bAKzAchL/blZIThgBRMTL2D1XRc6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHCH8QY0ZXyEg2C+QRZGwoRijb0ZYP98j15RbnIj0xpbmInWugI1WP/16g5MG0gkq
	 sJLKqd47QLOFtzx86pGpGw6HbaD3D2COBr8JA5Yp1kHFiUfEw1zabd4aiJTKvl1J+a
	 ZQDvdAixuafMQ6YotvbpxU7p6W00zg9wj37b9WRsQHpYRotTGsCRHsPVw5z3hlxMwJ
	 sZn6A99qgdUvuj7whS9oJOYonxQKROWvoy7NDVyRlFZyaN1jyGcgMOqZmPz666tNit
	 6l4pH1XdvzgS7X3elzgyOotEJZHdfLsiLrths1XG1qsRIS5d90F1DSHlAWunn24IFG
	 xoNd569qORQcQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH 01/10] crypto: x86/aegis128 - access 32-bit arguments as 32-bit
Date: Sun,  6 Oct 2024 18:24:21 -0700
Message-ID: <20241007012430.163606-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 29 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index ad7f4c891625..2de859173940 100644
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
2.46.2

