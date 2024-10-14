Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43F13A24D;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728879933; cv=none; b=MKemF9dP0tqDGJcO5jBBkiHDV90nDzZnl6NjjMCbBEROZqTu2z2J6ulnFDxE1kIrAtp+5weZ9s81kiz/iqMoSpuI6vEAYP9B8vUa6Zl2Pze9nphoPwIO+pogzJ2NDiDYAYmcBtluFT6mi0DiewTKFBZTHu7EPBIXpNvDrGLG4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728879933; c=relaxed/simple;
	bh=S507UONhbJRA/Nk31B/+8d7E9sxvFQ7zN3/8PYLAt6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UM4iaFT+2jRULx1VAJ5ZG1zDn/9hDvNoLsdycih0VcBfLS/SoKT/W/V/uSUoiTOAsWJK0ThtNYozwMT3va7Yu9OK8M189ZTbHGlSceSjmD+KXL4iMRoll3iyyjwCxGtTABvgrodN/2xY89HM6F0ABz/IJGYOIh1M3r1rcQbCVeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJ0a7SGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJ0a7SGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD40C4CED3;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728879932;
	bh=S507UONhbJRA/Nk31B/+8d7E9sxvFQ7zN3/8PYLAt6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ0a7SGUz+8rAe6Yu6XdXmrsoqNh7fH0hGCzEW9DzZMM2aBTlpjJFy1th7CAcYwOU
	 eR5qX5qeHE/FqYzLT8GZgZHtMmFuT9Sx9ULg/QuzppJvsoVUy23nz2DoAMYb+DPLJS
	 gpOLNmrC5ENL2o/bRibIP7ueOkzgupDvHOskhtAOWuSke2rLNgyvhNTphn/FhbFJbb
	 yr6TiDuzRuYuF5EYTqqTer8A7iEziFMxuAOfTvAdMOetKHbARrxZ+/3zFtrWCl8UzC
	 ACpDwa/pKfIx57zDTPiAcfUGEn9GzGKBIzY9PkMFHp0mRXm5oSdehjnSw5KgsjqBuW
	 oQhxgfdwt+Xvw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and excessive unrolling
Date: Sun, 13 Oct 2024 21:24:47 -0700
Message-ID: <20241014042447.50197-4-ebiggers@kernel.org>
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

crc32c-pcl-intel-asm_64.S has a loop with 1 to 127 iterations fully
unrolled and uses a jump table to jump into the correct location.  This
optimization is misguided, as it bloats the binary code size and
introduces an indirect call.  x86_64 CPUs can predict loops well, so it
is fine to just use a loop instead.  Loop bookkeeping instructions can
compete with the crc instructions for the ALUs, but this is easily
mitigated by unrolling the loop by a smaller amount, such as 4 times.

Therefore, re-roll the loop and make related tweaks to the code.

This reduces the binary code size of crc_pclmul() from 4546 bytes to 418
bytes, a 91% reduction.  In general it also makes the code faster, with
some large improvements seen when retpoline is enabled.

More detailed performance results are shown below.  They are given as
percent improvement in throughput (negative means regressed) for CPU
microarchitecture vs. input length in bytes.  E.g. an improvement from
40 GB/s to 50 GB/s would be listed as 25%.

Table 1: Results with retpoline enabled (the default):

                       |   512 |   833 |  1024 |  2000 |  3173 |  4096 |
  ---------------------+-------+-------+-------+------ +-------+-------+
  Intel Haswell        | 35.0% | 20.7% | 17.8% |  9.7% | -0.2% |  4.4% |
  Intel Emerald Rapids | 66.8% | 45.2% | 36.3% | 19.3% |  0.0% |  5.4% |
  AMD Zen 2            | 29.5% | 17.2% | 13.5% |  8.6% | -0.5% |  2.8% |

Table 2: Results with retpoline disabled:

                       |   512 |   833 |  1024 |  2000 |  3173 |  4096 |
  ---------------------+-------+-------+-------+------ +-------+-------+
  Intel Haswell        |  3.3% |  4.8% |  4.5% |  0.9% | -2.9% |  0.3% |
  Intel Emerald Rapids |  7.5% |  6.4% |  5.2% |  2.3% | -0.0% |  0.6% |
  AMD Zen 2            | 11.8% |  1.4% |  0.2% |  1.3% | -0.9% | -0.2% |

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 233 +++++++++-------------
 1 file changed, 92 insertions(+), 141 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index bbf860e90951d..752812bc4991d 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -5,10 +5,11 @@
  * downloaded from:
  * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
  * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-paper.pdf
  *
  * Copyright (C) 2012 Intel Corporation.
+ * Copyright 2024 Google LLC
  *
  * Authors:
  *	Wajdi Feghali <wajdi.k.feghali@intel.com>
  *	James Guilford <james.guilford@intel.com>
  *	David Cote <david.m.cote@intel.com>
@@ -42,186 +43,153 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
 
 #include <linux/linkage.h>
-#include <asm/nospec-branch.h>
 
 ## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
 
-.macro LABEL prefix n
-.L\prefix\n\():
-.endm
-
-.macro JMPTBL_ENTRY i
-.quad .Lcrc_\i
-.endm
-
 # Define threshold below which buffers are considered "small" and routed to
 # regular CRC code that does not interleave the CRC instructions.
 #define SMALL_SIZE 200
 
 # unsigned int crc_pcl(const u8 *buffer, unsigned int len, unsigned int crc_init);
 
 .text
 SYM_FUNC_START(crc_pcl)
-#define    bufp		rdi
-#define    bufp_dw	%edi
-#define    bufp_w	%di
-#define    bufp_b	%dil
-#define    bufptmp	%rcx
-#define    block_0	%rcx
-#define    block_1	%rdx
-#define    block_2	%r11
-#define    len		%esi
-#define    crc_init_arg %edx
-#define    tmp		%rbx
-#define    crc_init	%r8d
-#define    crc_init_q	%r8
-#define    crc1		%r9
-#define    crc2		%r10
-
-	pushq   %rbx
-	pushq   %rdi
-	pushq   %rsi
+#define    bufp		  %rdi
+#define    bufp_d	  %edi
+#define    len		  %esi
+#define    crc_init	  %edx
+#define    crc_init_q	  %rdx
+#define    n_misaligned	  %ecx /* overlaps chunk_bytes! */
+#define    n_misaligned_q %rcx
+#define    chunk_bytes	  %ecx /* overlaps n_misaligned! */
+#define    chunk_bytes_q  %rcx
+#define    crc1		  %r8
+#define    crc2		  %r9
 
-	## Move crc_init for Linux to a different
-	mov     crc_init_arg, crc_init
-
-	mov	%bufp, bufptmp		# rdi = *buf
 	cmp	$SMALL_SIZE, len
 	jb	.Lsmall
 
 	################################################################
 	## 1) ALIGN:
 	################################################################
-	neg     %bufp
-	and     $7, %bufp		# calculate the unalignment amount of
+	mov	bufp_d, n_misaligned
+	neg	n_misaligned
+	and	$7, n_misaligned	# calculate the misalignment amount of
 					# the address
-	je      .Lproc_block		# Skip if aligned
+	je	.Laligned		# Skip if aligned
 
+	# Process 1 <= n_misaligned <= 7 bytes individually in order to align
+	# the remaining data to an 8-byte boundary.
 .Ldo_align:
-	#### Calculate CRC of unaligned bytes of the buffer (if any)
-	movq    (bufptmp), tmp		# load a quadward from the buffer
-	add     %bufp, bufptmp		# align buffer pointer for quadword
-					# processing
-	sub	bufp_dw, len		# update buffer length
+	movq	(bufp), %rax
+	add	n_misaligned_q, bufp
+	sub	n_misaligned, len
 .Lalign_loop:
-	crc32b	%bl, crc_init		# compute crc32 of 1-byte
-	shr     $8, tmp			# get next byte
-	dec     %bufp
+	crc32b	%al, crc_init		# compute crc32 of 1-byte
+	shr	$8, %rax		# get next byte
+	dec	n_misaligned
 	jne     .Lalign_loop
-
-.Lproc_block:
+.Laligned:
 
 	################################################################
-	## 2) PROCESS  BLOCKS:
+	## 2) PROCESS BLOCK:
 	################################################################
 
-	## compute num of bytes to be processed
-
 	cmp	$128*24, len
 	jae     .Lfull_block
 
-.Lcontinue_block:
-	## len < 128*24
-	movq    $2731, %rax		# 2731 = ceil(2^16 / 24)
-	mul	len
-	shrq    $16, %rax
-
-	## eax contains floor(bytes / 24) = num 24-byte chunks to do
-
-	## process rax 24-byte chunks (128 >= rax >= 0)
-
-	## compute end address of each block
-	## block 0 (base addr + RAX * 8)
-	## block 1 (base addr + RAX * 16)
-	## block 2 (base addr + RAX * 24)
-	lea     (bufptmp, %rax, 8), block_0
-	lea     (block_0, %rax, 8), block_1
-	lea     (block_1, %rax, 8), block_2
-
-	xor     crc1, crc1
-	xor     crc2, crc2
-
-	## branch into array
-	leaq	jump_table(%rip), %bufp
-	mov	(%bufp,%rax,8), %bufp
-	JMP_NOSPEC bufp
+.Lpartial_block:
+	# Compute floor(len / 24) to get num qwords to process from each lane.
+	imul	$2731, len, %eax	# 2731 = ceil(2^16 / 24)
+	shr	$16, %eax
+	jmp	.Lcrc_3lanes
 
-	################################################################
-	## 2a) PROCESS FULL BLOCKS:
-	################################################################
 .Lfull_block:
-	movl    $128,%eax
-	lea     128*8*2(block_0), block_1
-	lea     128*8*3(block_0), block_2
-	add     $128*8*1, block_0
-
-	xor     crc1,crc1
-	xor     crc2,crc2
-
-	# Fall through into top of crc array (crc_128)
+	# Processing 128 qwords from each lane.
+	mov	$128, %eax
 
 	################################################################
-	## 3) CRC Array:
+	## 3) CRC each of three lanes:
 	################################################################
 
-	i=128
-.rept 128-1
-.altmacro
-LABEL crc_ %i
-.noaltmacro
-	ENDBR
-	crc32q   -i*8(block_0), crc_init_q
-	crc32q   -i*8(block_1), crc1
-	crc32q   -i*8(block_2), crc2
-	i=(i-1)
-.endr
-
-.altmacro
-LABEL crc_ %i
-.noaltmacro
-	ENDBR
-	crc32q   -i*8(block_0), crc_init_q
-	crc32q   -i*8(block_1), crc1
-# SKIP  crc32  -i*8(block_2), crc2 ; Don't do this one yet
+.Lcrc_3lanes:
+	xor	crc1,crc1
+	xor     crc2,crc2
+	mov	%eax, chunk_bytes
+	shl	$3, chunk_bytes		# num bytes to process from each lane
+	sub	$5, %eax		# 4 for 4x_loop, 1 for special last iter
+	jl	.Lcrc_3lanes_4x_done
+
+	# Unroll the loop by a factor of 4 to reduce the overhead of the loop
+	# bookkeeping instructions, which can compete with crc32q for the ALUs.
+.Lcrc_3lanes_4x_loop:
+	crc32q	(bufp), crc_init_q
+	crc32q	(bufp,chunk_bytes_q), crc1
+	crc32q	(bufp,chunk_bytes_q,2), crc2
+	crc32q	8(bufp), crc_init_q
+	crc32q	8(bufp,chunk_bytes_q), crc1
+	crc32q	8(bufp,chunk_bytes_q,2), crc2
+	crc32q	16(bufp), crc_init_q
+	crc32q	16(bufp,chunk_bytes_q), crc1
+	crc32q	16(bufp,chunk_bytes_q,2), crc2
+	crc32q	24(bufp), crc_init_q
+	crc32q	24(bufp,chunk_bytes_q), crc1
+	crc32q	24(bufp,chunk_bytes_q,2), crc2
+	add	$32, bufp
+	sub	$4, %eax
+	jge	.Lcrc_3lanes_4x_loop
+
+.Lcrc_3lanes_4x_done:
+	add	$4, %eax
+	jz	.Lcrc_3lanes_last_qword
+
+.Lcrc_3lanes_1x_loop:
+	crc32q	(bufp), crc_init_q
+	crc32q	(bufp,chunk_bytes_q), crc1
+	crc32q	(bufp,chunk_bytes_q,2), crc2
+	add	$8, bufp
+	dec	%eax
+	jnz	.Lcrc_3lanes_1x_loop
 
-	mov     block_2, block_0
+.Lcrc_3lanes_last_qword:
+	crc32q	(bufp), crc_init_q
+	crc32q	(bufp,chunk_bytes_q), crc1
+# SKIP  crc32q	(bufp,chunk_bytes_q,2), crc2	; Don't do this one yet
 
 	################################################################
 	## 4) Combine three results:
 	################################################################
 
-	lea	(K_table-8)(%rip), %bufp		# first entry is for idx 1
-	shlq    $3, %rax			# rax *= 8
-	pmovzxdq (%bufp,%rax), %xmm0		# 2 consts: K1:K2
-	leal	(%eax,%eax,2), %eax		# rax *= 3 (total *24)
-	sub	%eax, len			# len -= rax*24
+	lea	(K_table-8)(%rip), %rax		# first entry is for idx 1
+	pmovzxdq (%rax,chunk_bytes_q), %xmm0	# 2 consts: K1:K2
+	lea	(chunk_bytes,chunk_bytes,2), %eax # chunk_bytes * 3
+	sub	%eax, len			# len -= chunk_bytes * 3
 
 	movq	crc_init_q, %xmm1		# CRC for block 1
 	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
 
 	movq    crc1, %xmm2			# CRC for block 2
 	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
 
 	pxor    %xmm2,%xmm1
 	movq    %xmm1, %rax
-	xor     -i*8(block_2), %rax
+	xor	(bufp,chunk_bytes_q,2), %rax
 	mov	crc2, crc_init_q
 	crc32	%rax, crc_init_q
+	lea	8(bufp,chunk_bytes_q,2), bufp
 
 	################################################################
-	## 5) Check for end:
+	## 5) If more blocks remain, goto (2):
 	################################################################
 
-LABEL crc_ 0
-	ENDBR
 	cmp	$128*24, len
-	jae     .Lfull_block
+	jae	.Lfull_block
 	cmp	$SMALL_SIZE, len
-	jae     .Lcontinue_block
+	jae	.Lpartial_block
 
 	#######################################################################
 	## 6) Process any remainder without interleaving:
 	#######################################################################
 .Lsmall:
@@ -229,51 +197,34 @@ LABEL crc_ 0
 	jz	.Ldone
 	mov	len, %eax
 	shr	$3, %eax
 	jz	.Ldo_dword
 .Ldo_qwords:
-	crc32q	(bufptmp), crc_init_q
-	add	$8, bufptmp
+	crc32q	(bufp), crc_init_q
+	add	$8, bufp
 	dec	%eax
 	jnz	.Ldo_qwords
 .Ldo_dword:
 	test	$4, len
 	jz	.Ldo_word
-	crc32l	(bufptmp), crc_init
-	add	$4, bufptmp
+	crc32l	(bufp), crc_init
+	add	$4, bufp
 .Ldo_word:
 	test	$2, len
 	jz	.Ldo_byte
-	crc32w	(bufptmp), crc_init
-	add	$2, bufptmp
+	crc32w	(bufp), crc_init
+	add	$2, bufp
 .Ldo_byte:
 	test	$1, len
 	jz	.Ldone
-	crc32b	(bufptmp), crc_init
+	crc32b	(bufp), crc_init
 .Ldone:
 	mov	crc_init, %eax
-	popq    %rsi
-	popq    %rdi
-	popq    %rbx
         RET
 SYM_FUNC_END(crc_pcl)
 
 .section	.rodata, "a", @progbits
-        ################################################################
-        ## jump table        Table is 129 entries x 2 bytes each
-        ################################################################
-.align 4
-jump_table:
-	i=0
-.rept 129
-.altmacro
-JMPTBL_ENTRY %i
-.noaltmacro
-	i=i+1
-.endr
-
-
 	################################################################
 	## PCLMULQDQ tables
 	## Table is 128 entries x 2 words (8 bytes) each
 	################################################################
 .align 8
-- 
2.47.0

