Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADE34403F;
	Sat, 21 Mar 2026 04:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066319; cv=none; b=kyFC19wUr6LWR+Kx8HlVKotGCFhTt9mMDlxgpxjFOzJBC115xq2JFM1bqjy7qYak8dZZeCi+vJazym9n02JTcdnn3KJCLzzBZiaRgrN+uffJEPZzCBDeNWXeIqSnfbJP5MQArN33jiAyaeT9mXW/FgVXvzkcMfdKyGfk3K5nl+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066319; c=relaxed/simple;
	bh=qg6pvp962mI/p8DMmrjDZbJcf5PUe7B6eGD6uPKrr6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlnOBFyTXmkoteL0xtgqAso+SZSq/5Id0+ZOpS7XyROY2BnAL01txY7aS6G84GnfUqqNClDGYORpnOrl9epYbY+YwuHwA+QpceZHmMLmGFkDJyYH//m+4yhJKPKzaWbs2GYYBqQnub4jkMnWUFdEoO+DTLr2JooP/j6cZWDwDHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kD2xmGOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kD2xmGOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9A1C2BCB6;
	Sat, 21 Mar 2026 04:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066319;
	bh=qg6pvp962mI/p8DMmrjDZbJcf5PUe7B6eGD6uPKrr6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kD2xmGOdND8P/eZmcSux6qbVuOY2toKtAJBCczSYXo/DCiKAS83SQbfRHVEIz7Uhz
	 JZiAUUq54rnHOmUNCixU+SXNWanfuLKLchOA7hrieVr5pSX0vlm35Qjry7E62HBvWG
	 CGUBJF803htwlG8WOK7f1bsz8lGjuEjnMpVs7WNQ/UKBqcMStkw7xtwBtjAMhz4wqe
	 1T05KDodm+P+neDNoXLkPFYDQmzr0bbpvmzo9MTCEysy9Tt+h9AJMzgqJVWl2FfNLJ
	 yQ8cBoCU20ONAdZZCb5uRI/C4DR/yDhnbePemA5AlgJRqh5fICoMdKpJygVhCa31Wy
	 Vlw3a+fiWx5NQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/12] lib/crypto: sm3: Add SM3 library API
Date: Fri, 20 Mar 2026 21:09:27 -0700
Message-ID: <20260321040935.410034-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a straightforward library API for SM3, mirroring the ones for the
other hash algorithms.  It uses the existing generic implementation of
SM3's compression function in lib/crypto/sm3.c.  Hooks are added for
architecture-optimized implementations, which later commits will wire up
to the existing optimized SM3 code for arm64, riscv, and x86.

Note that the rationale for this is *not* that SM3 should be used, or
that any kernel subsystem currently seems like a candidate for switching
from the sm3 crypto_shash to SM3 library.  (SM3, in fact, shouldn't be
used.  Likewise you shouldn't use MD5, SHA-1, RC4, etc...)

Rather, it's just that this will simplify how the kernel's existing SM3
code is integrated and make it much easier to maintain and test.  SM3 is
one of the only hash algorithms with arch-optimized code that is still
integrated in the old way.  By converting it to the new lib/crypto/ code
organization, we'll only have to keep track of one way of doing things.
The library will also get a KUnit test suite (as usual for lib/crypto/),
so it will become more easily and comprehensively tested as well.

Skip adding functions for HMAC-SM3 for now, though.  There's not as much
point in adding those right now.

Note: similar to the other hash algorithms, the library API uses
'struct sm3_ctx', not 'struct sm3_state'.  The existing 'struct
sm3_state' and the sm3_block_generic() function which uses it are
temporarily kept around until their users are updated by later commits.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sm3.h |  70 ++++++++++++++++---
 lib/crypto/Kconfig   |   7 ++
 lib/crypto/sm3.c     | 155 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 203 insertions(+), 29 deletions(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 918d318795ef..702c5326b4be 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Common values for SM3 algorithm
+ * SM3 hash algorithm
  *
  * Copyright (C) 2017 ARM Limited or its affiliates.
  * Copyright (C) 2017 Gilad Ben-Yossef <gilad@benyossef.com>
  * Copyright (C) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
@@ -29,18 +29,68 @@ struct sm3_state {
 	u32 state[SM3_DIGEST_SIZE / 4];
 	u64 count;
 	u8 buffer[SM3_BLOCK_SIZE];
 };
 
-/*
- * Stand-alone implementation of the SM3 algorithm. It is designed to
- * have as little dependencies as possible so it can be used in the
- * kexec_file purgatory. In other cases you should generally use the
- * hash APIs from include/crypto/hash.h. Especially when hashing large
- * amounts of data as those APIs may be hw-accelerated.
+void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
+
+/* State for the SM3 compression function */
+struct sm3_block_state {
+	u32 h[SM3_DIGEST_SIZE / 4];
+};
+
+/**
+ * struct sm3_ctx - Context for hashing a message with SM3
+ * @state: the compression function state
+ * @bytecount: number of bytes processed so far
+ * @buf: partial block buffer; bytecount % SM3_BLOCK_SIZE bytes are valid
+ */
+struct sm3_ctx {
+	struct sm3_block_state state;
+	u64 bytecount;
+	u8 buf[SM3_BLOCK_SIZE] __aligned(__alignof__(__be64));
+};
+
+/**
+ * sm3_init() - Initialize an SM3 context for a new message
+ * @ctx: the context to initialize
  *
- * For details see lib/crypto/sm3.c
+ * If you don't need incremental computation, consider sm3() instead.
+ *
+ * Context: Any context.
  */
+void sm3_init(struct sm3_ctx *ctx);
 
-void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
+/**
+ * sm3_update() - Update an SM3 context with message data
+ * @ctx: the context to update; must have been initialized
+ * @data: the message data
+ * @len: the data length in bytes
+ *
+ * This can be called any number of times.
+ *
+ * Context: Any context.
+ */
+void sm3_update(struct sm3_ctx *ctx, const u8 *data, size_t len);
+
+/**
+ * sm3_final() - Finish computing an SM3 message digest
+ * @ctx: the context to finalize; must have been initialized
+ * @out: (output) the resulting SM3 message digest
+ *
+ * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
+ *
+ * Context: Any context.
+ */
+void sm3_final(struct sm3_ctx *ctx, u8 out[at_least SM3_DIGEST_SIZE]);
+
+/**
+ * sm3() - Compute SM3 message digest in one shot
+ * @data: the message data
+ * @len: the data length in bytes
+ * @out: (output) the resulting SM3 message digest
+ *
+ * Context: Any context.
+ */
+void sm3(const u8 *data, size_t len, u8 out[at_least SM3_DIGEST_SIZE]);
 
-#endif
+#endif /* _CRYPTO_SM3_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4910fe20e42a..c5819e2518f6 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -265,9 +265,16 @@ config CRYPTO_LIB_SHA3_ARCH
 	default y if ARM64
 	default y if S390
 
 config CRYPTO_LIB_SM3
 	tristate
+	help
+	  The SM3 library functions.  Select this if your module uses any of the
+	  functions from <crypto/sm3.h>.
+
+config CRYPTO_LIB_SM3_ARCH
+	bool
+	depends on CRYPTO_LIB_SM3 && !UML
 
 source "lib/crypto/tests/Kconfig"
 
 endmenu
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index c6b9ad8a3ac6..20500cf4b8c0 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -13,10 +13,17 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
+static const struct sm3_block_state sm3_iv = {
+	.h = {
+		SM3_IVA, SM3_IVB, SM3_IVC, SM3_IVD,
+		SM3_IVE, SM3_IVF, SM3_IVG, SM3_IVH,
+	},
+};
+
 static const u32 ____cacheline_aligned K[64] = {
 	0x79cc4519, 0xf3988a32, 0xe7311465, 0xce6228cb,
 	0x9cc45197, 0x3988a32f, 0x7311465e, 0xe6228cbc,
 	0xcc451979, 0x988a32f3, 0x311465e7, 0x6228cbce,
 	0xc451979c, 0x88a32f39, 0x11465e73, 0x228cbce6,
@@ -70,22 +77,23 @@ static const u32 ____cacheline_aligned K[64] = {
 			^ W[(i-9) & 0x0f]		\
 			^ rol32(W[(i-3) & 0x0f], 15))	\
 		^ rol32(W[(i-13) & 0x0f], 7)		\
 		^ W[(i-6) & 0x0f])
 
-static void sm3_transform(struct sm3_state *sctx, u8 const *data, u32 W[16])
+static void sm3_transform(struct sm3_block_state *state,
+			  const u8 data[SM3_BLOCK_SIZE], u32 W[16])
 {
 	u32 a, b, c, d, e, f, g, h, ss1, ss2;
 
-	a = sctx->state[0];
-	b = sctx->state[1];
-	c = sctx->state[2];
-	d = sctx->state[3];
-	e = sctx->state[4];
-	f = sctx->state[5];
-	g = sctx->state[6];
-	h = sctx->state[7];
+	a = state->h[0];
+	b = state->h[1];
+	c = state->h[2];
+	d = state->h[3];
+	e = state->h[4];
+	f = state->h[5];
+	g = state->h[6];
+	h = state->h[7];
 
 	R1(a, b, c, d, e, f, g, h, K[0], I(0), I(4));
 	R1(d, a, b, c, h, e, f, g, K[1], I(1), I(5));
 	R1(c, d, a, b, g, h, e, f, K[2], I(2), I(6));
 	R1(b, c, d, a, f, g, h, e, K[3], I(3), I(7));
@@ -151,18 +159,18 @@ static void sm3_transform(struct sm3_state *sctx, u8 const *data, u32 W[16])
 	R2(a, b, c, d, e, f, g, h, K[60], W1(60), W2(64));
 	R2(d, a, b, c, h, e, f, g, K[61], W1(61), W2(65));
 	R2(c, d, a, b, g, h, e, f, K[62], W1(62), W2(66));
 	R2(b, c, d, a, f, g, h, e, K[63], W1(63), W2(67));
 
-	sctx->state[0] ^= a;
-	sctx->state[1] ^= b;
-	sctx->state[2] ^= c;
-	sctx->state[3] ^= d;
-	sctx->state[4] ^= e;
-	sctx->state[5] ^= f;
-	sctx->state[6] ^= g;
-	sctx->state[7] ^= h;
+	state->h[0] ^= a;
+	state->h[1] ^= b;
+	state->h[2] ^= c;
+	state->h[3] ^= d;
+	state->h[4] ^= e;
+	state->h[5] ^= f;
+	state->h[6] ^= g;
+	state->h[7] ^= h;
 }
 #undef R
 #undef R1
 #undef R2
 #undef I
@@ -172,15 +180,124 @@ static void sm3_transform(struct sm3_state *sctx, u8 const *data, u32 W[16])
 void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks)
 {
 	u32 W[16];
 
 	do {
-		sm3_transform(sctx, data, W);
+		sm3_transform((struct sm3_block_state *)sctx->state, data, W);
 		data += SM3_BLOCK_SIZE;
 	} while (--blocks);
 
 	memzero_explicit(W, sizeof(W));
 }
 EXPORT_SYMBOL_GPL(sm3_block_generic);
 
-MODULE_DESCRIPTION("Generic SM3 library");
+static void __maybe_unused sm3_blocks_generic(struct sm3_block_state *state,
+					      const u8 *data, size_t nblocks)
+{
+	u32 W[16];
+
+	do {
+		sm3_transform(state, data, W);
+		data += SM3_BLOCK_SIZE;
+	} while (--nblocks);
+
+	memzero_explicit(W, sizeof(W));
+}
+
+#ifdef CONFIG_CRYPTO_LIB_SM3_ARCH
+#include "sm3.h" /* $(SRCARCH)/sm3.h */
+#else
+#define sm3_blocks sm3_blocks_generic
+#endif
+
+void sm3_init(struct sm3_ctx *ctx)
+{
+	ctx->state = sm3_iv;
+	ctx->bytecount = 0;
+}
+EXPORT_SYMBOL_GPL(sm3_init);
+
+void sm3_update(struct sm3_ctx *ctx, const u8 *data, size_t len)
+{
+	size_t partial = ctx->bytecount % SM3_BLOCK_SIZE;
+
+	ctx->bytecount += len;
+
+	if (partial + len >= SM3_BLOCK_SIZE) {
+		size_t nblocks;
+
+		if (partial) {
+			size_t l = SM3_BLOCK_SIZE - partial;
+
+			memcpy(&ctx->buf[partial], data, l);
+			data += l;
+			len -= l;
+
+			sm3_blocks(&ctx->state, ctx->buf, 1);
+		}
+
+		nblocks = len / SM3_BLOCK_SIZE;
+		len %= SM3_BLOCK_SIZE;
+
+		if (nblocks) {
+			sm3_blocks(&ctx->state, data, nblocks);
+			data += nblocks * SM3_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(&ctx->buf[partial], data, len);
+}
+EXPORT_SYMBOL_GPL(sm3_update);
+
+static void __sm3_final(struct sm3_ctx *ctx, u8 out[SM3_DIGEST_SIZE])
+{
+	u64 bitcount = ctx->bytecount << 3;
+	size_t partial = ctx->bytecount % SM3_BLOCK_SIZE;
+
+	ctx->buf[partial++] = 0x80;
+	if (partial > SM3_BLOCK_SIZE - 8) {
+		memset(&ctx->buf[partial], 0, SM3_BLOCK_SIZE - partial);
+		sm3_blocks(&ctx->state, ctx->buf, 1);
+		partial = 0;
+	}
+	memset(&ctx->buf[partial], 0, SM3_BLOCK_SIZE - 8 - partial);
+	*(__be64 *)&ctx->buf[SM3_BLOCK_SIZE - 8] = cpu_to_be64(bitcount);
+	sm3_blocks(&ctx->state, ctx->buf, 1);
+
+	for (size_t i = 0; i < SM3_DIGEST_SIZE; i += 4)
+		put_unaligned_be32(ctx->state.h[i / 4], out + i);
+}
+
+void sm3_final(struct sm3_ctx *ctx, u8 out[SM3_DIGEST_SIZE])
+{
+	__sm3_final(ctx, out);
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+EXPORT_SYMBOL_GPL(sm3_final);
+
+void sm3(const u8 *data, size_t len, u8 out[SM3_DIGEST_SIZE])
+{
+	struct sm3_ctx ctx;
+
+	sm3_init(&ctx);
+	sm3_update(&ctx, data, len);
+	sm3_final(&ctx, out);
+}
+EXPORT_SYMBOL_GPL(sm3);
+
+#ifdef sm3_mod_init_arch
+static int __init sm3_mod_init(void)
+{
+	sm3_mod_init_arch();
+	return 0;
+}
+subsys_initcall(sm3_mod_init);
+
+static void __exit sm3_mod_exit(void)
+{
+}
+module_exit(sm3_mod_exit);
+#endif
+
+MODULE_DESCRIPTION("SM3 library functions");
 MODULE_LICENSE("GPL v2");
-- 
2.53.0

