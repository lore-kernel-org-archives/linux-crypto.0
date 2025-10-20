Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA192222D1;
	Mon, 20 Oct 2025 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921617; cv=none; b=gvTucNfv882jLBrfxSDpYrXLDQud6PeJPgHTwPkXAwKHFqyCtwgFU/QwnMlSvuu9dhwnt0EnZWw2iK0mbDuiiCTFs9BDaqW7JyhoNcrW33W/pUucSzxuu/jar0IanCUfR4chAX8VCvgGlgrdlXbIwQrP1Abqmaveh0tDIi3Cvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921617; c=relaxed/simple;
	bh=cOfo+vQJHwt2jR/1l9Mz7dS2z0ta/WcLrt8/j3uJDXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENqoUsBXzZkjnZWtFc3qQJkkPu+tBukPDoyRYSfdoriPLxkplGUXE56l3iGxQ+k77A6pJatjk9kiXGn7EtzSyscVR6POjpIYq8MrK4QpENhqlaewwmMCnIhcBpUS0GzQ5n9zPD4OJml19vX1ZHzd3n4MskJkCbXVIDqT62H0ZEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOhzAKtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOhzAKtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928DAC116C6;
	Mon, 20 Oct 2025 00:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921616;
	bh=cOfo+vQJHwt2jR/1l9Mz7dS2z0ta/WcLrt8/j3uJDXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOhzAKtFKZVFysTC8yxErFpISUC2VMzxJyDD4hdrcz3uTIj089WiV2ODOJ9CcZikf
	 Wnrdg6pzK3qd37l9VMFqSh+HhqYmIraNWDgxnLHKmXDbxW4QOAo9e3aqgzI681X7F8
	 2T/xNT/n69e2pc5tgrP9nGk7sY5Gnj/HKo8uIcEmP5fh7e45rxM6BKOVYluW8bvVQx
	 HTDb0ijna/p2XtzNmpeqGJC6af59j1w9wiqAKySaKq8+wgm9Glj3HxO4bH5IIJrckn
	 zIPtzRoCL+L4Aa5u6mwEvZBRdFjBdfyqPlBGW73nCvNYIBFc6kyZa+4+tpZouJTEg/
	 PhF3qfNlsLBOQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/17] lib/crypto: sha3: Document one-shot functions in header and improve docs
Date: Sun, 19 Oct 2025 17:50:33 -0700
Message-ID: <20251020005038.661542-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move kerneldoc for the one-shot functions to the header for the
following reasons:

- This style is already used in sha1.h, sha2.h, and crypto_shash.
  And all the inline functions in sha3.h already.

- The header is where people who want to call the code usually look.

- This way the documentation won't have to be moved each time a function
  is changed to or from an inline function.

Also revise this documentation to fix some errors, be more user focused
(rather than focusing on implementation details like whether a context
is allocated and zeroized), and be a bit more consistent with sha2.h.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sha3.h | 75 +++++++++++++++++++++++++++++++++++++++++++
 lib/crypto/sha3.c     | 70 ----------------------------------------
 2 files changed, 75 insertions(+), 70 deletions(-)

diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 58d2b3e0663e8..80acdb266b8e3 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -259,13 +259,88 @@ static inline void shake_squeeze(struct shake_ctx *ctx,
 				 u8 *out, size_t out_len)
 {
 	return __sha3_squeeze(&ctx->ctx, out, out_len);
 }
 
+/**
+ * sha3_224() - Compute SHA3-224 digest in one shot
+ * @in: The input data to be digested
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the digest will be stored
+ *
+ * Convenience function that computes a SHA3-224 digest.  Use this instead of
+ * the incremental API if you're able to provide all the input at once.
+ *
+ * Context: Any context.
+ */
 void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE]);
+
+/**
+ * sha3_256() - Compute SHA3-256 digest in one shot
+ * @in: The input data to be digested
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the digest will be stored
+ *
+ * Convenience function that computes a SHA3-256 digest.  Use this instead of
+ * the incremental API if you're able to provide all the input at once.
+ *
+ * Context: Any context.
+ */
 void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE]);
+
+/**
+ * sha3_384() - Compute SHA3-384 digest in one shot
+ * @in: The input data to be digested
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the digest will be stored
+ *
+ * Convenience function that computes a SHA3-384 digest.  Use this instead of
+ * the incremental API if you're able to provide all the input at once.
+ *
+ * Context: Any context.
+ */
 void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE]);
+
+/**
+ * sha3_512() - Compute SHA3-512 digest in one shot
+ * @in: The input data to be digested
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the digest will be stored
+ *
+ * Convenience function that computes a SHA3-512 digest.  Use this instead of
+ * the incremental API if you're able to provide all the input at once.
+ *
+ * Context: Any context.
+ */
 void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE]);
+
+/**
+ * shake128() - Compute SHAKE128 in one shot
+ * @in: The input data to be used
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the output will be stored
+ * @out_len: Length of the output to produce in bytes
+ *
+ * Convenience function that computes SHAKE128 in one shot.  Use this instead of
+ * the incremental API if you're able to provide all the input at once as well
+ * as receive all the output at once.  All output lengths are supported.
+ *
+ * Context: Any context.
+ */
 void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len);
+
+/**
+ * shake256() - Compute SHAKE256 in one shot
+ * @in: The input data to be used
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the output will be stored
+ * @out_len: Length of the output to produce in bytes
+ *
+ * Convenience function that computes SHAKE256 in one shot.  Use this instead of
+ * the incremental API if you're able to provide all the input at once as well
+ * as receive all the output at once.  All output lengths are supported.
+ *
+ * Context: Any context.
+ */
 void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len);
 
 #endif /* __CRYPTO_SHA3_H__ */
diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 6c13a43b0f868..6705c1b48da48 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -284,107 +284,50 @@ void __sha3_squeeze(struct __sha3_ctx *ctx, u8 *out, size_t out_len)
 
 	ctx->squeeze_offset = squeeze_offset;
 }
 EXPORT_SYMBOL_GPL(__sha3_squeeze);
 
-/**
- * sha3_224() - Convenience wrapper to digest a simple buffer as SHA3-224
- * @in: The data to be digested
- * @in_len: The amount of data to be digested in bytes
- * @out: The buffer into which the digest will be stored (size not checked)
- *
- * Convenience wrapper to initialise a SHA3 context for SHA-224, add the input
- * data to it, finalise it, extract 28 bytes of digest and clear the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
 	sha3_224_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_224);
 
-/**
- * sha3_256() - Convenience wrapper to digest a simple buffer as SHA3-256
- * @in: The data to be digested
- * @in_len: The amount of data to be digested in bytes
- * @out: The buffer into which the digest will be stored (size not checked)
- *
- * Convenience wrapper to initialise a SHA3 context for SHA-256, add the input
- * data to it, finalise it, extract 32 bytes of digest and clear the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
 	sha3_256_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_256);
 
-/**
- * sha3_384() - Convenience wrapper to digest a simple buffer as SHA3-384
- * @in: The data to be digested
- * @in_len: The amount of data to be digested in bytes
- * @out: The buffer into which the digest will be stored (size not checked)
- *
- * Convenience wrapper to initialise a SHA3 context for SHA-384, add the input
- * data to it, finalise it, extract 48 bytes of digest and clear the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
 	sha3_384_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_384);
 
-/**
- * sha3_512() - Convenience wrapper to digest a simple buffer as SHA3-512
- * @in: The data to be digested in bytes
- * @in_len: The amount of data to be digested in bytes
- * @out: The buffer into which the digest will be stored (size not checked)
- *
- * Convenience wrapper to initialise a SHA3 context for SHA-512, add the input
- * data to it, finalise it, extract 64 bytes of digest and clear the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
 	sha3_512_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_512);
 
-/**
- * shake128() - Convenience wrapper to apply SHAKE128 to a simple buffer
- * @in: The input data to be used
- * @in_len: The amount of input data in bytes
- * @out: The buffer in which to store the output
- * @out_len: The amount of output to store in bytes (variable length)
- *
- * Convenience wrapper to initialise a SHA3 context for SHAKE128, add the input
- * data to it, finalise it, extract the requested amount of output and clear
- * the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 {
 	struct shake_ctx ctx;
 
 	shake128_init(&ctx);
@@ -392,23 +335,10 @@ void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 	shake_squeeze(&ctx, out, out_len);
 	shake_zeroize_ctx(&ctx);
 }
 EXPORT_SYMBOL_GPL(shake128);
 
-/**
- * shake256() - Convenience wrapper to apply SHAKE256 to a simple buffer
- * @in: The input data to be used
- * @in_len: The amount of input data in bytes
- * @out: The buffer in which to store the output
- * @out_len: The amount of output to store in bytes (variable length)
- *
- * Convenience wrapper to initialise a SHA3 context for SHAKE128, add the input
- * data to it, finalise it, extract the requested amount of output and clear
- * the context.
- *
- * Context: May use the FPU/Vector unit registers.
- */
 void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 {
 	struct shake_ctx ctx;
 
 	shake256_init(&ctx);
-- 
2.51.1.dirty

