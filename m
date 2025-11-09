Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22146274B35;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732198; cv=none; b=mXi1DkMtzcByvd833nUTizhK75LSKt9z5GmmbpMD2Se/nZIMZuwzc2zmFoYFqVHB3uu0uO7PF70KENmhmN6bsag/wKFK1luUHpxnzx3eqvUlCVN0V1XT3el5x1rv5VXgpnQCAV408XwvSDGdODEA3zLP6MP9nP9tTRfaduO/ytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732198; c=relaxed/simple;
	bh=ZoXcGXBGVlSr3Ho0fOCW8R5LkDPylPl0IcgWUO0IZ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SItfqCbi5+A+xTYYz6KcHTJForXzt5SUUvOW66rlC4AwG8b+Pq6C6/M+GAqZlqPHgKil2rNUiyR265gfUul8KuMZuBa6PXFT61HsSw/MqyLuKNZfa7ZJRLEZs+0Yl2s7uBfqMEha3JlU2BFxL9nJrtxkbqyQAzgShywfoHt0MT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltPtQ5D7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltPtQ5D7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E1AC113D0;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732197;
	bh=ZoXcGXBGVlSr3Ho0fOCW8R5LkDPylPl0IcgWUO0IZ7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltPtQ5D7C46OOur1c0zaKE1wwSXXrQWTzc1bWwcLWUlmUafAEN6NoRIoVLIOTAeGX
	 6bRgBrTbohN3/p2j05DymcyF1vlGi+3VtDK8whLCWHNMvnQGwXdfu6XLKHz1xNxRhN
	 pQzlf6XrG4q34VBUUno6eTqcAE8gAn7Hk1qCL6rqn8IfIyVBsADHDwhK042NgD6e5Y
	 uR8I0M4q/OkfvtsX6gGZZbXoJDYTdxGkmpKZ32Adbn3k8O5ISU8jiyR/YG1RokSwPo
	 OhTBpsZTNgqjsIKSeDJiEzyC8nxJ4yQ7ME1xCiinSpfwofDt4gUNP5NTgGfb47TsN9
	 cpVwpeIa/Z4EA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/9] lib/crypto: polyval: Add POLYVAL library
Date: Sun,  9 Nov 2025 15:47:17 -0800
Message-ID: <20251109234726.638437-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for POLYVAL to lib/crypto/.

This will replace the polyval crypto_shash algorithm and its use in the
hctr2 template, simplifying the code and reducing overhead.

Specifically, this commit introduces the POLYVAL library API and a
generic implementation of it.  Later commits will migrate the existing
architecture-optimized implementations of POLYVAL into lib/crypto/ and
add a KUnit test suite.

I've also rewritten the generic implementation completely, using a more
modern approach instead of the traditional table-based approach.  It's
now constant-time, requires no precomputation or dynamic memory
allocations, decreases the per-key memory usage from 4096 bytes to 16
bytes, and is faster than the old polyval-generic even on bulk data
reusing the same key (at least on x86_64, where I measured 15% faster).
We should do this for GHASH too, but for now just do it for POLYVAL.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/polyval.h | 171 +++++++++++++++++++++-
 lib/crypto/Kconfig       |  10 ++
 lib/crypto/Makefile      |   8 +
 lib/crypto/polyval.c     | 307 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 493 insertions(+), 3 deletions(-)
 create mode 100644 lib/crypto/polyval.c

diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index d2e63743e592..5ba4c248cad1 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -1,14 +1,179 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Common values for the Polyval hash algorithm
+ * POLYVAL library API
  *
- * Copyright 2021 Google LLC
+ * Copyright 2025 Google LLC
  */
 
 #ifndef _CRYPTO_POLYVAL_H
 #define _CRYPTO_POLYVAL_H
 
+#include <linux/string.h>
+#include <linux/types.h>
+
 #define POLYVAL_BLOCK_SIZE	16
 #define POLYVAL_DIGEST_SIZE	16
 
+/**
+ * struct polyval_elem - An element of the POLYVAL finite field
+ * @bytes: View of the element as a byte array (unioned with @lo and @hi)
+ * @lo: The low 64 terms of the element's polynomial
+ * @hi: The high 64 terms of the element's polynomial
+ *
+ * This represents an element of the finite field GF(2^128), using the POLYVAL
+ * convention: little-endian byte order and natural bit order.
+ */
+struct polyval_elem {
+	union {
+		u8 bytes[POLYVAL_BLOCK_SIZE];
+		struct {
+			__le64 lo;
+			__le64 hi;
+		};
+	};
+};
+
+/**
+ * struct polyval_key - Prepared key for POLYVAL
+ *
+ * This may contain just the raw key H, or it may contain precomputed key
+ * powers, depending on the platform's POLYVAL implementation.  Use
+ * polyval_preparekey() to initialize this.
+ */
+struct polyval_key {
+#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#error "Unhandled arch"
+#else /* CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
+	/** @h: The hash key H */
+	struct polyval_elem h;
+#endif /* !CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
+};
+
+/**
+ * struct polyval_ctx - Context for computing a POLYVAL value
+ * @key: Pointer to the prepared POLYVAL key.  The user of the API is
+ *	 responsible for ensuring that the key lives as long as the context.
+ * @acc: The accumulator
+ * @partial: Number of data bytes processed so far modulo POLYVAL_BLOCK_SIZE
+ */
+struct polyval_ctx {
+	const struct polyval_key *key;
+	struct polyval_elem acc;
+	size_t partial;
+};
+
+/**
+ * polyval_preparekey() - Prepare a POLYVAL key
+ * @key: (output) The key structure to initialize
+ * @raw_key: The raw hash key
+ *
+ * Initialize a POLYVAL key structure from a raw key.  This may be a simple
+ * copy, or it may involve precomputing powers of the key, depending on the
+ * platform's POLYVAL implementation.
+ *
+ * Context: Any context.
+ */
+#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+void polyval_preparekey(struct polyval_key *key,
+			const u8 raw_key[POLYVAL_BLOCK_SIZE]);
+
+#else
+static inline void polyval_preparekey(struct polyval_key *key,
+				      const u8 raw_key[POLYVAL_BLOCK_SIZE])
+{
+	/* Just a simple copy, so inline it. */
+	memcpy(key->h.bytes, raw_key, POLYVAL_BLOCK_SIZE);
+}
 #endif
+
+/**
+ * polyval_init() - Initialize a POLYVAL context for a new message
+ * @ctx: The context to initialize
+ * @key: The key to use.  Note that a pointer to the key is saved in the
+ *	 context, so the key must live at least as long as the context.
+ */
+static inline void polyval_init(struct polyval_ctx *ctx,
+				const struct polyval_key *key)
+{
+	*ctx = (struct polyval_ctx){ .key = key };
+}
+
+/**
+ * polyval_import_blkaligned() - Import a POLYVAL accumulator value
+ * @ctx: The context to initialize
+ * @key: The key to import.  Note that a pointer to the key is saved in the
+ *	 context, so the key must live at least as long as the context.
+ * @acc: The accumulator value to import.
+ *
+ * This imports an accumulator that was saved by polyval_export_blkaligned().
+ * The same key must be used.
+ */
+static inline void
+polyval_import_blkaligned(struct polyval_ctx *ctx,
+			  const struct polyval_key *key,
+			  const struct polyval_elem *acc)
+{
+	*ctx = (struct polyval_ctx){ .key = key, .acc = *acc };
+}
+
+/**
+ * polyval_export_blkaligned() - Export a POLYVAL accumulator value
+ * @ctx: The context to export the accumulator value from
+ * @acc: (output) The exported accumulator value
+ *
+ * This exports the accumulator from a POLYVAL context.  The number of data
+ * bytes processed so far must be a multiple of POLYVAL_BLOCK_SIZE.
+ */
+static inline void polyval_export_blkaligned(const struct polyval_ctx *ctx,
+					     struct polyval_elem *acc)
+{
+	*acc = ctx->acc;
+}
+
+/**
+ * polyval_update() - Update a POLYVAL context with message data
+ * @ctx: The context to update; must have been initialized
+ * @data: The message data
+ * @len: The data length in bytes.  Doesn't need to be block-aligned.
+ *
+ * This can be called any number of times.
+ *
+ * Context: Any context.
+ */
+void polyval_update(struct polyval_ctx *ctx, const u8 *data, size_t len);
+
+/**
+ * polyval_final() - Finish computing a POLYVAL value
+ * @ctx: The context to finalize
+ * @out: The output value
+ *
+ * If the total data length isn't a multiple of POLYVAL_BLOCK_SIZE, then the
+ * final block is automatically zero-padded.
+ *
+ * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
+ *
+ * Context: Any context.
+ */
+void polyval_final(struct polyval_ctx *ctx, u8 out[POLYVAL_BLOCK_SIZE]);
+
+/**
+ * polyval() - Compute a POLYVAL value
+ * @key: The prepared key
+ * @data: The message data
+ * @len: The data length in bytes.  Doesn't need to be block-aligned.
+ * @out: The output value
+ *
+ * Context: Any context.
+ */
+static inline void polyval(const struct polyval_key *key,
+			   const u8 *data, size_t len,
+			   u8 out[POLYVAL_BLOCK_SIZE])
+{
+	struct polyval_ctx ctx;
+
+	polyval_init(&ctx, key);
+	polyval_update(&ctx, data, len);
+	polyval_final(&ctx, out);
+}
+
+#endif /* _CRYPTO_POLYVAL_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 7445054fc0ad..6545f0e83b83 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -133,10 +133,20 @@ config CRYPTO_LIB_POLY1305_RSIZE
 	default 2 if MIPS || RISCV
 	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 1
 
+config CRYPTO_LIB_POLYVAL
+	tristate
+	help
+	  The POLYVAL library functions.  Select this if your module uses any of
+	  the functions from <crypto/polyval.h>.
+
+config CRYPTO_LIB_POLYVAL_ARCH
+	bool
+	depends on CRYPTO_LIB_POLYVAL && !UML
+
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_UTILS
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 5515e73bfd5e..055e44008805 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -196,10 +196,18 @@ clean-files += arm/poly1305-core.S \
 	       riscv/poly1305-core.S \
 	       x86/poly1305-x86_64-cryptogams.S
 
 ################################################################################
 
+obj-$(CONFIG_CRYPTO_LIB_POLYVAL) += libpolyval.o
+libpolyval-y := polyval.o
+ifeq ($(CONFIG_CRYPTO_LIB_POLYVAL_ARCH),y)
+CFLAGS_polyval.o += -I$(src)/$(SRCARCH)
+endif
+
+################################################################################
+
 obj-$(CONFIG_CRYPTO_LIB_SHA1) += libsha1.o
 libsha1-y := sha1.o
 ifeq ($(CONFIG_CRYPTO_LIB_SHA1_ARCH),y)
 CFLAGS_sha1.o += -I$(src)/$(SRCARCH)
 ifeq ($(CONFIG_ARM),y)
diff --git a/lib/crypto/polyval.c b/lib/crypto/polyval.c
new file mode 100644
index 000000000000..5796275f574a
--- /dev/null
+++ b/lib/crypto/polyval.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * POLYVAL library functions
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <crypto/polyval.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+
+/*
+ * POLYVAL is an almost-XOR-universal hash function.  Similar to GHASH, POLYVAL
+ * interprets the message as the coefficients of a polynomial in GF(2^128) and
+ * evaluates that polynomial at a secret point.  POLYVAL has a simple
+ * mathematical relationship with GHASH, but it uses a better field convention
+ * which makes it easier and faster to implement.
+ *
+ * POLYVAL is not a cryptographic hash function, and it should be used only by
+ * algorithms that are specifically designed to use it.
+ *
+ * POLYVAL is specified by "AES-GCM-SIV: Nonce Misuse-Resistant Authenticated
+ * Encryption" (https://datatracker.ietf.org/doc/html/rfc8452)
+ *
+ * POLYVAL is also used by HCTR2.  See "Length-preserving encryption with HCTR2"
+ * (https://eprint.iacr.org/2021/1441.pdf).
+ *
+ * This file provides a library API for POLYVAL.  This API can delegate to
+ * either a generic implementation or an architecture-optimized implementation.
+ *
+ * For the generic implementation, we don't use the traditional table approach
+ * to GF(2^128) multiplication.  That approach is not constant-time and requires
+ * a lot of memory.  Instead, we use a different approach which emulates
+ * carryless multiplication using standard multiplications by spreading the data
+ * bits apart using "holes".  This allows the carries to spill harmlessly.  This
+ * approach is borrowed from BoringSSL, which in turn credits BearSSL's
+ * documentation (https://bearssl.org/constanttime.html#ghash-for-gcm) for the
+ * "holes" trick and a presentation by Shay Gueron
+ * (https://crypto.stanford.edu/RealWorldCrypto/slides/gueron.pdf) for the
+ * 256-bit => 128-bit reduction algorithm.
+ */
+
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+
+/* Do a 64 x 64 => 128 bit carryless multiplication. */
+static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
+{
+	/*
+	 * With 64-bit multiplicands and one term every 4 bits, there would be
+	 * up to 64 / 4 = 16 one bits per column when each multiplication is
+	 * written out as a series of additions in the schoolbook manner.
+	 * Unfortunately, that doesn't work since the value 16 is 1 too large to
+	 * fit in 4 bits.  Carries would sometimes overflow into the next term.
+	 *
+	 * Using one term every 5 bits would work.  However, that would cost
+	 * 5 x 5 = 25 multiplications instead of 4 x 4 = 16.
+	 *
+	 * Instead, mask off 4 bits from one multiplicand, giving a max of 15
+	 * one bits per column.  Then handle those 4 bits separately.
+	 */
+	u64 a0 = a & 0x1111111111111110;
+	u64 a1 = a & 0x2222222222222220;
+	u64 a2 = a & 0x4444444444444440;
+	u64 a3 = a & 0x8888888888888880;
+
+	u64 b0 = b & 0x1111111111111111;
+	u64 b1 = b & 0x2222222222222222;
+	u64 b2 = b & 0x4444444444444444;
+	u64 b3 = b & 0x8888888888888888;
+
+	/* Multiply the high 60 bits of @a by @b. */
+	u128 c0 = (a0 * (u128)b0) ^ (a1 * (u128)b3) ^
+		  (a2 * (u128)b2) ^ (a3 * (u128)b1);
+	u128 c1 = (a0 * (u128)b1) ^ (a1 * (u128)b0) ^
+		  (a2 * (u128)b3) ^ (a3 * (u128)b2);
+	u128 c2 = (a0 * (u128)b2) ^ (a1 * (u128)b1) ^
+		  (a2 * (u128)b0) ^ (a3 * (u128)b3);
+	u128 c3 = (a0 * (u128)b3) ^ (a1 * (u128)b2) ^
+		  (a2 * (u128)b1) ^ (a3 * (u128)b0);
+
+	/* Multiply the low 4 bits of @a by @b. */
+	u64 e0 = -(a & 1) & b;
+	u64 e1 = -((a >> 1) & 1) & b;
+	u64 e2 = -((a >> 2) & 1) & b;
+	u64 e3 = -((a >> 3) & 1) & b;
+	u64 extra_lo = e0 ^ (e1 << 1) ^ (e2 << 2) ^ (e3 << 3);
+	u64 extra_hi = (e1 >> 63) ^ (e2 >> 62) ^ (e3 >> 61);
+
+	/* Add all the intermediate products together. */
+	*out_lo = (((u64)c0) & 0x1111111111111111) ^
+		  (((u64)c1) & 0x2222222222222222) ^
+		  (((u64)c2) & 0x4444444444444444) ^
+		  (((u64)c3) & 0x8888888888888888) ^ extra_lo;
+	*out_hi = (((u64)(c0 >> 64)) & 0x1111111111111111) ^
+		  (((u64)(c1 >> 64)) & 0x2222222222222222) ^
+		  (((u64)(c2 >> 64)) & 0x4444444444444444) ^
+		  (((u64)(c3 >> 64)) & 0x8888888888888888) ^ extra_hi;
+}
+
+#else /* CONFIG_ARCH_SUPPORTS_INT128 */
+
+/* Do a 32 x 32 => 64 bit carryless multiplication. */
+static u64 clmul32(u32 a, u32 b)
+{
+	/*
+	 * With 32-bit multiplicands and one term every 4 bits, there are up to
+	 * 32 / 4 = 8 one bits per column when each multiplication is written
+	 * out as a series of additions in the schoolbook manner.  The value 8
+	 * fits in 4 bits, so the carries don't overflow into the next term.
+	 */
+	u32 a0 = a & 0x11111111;
+	u32 a1 = a & 0x22222222;
+	u32 a2 = a & 0x44444444;
+	u32 a3 = a & 0x88888888;
+
+	u32 b0 = b & 0x11111111;
+	u32 b1 = b & 0x22222222;
+	u32 b2 = b & 0x44444444;
+	u32 b3 = b & 0x88888888;
+
+	u64 c0 = (a0 * (u64)b0) ^ (a1 * (u64)b3) ^
+		 (a2 * (u64)b2) ^ (a3 * (u64)b1);
+	u64 c1 = (a0 * (u64)b1) ^ (a1 * (u64)b0) ^
+		 (a2 * (u64)b3) ^ (a3 * (u64)b2);
+	u64 c2 = (a0 * (u64)b2) ^ (a1 * (u64)b1) ^
+		 (a2 * (u64)b0) ^ (a3 * (u64)b3);
+	u64 c3 = (a0 * (u64)b3) ^ (a1 * (u64)b2) ^
+		 (a2 * (u64)b1) ^ (a3 * (u64)b0);
+
+	/* Add all the intermediate products together. */
+	return (c0 & 0x1111111111111111) ^
+	       (c1 & 0x2222222222222222) ^
+	       (c2 & 0x4444444444444444) ^
+	       (c3 & 0x8888888888888888);
+}
+
+/* Do a 64 x 64 => 128 bit carryless multiplication. */
+static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
+{
+	u32 a_lo = (u32)a;
+	u32 a_hi = a >> 32;
+	u32 b_lo = (u32)b;
+	u32 b_hi = b >> 32;
+
+	/* Karatsuba multiplication */
+	u64 lo = clmul32(a_lo, b_lo);
+	u64 hi = clmul32(a_hi, b_hi);
+	u64 mi = clmul32(a_lo ^ a_hi, b_lo ^ b_hi) ^ lo ^ hi;
+
+	*out_lo = lo ^ (mi << 32);
+	*out_hi = hi ^ (mi >> 32);
+}
+#endif /* !CONFIG_ARCH_SUPPORTS_INT128 */
+
+/* Compute @a = @a * @b * x^-128 in the POLYVAL field. */
+static void __maybe_unused
+polyval_mul_generic(struct polyval_elem *a, const struct polyval_elem *b)
+{
+	u64 c0, c1, c2, c3, mi0, mi1;
+
+	/*
+	 * Carryless-multiply @a by @b using Karatsuba multiplication.  Store
+	 * the 256-bit product in @c0 (low) through @c3 (high).
+	 */
+	clmul64(le64_to_cpu(a->lo), le64_to_cpu(b->lo), &c0, &c1);
+	clmul64(le64_to_cpu(a->hi), le64_to_cpu(b->hi), &c2, &c3);
+	clmul64(le64_to_cpu(a->lo ^ a->hi), le64_to_cpu(b->lo ^ b->hi),
+		&mi0, &mi1);
+	mi0 ^= c0 ^ c2;
+	mi1 ^= c1 ^ c3;
+	c1 ^= mi0;
+	c2 ^= mi1;
+
+	/*
+	 * Cancel out the low 128 bits of the product by adding multiples of
+	 * G(x) = x^128 + x^127 + x^126 + x^121 + 1.  Do this in two steps, each
+	 * of which cancels out 64 bits.  Note that we break G(x) into three
+	 * parts: 1, x^64 * (x^63 + x^62 + x^57), and x^128 * 1.
+	 */
+
+	/*
+	 * First, add G(x) times c0 as follows:
+	 *
+	 * (c0, c1, c2) = (0,
+	 *                 c1 + (c0 * (x^63 + x^62 + x^57) mod x^64),
+	 *		   c2 + c0 + floor((c0 * (x^63 + x^62 + x^57)) / x^64))
+	 */
+	c1 ^= (c0 << 63) ^ (c0 << 62) ^ (c0 << 57);
+	c2 ^= c0 ^ (c0 >> 1) ^ (c0 >> 2) ^ (c0 >> 7);
+
+	/*
+	 * Second, add G(x) times the new c1:
+	 *
+	 * (c1, c2, c3) = (0,
+	 *                 c2 + (c1 * (x^63 + x^62 + x^57) mod x^64),
+	 *		   c3 + c1 + floor((c1 * (x^63 + x^62 + x^57)) / x^64))
+	 */
+	c2 ^= (c1 << 63) ^ (c1 << 62) ^ (c1 << 57);
+	c3 ^= c1 ^ (c1 >> 1) ^ (c1 >> 2) ^ (c1 >> 7);
+
+	/* Return (c2, c3).  This implicitly multiplies by x^-128. */
+	a->lo = cpu_to_le64(c2);
+	a->hi = cpu_to_le64(c3);
+}
+
+static void __maybe_unused
+polyval_blocks_generic(struct polyval_elem *acc, const struct polyval_elem *key,
+		       const u8 *data, size_t nblocks)
+{
+	do {
+		acc->lo ^= get_unaligned((__le64 *)data);
+		acc->hi ^= get_unaligned((__le64 *)(data + 8));
+		polyval_mul_generic(acc, key);
+		data += POLYVAL_BLOCK_SIZE;
+	} while (--nblocks);
+}
+
+/* Include the arch-optimized implementation of POLYVAL, if one is available. */
+#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#include "polyval.h" /* $(SRCARCH)/polyval.h */
+void polyval_preparekey(struct polyval_key *key,
+			const u8 raw_key[POLYVAL_BLOCK_SIZE])
+{
+	polyval_preparekey_arch(key, raw_key);
+}
+EXPORT_SYMBOL_GPL(polyval_preparekey);
+#endif /* Else, polyval_preparekey() is an inline function. */
+
+/*
+ * polyval_mul_generic() and polyval_blocks_generic() take the key as a
+ * polyval_elem rather than a polyval_key, so that arch-optimized
+ * implementations with a different key format can use it as a fallback (if they
+ * have H^1 stored somewhere in their struct).  Thus, the following dispatch
+ * code is needed to pass the appropriate key argument.
+ */
+
+static void polyval_mul(struct polyval_ctx *ctx)
+{
+#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+	polyval_mul_arch(&ctx->acc, ctx->key);
+#else
+	polyval_mul_generic(&ctx->acc, &ctx->key->h);
+#endif
+}
+
+static void polyval_blocks(struct polyval_ctx *ctx,
+			   const u8 *data, size_t nblocks)
+{
+#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+	polyval_blocks_arch(&ctx->acc, ctx->key, data, nblocks);
+#else
+	polyval_blocks_generic(&ctx->acc, &ctx->key->h, data, nblocks);
+#endif
+}
+
+void polyval_update(struct polyval_ctx *ctx, const u8 *data, size_t len)
+{
+	if (unlikely(ctx->partial)) {
+		size_t n = min(len, POLYVAL_BLOCK_SIZE - ctx->partial);
+
+		len -= n;
+		while (n--)
+			ctx->acc.bytes[ctx->partial++] ^= *data++;
+		if (ctx->partial < POLYVAL_BLOCK_SIZE)
+			return;
+		polyval_mul(ctx);
+	}
+	if (len >= POLYVAL_BLOCK_SIZE) {
+		size_t nblocks = len / POLYVAL_BLOCK_SIZE;
+
+		polyval_blocks(ctx, data, nblocks);
+		data += len & ~(POLYVAL_BLOCK_SIZE - 1);
+		len &= POLYVAL_BLOCK_SIZE - 1;
+	}
+	for (size_t i = 0; i < len; i++)
+		ctx->acc.bytes[i] ^= data[i];
+	ctx->partial = len;
+}
+EXPORT_SYMBOL_GPL(polyval_update);
+
+void polyval_final(struct polyval_ctx *ctx, u8 out[POLYVAL_BLOCK_SIZE])
+{
+	if (unlikely(ctx->partial))
+		polyval_mul(ctx);
+	memcpy(out, &ctx->acc, POLYVAL_BLOCK_SIZE);
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+EXPORT_SYMBOL_GPL(polyval_final);
+
+#ifdef polyval_mod_init_arch
+static int __init polyval_mod_init(void)
+{
+	polyval_mod_init_arch();
+	return 0;
+}
+subsys_initcall(polyval_mod_init);
+
+static void __exit polyval_mod_exit(void)
+{
+}
+module_exit(polyval_mod_exit);
+#endif
+
+MODULE_DESCRIPTION("POLYVAL almost-XOR-universal hash function");
+MODULE_LICENSE("GPL");
-- 
2.51.2

