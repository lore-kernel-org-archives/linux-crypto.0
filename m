Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7BC1369AA;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728879932; cv=none; b=hxkoDt2BX3MWpjs2BvmUW0WcdLfsR2++PItAHBcwBhX31FOg6TPAzGrCjk40Iv5Fwu+ACPDjEXoR/R4g8T/TKgpW6JmwRzqSeCN615S7IUbw1aUi03C0QXI0NTgzcYw2QgcFIlJxrFP90t4zko5bYiKbIMpAQZ6cRgCgNh+WYjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728879932; c=relaxed/simple;
	bh=PJQ2WFhPJRxPyoMGMR3LzkZSPPky28CN3RLpvs4UTaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5KvlIV0jOu4ktk75OocFkNGfJspWtCO+TZAExBrFL27nngQVSLFOxp8NiwHnm2vSVyhkWQx+SnODdFx9NSPYUN5ZWT4ew/iNn1gp/q7tEZ1xgnjuLxajBzuQnK982xCuD+0WgVxrl0PX5SUjq7N2Rmi9ki4MlLkCFg1t7UeMvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMOZ+OT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMOZ+OT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F826C4AF0B;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728879932;
	bh=PJQ2WFhPJRxPyoMGMR3LzkZSPPky28CN3RLpvs4UTaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMOZ+OT9PZ7lO+ZCa2NUof4BzuB/E+VcN69a3+4SKR4lBytiQ7AGawL3G8Z8i0cTM
	 wn6cgGqJteUjW8Gh9D24EY53urxlsZHamH3Dy2AIq5ruL1UeCurVjYR6+fCIfIdyMt
	 odFgcVGz/bhW/gsPwrA2ix+HbzKymkZOIdvCJfqDCaGIxPwJj51eRs/Dqjwu4LUeuR
	 zf1DJnKjMofaEvLbZjQiD3M7kM7X8nhfoEJdbq+apcowYSzj5o1Qs2UaJkt5ELhchM
	 aMSCH649p+ZTY9KjmEGowI5Buv+EgS+vUBpiOkIj683FM8bvIJEfG9+49P5XwWKKHz
	 +D7QlADhN/Zgw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] crypto: x86/crc32c - access 32-bit arguments as 32-bit
Date: Sun, 13 Oct 2024 21:24:46 -0700
Message-ID: <20241014042447.50197-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014042447.50197-1-ebiggers@kernel.org>
References: <20241014042447.50197-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix crc32c-pcl-intel-asm_64.S to access 32-bit arguments as 32-bit
values instead of 64-bit, since the upper bits of the corresponding
64-bit registers are not guaranteed to be zero.  Also update the type of
the length argument to be unsigned int rather than int, as the assembly
code treats it as unsigned.

Note: there haven't been any reports of this bug actually causing
incorrect behavior.  Neither gcc nor clang guarantee zero-extension to
64 bits, but zero-extension is likely to happen in practice because most
instructions that operate on 32-bit registers zero-extend to 64 bits.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/crc32c-intel_glue.c       |  2 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 57 +++++++++++------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index feccb5254c7e5..52c5d47ef5a14 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -39,11 +39,11 @@
  * size is >= 512 to account
  * for fpu state save/restore overhead.
  */
 #define CRC32C_PCL_BREAKEVEN	512
 
-asmlinkage unsigned int crc_pcl(const u8 *buffer, int len,
+asmlinkage unsigned int crc_pcl(const u8 *buffer, unsigned int len,
 				unsigned int crc_init);
 #endif /* CONFIG_X86_64 */
 
 static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t length)
 {
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 466cea4943963..bbf860e90951d 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -58,11 +58,11 @@
 
 # Define threshold below which buffers are considered "small" and routed to
 # regular CRC code that does not interleave the CRC instructions.
 #define SMALL_SIZE 200
 
-# unsigned int crc_pcl(u8 *buffer, int len, unsigned int crc_init);
+# unsigned int crc_pcl(const u8 *buffer, unsigned int len, unsigned int crc_init);
 
 .text
 SYM_FUNC_START(crc_pcl)
 #define    bufp		rdi
 #define    bufp_dw	%edi
@@ -70,18 +70,15 @@ SYM_FUNC_START(crc_pcl)
 #define    bufp_b	%dil
 #define    bufptmp	%rcx
 #define    block_0	%rcx
 #define    block_1	%rdx
 #define    block_2	%r11
-#define    len		%rsi
-#define    len_dw	%esi
-#define    len_w	%si
-#define    len_b	%sil
-#define    crc_init_arg %rdx
+#define    len		%esi
+#define    crc_init_arg %edx
 #define    tmp		%rbx
-#define    crc_init	%r8
-#define    crc_init_dw	%r8d
+#define    crc_init	%r8d
+#define    crc_init_q	%r8
 #define    crc1		%r9
 #define    crc2		%r10
 
 	pushq   %rbx
 	pushq   %rdi
@@ -105,13 +102,13 @@ SYM_FUNC_START(crc_pcl)
 .Ldo_align:
 	#### Calculate CRC of unaligned bytes of the buffer (if any)
 	movq    (bufptmp), tmp		# load a quadward from the buffer
 	add     %bufp, bufptmp		# align buffer pointer for quadword
 					# processing
-	sub     %bufp, len		# update buffer length
+	sub	bufp_dw, len		# update buffer length
 .Lalign_loop:
-	crc32b  %bl, crc_init_dw 	# compute crc32 of 1-byte
+	crc32b	%bl, crc_init		# compute crc32 of 1-byte
 	shr     $8, tmp			# get next byte
 	dec     %bufp
 	jne     .Lalign_loop
 
 .Lproc_block:
@@ -119,19 +116,18 @@ SYM_FUNC_START(crc_pcl)
 	################################################################
 	## 2) PROCESS  BLOCKS:
 	################################################################
 
 	## compute num of bytes to be processed
-	movq    len, tmp		# save num bytes in tmp
 
-	cmpq    $128*24, len
+	cmp	$128*24, len
 	jae     .Lfull_block
 
 .Lcontinue_block:
 	## len < 128*24
 	movq    $2731, %rax		# 2731 = ceil(2^16 / 24)
-	mul     len_dw
+	mul	len
 	shrq    $16, %rax
 
 	## eax contains floor(bytes / 24) = num 24-byte chunks to do
 
 	## process rax 24-byte chunks (128 >= rax >= 0)
@@ -174,21 +170,21 @@ SYM_FUNC_START(crc_pcl)
 .rept 128-1
 .altmacro
 LABEL crc_ %i
 .noaltmacro
 	ENDBR
-	crc32q   -i*8(block_0), crc_init
+	crc32q   -i*8(block_0), crc_init_q
 	crc32q   -i*8(block_1), crc1
 	crc32q   -i*8(block_2), crc2
 	i=(i-1)
 .endr
 
 .altmacro
 LABEL crc_ %i
 .noaltmacro
 	ENDBR
-	crc32q   -i*8(block_0), crc_init
+	crc32q   -i*8(block_0), crc_init_q
 	crc32q   -i*8(block_1), crc1
 # SKIP  crc32  -i*8(block_2), crc2 ; Don't do this one yet
 
 	mov     block_2, block_0
 
@@ -198,66 +194,65 @@ LABEL crc_ %i
 
 	lea	(K_table-8)(%rip), %bufp		# first entry is for idx 1
 	shlq    $3, %rax			# rax *= 8
 	pmovzxdq (%bufp,%rax), %xmm0		# 2 consts: K1:K2
 	leal	(%eax,%eax,2), %eax		# rax *= 3 (total *24)
-	subq    %rax, tmp			# tmp -= rax*24
+	sub	%eax, len			# len -= rax*24
 
-	movq    crc_init, %xmm1			# CRC for block 1
+	movq	crc_init_q, %xmm1		# CRC for block 1
 	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
 
 	movq    crc1, %xmm2			# CRC for block 2
 	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
 
 	pxor    %xmm2,%xmm1
 	movq    %xmm1, %rax
 	xor     -i*8(block_2), %rax
-	mov     crc2, crc_init
-	crc32   %rax, crc_init
+	mov	crc2, crc_init_q
+	crc32	%rax, crc_init_q
 
 	################################################################
 	## 5) Check for end:
 	################################################################
 
 LABEL crc_ 0
 	ENDBR
-	mov     tmp, len
-	cmp     $128*24, tmp
+	cmp	$128*24, len
 	jae     .Lfull_block
-	cmp	$SMALL_SIZE, tmp
+	cmp	$SMALL_SIZE, len
 	jae     .Lcontinue_block
 
 	#######################################################################
 	## 6) Process any remainder without interleaving:
 	#######################################################################
 .Lsmall:
 	test	len, len
 	jz	.Ldone
-	mov	len_dw, %eax
+	mov	len, %eax
 	shr	$3, %eax
 	jz	.Ldo_dword
 .Ldo_qwords:
-	crc32q	(bufptmp), crc_init
+	crc32q	(bufptmp), crc_init_q
 	add	$8, bufptmp
 	dec	%eax
 	jnz	.Ldo_qwords
 .Ldo_dword:
-	test	$4, len_dw
+	test	$4, len
 	jz	.Ldo_word
-	crc32l	(bufptmp), crc_init_dw
+	crc32l	(bufptmp), crc_init
 	add	$4, bufptmp
 .Ldo_word:
-	test	$2, len_dw
+	test	$2, len
 	jz	.Ldo_byte
-	crc32w	(bufptmp), crc_init_dw
+	crc32w	(bufptmp), crc_init
 	add	$2, bufptmp
 .Ldo_byte:
-	test	$1, len_dw
+	test	$1, len
 	jz	.Ldone
-	crc32b	(bufptmp), crc_init_dw
+	crc32b	(bufptmp), crc_init
 .Ldone:
-	movq    crc_init, %rax
+	mov	crc_init, %eax
 	popq    %rsi
 	popq    %rdi
 	popq    %rbx
         RET
 SYM_FUNC_END(crc_pcl)
-- 
2.47.0

