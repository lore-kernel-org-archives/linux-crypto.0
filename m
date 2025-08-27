Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A5C27B354;
	Wed, 27 Aug 2025 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307701; cv=none; b=W4CbTSMrXP3M7iZuYw25+vTAjagFlLzPB4f5AMzAjmYeEcQXJRAPdtgkSWzUkMez7bE3zyb0bXCkfMWNE8IIMXkhg1TAaJO9SRer8ApSxcqFxus8gPcKfQNRAfO3hmnLUdHImlq75nXf9nqSMtchomBU5U4KEKzNmXo3JcawrJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307701; c=relaxed/simple;
	bh=x/NuAW84/cQ0t0p3ZfjB/C473ct6iM59qATu6l/hJrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl+cWq21+R5yBbOloJ5f92SQTbJVxnqpUzQ57S3/BlwE9VKMLVyzuSS1nIbiBtQRxgZ49qRqrxBfZgt7/iye40OJHb56XXTxnGEzLC5WS0LqfOVZTVjxQNACwLVLKOIK3Nj87Q56OWasviovrS0gZ/q4DR+/ZycKx0HHWlDpjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dg+da+KH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dg+da+KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D6C4CEF0;
	Wed, 27 Aug 2025 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307701;
	bh=x/NuAW84/cQ0t0p3ZfjB/C473ct6iM59qATu6l/hJrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg+da+KHJqXKeYUE+nRoDEcrPOzL+VJhQ0dFzQJ2Ry8ITujl+oK7WFeRLyqc57b/G
	 YIbwQjCptgz57cVQrciuVhv19wrndQBmUAS/pNgT5Vz4skqNMo3STV7T3QJxR/GjaK
	 X54SecwHkyqiP3507WtRIPDs8OXukZhl/ztOHDIVSZpMsLyXCrcCWW7kKBrJ5kAOX3
	 0U/htlHBHgNnoe2MLCZ4DLptCsRbl1Ttzs3sNT4F90QWwjuIdtBentGz31PIuMZ4wt
	 qgspCCosrv6DKtr27Vigg7ppRZCODR53Gb1WuKnIWAGUjr9ul0ECPgTUtRAxnxv4OL
	 hT+GLbBczKjfw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/12] lib/crypto: blake2s: Move generic code into blake2s.c
Date: Wed, 27 Aug 2025 08:11:29 -0700
Message-ID: <20250827151131.27733-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move blake2s_compress_generic() from blake2s-generic.c to blake2s.c.

For now it's still guarded by CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC, but
this prepares for changing it to a 'static __maybe_unused' function and
just using the compiler to automatically decide its inclusion.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile          |   1 -
 lib/crypto/blake2s-generic.c | 111 -----------------------------------
 lib/crypto/blake2s.c         |  94 +++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 112 deletions(-)
 delete mode 100644 lib/crypto/blake2s-generic.c

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index eeddb993da033..be45dcfb8969b 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -30,11 +30,10 @@ libarc4-y					:= arc4.o
 obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 # blake2s is used by the /dev/random driver which is always builtin
 obj-y						+= libblake2s.o
 libblake2s-y					:= blake2s.o
-libblake2s-$(CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC)	+= blake2s-generic.o
 
 ################################################################################
 
 # chacha20_block() is used by the /dev/random driver which is always builtin
 obj-y += chacha-block-generic.o
diff --git a/lib/crypto/blake2s-generic.c b/lib/crypto/blake2s-generic.c
deleted file mode 100644
index 9828176a2efec..0000000000000
--- a/lib/crypto/blake2s-generic.c
+++ /dev/null
@@ -1,111 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR MIT
-/*
- * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
- *
- * This is an implementation of the BLAKE2s hash and PRF functions.
- *
- * Information: https://blake2.net/
- *
- */
-
-#include <crypto/internal/blake2s.h>
-#include <linux/bug.h>
-#include <linux/export.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/unaligned.h>
-
-static const u8 blake2s_sigma[10][16] = {
-	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
-	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
-	{ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
-	{ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
-	{ 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
-	{ 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
-	{ 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
-	{ 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
-	{ 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
-	{ 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
-};
-
-static inline void blake2s_increment_counter(struct blake2s_state *state,
-					     const u32 inc)
-{
-	state->t[0] += inc;
-	state->t[1] += (state->t[0] < inc);
-}
-
-void blake2s_compress(struct blake2s_state *state, const u8 *block,
-		      size_t nblocks, const u32 inc)
-		      __weak __alias(blake2s_compress_generic);
-
-void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
-			      size_t nblocks, const u32 inc)
-{
-	u32 m[16];
-	u32 v[16];
-	int i;
-
-	WARN_ON(IS_ENABLED(DEBUG) &&
-		(nblocks > 1 && inc != BLAKE2S_BLOCK_SIZE));
-
-	while (nblocks > 0) {
-		blake2s_increment_counter(state, inc);
-		memcpy(m, block, BLAKE2S_BLOCK_SIZE);
-		le32_to_cpu_array(m, ARRAY_SIZE(m));
-		memcpy(v, state->h, 32);
-		v[ 8] = BLAKE2S_IV0;
-		v[ 9] = BLAKE2S_IV1;
-		v[10] = BLAKE2S_IV2;
-		v[11] = BLAKE2S_IV3;
-		v[12] = BLAKE2S_IV4 ^ state->t[0];
-		v[13] = BLAKE2S_IV5 ^ state->t[1];
-		v[14] = BLAKE2S_IV6 ^ state->f[0];
-		v[15] = BLAKE2S_IV7 ^ state->f[1];
-
-#define G(r, i, a, b, c, d) do { \
-	a += b + m[blake2s_sigma[r][2 * i + 0]]; \
-	d = ror32(d ^ a, 16); \
-	c += d; \
-	b = ror32(b ^ c, 12); \
-	a += b + m[blake2s_sigma[r][2 * i + 1]]; \
-	d = ror32(d ^ a, 8); \
-	c += d; \
-	b = ror32(b ^ c, 7); \
-} while (0)
-
-#define ROUND(r) do { \
-	G(r, 0, v[0], v[ 4], v[ 8], v[12]); \
-	G(r, 1, v[1], v[ 5], v[ 9], v[13]); \
-	G(r, 2, v[2], v[ 6], v[10], v[14]); \
-	G(r, 3, v[3], v[ 7], v[11], v[15]); \
-	G(r, 4, v[0], v[ 5], v[10], v[15]); \
-	G(r, 5, v[1], v[ 6], v[11], v[12]); \
-	G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
-	G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
-} while (0)
-		ROUND(0);
-		ROUND(1);
-		ROUND(2);
-		ROUND(3);
-		ROUND(4);
-		ROUND(5);
-		ROUND(6);
-		ROUND(7);
-		ROUND(8);
-		ROUND(9);
-
-#undef G
-#undef ROUND
-
-		for (i = 0; i < 8; ++i)
-			state->h[i] ^= v[i] ^ v[i + 8];
-
-		block += BLAKE2S_BLOCK_SIZE;
-		--nblocks;
-	}
-}
-
-EXPORT_SYMBOL(blake2s_compress_generic);
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 51f2dd7a38a4e..b5b75ade46588 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -14,10 +14,104 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
+#ifdef CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC
+static const u8 blake2s_sigma[10][16] = {
+	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
+	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
+	{ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
+	{ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
+	{ 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
+	{ 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
+	{ 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
+	{ 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
+	{ 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
+	{ 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
+};
+
+static inline void blake2s_increment_counter(struct blake2s_state *state,
+					     const u32 inc)
+{
+	state->t[0] += inc;
+	state->t[1] += (state->t[0] < inc);
+}
+
+void blake2s_compress(struct blake2s_state *state, const u8 *block,
+		      size_t nblocks, const u32 inc)
+		      __weak __alias(blake2s_compress_generic);
+
+void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
+			      size_t nblocks, const u32 inc)
+{
+	u32 m[16];
+	u32 v[16];
+	int i;
+
+	WARN_ON(IS_ENABLED(DEBUG) &&
+		(nblocks > 1 && inc != BLAKE2S_BLOCK_SIZE));
+
+	while (nblocks > 0) {
+		blake2s_increment_counter(state, inc);
+		memcpy(m, block, BLAKE2S_BLOCK_SIZE);
+		le32_to_cpu_array(m, ARRAY_SIZE(m));
+		memcpy(v, state->h, 32);
+		v[ 8] = BLAKE2S_IV0;
+		v[ 9] = BLAKE2S_IV1;
+		v[10] = BLAKE2S_IV2;
+		v[11] = BLAKE2S_IV3;
+		v[12] = BLAKE2S_IV4 ^ state->t[0];
+		v[13] = BLAKE2S_IV5 ^ state->t[1];
+		v[14] = BLAKE2S_IV6 ^ state->f[0];
+		v[15] = BLAKE2S_IV7 ^ state->f[1];
+
+#define G(r, i, a, b, c, d) do { \
+	a += b + m[blake2s_sigma[r][2 * i + 0]]; \
+	d = ror32(d ^ a, 16); \
+	c += d; \
+	b = ror32(b ^ c, 12); \
+	a += b + m[blake2s_sigma[r][2 * i + 1]]; \
+	d = ror32(d ^ a, 8); \
+	c += d; \
+	b = ror32(b ^ c, 7); \
+} while (0)
+
+#define ROUND(r) do { \
+	G(r, 0, v[0], v[ 4], v[ 8], v[12]); \
+	G(r, 1, v[1], v[ 5], v[ 9], v[13]); \
+	G(r, 2, v[2], v[ 6], v[10], v[14]); \
+	G(r, 3, v[3], v[ 7], v[11], v[15]); \
+	G(r, 4, v[0], v[ 5], v[10], v[15]); \
+	G(r, 5, v[1], v[ 6], v[11], v[12]); \
+	G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
+	G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
+} while (0)
+		ROUND(0);
+		ROUND(1);
+		ROUND(2);
+		ROUND(3);
+		ROUND(4);
+		ROUND(5);
+		ROUND(6);
+		ROUND(7);
+		ROUND(8);
+		ROUND(9);
+
+#undef G
+#undef ROUND
+
+		for (i = 0; i < 8; ++i)
+			state->h[i] ^= v[i] ^ v[i + 8];
+
+		block += BLAKE2S_BLOCK_SIZE;
+		--nblocks;
+	}
+}
+EXPORT_SYMBOL(blake2s_compress_generic);
+#endif /* CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC */
+
 static inline void blake2s_set_lastblock(struct blake2s_state *state)
 {
 	state->f[0] = -1;
 }
 
-- 
2.50.1

