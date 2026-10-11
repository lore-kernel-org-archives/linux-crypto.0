Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4DF293458
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791726555; cv=none; b=IaYhJ6vavmGbeYhBi//CFELGoNjxDvMdwiMFml+cOnOc8sCn0aWe+JcKLzRGVd53O+24YDUtVNcInKJLxll5EpcI8WMcI27S8apUq0KMAp26uZslxUkuLW2I/uoki4SpwRB4XpZuFxSiqQ+OE2n/6WbubpxLAxGPgenogknOG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791726555; c=relaxed/simple;
	bh=m3yQz59mqfmLyHQHvecYEEbUXjm7NMtbo0sf/OMkY8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZTnxGByt+0xQRTUalWpnG5s0JKz1XlBw1398Kedbhm0WETud8tmQHOI/e6kqACkMg88sJ9y5ExFbXrnEPxTNqvO/PPdp7sfjzFdzYOIbVIdeVcdbb7fzLL65sy0dGGUROimGyDc4CclOL+xTM7K/jJx/uWMz6R73iSdVE407rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYEX6BYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYEX6BYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43C31F0089B;
	Sun, 11 Oct 2026 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791726554;
	bh=LhXMdUMHDv+NgBCJNvTQUABAqGhLywdYNepNh1Kb+kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYEX6BYAG0Qp4NB+LLt01Bot0Ayw/J5QC1prRcfE2jxLSvFp+Z+x45Gz4EZw+VvMl
	 bfnXt0jtyMgPr914vuq+jUHhhSVuP7cyR+qSELxUg4zvzLbtKL7AFllG4u3kcNkTzj
	 p6vHuyTuuCaufGG9GYW6/Uquy7rNL3ZBxPUQvq3bRPg5NRXwoemw1j5ubisrDqAKlw
	 zzfAOwd7tcbkxrIP1/S//0NR5VWfcQW2xIRMnG12WIRf6cJqnbVZJAM2nXlv5rlCFF
	 KPbR6H55I4T2sBid+uGHtgy6UlnqgKulWDEWy8nPfWXI6f8+vtMcM5myG97qaB2GtK
	 NeK5jQrHDBF7Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] lib/crypto: x86/sha256: Follow the normal %rbp convention
Date: Sun, 11 Oct 2026 15:48:42 +0200
Message-ID: <20261011134843.166585-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011134843.166585-1-ebiggers@kernel.org>
References: <20261011134843.166585-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the SHA-256 assembly functions push callee-save GPRs to the
stack *before* they set up the frame pointer (%rbp).  (They are leaf
functions, but they need to set up a frame pointer anyway because they
allocate a 16- or 32-byte-aligned buffer on the stack.)

As a result, during these functions, 8(%rbp) doesn't contain a return
address like it is supposed to.

This differs from the convention used by C code, and it interferes with
the frame pointer unwinder (CONFIG_UNWINDER_FRAME_POINTER=y).
Specifically, if a call trace is dumped in these functions, then all
entries are populated purely from the fallback scan of the entire stack:

    RIP: 0010:sha256_transform_rorx+0xd78/0x1120
    [...]
    Call Trace:
     <TASK>
     ? sha256_blocks_avx2+0x37/0x70
     ? __sha256_update+0x77/0x220
     ? sha256+0x9d/0x110
     [...]
     ? do_syscall_64+0x6f/0x3e0

With this fix to follow the normal %rbp convention, the call trace is
generated reliably:

    RIP: 0010:sha256_transform_rorx+0xdae/0x1120
    [...]
    Call Trace:
     <TASK>
     sha256_blocks_avx2+0x37/0x70
     __sha256_update+0x77/0x220
     sha256+0x9d/0x110
     [...]
     do_syscall_64+0x6f/0x3e0

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha256-avx-asm.S   | 10 +++++-----
 lib/crypto/x86/sha256-avx2-asm.S  | 10 ++++------
 lib/crypto/x86/sha256-ni-asm.S    |  9 +++++----
 lib/crypto/x86/sha256-ssse3-asm.S |  8 ++++----
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/lib/crypto/x86/sha256-avx-asm.S b/lib/crypto/x86/sha256-avx-asm.S
index c1aceb3ba3a3..efb8dff5e8a9 100644
--- a/lib/crypto/x86/sha256-avx-asm.S
+++ b/lib/crypto/x86/sha256-avx-asm.S
@@ -345,13 +345,13 @@ a = TMP_
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_avx)
+	pushq   %rbp
+	movq    %rsp, %rbp
 	pushq   %rbx
 	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
-	pushq	%rbp
-	movq	%rsp, %rbp
 
 	subq    $STACK_SIZE, %rsp	# allocate stack space
 	and	$~15, %rsp		# align stack pointer
@@ -445,13 +445,13 @@ SYM_FUNC_START(sha256_transform_avx)
 	cmp     _INP_END(%rsp), INP
 	jne     .Lloop0
 
-	mov	%rbp, %rsp
-	popq	%rbp
+	lea     -40(%rbp), %rsp
 	popq    %r15
 	popq    %r14
 	popq    %r13
-	popq	%r12
+	popq    %r12
 	popq    %rbx
+	popq    %rbp
 	RET
 SYM_FUNC_END(sha256_transform_avx)
 
diff --git a/lib/crypto/x86/sha256-avx2-asm.S b/lib/crypto/x86/sha256-avx2-asm.S
index eb8836fb9695..a719c2173b61 100644
--- a/lib/crypto/x86/sha256-avx2-asm.S
+++ b/lib/crypto/x86/sha256-avx2-asm.S
@@ -522,15 +522,14 @@ STACK_SIZE	= _CTX      + _CTX_SIZE
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_rorx)
+	pushq	%rbp
+	mov	%rsp, %rbp
 	pushq	%rbx
 	pushq	%r12
 	pushq	%r13
 	pushq	%r14
 	pushq	%r15
 
-	push	%rbp
-	mov	%rsp, %rbp
-
 	subq	$STACK_SIZE, %rsp
 	and	$-32, %rsp	# align rsp to 32 byte boundary
 
@@ -704,14 +703,13 @@ SYM_FUNC_START(sha256_transform_rorx)
 
 .Ldone_hash:
 
-	mov	%rbp, %rsp
-	pop	%rbp
-
+	lea	-40(%rbp), %rsp
 	popq	%r15
 	popq	%r14
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	popq	%rbp
 	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
diff --git a/lib/crypto/x86/sha256-ni-asm.S b/lib/crypto/x86/sha256-ni-asm.S
index de5f707e7ef7..e47263273f43 100644
--- a/lib/crypto/x86/sha256-ni-asm.S
+++ b/lib/crypto/x86/sha256-ni-asm.S
@@ -276,10 +276,11 @@ SYM_FUNC_END(sha256_ni_transform)
 // to taking better advantage of the CPU's SHA-256 and SIMD throughput.
 //
 SYM_FUNC_START(sha256_ni_finup2x)
-	// Allocate 128 bytes of stack space, 16-byte aligned.
-	push		%rbx
 	push		%rbp
 	mov		%rsp, %rbp
+	push		%rbx
+
+	// Allocate 128 bytes of stack space, 16-byte aligned.
 	sub		$128, %rsp
 	and		$~15, %rsp
 
@@ -527,9 +528,9 @@ SYM_FUNC_START(sha256_ni_finup2x)
 	movdqu		STATE1_A, 0*16(OUT1)
 	movdqu		STATE1_B, 0*16(OUT2)
 
-	mov		%rbp, %rsp
-	pop		%rbp
+	lea		-8(%rbp), %rsp
 	pop		%rbx
+	pop		%rbp
 	RET
 SYM_FUNC_END(sha256_ni_finup2x)
 
diff --git a/lib/crypto/x86/sha256-ssse3-asm.S b/lib/crypto/x86/sha256-ssse3-asm.S
index 383b8eec7ebe..cc91b3e15a83 100644
--- a/lib/crypto/x86/sha256-ssse3-asm.S
+++ b/lib/crypto/x86/sha256-ssse3-asm.S
@@ -352,13 +352,13 @@ a = TMP_
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_ssse3)
+	pushq   %rbp
+	mov     %rsp, %rbp
 	pushq   %rbx
 	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
-	pushq   %rbp
-	mov	%rsp, %rbp
 
 	subq    $STACK_SIZE, %rsp
 	and	$~15, %rsp
@@ -456,13 +456,13 @@ SYM_FUNC_START(sha256_transform_ssse3)
 	cmp     _INP_END(%rsp), INP
 	jne     .Lloop0
 
-	mov	%rbp, %rsp
-	popq	%rbp
+	lea     -40(%rbp), %rsp
 	popq    %r15
 	popq    %r14
 	popq    %r13
 	popq    %r12
 	popq    %rbx
+	popq    %rbp
 
 	RET
 SYM_FUNC_END(sha256_transform_ssse3)
-- 
2.56.0

