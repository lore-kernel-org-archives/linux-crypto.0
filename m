Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660581AA8;
	Tue, 24 Mar 2026 00:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774313410; cv=none; b=k48wtb7iwatWCpUM1NItK7Ecea3FvhNX1YwlBIFfWqFi0MSHOh48UyauSE/0ewcp61NiPiTQBqgPTQKxwShKpE6ZxymmWdA9CYnsZHzRDdkCf5PvcfkJqSNYsAZ943yJBVKuShD+8/ZRU24uV3tXQxYYUQ5F/S/5e04q6CXVX0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774313410; c=relaxed/simple;
	bh=DP5RvThrmwwduBuiuEP/nEGN+iF6viTzjV4BJyGugH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFn6+m3r087audEpG+LpwC6kxRKTTjlkQCkJKJ7A5rL9+0V8RkkxjwUAhgh7iNjpLBvHybBXYNFQmjviFpXROyryQq4O1r5xAefjBtMjydVfvBXCnbWvh7VPLJMOsUX/3sZkoH+qJUIASWsE9gPIwTaq3L9jDfx8l0BeAxjKzSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVUvJehR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVUvJehR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA925C4CEF7;
	Tue, 24 Mar 2026 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774313410;
	bh=DP5RvThrmwwduBuiuEP/nEGN+iF6viTzjV4BJyGugH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVUvJehR5AUXtELkMkllJyiKebZxIhNmZ4/nR7tNivljvmNUK+Gr+qeKt9Xqd5x5j
	 W1Csj6TDL+5/kw21+fZ5hvfQogofACPndgaN/us19ikMXxy5h3PlbMa+6QPhbRojiW
	 EyGsbnTgyVyQN4ym8TCN83arfrUXWDqp2+00cK3UA8unudbTZZWdRPjvXNdtxqDFTK
	 v6KLy8t0Cal/AuIKun5oxq+fI9oUp+iKLPS6sSZQaVWx4KPk92BppcUbR64S7ABivL
	 tS8urKJZM9cFNEmumEwfBZCj4AdAgc2whQSprO8YMntDSeIZ/Cp4XF+tQHCe7ocSWG
	 uZo43DtLFvRCA==
Date: Mon, 23 Mar 2026 17:50:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 00/19] GHASH library
Message-ID: <20260324005008.GA230053@quark>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>

On Wed, Mar 18, 2026 at 11:17:01PM -0700, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git ghash-lib-v1
> 
> This series migrates the standalone GHASH code to lib/crypto/, then
> converts the "gcm" template and AES-GCM library code to use it.  (GHASH
> is the universal hash function used by GCM mode.)  As was the case with
> POLYVAL and Poly1305 as well, the library is a much better fit for it.
> 
> Since GHASH and POLYVAL are closely related and it often makes sense to
> implement one in terms of the other, the existing "polyval" library
> module is renamed to "gf128hash" and the GHASH support is added to it.
> 
> The generic implementation of GHASH is also replaced with a better one
> utilizing the existing polyval_mul_generic().
> 
> Note that some GHASH implementations, often faster ones using more
> recent CPU features, still exist in arch/*/crypto/ as internal
> components of AES-GCM implementations.  Those are left as-is for now.
> The goal with this GHASH library is just to provide parity with the
> existing standalone GHASH support, which is used when a full
> implementation of AES-GCM (or ${someothercipher}-GCM, if another block
> cipher is being used) is unavailable.  Migrating the
> architecture-optimized AES-GCM code to lib/crypto/ will be a next step.
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

As usual, the s390 code will need to be tested by someone who has the
privilege of access to a z/Architecture mainframe.  That is the only way
to test that code, given that the s390 community has not yet updated
QEMU to support the CPACF_KIMD_GHASH instruction.

From another review pass I also folded in some trivial cleanups that
don't seem worth sending a v2 for unless something else comes up.
Removed a definition I forgot to remove, dropped unnecessary rename of
'h' to 'k', improved consistency in a couple places, etc.

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index c74066d430fa..eaf2932ceaf5 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -35,10 +35,6 @@ struct arm_ghash_key {
 	u64			h[4][2];
 };
 
-struct arm_ghash_desc_ctx {
-	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
-};
-
 struct gcm_aes_ctx {
 	struct aes_enckey	aes_key;
 	u8			nonce[RFC4106_NONCE_SIZE];
diff --git a/lib/crypto/arm/gf128hash.h b/lib/crypto/arm/gf128hash.h
index cb929bed29d5..c33c8cbe51fe 100644
--- a/lib/crypto/arm/gf128hash.h
+++ b/lib/crypto/arm/gf128hash.h
@@ -12,7 +12,7 @@
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
-			   const u8 *src, const struct polyval_elem *k);
+			   const u8 *src, const struct polyval_elem *h);
 
 #define ghash_blocks_arch ghash_blocks_arch
 static void ghash_blocks_arch(struct polyval_elem *acc,
diff --git a/lib/crypto/arm/ghash-neon-core.S b/lib/crypto/arm/ghash-neon-core.S
index bf423fb06a75..eeffd12504a9 100644
--- a/lib/crypto/arm/ghash-neon-core.S
+++ b/lib/crypto/arm/ghash-neon-core.S
@@ -181,7 +181,7 @@
 	/*
 	 * void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
 	 *			      const u8 *src,
-	 *			      const struct polyval_elem *k)
+	 *			      const struct polyval_elem *h)
 	 */
 ENTRY(pmull_ghash_update_p8)
 	vld1.64		{SHASH}, [r3]
diff --git a/lib/crypto/arm64/gf128hash.h b/lib/crypto/arm64/gf128hash.h
index d5ef1b1b77e1..b2c85585b758 100644
--- a/lib/crypto/arm64/gf128hash.h
+++ b/lib/crypto/arm64/gf128hash.h
@@ -12,14 +12,14 @@
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_asimd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
 
+asmlinkage void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
+				      const u8 *src,
+				      const struct polyval_elem *h);
 asmlinkage void polyval_mul_pmull(struct polyval_elem *a,
 				  const struct polyval_elem *b);
 asmlinkage void polyval_blocks_pmull(struct polyval_elem *acc,
 				     const struct polyval_key *key,
 				     const u8 *data, size_t nblocks);
-asmlinkage void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
-				      const u8 *src,
-				      const struct polyval_elem *k);
 
 #define polyval_preparekey_arch polyval_preparekey_arch
 static void polyval_preparekey_arch(struct polyval_key *key,
@@ -91,8 +91,8 @@ static void ghash_blocks_arch(struct polyval_elem *acc,
 	if (static_branch_likely(&have_asimd) && may_use_simd()) {
 		do {
 			/* Allow rescheduling every 4 KiB. */
-			size_t n =
-				min_t(size_t, nblocks, 4096 / GHASH_BLOCK_SIZE);
+			size_t n = min_t(size_t, nblocks,
+					 4096 / GHASH_BLOCK_SIZE);
 
 			scoped_ksimd()
 				pmull_ghash_update_p8(n, acc, data, &key->h);
diff --git a/lib/crypto/arm64/ghash-neon-core.S b/lib/crypto/arm64/ghash-neon-core.S
index eadd6da47247..85b20fcd98fe 100644
--- a/lib/crypto/arm64/ghash-neon-core.S
+++ b/lib/crypto/arm64/ghash-neon-core.S
@@ -180,7 +180,7 @@
 	/*
 	 * void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
 	 *			      const u8 *src,
-	 *			      const struct polyval_elem *k)
+	 *			      const struct polyval_elem *h)
 	 */
 SYM_FUNC_START(pmull_ghash_update_p8)
 	ld1		{SHASH.2d}, [x3]
diff --git a/lib/crypto/riscv/ghash-riscv64-zvkg.S b/lib/crypto/riscv/ghash-riscv64-zvkg.S
index 2839ff1a990c..6a2a2f2bc7c8 100644
--- a/lib/crypto/riscv/ghash-riscv64-zvkg.S
+++ b/lib/crypto/riscv/ghash-riscv64-zvkg.S
@@ -55,6 +55,8 @@
 // void ghash_zvkg(u8 accumulator[GHASH_BLOCK_SIZE],
 //		   const u8 key[GHASH_BLOCK_SIZE],
 //		   const u8 *data, size_t nblocks);
+//
+// |nblocks| must be nonzero.
 SYM_FUNC_START(ghash_zvkg)
 	vsetivli	zero, 4, e32, m1, ta, ma
 	vle32.v		v1, (ACCUMULATOR)
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 279ff1a339be..5b60d5c3644b 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -41,7 +41,7 @@ config CRYPTO_LIB_GHASH_KUNIT_TEST
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
-	  KUnit tests for GHASH library functions.
+	  KUnit tests for the GHASH library functions.
 
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
