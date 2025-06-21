Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F125830E841;
	Sat, 21 Jun 2025 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750472253; cv=none; b=psSXxtWt4hjQtv9n1KdGHtdroRd9GhYw+yRFJsloI0B2ZXmkzf8oTqUvnyV3GO17kHR+b0ohV7yY3p3Q5i75Hv5KmOkoKH32ukkGZiGGiBXz+XxLz4uROzxqbEsM/xuYB7C7TybIqH55Go/OWiehn9LU5ieJYg6Su2OF9UbqUiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750472253; c=relaxed/simple;
	bh=eQ4/nQ88vxzg/hMwSx6B3cCRxSn2U+aUCaJPKNnsBCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VwO0UfNs18fHDbrf3Lp8cNGCcoePkRQdUc8D+QydwZVcmh+u0De+R6oeB9SzaZ4e4uEBaqxItmTn0inG53ozWcVG0Feday0d/Mo3MHcbWfqb44cH/6kk4eKMpSjXZnjlvTzL0RlkXDOhU5/+d/6OuAFaxu02mQUw0x8APhkaPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bH8zuCRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bH8zuCRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AABAC4CEE3;
	Sat, 21 Jun 2025 02:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750472252;
	bh=eQ4/nQ88vxzg/hMwSx6B3cCRxSn2U+aUCaJPKNnsBCg=;
	h=From:To:Cc:Subject:Date:From;
	b=bH8zuCRqLQ7i8pjDULcwk6OaQgKHOo4ArQMVlDkJMl5U3mH945TiMZYQohcGFO0l+
	 UN8dQNnK4K1v4WcBSvG4zcU/N7uAkU5OXsfg78gQ/HCqzm4gyYww+6eYQ+jvkyJuRR
	 TTEOzQEs2q6/Xio6vZX0Bmz+4NjNrMXso1u3iUbLJSaONGbePVYXSWH0tJfD77Hehk
	 TfcH9cUK9gr1J8NOCFWZEiO1gcDmASgr07E6i8BjVBDnDRvTIwncCvyS5HjOgEQZFk
	 klTLqLd4WS65N3yH+gPef3cgL+REH9MPRfdcxW7AsIG88ruNDFXsGHus++b16bBVpo
	 GjgtWXtkAl74g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/sha512: Remove unnecessary checks for nblocks==0
Date: Fri, 20 Jun 2025 19:15:49 -0700
Message-ID: <20250621021549.105357-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since sha512_blocks() is called only with nblocks >= 1, remove
unnecessary checks for nblocks == 0 from the x86 SHA-512 assembly code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx-asm.S   | 6 +-----
 lib/crypto/x86/sha512-avx2-asm.S  | 5 +----
 lib/crypto/x86/sha512-ssse3-asm.S | 6 +-----
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
index 84291772ba385..af7ea311cc945 100644
--- a/lib/crypto/x86/sha512-avx-asm.S
+++ b/lib/crypto/x86/sha512-avx-asm.S
@@ -271,18 +271,15 @@ frame_size = frame_WK + WK_SIZE
 #			    const u8 *data, size_t nblocks);
 # Purpose: Updates the SHA512 digest stored at "state" with the message
 # stored in "data".
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
-# "nblocks" is the message length in SHA512 blocks
+# "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_avx)
 	ANNOTATE_NOENDBR	# since this is called only via static_call
 
-	test msglen, msglen
-	je .Lnowork
-
 	# Save GPRs
 	push	%rbx
 	push	%r12
 	push	%r13
 	push	%r14
@@ -362,11 +359,10 @@ SYM_FUNC_START(sha512_transform_avx)
 	pop	%r14
 	pop	%r13
 	pop	%r12
 	pop	%rbx
 
-.Lnowork:
 	RET
 SYM_FUNC_END(sha512_transform_avx)
 
 ########################################################################
 ### Binary Data
diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index 2af6a4d7d1640..1302ddb5ec8cc 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -563,11 +563,11 @@ frame_size = frame_CTX + CTX_SIZE
 #			     const u8 *data, size_t nblocks);
 # Purpose: Updates the SHA512 digest stored at "state" with the message
 # stored in "data".
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
-# "nblocks" is the message length in SHA512 blocks
+# "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_rorx)
 	ANNOTATE_NOENDBR	# since this is called only via static_call
 
 	# Save GPRs
@@ -582,11 +582,10 @@ SYM_FUNC_START(sha512_transform_rorx)
 	mov	%rsp, %rbp
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
 	shl	$7, NUM_BLKS	# convert to bytes
-	jz	.Ldone_hash
 	add	INP, NUM_BLKS	# pointer to end of data
 	mov	NUM_BLKS, frame_INPEND(%rsp)
 
 	## load initial digest
 	mov	8*0(CTX1), a
@@ -668,12 +667,10 @@ SYM_FUNC_START(sha512_transform_rorx)
 	mov	frame_INP(%rsp), INP
 	add	$128, INP
 	cmp	frame_INPEND(%rsp), INP
 	jne	.Lloop0
 
-.Ldone_hash:
-
 	# Restore Stack Pointer
 	mov	%rbp, %rsp
 	pop	%rbp
 
 	# Restore GPRs
diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index a7544beb59d38..108f1accc6bc7 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -270,18 +270,15 @@ frame_size = frame_WK + WK_SIZE
 #			      const u8 *data, size_t nblocks);
 # Purpose: Updates the SHA512 digest stored at "state" with the message
 # stored in "data".
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
-# "nblocks" is the message length in SHA512 blocks
+# "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_ssse3)
 	ANNOTATE_NOENDBR	# since this is called only via static_call
 
-	test msglen, msglen
-	je .Lnowork
-
 	# Save GPRs
 	push	%rbx
 	push	%r12
 	push	%r13
 	push	%r14
@@ -361,11 +358,10 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	pop	%r14
 	pop	%r13
 	pop	%r12
 	pop	%rbx
 
-.Lnowork:
 	RET
 SYM_FUNC_END(sha512_transform_ssse3)
 
 ########################################################################
 ### Binary Data

base-commit: 662bd3f5ee337b68c51e24593010e15ff26dabf0
-- 
2.50.0

