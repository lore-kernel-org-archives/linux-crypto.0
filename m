Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF168301003;
	Tue,  9 Dec 2025 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245489; cv=none; b=IMFBnRaZ0l+sXpzu+SxwYssqlw5LT3eRvtAAi/t6LFEeIJxZ4vqK24smqsAH0n7/dI6J33MyzP/E1LtmRbt4QoVsY0g60uXT5/qP6+WV9vEgcHN+D/h7JPka0sDDuAG6hgG1K/Rh40Hq56OaEGqloEHM2LoiTwbiG2lMOKqnYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245489; c=relaxed/simple;
	bh=C/HEt+bs6NFsRXn8zFIuPUoZGkPi4flZwVpJkwj88NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXPNDMGKrDsU86adbHsK6+HMFEd/LgVT4VZPqdSO4sAyIxRrcYJG23CWVBGg/533c8IUXleQNAL6sJu1HP7GUL22uHusK2lqDb5rFDSCPQKRFejhbpe89VAqqmFxqJKT6tgVf+8Xv7aQO+6bJL8/9/SNbN/UWxEe48qGqvi3Nnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niHWVHM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niHWVHM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ED5C19424;
	Tue,  9 Dec 2025 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765245489;
	bh=C/HEt+bs6NFsRXn8zFIuPUoZGkPi4flZwVpJkwj88NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niHWVHM4FtmZBo3QjLlASK6+Yj252cRVaP1adtLY2gunvS2o8Jt7YGGDpeHfBD3T7
	 J96nRwMhOIaZHnuIGpYNKzI7kU6JsvnufxfFv+KBH8gDpSpBmInulyWUEh1z0tJB65
	 JsJwYQG9OHZXUm4+qTiETFkmzk2xZoweTBUDIqmOUckzyTYXNU1hgGfVxa1XzyTgf0
	 Cyfeh19+rHPpAKxiLRMMvrFeVL8Wq7fNW5uRqvQxHxK9URImCIcCCj4aldpzE/sucH
	 Hc9Ygqo9hoHNa8v61W/V5pnULc4RjMERATfvXM7dNUNLIc62HzNRpJipJlHkN13unN
	 rilKwam4FjaTA==
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/3] perf util: Add BLAKE2s support
Date: Mon,  8 Dec 2025 17:57:27 -0800
Message-ID: <20251209015729.23253-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209015729.23253-1-ebiggers@kernel.org>
References: <20251209015729.23253-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add BLAKE2s support to the perf utility library.  The code is borrowed
from the kernel.  This will replace the use of SHA-1 in genelf.c.

Tested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/perf/tests/util.c   |  78 +++++++++++++++++++-
 tools/perf/util/Build     |   1 +
 tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/blake2s.h |  73 ++++++++++++++++++
 4 files changed, 302 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/blake2s.c
 create mode 100644 tools/perf/util/blake2s.h

diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
index b273d287e164..efc3e4e4c6fa 100644
--- a/tools/perf/tests/util.c
+++ b/tools/perf/tests/util.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "tests.h"
+#include "util/blake2s.h"
 #include "util/debug.h"
 #include "util/sha1.h"
 
 #include <linux/compiler.h>
 #include <stdlib.h>
@@ -57,18 +58,93 @@ static int test_sha1(void)
 			memcmp(digest_of_digests, expected_digest_of_digests,
 			       SHA1_DIGEST_SIZE) == 0);
 	return 0;
 }
 
+/* Maximum data length tested by test_blake2s() */
+#define MAX_DATA_LEN 512
+
+/*
+ * Hash length tested by test_blake2s().  BLAKE2s supports variable-length
+ * hashes.  However, the only user of BLAKE2s in 'perf' uses 20-byte hashes,
+ * matching the length of the ELF build ID field.  So that's the length we test.
+ */
+#define HASH_LEN 20
+
+/* Test the implementation of the BLAKE2s hash algorithm. */
+static int test_blake2s(void)
+{
+	u8 data[MAX_DATA_LEN];
+	u8 hash[HASH_LEN];
+	u8 hash2[HASH_LEN];
+	struct blake2s_ctx main_ctx;
+	/*
+	 * This value was generated by the following Python code:
+	 *
+	 * import hashlib
+	 *
+	 * data = bytes(i % 256 for i in range(513))
+	 * h = hashlib.blake2s(digest_size=20)
+	 * for i in range(513):
+	 *     h.update(hashlib.blake2s(data=data[:i], digest_size=20).digest())
+	 * print(h.hexdigest())
+	 */
+	static const u8 expected_hash_of_hashes[20] = {
+		0xef, 0x9b, 0x13, 0x98, 0x78, 0x8e, 0x74, 0x59, 0x9c, 0xd5,
+		0x0c, 0xf0, 0x33, 0x97, 0x79, 0x3d, 0x3e, 0xd0, 0x95, 0xa6
+	};
+	size_t i;
+
+	/* Generate MAX_DATA_LEN bytes of data. */
+	for (i = 0; i < MAX_DATA_LEN; i++)
+		data[i] = i;
+
+	blake2s_init(&main_ctx, sizeof(hash));
+	for (i = 0; i <= MAX_DATA_LEN; i++) {
+		struct blake2s_ctx ctx;
+
+		/* Compute the BLAKE2s hash of 'i' data bytes. */
+		blake2s_init(&ctx, HASH_LEN);
+		blake2s_update(&ctx, data, i);
+		blake2s_final(&ctx, hash);
+
+		/* Verify that multiple updates produce the same result. */
+		blake2s_init(&ctx, HASH_LEN);
+		blake2s_update(&ctx, data, i / 2);
+		blake2s_update(&ctx, &data[i / 2], i - (i / 2));
+		blake2s_final(&ctx, hash2);
+		TEST_ASSERT_VAL("inconsistent BLAKE2s hashes",
+				memcmp(hash, hash2, HASH_LEN) == 0);
+
+		/*
+		 * Pass the hash to another BLAKE2s context, so that we
+		 * incrementally compute the hash of all the hashes.
+		 */
+		blake2s_update(&main_ctx, hash, HASH_LEN);
+	}
+
+	/* Verify the hash of all the hashes. */
+	blake2s_final(&main_ctx, hash);
+	TEST_ASSERT_VAL("wrong BLAKE2s hashes",
+			memcmp(hash, expected_hash_of_hashes, HASH_LEN) == 0);
+	return 0;
+}
+
 static int test__util(struct test_suite *t __maybe_unused, int subtest __maybe_unused)
 {
+	int ret;
+
 	TEST_ASSERT_VAL("empty string", test_strreplace(' ', "", "123", ""));
 	TEST_ASSERT_VAL("no match", test_strreplace('5', "123", "4", "123"));
 	TEST_ASSERT_VAL("replace 1", test_strreplace('3', "123", "4", "124"));
 	TEST_ASSERT_VAL("replace 2", test_strreplace('a', "abcabc", "ef", "efbcefbc"));
 	TEST_ASSERT_VAL("replace long", test_strreplace('a', "abcabc", "longlong",
 							"longlongbclonglongbc"));
 
-	return test_sha1();
+	ret = test_sha1();
+	if (ret != TEST_OK)
+		return ret;
+
+	return test_blake2s();
 }
 
 DEFINE_SUITE("util", util);
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 1c2a43e1dc68..b500053332d2 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -3,10 +3,11 @@ include $(srctree)/tools/scripts/utilities.mak
 
 perf-util-y += arm64-frame-pointer-unwind-support.o
 perf-util-y += addr2line.o
 perf-util-y += addr_location.o
 perf-util-y += annotate.o
+perf-util-y += blake2s.o
 perf-util-y += block-info.o
 perf-util-y += block-range.o
 perf-util-y += build-id.o
 perf-util-y += cacheline.o
 perf-util-y += capstone.o
diff --git a/tools/perf/util/blake2s.c b/tools/perf/util/blake2s.c
new file mode 100644
index 000000000000..ce5d89a19376
--- /dev/null
+++ b/tools/perf/util/blake2s.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * This is an implementation of the BLAKE2s hash and PRF functions.
+ *
+ * Information: https://blake2.net/
+ */
+
+#include "blake2s.h"
+#include <linux/kernel.h>
+
+static inline u32 ror32(u32 v, int n)
+{
+	return (v >> n) | (v << (32 - n));
+}
+
+static inline void le32_to_cpu_array(u32 a[], size_t n)
+{
+	for (size_t i = 0; i < n; i++)
+		a[i] = le32_to_cpu((__force __le32)a[i]);
+}
+
+static inline void cpu_to_le32_array(u32 a[], size_t n)
+{
+	for (size_t i = 0; i < n; i++)
+		a[i] = (__force u32)cpu_to_le32(a[i]);
+}
+
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
+static inline void blake2s_increment_counter(struct blake2s_ctx *ctx, u32 inc)
+{
+	ctx->t[0] += inc;
+	ctx->t[1] += (ctx->t[0] < inc);
+}
+
+static void blake2s_compress(struct blake2s_ctx *ctx,
+			     const u8 *data, size_t nblocks, u32 inc)
+{
+	u32 m[16];
+	u32 v[16];
+	int i;
+
+	while (nblocks > 0) {
+		blake2s_increment_counter(ctx, inc);
+		memcpy(m, data, BLAKE2S_BLOCK_SIZE);
+		le32_to_cpu_array(m, ARRAY_SIZE(m));
+		memcpy(v, ctx->h, 32);
+		v[ 8] = BLAKE2S_IV0;
+		v[ 9] = BLAKE2S_IV1;
+		v[10] = BLAKE2S_IV2;
+		v[11] = BLAKE2S_IV3;
+		v[12] = BLAKE2S_IV4 ^ ctx->t[0];
+		v[13] = BLAKE2S_IV5 ^ ctx->t[1];
+		v[14] = BLAKE2S_IV6 ^ ctx->f[0];
+		v[15] = BLAKE2S_IV7 ^ ctx->f[1];
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
+			ctx->h[i] ^= v[i] ^ v[i + 8];
+
+		data += BLAKE2S_BLOCK_SIZE;
+		--nblocks;
+	}
+}
+
+static inline void blake2s_set_lastblock(struct blake2s_ctx *ctx)
+{
+	ctx->f[0] = -1;
+}
+
+void blake2s_update(struct blake2s_ctx *ctx, const u8 *in, size_t inlen)
+{
+	const size_t fill = BLAKE2S_BLOCK_SIZE - ctx->buflen;
+
+	if (unlikely(!inlen))
+		return;
+	if (inlen > fill) {
+		memcpy(ctx->buf + ctx->buflen, in, fill);
+		blake2s_compress(ctx, ctx->buf, 1, BLAKE2S_BLOCK_SIZE);
+		ctx->buflen = 0;
+		in += fill;
+		inlen -= fill;
+	}
+	if (inlen > BLAKE2S_BLOCK_SIZE) {
+		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
+
+		blake2s_compress(ctx, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
+		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+	}
+	memcpy(ctx->buf + ctx->buflen, in, inlen);
+	ctx->buflen += inlen;
+}
+
+void blake2s_final(struct blake2s_ctx *ctx, u8 *out)
+{
+	blake2s_set_lastblock(ctx);
+	memset(ctx->buf + ctx->buflen, 0,
+	       BLAKE2S_BLOCK_SIZE - ctx->buflen); /* Padding */
+	blake2s_compress(ctx, ctx->buf, 1, ctx->buflen);
+	cpu_to_le32_array(ctx->h, ARRAY_SIZE(ctx->h));
+	memcpy(out, ctx->h, ctx->outlen);
+	memset(ctx, 0, sizeof(*ctx));
+}
diff --git a/tools/perf/util/blake2s.h b/tools/perf/util/blake2s.h
new file mode 100644
index 000000000000..a1fe81a4bea8
--- /dev/null
+++ b/tools/perf/util/blake2s.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#ifndef _CRYPTO_BLAKE2S_H
+#define _CRYPTO_BLAKE2S_H
+
+#include <string.h>
+#include <linux/types.h>
+
+#define BLAKE2S_BLOCK_SIZE 64
+
+struct blake2s_ctx {
+	u32 h[8];
+	u32 t[2];
+	u32 f[2];
+	u8 buf[BLAKE2S_BLOCK_SIZE];
+	unsigned int buflen;
+	unsigned int outlen;
+};
+
+enum blake2s_iv {
+	BLAKE2S_IV0 = 0x6A09E667UL,
+	BLAKE2S_IV1 = 0xBB67AE85UL,
+	BLAKE2S_IV2 = 0x3C6EF372UL,
+	BLAKE2S_IV3 = 0xA54FF53AUL,
+	BLAKE2S_IV4 = 0x510E527FUL,
+	BLAKE2S_IV5 = 0x9B05688CUL,
+	BLAKE2S_IV6 = 0x1F83D9ABUL,
+	BLAKE2S_IV7 = 0x5BE0CD19UL,
+};
+
+static inline void __blake2s_init(struct blake2s_ctx *ctx, size_t outlen,
+				  const void *key, size_t keylen)
+{
+	ctx->h[0] = BLAKE2S_IV0 ^ (0x01010000 | keylen << 8 | outlen);
+	ctx->h[1] = BLAKE2S_IV1;
+	ctx->h[2] = BLAKE2S_IV2;
+	ctx->h[3] = BLAKE2S_IV3;
+	ctx->h[4] = BLAKE2S_IV4;
+	ctx->h[5] = BLAKE2S_IV5;
+	ctx->h[6] = BLAKE2S_IV6;
+	ctx->h[7] = BLAKE2S_IV7;
+	ctx->t[0] = 0;
+	ctx->t[1] = 0;
+	ctx->f[0] = 0;
+	ctx->f[1] = 0;
+	ctx->buflen = 0;
+	ctx->outlen = outlen;
+	if (keylen) {
+		memcpy(ctx->buf, key, keylen);
+		memset(&ctx->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen);
+		ctx->buflen = BLAKE2S_BLOCK_SIZE;
+	}
+}
+
+static inline void blake2s_init(struct blake2s_ctx *ctx, size_t outlen)
+{
+	__blake2s_init(ctx, outlen, NULL, 0);
+}
+
+static inline void blake2s_init_key(struct blake2s_ctx *ctx, size_t outlen,
+				    const void *key, size_t keylen)
+{
+	__blake2s_init(ctx, outlen, key, keylen);
+}
+
+void blake2s_update(struct blake2s_ctx *ctx, const u8 *in, size_t inlen);
+
+void blake2s_final(struct blake2s_ctx *ctx, u8 *out);
+
+#endif /* _CRYPTO_BLAKE2S_H */
-- 
2.52.0

