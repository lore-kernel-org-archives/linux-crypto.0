Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1771E5B69;
	Fri,  4 Jul 2025 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751596928; cv=none; b=nS9PqcEpVxwxxzbu+Hj5/lCMO+2C1uFQhcslinhz3nLhmuesW1g1pSEtiD+U4fYXYJIZOIJc6Pz96bQkBXoy4jF1rNFcnMlEZi0kTbHnMGzSBA4eei6VsvlP4t1LAAfY90iwjfHVRfuuV2EkwwZ6go27VfucRzvXqOwBHaYEVRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751596928; c=relaxed/simple;
	bh=ZmWFyCvhpkEvRK5ZvfnfogthS9shinEKaV9jCAXnFN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlmIc0PLsyQyoMedfEFysOOyvBj9xGj7m42n3Vw+tHZOXReXicnp8TruVy83R/4h3CgFGE9UDpHXHeRHi1MhaxlZIgHcCr6YeZJ2CD1VAH3aNnzW7jvB+6R6K0uhDgkw6sOsd/PTik21+Yh+bYAuRTNs23aok+c0I30Wn332qJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIx+dLHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIx+dLHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9387DC4CEF1;
	Fri,  4 Jul 2025 02:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751596927;
	bh=ZmWFyCvhpkEvRK5ZvfnfogthS9shinEKaV9jCAXnFN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIx+dLHvnD7vp3FPJybU2kv4jSWxAyNj5jnP4psbbrCgaVDbbNBW4LzV3aFWwr3H4
	 5TLrX21MwCQVxP5mDdBzmT/T+S2RhFa7m/0OheQKgQa+l6ymMmWAwNgmvczbvhOwu9
	 WwGaW3Q3x3osRu3Rj0KTdE9vND2dGwtuaL0/GdJR04gQAnoMzYrVSSNhppXSc8ZTGM
	 N+bAek2IvuOWUlTfnHLXGxFqzcQT4b4ZXsi7pOQ1RkE2Mf6yYxsb9V+avhEtYP0S5B
	 yiWIcWxGE95EgKC7xXxGnwmPfRkL/sdM7tqSoM8bxng1D7+Na+bzeFHgFNXR8L2Hw1
	 PffSvqfkkhmSg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] lib/crypto: x86/sha256: Remove unnecessary checks for nblocks==0
Date: Thu,  3 Jul 2025 19:39:58 -0700
Message-ID: <20250704023958.73274-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250704023958.73274-1-ebiggers@kernel.org>
References: <20250704023958.73274-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since sha256_blocks() is called only with nblocks >= 1, remove
unnecessary checks for nblocks == 0 from the x86 SHA-256 assembly code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha256-avx-asm.S   | 3 ---
 lib/crypto/x86/sha256-avx2-asm.S  | 1 -
 lib/crypto/x86/sha256-ni-asm.S    | 3 ---
 lib/crypto/x86/sha256-ssse3-asm.S | 3 ---
 4 files changed, 10 deletions(-)

diff --git a/lib/crypto/x86/sha256-avx-asm.S b/lib/crypto/x86/sha256-avx-asm.S
index 798a7f07fa013..c1aceb3ba3a3a 100644
--- a/lib/crypto/x86/sha256-avx-asm.S
+++ b/lib/crypto/x86/sha256-avx-asm.S
@@ -355,11 +355,10 @@ SYM_FUNC_START(sha256_transform_avx)
 
 	subq    $STACK_SIZE, %rsp	# allocate stack space
 	and	$~15, %rsp		# align stack pointer
 
 	shl     $6, NUM_BLKS		# convert to bytes
-	jz      .Ldone_hash
 	add     INP, NUM_BLKS		# pointer to end of data
 	mov     NUM_BLKS, _INP_END(%rsp)
 
 	## load initial digest
 	mov     4*0(CTX), a
@@ -444,12 +443,10 @@ SYM_FUNC_START(sha256_transform_avx)
 	mov     _INP(%rsp), INP
 	add     $64, INP
 	cmp     _INP_END(%rsp), INP
 	jne     .Lloop0
 
-.Ldone_hash:
-
 	mov	%rbp, %rsp
 	popq	%rbp
 	popq    %r15
 	popq    %r14
 	popq    %r13
diff --git a/lib/crypto/x86/sha256-avx2-asm.S b/lib/crypto/x86/sha256-avx2-asm.S
index 62a46993359e6..eb8836fb9695c 100644
--- a/lib/crypto/x86/sha256-avx2-asm.S
+++ b/lib/crypto/x86/sha256-avx2-asm.S
@@ -533,11 +533,10 @@ SYM_FUNC_START(sha256_transform_rorx)
 
 	subq	$STACK_SIZE, %rsp
 	and	$-32, %rsp	# align rsp to 32 byte boundary
 
 	shl	$6, NUM_BLKS	# convert to bytes
-	jz	.Ldone_hash
 	lea	-64(INP, NUM_BLKS), NUM_BLKS # pointer to last block
 	mov	NUM_BLKS, _INP_END(%rsp)
 
 	cmp	NUM_BLKS, INP
 	je	.Lonly_one_block
diff --git a/lib/crypto/x86/sha256-ni-asm.S b/lib/crypto/x86/sha256-ni-asm.S
index 9ebbacbb9c13b..4bd9490ffc662 100644
--- a/lib/crypto/x86/sha256-ni-asm.S
+++ b/lib/crypto/x86/sha256-ni-asm.S
@@ -110,11 +110,10 @@
  */
 .text
 SYM_FUNC_START(sha256_ni_transform)
 
 	shl		$6, NUM_BLKS		/*  convert to bytes */
-	jz		.Ldone_hash
 	add		DATA_PTR, NUM_BLKS	/* pointer to end of data */
 
 	/*
 	 * load initial hash values
 	 * Need to reorder these appropriately
@@ -161,12 +160,10 @@ SYM_FUNC_START(sha256_ni_transform)
 	pshufd		$0x1B, STATE1, STATE1		/* DCBA */
 
 	movdqu		STATE1, 0*16(STATE_PTR)
 	movdqu		STATE0, 1*16(STATE_PTR)
 
-.Ldone_hash:
-
 	RET
 SYM_FUNC_END(sha256_ni_transform)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
diff --git a/lib/crypto/x86/sha256-ssse3-asm.S b/lib/crypto/x86/sha256-ssse3-asm.S
index 3b602b7d43fad..0a2719661784c 100644
--- a/lib/crypto/x86/sha256-ssse3-asm.S
+++ b/lib/crypto/x86/sha256-ssse3-asm.S
@@ -363,11 +363,10 @@ SYM_FUNC_START(sha256_transform_ssse3)
 
 	subq    $STACK_SIZE, %rsp
 	and	$~15, %rsp
 
 	shl     $6, NUM_BLKS		 # convert to bytes
-	jz      .Ldone_hash
 	add     INP, NUM_BLKS
 	mov     NUM_BLKS, _INP_END(%rsp) # pointer to end of data
 
 	## load initial digest
 	mov     4*0(CTX), a
@@ -456,12 +455,10 @@ SYM_FUNC_START(sha256_transform_ssse3)
 	mov     _INP(%rsp), INP
 	add     $64, INP
 	cmp     _INP_END(%rsp), INP
 	jne     .Lloop0
 
-.Ldone_hash:
-
 	mov	%rbp, %rsp
 	popq	%rbp
 	popq    %r15
 	popq    %r14
 	popq    %r13
-- 
2.50.0

