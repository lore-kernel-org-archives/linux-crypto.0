Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E53293458
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791726553; cv=none; b=JIMXlgLH6NBF7f9OU/1zDQhbaqtccozeD03nYraFgic9P8aEa69Wvk8PcbA7L7S4vSRA7VKqflhae2iFxI+fXd+Yg2ys2VGc4vKnjVq6mX6EDrADH0fc0o3EtCPTBNropjkaTSeyfvrYCHPMoCF3SlK9SYDDV2G5zs2poJSZF5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791726553; c=relaxed/simple;
	bh=DiQFuqJn2OgMFWdtdoBTEXrwxMIKIRRWdTYfBxiT/pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syZiWMxlSMJs+abvI3Z5wfU390M44S7icqBVp7gkjRzu0JTkmu0DB7xGKFi36Ala8Y7FNeglunQUG3gFzi4gK2i6BUVHOAC/EsYF5j9or2Hnb1mgxJnf0+5gQSpbIs+zbUjFT7QnG/AF3pJom1cZu9MxgkUCL8lWs9XV3gwGm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoSqyEoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoSqyEoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EE71F0089C;
	Sun, 11 Oct 2026 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791726552;
	bh=jNLKhn6TE03yTZZ4XJpK1L06uJxlgqXok/td3LJO3g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoSqyEoyZA0pRt9ghnPULysewAm/XOg0tHIH3MPecM38LsjH/G77gCXC3H61XsBMD
	 ITWE03JT3ptqSU2mMmkq/si30Sdl1kqwPknmc2nK9ry8RZVeYO/UWbvVNlBvy+A8nJ
	 /d0ckaX1W2z3VZIYWuHSwYGQMkthvMUhY70Ye6UQtn+feDZNOB6Ppf7u48aNZ2UOsF
	 qRNhg7taAkniSbSF1emOgD9GO83kOj/7Q02hRKOKl6I8l9esE0oRlgKoqW6oEbBY9V
	 7Q0tYTiizsENCpHUYU/dt3RMgPE0cRXEVwi8csfsmHKZsSWsY/ULJUHRimfuq58fut
	 b58Rf5lp3LnMQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] lib/crypto: x86/sha1: Follow the normal %rbp convention
Date: Sun, 11 Oct 2026 15:48:41 +0200
Message-ID: <20261011134843.166585-2-ebiggers@kernel.org>
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

Some of the SHA-1 assembly functions push callee-save GPRs to the stack
*before* they set up the frame pointer (%rbp).  (They are leaf
functions, but they need to set up a frame pointer anyway because they
allocate a 16- or 32-byte-aligned buffer on the stack.)

As a result, during these functions, 8(%rbp) doesn't contain a return
address like it is supposed to.

This differs from the convention used by C code, and it interferes with
the frame pointer unwinder (CONFIG_UNWINDER_FRAME_POINTER=y).
Specifically, if a call trace is dumped in these functions, then all
entries are populated purely from the fallback scan of the entire stack:

    RIP: 0010:sha1_transform_avx2+0x1921/0x1ea0
    [...]
    Call Trace:
     <TASK>
     ? sha1_transform_avx+0x2a9/0xc90
     ? sha1_blocks_avx2+0x78/0x140
     ? kernel_fpu_end+0x2d/0x40
     ? sha1_blocks_avx2+0x52/0x140
     ? sha1_update+0x77/0x220
     [...]
     ? do_syscall_64+0x6f/0x3e0

With this fix to follow the normal %rbp convention, the call trace is
generated reliably:

    RIP: 0010:sha1_transform_avx2+0x66e/0x1ea0
    [...]
    Call Trace:
     <TASK>
     sha1_blocks_avx2+0x78/0x140
     sha1_update+0x77/0x220
     [...]
     do_syscall_64+0x6f/0x3e0

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha1-avx2-asm.S      | 10 +++++-----
 lib/crypto/x86/sha1-ssse3-and-avx.S |  9 +++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/crypto/x86/sha1-avx2-asm.S b/lib/crypto/x86/sha1-avx2-asm.S
index 91b2dc6db179..ca64d7104a47 100644
--- a/lib/crypto/x86/sha1-avx2-asm.S
+++ b/lib/crypto/x86/sha1-avx2-asm.S
@@ -622,6 +622,9 @@
 .macro SHA1_VECTOR_ASM  name
 	SYM_FUNC_START(\name)
 
+	push	%rbp
+	mov	%rsp, %rbp
+
 	push	%rbx
 	push	%r12
 	push	%r13
@@ -631,8 +634,6 @@
 	RESERVE_STACK  = (W_SIZE*4 + 8+24)
 
 	/* Align stack */
-	push	%rbp
-	mov	%rsp, %rbp
 	and	$~(0x20-1), %rsp
 	sub	$RESERVE_STACK, %rsp
 
@@ -651,14 +652,13 @@
 
 	avx2_zeroupper
 
-	mov	%rbp, %rsp
-	pop	%rbp
-
+	lea	-40(%rbp), %rsp
 	pop	%r15
 	pop	%r14
 	pop	%r13
 	pop	%r12
 	pop	%rbx
+	pop	%rbp
 
 	RET
 
diff --git a/lib/crypto/x86/sha1-ssse3-and-avx.S b/lib/crypto/x86/sha1-ssse3-and-avx.S
index 78b48cb09c5b..fe0faaf494c7 100644
--- a/lib/crypto/x86/sha1-ssse3-and-avx.S
+++ b/lib/crypto/x86/sha1-ssse3-and-avx.S
@@ -69,11 +69,12 @@
 .macro SHA1_VECTOR_ASM  name
 	SYM_FUNC_START(\name)
 
-	push	%rbx
-	push	%r12
 	push	%rbp
 	mov	%rsp, %rbp
 
+	push	%rbx
+	push	%r12
+
 	sub	$64, %rsp		# allocate workspace
 	and	$~15, %rsp		# align stack
 
@@ -95,10 +96,10 @@
 	xor	%eax, %eax
 	rep stosq
 
-	mov	%rbp, %rsp		# deallocate workspace
-	pop	%rbp
+	lea	-16(%rbp), %rsp		# deallocate workspace
 	pop	%r12
 	pop	%rbx
+	pop	%rbp
 	RET
 
 	SYM_FUNC_END(\name)
-- 
2.56.0

