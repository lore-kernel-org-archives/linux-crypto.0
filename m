Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143C132132;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728879932; cv=none; b=ZeXV3th6AtRt3JY5TstcRMwFFRJ9i3OtxpG03/mRNRTmNPNv4tU8t594ciVxwsiW3Ae9zrdcF/XLfu7ECA2TwYdYFYqVyaADL5R+QBNjxZjilHSZ0cZz9cQ7dTwdQqYcmO+3gEdHqqpmAU1RwyGON6NHJONoVyWfSgmvNHXoMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728879932; c=relaxed/simple;
	bh=V4G8veCQ1vyP2bYC5v5Sfu2aA7K3ftboPQc0JQW7sIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAe8IEW0igL1wJGJKVo1n0a9SWmKtnDCwx+mboGfxnr4E/NrlNeMfMZAjyjgvLkXOqighbWWMvLCY/nnGCA/lK7QEhczuRkERrjK6xrXoAtvIAgwVx3fi2ZXZbdndhp2x0a7D3didcIDvo5/WN4mQm+gMNwvQJTempst661dkdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ay2qmW0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ay2qmW0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003C4C4AF09;
	Mon, 14 Oct 2024 04:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728879932;
	bh=V4G8veCQ1vyP2bYC5v5Sfu2aA7K3ftboPQc0JQW7sIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ay2qmW0DUJIeorLXIHKyPkIedinlUlRAfjy2n9qHW8C1YhXik5JYv+cWv3r/0Six4
	 zcaW0cfAtak1GmHk7l8nZWfLpMXzv/hU6puWay3zFkoi2L6W275D83+8x8WvuGw6qP
	 Bm33MlwFZN8SPPiQmYFkg8rCbse/VKYRpR2kWrE8pM8ZHizrSNdxxa0Zo+uCWbzCY8
	 xy4Z95QJcmzLRkRa+42pB+IBpGUzjLQ4pBeiRY5jDtzzVyPh5P3nQwXF9Qv6UgLU5c
	 7/CUlUn+moTXSXKTNeK1nULD/jIq5/UxSZknBpO8xWnPbW8yA7A+L5nhB1lcpEJQjV
	 7zrY5PHuaK9kA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] crypto: x86/crc32c - simplify code for handling fewer than 200 bytes
Date: Sun, 13 Oct 2024 21:24:45 -0700
Message-ID: <20241014042447.50197-2-ebiggers@kernel.org>
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

The assembly code in crc32c-pcl-intel-asm_64.S is invoked only for
lengths >= 512, due to the overhead of saving and restoring FPU state.
Therefore, it is unnecessary for this code to be excessively "optimized"
for lengths < 200.  Eliminate the excessive unrolling of this part of
the code and use a more straightforward qword-at-a-time loop.

Note: the part of the code in question is not entirely redundant, as it
is still used to process any remainder mod 24, as well as any remaining
data when fewer than 200 bytes remain after least one 3072-byte chunk.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 116 ++++++----------------
 1 file changed, 33 insertions(+), 83 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index bbcff1fb78cb2..466cea4943963 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -54,24 +54,14 @@
 
 .macro JMPTBL_ENTRY i
 .quad .Lcrc_\i
 .endm
 
-.macro JNC_LESS_THAN j
-	jnc .Lless_than_\j
-.endm
-
-# Define threshold where buffers are considered "small" and routed to more
-# efficient "by-1" code. This "by-1" code only handles up to 255 bytes, so
-# SMALL_SIZE can be no larger than 255.
-
+# Define threshold below which buffers are considered "small" and routed to
+# regular CRC code that does not interleave the CRC instructions.
 #define SMALL_SIZE 200
 
-.if (SMALL_SIZE > 255)
-.error "SMALL_ SIZE must be < 256"
-.endif
-
 # unsigned int crc_pcl(u8 *buffer, int len, unsigned int crc_init);
 
 .text
 SYM_FUNC_START(crc_pcl)
 #define    bufp		rdi
@@ -98,29 +88,22 @@ SYM_FUNC_START(crc_pcl)
 	pushq   %rsi
 
 	## Move crc_init for Linux to a different
 	mov     crc_init_arg, crc_init
 
+	mov	%bufp, bufptmp		# rdi = *buf
+	cmp	$SMALL_SIZE, len
+	jb	.Lsmall
+
 	################################################################
 	## 1) ALIGN:
 	################################################################
-
-	mov     %bufp, bufptmp		# rdi = *buf
 	neg     %bufp
 	and     $7, %bufp		# calculate the unalignment amount of
 					# the address
 	je      .Lproc_block		# Skip if aligned
 
-	## If len is less than 8 and we're unaligned, we need to jump
-	## to special code to avoid reading beyond the end of the buffer
-	cmp     $8, len
-	jae     .Ldo_align
-	# less_than_8 expects length in upper 3 bits of len_dw
-	# less_than_8_post_shl1 expects length = carryflag * 8 + len_dw[31:30]
-	shl     $32-3+1, len_dw
-	jmp     .Lless_than_8_post_shl1
-
 .Ldo_align:
 	#### Calculate CRC of unaligned bytes of the buffer (if any)
 	movq    (bufptmp), tmp		# load a quadward from the buffer
 	add     %bufp, bufptmp		# align buffer pointer for quadword
 					# processing
@@ -142,13 +125,10 @@ SYM_FUNC_START(crc_pcl)
 
 	cmpq    $128*24, len
 	jae     .Lfull_block
 
 .Lcontinue_block:
-	cmpq    $SMALL_SIZE, len
-	jb      .Lsmall
-
 	## len < 128*24
 	movq    $2731, %rax		# 2731 = ceil(2^16 / 24)
 	mul     len_dw
 	shrq    $16, %rax
 
@@ -241,72 +221,42 @@ LABEL crc_ %i
 LABEL crc_ 0
 	ENDBR
 	mov     tmp, len
 	cmp     $128*24, tmp
 	jae     .Lfull_block
-	cmp     $24, tmp
+	cmp	$SMALL_SIZE, tmp
 	jae     .Lcontinue_block
 
-.Lless_than_24:
-	shl     $32-4, len_dw			# less_than_16 expects length
-						# in upper 4 bits of len_dw
-	jnc     .Lless_than_16
-	crc32q  (bufptmp), crc_init
-	crc32q  8(bufptmp), crc_init
-	jz      .Ldo_return
-	add     $16, bufptmp
-	# len is less than 8 if we got here
-	# less_than_8 expects length in upper 3 bits of len_dw
-	# less_than_8_post_shl1 expects length = carryflag * 8 + len_dw[31:30]
-	shl     $2, len_dw
-	jmp     .Lless_than_8_post_shl1
-
 	#######################################################################
-	## 6) LESS THAN 256-bytes REMAIN AT THIS POINT (8-bits of len are full)
+	## 6) Process any remainder without interleaving:
 	#######################################################################
 .Lsmall:
-	shl $32-8, len_dw		# Prepare len_dw for less_than_256
-	j=256
-.rept 5					# j = {256, 128, 64, 32, 16}
-.altmacro
-LABEL less_than_ %j			# less_than_j: Length should be in
-					# upper lg(j) bits of len_dw
-	j=(j/2)
-	shl     $1, len_dw		# Get next MSB
-	JNC_LESS_THAN %j
-.noaltmacro
-	i=0
-.rept (j/8)
-	crc32q  i(bufptmp), crc_init	# Compute crc32 of 8-byte data
-	i=i+8
-.endr
-	jz      .Ldo_return		# Return if remaining length is zero
-	add     $j, bufptmp		# Advance buf
-.endr
-
-.Lless_than_8:				# Length should be stored in
-					# upper 3 bits of len_dw
-	shl     $1, len_dw
-.Lless_than_8_post_shl1:
-	jnc     .Lless_than_4
-	crc32l  (bufptmp), crc_init_dw	# CRC of 4 bytes
-	jz      .Ldo_return		# return if remaining data is zero
-	add     $4, bufptmp
-.Lless_than_4:				# Length should be stored in
-					# upper 2 bits of len_dw
-	shl     $1, len_dw
-	jnc     .Lless_than_2
-	crc32w  (bufptmp), crc_init_dw	# CRC of 2 bytes
-	jz      .Ldo_return		# return if remaining data is zero
-	add     $2, bufptmp
-.Lless_than_2:				# Length should be stored in the MSB
-					# of len_dw
-	shl     $1, len_dw
-	jnc     .Lless_than_1
-	crc32b  (bufptmp), crc_init_dw	# CRC of 1 byte
-.Lless_than_1:				# Length should be zero
-.Ldo_return:
+	test	len, len
+	jz	.Ldone
+	mov	len_dw, %eax
+	shr	$3, %eax
+	jz	.Ldo_dword
+.Ldo_qwords:
+	crc32q	(bufptmp), crc_init
+	add	$8, bufptmp
+	dec	%eax
+	jnz	.Ldo_qwords
+.Ldo_dword:
+	test	$4, len_dw
+	jz	.Ldo_word
+	crc32l	(bufptmp), crc_init_dw
+	add	$4, bufptmp
+.Ldo_word:
+	test	$2, len_dw
+	jz	.Ldo_byte
+	crc32w	(bufptmp), crc_init_dw
+	add	$2, bufptmp
+.Ldo_byte:
+	test	$1, len_dw
+	jz	.Ldone
+	crc32b	(bufptmp), crc_init_dw
+.Ldone:
 	movq    crc_init, %rax
 	popq    %rsi
 	popq    %rdi
 	popq    %rbx
         RET
-- 
2.47.0

