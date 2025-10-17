Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BAF257831;
	Fri, 17 Oct 2025 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760726068; cv=none; b=Yqz7VcifM8SplGKHWLHQrBfkUfyqqahuD5u5m+WycmFnJ6DQvHrp9qGYswU1r0Z941cD5gDkhh8nLc0jjdPxqZvxrzdyQNcOhpXDjLPmciIU00Nzc/awT4zmWWDrRlG+YWKolBgoHWayhANcSxGO0HfVUjW8AGS4IaBDZhvzPVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760726068; c=relaxed/simple;
	bh=cme3lAtwMXkYDySA+0NTBRWRZbCrizPdv6pMw4zVpCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3w1N/y/t8ZaKjybCF5ERE099ejF3GQT4uxBkFdlg0e/EtMf4cuoWDwvKxufFeU4iM6lAmehECkWAzdYJNoBMCaCIQJKafsKsuO15QGatX73WNmfwSboN6CW5Y3c/6KFDqRdBPdeJKuMgkCLJ9aXg8YHQU7x3VpK+kshFpLUNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwgPZcNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwgPZcNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E74C113D0;
	Fri, 17 Oct 2025 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760726067;
	bh=cme3lAtwMXkYDySA+0NTBRWRZbCrizPdv6pMw4zVpCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FwgPZcNjuWTeTW+W/+9ntoXcJLtKeo+19ytzrA/cYipIDhtQ3fvKZAbBkywkMS4rB
	 vW0thvqh/4hxA3Fb01cDEexUkMrbjZdkCtvDzQl05QIzRAmivTN//e7SgqCp2jIiNI
	 qN1bfApU8o3VCS2Va6S9WXk/Mpq14cXHFT3EaEX2/junjLuzTlvRgF521Bs/8PmADm
	 wS5C7EU9qufyEfQ3Yc2EvCXzvlvPKmyWjV+qAKuQgexDjlMID7EJ7hOLyWXmOEhxT4
	 i4bKnbJe/Ntkx82MVmKU4d7eyMLc74e4Szc+5HCBi6gRQm8qibS3+HF2pWZxcPeO3s
	 Ni03eQSZsyklw==
Date: Fri, 17 Oct 2025 18:34:26 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/8] crypto: x86/aes-gcm - add VAES+AVX2 optimized code
Message-ID: <20251017183426.GA315411@google.com>
References: <20251002023117.37504-1-ebiggers@kernel.org>
 <20251002023117.37504-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002023117.37504-2-ebiggers@kernel.org>

On Wed, Oct 01, 2025 at 07:31:10PM -0700, Eric Biggers wrote:
> Add an implementation of AES-GCM that uses 256-bit vectors and the
> following CPU features: Vector AES (VAES), Vector Carryless
> Multiplication (VPCLMULQDQ), and AVX2.

A few non-functional cleanups I applied after reading over the assembly
file again (wasn't worth resending the whole patchset):

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx2.S b/arch/x86/crypto/aes-gcm-vaes-avx2.S
index e628dbb33c0e..f58096a37342 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx2.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx2.S
@@ -231,11 +231,10 @@ SYM_FUNC_START(aes_gcm_precompute_vaes_avx2)
 	.set	TMP2,		%ymm2
 	.set	TMP2_XMM,	%xmm2
 	.set	H_CUR,		%ymm3
 	.set	H_CUR_XMM,	%xmm3
 	.set	H_CUR2,		%ymm4
-	.set	H_CUR2_XMM,	%xmm4
 	.set	H_INC,		%ymm5
 	.set	H_INC_XMM,	%xmm5
 	.set	GFPOLY,		%ymm6
 	.set	GFPOLY_XMM,	%xmm6
 
@@ -576,11 +575,10 @@ SYM_FUNC_START(aes_gcm_aad_update_vaes_avx2)
 
 	jz		.Laad_done
 	cmp		$16, AADLEN
 	jle		.Laad_lastblock
 
-.Laad_last2blocks:
 	// Update GHASH with the remaining 17 <= AADLEN <= 31 bytes of AAD.
 	mov		AADLEN, AADLEN	// Zero-extend AADLEN to AADLEN64.
 	vmovdqu		(AAD), TMP0_XMM
 	vmovdqu		-16(AAD, AADLEN64), TMP1_XMM
 	vpshufb		BSWAP_MASK_XMM, TMP0_XMM, TMP0_XMM
@@ -632,11 +630,11 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx2)
 	vpxor		RNDKEY0, AESDATA\i, AESDATA\i
 .endr
 .endm
 
 // Generate and encrypt counter blocks in the given AESDATA vectors, excluding
-// the last AES round.  Clobbers TMP0.
+// the last AES round.  Clobbers %rax and TMP0.
 .macro	_aesenc_loop	vecs:vararg
 	_ctr_begin	\vecs
 	lea		16(KEY), %rax
 .Laesenc_loop\@:
 	vbroadcasti128	(%rax), TMP0
@@ -687,11 +685,11 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx2)
 	.set	KEY,		%rdi
 	.set	LE_CTR_PTR,	%rsi
 	.set	LE_CTR_PTR32,	%esi
 	.set	GHASH_ACC_PTR,	%rdx
 	.set	SRC,		%rcx	// Assumed to be %rcx.
-					// See .Ltail_xor_and_ghash_partial_vec
+					// See .Ltail_xor_and_ghash_1to16bytes
 	.set	DST,		%r8
 	.set	DATALEN,	%r9d
 	.set	DATALEN64,	%r9	// Zero-extend DATALEN before using!
 
 	// Additional local variables
@@ -734,11 +732,10 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx2)
 	// H_POW[2-1]_XORED contain cached values from KEY->h_powers_xored.  The
 	// descending numbering reflects the order of the key powers.
 	.set	H_POW2_XORED,	%ymm7
 	.set	H_POW2_XORED_XMM, %xmm7
 	.set	H_POW1_XORED,	%ymm8
-	.set	H_POW1_XORED_XMM, %xmm8
 
 	// RNDKEY0 caches the zero-th round key, and RNDKEYLAST the last one.
 	.set	RNDKEY0,	%ymm9
 	.set	RNDKEYLAST,	%ymm10
 
@@ -749,13 +746,11 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx2)
 	.set	AESDATA0,	%ymm12
 	.set	AESDATA0_XMM,	%xmm12
 	.set	AESDATA1,	%ymm13
 	.set	AESDATA1_XMM,	%xmm13
 	.set	AESDATA2,	%ymm14
-	.set	AESDATA2_XMM,	%xmm14
 	.set	AESDATA3,	%ymm15
-	.set	AESDATA3_XMM,	%xmm15
 
 .if \enc
 	.set	GHASHDATA_PTR,	DST
 .else
 	.set	GHASHDATA_PTR,	SRC
