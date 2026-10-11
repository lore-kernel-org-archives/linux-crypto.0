Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FFE44F548
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791726556; cv=none; b=DlgFUMFrwzy/ZGgzJMS0E84Hd1z6rel4DtWeJFcjQL5P7ZU06qpgtnjBNmSbDR7C/NizVim3GoeZpOWdFGqevSv2yPe1eYtfzF58xKOrJ613LQPSkt3SmwEwHh5FcgyiR0ChoTZNDbCyCR16de7tM3p54lUKbItCKOSHAdZXr2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791726556; c=relaxed/simple;
	bh=9hLgyO2+Qr1BW3xo24vUdp7i/p/fJbbtAoY/O7W35B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJD2JXRizrtkkSrny2Tlo+SpIvgTb+PHNQhiAKSh5AjxYtJAhAOALJomBAQz4kPSdZSej0oMeUTxKTrAy8EVgjP/C68qK7JL6NSx7uijb/99fc9RJCcqs6HwIZxsI2GCTyGog3+aLN4f0AYjCThwjCM7906w6GIgfGp/rYaW1vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqAkxhai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqAkxhai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713611F0089C;
	Sun, 11 Oct 2026 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791726555;
	bh=It+GyRuyrR2NE/jZUdqvVG3tQygkgzv6sQmBpQYfzps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqAkxhaiunTR7nDEslcLJBkbm3614Jsa6/wux9YzQJ4ZPklaTx/1I68BXi87zS1MP
	 XrHQR/06jzYZqEMf/DiOljYDx5GsiJsYwdPwMy3UPvD80qFCMSpdhD0Rw0qlzwhLNj
	 gs/9RsK5PmxdkqQP8r2MV0tA8Fg+Ac/dlC1yJp3cejmMzRje+dDN4rLE3KZDE52GE0
	 nuljgWn3V0tel7amf3PT+BPis2N+pcwQHIGdgJndF3k37P+MLmnsNWazFGRzhWvvgj
	 wUKoCDy+muZuQ+uY1/+C/QTexAHm+DiXyuGmZ/BcheGfnN1A8GkbpR9K57muQLTdnR
	 /pRSSNEHt6H8g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] lib/crypto: x86/sha512: Follow the normal %rbp convention
Date: Sun, 11 Oct 2026 15:48:43 +0200
Message-ID: <20261011134843.166585-4-ebiggers@kernel.org>
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

The SHA-512 assembly functions push callee-save GPRs to the stack
*before* they set up the frame pointer (%rbp).  (They are leaf
functions, but they need to set up a frame pointer anyway because they
allocate a 32-byte-aligned buffer on the stack.)

As a result, during these functions, 8(%rbp) doesn't contain a return
address like it is supposed to.

This differs from the convention used by C code, and it interferes with
the frame pointer unwinder (CONFIG_UNWINDER_FRAME_POINTER=y).
Specifically, if a call trace is dumped in these functions, then all
entries are populated purely from the fallback scan of the entire stack:

    RIP: 0010:sha512_transform_rorx+0x673/0xdf0
    [...]
    Call Trace:
     <TASK>
     ? sha512_blocks_avx2+0x37/0x60
     ? __sha512_update+0x80/0x230
     ? sha512+0x31/0x190
     ? sha512+0x114/0x190
     [...]
     ? do_syscall_64+0x6f/0x3e0

With this fix to follow the normal %rbp convention, the call trace is
generated reliably:

    RIP: 0010:sha512_transform_rorx+0x90c/0xdf0
    [...]
    Call Trace:
     <TASK>
     sha512_blocks_avx2+0x37/0x60
     __sha512_update+0x80/0x230
     sha512+0x114/0x190
     [...]
     do_syscall_64+0x6f/0x3e0

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx-asm.S   | 11 ++++++-----
 lib/crypto/x86/sha512-avx2-asm.S  | 11 ++++++-----
 lib/crypto/x86/sha512-ssse3-asm.S | 11 ++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
index 7732aa8fd850..a17dfedc1c51 100644
--- a/lib/crypto/x86/sha512-avx-asm.S
+++ b/lib/crypto/x86/sha512-avx-asm.S
@@ -276,6 +276,9 @@ frame_size = frame_WK + WK_SIZE
 ########################################################################
 SYM_FUNC_START(sha512_transform_avx)
 
+	push	%rbp
+	mov	%rsp, %rbp
+
 	# Save GPRs
 	push	%rbx
 	push	%r12
@@ -284,8 +287,6 @@ SYM_FUNC_START(sha512_transform_avx)
 	push	%r15
 
 	# Allocate Stack Space
-	push	%rbp
-	mov	%rsp, %rbp
 	sub     $frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
@@ -348,9 +349,8 @@ SYM_FUNC_START(sha512_transform_avx)
 	dec     msglen
 	jnz     .Lupdateblock
 
-	# Restore Stack Pointer
-	mov	%rbp, %rsp
-	pop	%rbp
+	# Deallocate Stack Space
+	lea	-40(%rbp), %rsp
 
 	# Restore GPRs
 	pop	%r15
@@ -358,6 +358,7 @@ SYM_FUNC_START(sha512_transform_avx)
 	pop	%r13
 	pop	%r12
 	pop	%rbx
+	pop	%rbp
 
 	RET
 SYM_FUNC_END(sha512_transform_avx)
diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index 22bdbfd899d0..2256d51297e1 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -568,6 +568,9 @@ frame_size = frame_CTX + CTX_SIZE
 ########################################################################
 SYM_FUNC_START(sha512_transform_rorx)
 
+	push	%rbp
+	mov	%rsp, %rbp
+
 	# Save GPRs
 	push	%rbx
 	push	%r12
@@ -576,8 +579,6 @@ SYM_FUNC_START(sha512_transform_rorx)
 	push	%r15
 
 	# Allocate Stack Space
-	push	%rbp
-	mov	%rsp, %rbp
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
@@ -667,9 +668,8 @@ SYM_FUNC_START(sha512_transform_rorx)
 	cmp	frame_INPEND(%rsp), INP
 	jne	.Lloop0
 
-	# Restore Stack Pointer
-	mov	%rbp, %rsp
-	pop	%rbp
+	# Deallocate Stack Space
+	lea	-40(%rbp), %rsp
 
 	# Restore GPRs
 	pop	%r15
@@ -677,6 +677,7 @@ SYM_FUNC_START(sha512_transform_rorx)
 	pop	%r13
 	pop	%r12
 	pop	%rbx
+	pop	%rbp
 
 	vzeroupper
 	RET
diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 4cae7445b2a8..1a37b7a735cf 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -275,6 +275,9 @@ frame_size = frame_WK + WK_SIZE
 ########################################################################
 SYM_FUNC_START(sha512_transform_ssse3)
 
+	push	%rbp
+	mov	%rsp, %rbp
+
 	# Save GPRs
 	push	%rbx
 	push	%r12
@@ -283,8 +286,6 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	push	%r15
 
 	# Allocate Stack Space
-	push	%rbp
-	mov	%rsp, %rbp
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
@@ -347,9 +348,8 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	dec	msglen
 	jnz	.Lupdateblock
 
-	# Restore Stack Pointer
-	mov	%rbp, %rsp
-	pop	%rbp
+	# Deallocate Stack Space
+	lea	-40(%rbp), %rsp
 
 	# Restore GPRs
 	pop	%r15
@@ -357,6 +357,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	pop	%r13
 	pop	%r12
 	pop	%rbx
+	pop	%rbp
 
 	RET
 SYM_FUNC_END(sha512_transform_ssse3)
-- 
2.56.0

