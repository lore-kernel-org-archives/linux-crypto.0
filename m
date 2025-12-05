Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29D1FC7FB;
	Fri,  5 Dec 2025 04:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909308; cv=none; b=rfGROfwDTP7lUgxh4TZAvmu390Sj1agHarOPEyc2GCmOtsNkk15RZ5jesadyRhKnrvKXE+ciDzKylbpbgjvH268Tz7wr+3toZuBAYhOpHI1VvJcNVdS+DW8l2TEYuFHuoF4d2lYVwZmweqiKfNScd1Zjbr+Pgk1DBe+X0oZJypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909308; c=relaxed/simple;
	bh=y4+EaSGSFP1m86mNrPnaE3R2FAlxGoyArpWrVimH0vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KEytUamch0CyglK87udgfkWUs+MniG/R8MVbZee3j4RHb6LHof5+8Wz7fLESXLYERUWF49/tmVpM10G49Y4GHpLvkn3NnXCCkgaqPlYsRbCN+fFPH2kJOV05vkektWLZa6qr3dKtP6j1JSbOZt0Id371/l0TipxJKrkqtTiCTl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3JO04Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3JO04Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8449BC4CEF1;
	Fri,  5 Dec 2025 04:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764909308;
	bh=y4+EaSGSFP1m86mNrPnaE3R2FAlxGoyArpWrVimH0vg=;
	h=From:To:Cc:Subject:Date:From;
	b=O3JO04Ao8W1MQpkBrp4a3B7KopDFig2+Jx8GjMrnY/YM4de7mW/PaBowSER5o6n3f
	 rSGxwIFEieJcqqWekR4i7Le73Rq7384tmE63dtvzQ0DZlnXDxQ2sOXui5GtwLjN2/l
	 Z1MgqQXFInyZ2kr63k9meaAMk6APGjxqdHfkGC3XbVwA8UMMAOeYaqKRPVKIkLKFKX
	 lAhI3aeNaQPr/n3jFWar5ZaCjZFkLQs3UTVRwSulK/HWa5cDa8Lv/R2f6cqg1zbGBY
	 3sPaq/iGux4LTT8T/31dyDde8f2AUBxVZvvIlia0PlHSMv3FKWHwfaRW1WpejuHIq/
	 VuQYjCh/dCJPw==
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
Subject: [PATCH] perf genelf: Switch from SHA-1 to BLAKE2s for build ID generation
Date: Thu,  4 Dec 2025 20:31:21 -0800
Message-ID: <20251205043121.62356-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent patches [1] [2] added an implementation of SHA-1 to perf and made
it be used for build ID generation.

I had understood the choice of SHA-1, which is a legacy algorithm, to be
for backwards compatibility.

It turns out, though, that there's no backwards compatibility
requirement here other than the size of the build ID field, which is
fixed at 20 bytes.  Not only did the hash algorithm already change (from
MD5 to SHA-1), but the inputs to the hash changed too: from
'load_addr || code' to just 'code', and now again to
'code || symtab || strsym' [3].  Different linkers generate different
build IDs, with the LLVM linker using BLAKE3 hashes for example [4].

Therefore, we might as well switch to a more modern algorithm.  Let's go
with BLAKE2s.  It's faster than SHA-1, isn't cryptographically broken,
is easier to implement than BLAKE3, and the kernel's implementation in
lib/crypto/blake2s.c is easily borrowed.  It also natively supports
variable-length hashes, so it can directly produce the needed 20 bytes.

Also make the following additional improvements:

- Provide and use an incremental API, so the three inputs being hashed
  don't all have to be concatenated into one buffer.

- Add tag/length prefixes to each of the three inputs, so that different
  tuples of inputs reliably result in different hashes.

[1] https://lore.kernel.org/linux-perf-users/20250521225307.743726-1-yuzhuo@google.com/
[2] https://lore.kernel.org/linux-perf-users/20250625202311.23244-1-ebiggers@kernel.org/
[3] https://lore.kernel.org/linux-perf-users/20251125080748.461014-1-namhyung@kernel.org/
[4] https://github.com/llvm/llvm-project/commit/d3e5b6f7539b86995aef6e2075c1edb3059385ce

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/perf/tests/util.c   |  78 ++++++++++++--------
 tools/perf/util/Build     |   2 +-
 tools/perf/util/blake2s.c | 151 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/blake2s.h |  73 ++++++++++++++++++
 tools/perf/util/genelf.c  |  58 +++++++--------
 tools/perf/util/sha1.c    |  97 ------------------------
 tools/perf/util/sha1.h    |   6 --
 7 files changed, 302 insertions(+), 163 deletions(-)
 create mode 100644 tools/perf/util/blake2s.c
 create mode 100644 tools/perf/util/blake2s.h
 delete mode 100644 tools/perf/util/sha1.c
 delete mode 100644 tools/perf/util/sha1.h

diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
index b273d287e164..695e061f0fa7 100644
--- a/tools/perf/tests/util.c
+++ b/tools/perf/tests/util.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "tests.h"
+#include "util/blake2s.h"
 #include "util/debug.h"
-#include "util/sha1.h"
 
 #include <linux/compiler.h>
 #include <stdlib.h>
 #include <string2.h>
 
@@ -15,49 +15,69 @@ static int test_strreplace(char needle, const char *haystack,
 
 	free(new);
 	return ret == 0;
 }
 
-#define MAX_LEN 512
+#define MAX_DATA_LEN 512 /* Maximum tested data length */
+#define HASH_LEN 20 /* Hash length to test */
 
-/* Test sha1() for all lengths from 0 to MAX_LEN inclusively. */
-static int test_sha1(void)
+/* Test the implementation of the BLAKE2s hash algorithm. */
+static int test_blake2s(void)
 {
-	u8 data[MAX_LEN];
-	size_t digests_size = (MAX_LEN + 1) * SHA1_DIGEST_SIZE;
-	u8 *digests;
-	u8 digest_of_digests[SHA1_DIGEST_SIZE];
+	u8 data[MAX_DATA_LEN];
+	u8 hash[HASH_LEN];
+	u8 hash2[HASH_LEN];
+	struct blake2s_ctx main_ctx;
 	/*
-	 * The correctness of this value was verified by running this test with
-	 * sha1() replaced by OpenSSL's SHA1().
+	 * This value was generated by the following Python code:
+	 *
+	 * import hashlib
+	 *
+	 * data = bytes(i % 256 for i in range(513))
+	 * h = hashlib.blake2s(digest_size=20)
+	 * for i in range(513):
+	 *     h.update(hashlib.blake2s(data=data[:i], digest_size=20).digest())
+	 * print(h.hexdigest())
 	 */
-	static const u8 expected_digest_of_digests[SHA1_DIGEST_SIZE] = {
-		0x74, 0xcd, 0x4c, 0xb9, 0xd8, 0xa6, 0xd5, 0x95, 0x22, 0x8b,
-		0x7e, 0xd6, 0x8b, 0x7e, 0x46, 0x95, 0x31, 0x9b, 0xa2, 0x43,
+	static const u8 expected_hash_of_hashes[20] = {
+		0xef, 0x9b, 0x13, 0x98, 0x78, 0x8e, 0x74, 0x59, 0x9c, 0xd5,
+		0x0c, 0xf0, 0x33, 0x97, 0x79, 0x3d, 0x3e, 0xd0, 0x95, 0xa6
 	};
 	size_t i;
 
-	digests = malloc(digests_size);
-	TEST_ASSERT_VAL("failed to allocate digests", digests != NULL);
-
-	/* Generate MAX_LEN bytes of data. */
-	for (i = 0; i < MAX_LEN; i++)
+	/* Generate MAX_DATA_LEN bytes of data. */
+	for (i = 0; i < MAX_DATA_LEN; i++)
 		data[i] = i;
 
-	/* Calculate a SHA-1 for each length 0 through MAX_LEN inclusively. */
-	for (i = 0; i <= MAX_LEN; i++)
-		sha1(data, i, &digests[i * SHA1_DIGEST_SIZE]);
+	blake2s_init(&main_ctx, sizeof(hash));
+	for (i = 0; i <= MAX_DATA_LEN; i++) {
+		struct blake2s_ctx ctx;
+
+		/* Compute the BLAKE2s hash of 'i' data bytes. */
+		blake2s_init(&ctx, HASH_LEN);
+		blake2s_update(&ctx, data, i);
+		blake2s_final(&ctx, hash);
 
-	/* Calculate digest of all digests calculated above. */
-	sha1(digests, digests_size, digest_of_digests);
+		/* Verify that multiple updates produce the same result. */
+		blake2s_init(&ctx, HASH_LEN);
+		blake2s_update(&ctx, data, i / 2);
+		blake2s_update(&ctx, &data[i / 2], i - (i / 2));
+		blake2s_final(&ctx, hash2);
+		TEST_ASSERT_VAL("inconsistent BLAKE2s hashes",
+				memcmp(hash, hash2, HASH_LEN) == 0);
 
-	free(digests);
+		/*
+		 * Pass the hash to another BLAKE2s context, so that we
+		 * incrementally compute the hash of all the hashes.
+		 */
+		blake2s_update(&main_ctx, hash, HASH_LEN);
+	}
 
-	/* Check for the expected result. */
-	TEST_ASSERT_VAL("wrong output from sha1()",
-			memcmp(digest_of_digests, expected_digest_of_digests,
-			       SHA1_DIGEST_SIZE) == 0);
+	/* Verify the hash of all the hashes. */
+	blake2s_final(&main_ctx, hash);
+	TEST_ASSERT_VAL("wrong BLAKE2s hashes",
+			memcmp(hash, expected_hash_of_hashes, HASH_LEN) == 0);
 	return 0;
 }
 
 static int test__util(struct test_suite *t __maybe_unused, int subtest __maybe_unused)
 {
@@ -66,9 +86,9 @@ static int test__util(struct test_suite *t __maybe_unused, int subtest __maybe_u
 	TEST_ASSERT_VAL("replace 1", test_strreplace('3', "123", "4", "124"));
 	TEST_ASSERT_VAL("replace 2", test_strreplace('a', "abcabc", "ef", "efbcefbc"));
 	TEST_ASSERT_VAL("replace long", test_strreplace('a', "abcabc", "longlong",
 							"longlongbclonglongbc"));
 
-	return test_sha1();
+	return test_blake2s();
 }
 
 DEFINE_SUITE("util", util);
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 1c2a43e1dc68..2a9f3d015c1d 100644
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
@@ -41,11 +42,10 @@ perf-util-y += rlimit.o
 perf-util-y += argv_split.o
 perf-util-y += rbtree.o
 perf-util-y += libstring.o
 perf-util-y += bitmap.o
 perf-util-y += hweight.o
-perf-util-y += sha1.o
 perf-util-y += smt.o
 perf-util-y += strbuf.o
 perf-util-y += string.o
 perf-util-y += strlist.o
 perf-util-y += strfilter.o
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
diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index a1cd5196f4ec..505fefdc60f3 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -16,12 +16,12 @@
 #include <err.h>
 #ifdef HAVE_LIBDW_SUPPORT
 #include <dwarf.h>
 #endif
 
+#include "blake2s.h"
 #include "genelf.h"
-#include "sha1.h"
 #include "../util/jitdump.h"
 #include <linux/compiler.h>
 
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
@@ -49,11 +49,11 @@ static char shd_string_table[] = {
 };
 
 static struct buildid_note {
 	Elf_Note desc;		/* descsz: size of build-id, must be multiple of 4 */
 	char	 name[4];	/* GNU\0 */
-	u8	 build_id[SHA1_DIGEST_SIZE];
+	u8	 build_id[20];
 } bnote;
 
 static Elf_Sym symtab[]={
 	/* symbol 0 MUST be the undefined symbol */
 	{ .st_name  = 0, /* index in sym_string table */
@@ -150,13 +150,32 @@ jit_add_eh_frame_info(Elf *e, void* unwinding, uint64_t unwinding_header_size,
 	shdr->sh_entsize = 0;
 
 	return 0;
 }
 
+enum {
+	TAG_CODE = 0,
+	TAG_SYMTAB = 1,
+	TAG_STRSYM = 2,
+};
+
+/*
+ * Update the hash using the given data, also prepending a (tag, len) prefix to
+ * ensure that different input tuples result in different outputs.
+ */
+static void blake2s_update_tagged(struct blake2s_ctx *ctx, int tag,
+				  const void *data, size_t len)
+{
+	u64 prefix = ((u64)tag << 56) | len;
+
+	blake2s_update(ctx, (const u8 *)&prefix, sizeof(prefix));
+	blake2s_update(ctx, data, len);
+}
+
 /*
  * fd: file descriptor open for writing for the output file
- * load_addr: code load address (could be zero, just used for buildid)
+ * load_addr: code load address (could be zero)
  * sym: function name (for native code - used as the symbol)
  * code: the native code
  * csize: the code size in bytes
  */
 int
@@ -171,12 +190,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	Elf_Ehdr *ehdr;
 	Elf_Phdr *phdr;
 	Elf_Shdr *shdr;
 	uint64_t eh_frame_base_offset;
 	char *strsym = NULL;
-	void *build_id_data = NULL, *tmp;
-	int build_id_data_len;
+	struct blake2s_ctx ctx;
 	int symlen;
 	int retval = -1;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		warnx("ELF initialization failed");
@@ -251,17 +269,12 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_type = SHT_PROGBITS;
 	shdr->sh_addr = GEN_ELF_TEXT_OFFSET;
 	shdr->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
 	shdr->sh_entsize = 0;
 
-	build_id_data = malloc(csize);
-	if (build_id_data == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(build_id_data, code, csize);
-	build_id_data_len = csize;
+	blake2s_init(&ctx, sizeof(bnote.build_id));
+	blake2s_update_tagged(&ctx, TAG_CODE, code, csize);
 
 	/*
 	 * Setup .eh_frame_hdr and .eh_frame
 	 */
 	if (unwinding) {
@@ -342,18 +355,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_type = SHT_SYMTAB;
 	shdr->sh_flags = 0;
 	shdr->sh_entsize = sizeof(Elf_Sym);
 	shdr->sh_link = unwinding ? 6 : 4; /* index of .strtab section */
 
-	tmp = realloc(build_id_data, build_id_data_len + sizeof(symtab));
-	if (tmp == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(tmp + build_id_data_len, symtab, sizeof(symtab));
-	build_id_data = tmp;
-	build_id_data_len += sizeof(symtab);
+	blake2s_update_tagged(&ctx, TAG_SYMTAB, symtab, sizeof(symtab));
 
 	/*
 	 * setup symbols string table
 	 * 2 = 1 for 0 in 1st entry, 1 for the 0 at end of symbol for 2nd entry
 	 */
@@ -393,18 +399,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_name = 25; /* offset in shd_string_table */
 	shdr->sh_type = SHT_STRTAB;
 	shdr->sh_flags = 0;
 	shdr->sh_entsize = 0;
 
-	tmp = realloc(build_id_data, build_id_data_len + symlen);
-	if (tmp == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(tmp + build_id_data_len, strsym, symlen);
-	build_id_data = tmp;
-	build_id_data_len += symlen;
+	blake2s_update_tagged(&ctx, TAG_STRSYM, strsym, symlen);
 
 	/*
 	 * setup build-id section
 	 */
 	scn = elf_newscn(e);
@@ -420,11 +419,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	}
 
 	/*
 	 * build-id generation
 	 */
-	sha1(build_id_data, build_id_data_len, bnote.build_id);
+	blake2s_final(&ctx, bnote.build_id);
 	bnote.desc.namesz = sizeof(bnote.name); /* must include 0 termination */
 	bnote.desc.descsz = sizeof(bnote.build_id);
 	bnote.desc.type   = NT_GNU_BUILD_ID;
 	strcpy(bnote.name, "GNU");
 
@@ -465,9 +464,8 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	retval = 0;
 error:
 	(void)elf_end(e);
 
 	free(strsym);
-	free(build_id_data);
 
 	return retval;
 }
diff --git a/tools/perf/util/sha1.c b/tools/perf/util/sha1.c
deleted file mode 100644
index 7032fa4ff3fd..000000000000
--- a/tools/perf/util/sha1.c
+++ /dev/null
@@ -1,97 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * SHA-1 message digest algorithm
- *
- * Copyright 2025 Google LLC
- */
-#include <linux/bitops.h>
-#include <linux/kernel.h>
-#include <linux/unaligned.h>
-#include <string.h>
-
-#include "sha1.h"
-
-#define SHA1_BLOCK_SIZE 64
-
-static const u32 sha1_K[4] = { 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xCA62C1D6 };
-
-#define SHA1_ROUND(i, a, b, c, d, e)                                          \
-	do {                                                                  \
-		if ((i) >= 16)                                                \
-			w[i] = rol32(w[(i) - 16] ^ w[(i) - 14] ^ w[(i) - 8] ^ \
-					     w[(i) - 3],                      \
-				     1);                                      \
-		e += w[i] + rol32(a, 5) + sha1_K[(i) / 20];                   \
-		if ((i) < 20)                                                 \
-			e += (b & (c ^ d)) ^ d;                               \
-		else if ((i) < 40 || (i) >= 60)                               \
-			e += b ^ c ^ d;                                       \
-		else                                                          \
-			e += (c & d) ^ (b & (c ^ d));                         \
-		b = rol32(b, 30);                                             \
-		/* The new (a, b, c, d, e) is the old (e, a, b, c, d). */     \
-	} while (0)
-
-#define SHA1_5ROUNDS(i)                             \
-	do {                                        \
-		SHA1_ROUND((i) + 0, a, b, c, d, e); \
-		SHA1_ROUND((i) + 1, e, a, b, c, d); \
-		SHA1_ROUND((i) + 2, d, e, a, b, c); \
-		SHA1_ROUND((i) + 3, c, d, e, a, b); \
-		SHA1_ROUND((i) + 4, b, c, d, e, a); \
-	} while (0)
-
-#define SHA1_20ROUNDS(i)                \
-	do {                            \
-		SHA1_5ROUNDS((i) + 0);  \
-		SHA1_5ROUNDS((i) + 5);  \
-		SHA1_5ROUNDS((i) + 10); \
-		SHA1_5ROUNDS((i) + 15); \
-	} while (0)
-
-static void sha1_blocks(u32 h[5], const u8 *data, size_t nblocks)
-{
-	while (nblocks--) {
-		u32 a = h[0];
-		u32 b = h[1];
-		u32 c = h[2];
-		u32 d = h[3];
-		u32 e = h[4];
-		u32 w[80];
-
-		for (int i = 0; i < 16; i++)
-			w[i] = get_unaligned_be32(&data[i * 4]);
-		SHA1_20ROUNDS(0);
-		SHA1_20ROUNDS(20);
-		SHA1_20ROUNDS(40);
-		SHA1_20ROUNDS(60);
-
-		h[0] += a;
-		h[1] += b;
-		h[2] += c;
-		h[3] += d;
-		h[4] += e;
-		data += SHA1_BLOCK_SIZE;
-	}
-}
-
-/* Calculate the SHA-1 message digest of the given data. */
-void sha1(const void *data, size_t len, u8 out[SHA1_DIGEST_SIZE])
-{
-	u32 h[5] = { 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476,
-		     0xC3D2E1F0 };
-	u8 final_data[2 * SHA1_BLOCK_SIZE] = { 0 };
-	size_t final_len = len % SHA1_BLOCK_SIZE;
-
-	sha1_blocks(h, data, len / SHA1_BLOCK_SIZE);
-
-	memcpy(final_data, data + len - final_len, final_len);
-	final_data[final_len] = 0x80;
-	final_len = round_up(final_len + 9, SHA1_BLOCK_SIZE);
-	put_unaligned_be64((u64)len * 8, &final_data[final_len - 8]);
-
-	sha1_blocks(h, final_data, final_len / SHA1_BLOCK_SIZE);
-
-	for (int i = 0; i < 5; i++)
-		put_unaligned_be32(h[i], &out[i * 4]);
-}
diff --git a/tools/perf/util/sha1.h b/tools/perf/util/sha1.h
deleted file mode 100644
index e92c9966e1d5..000000000000
--- a/tools/perf/util/sha1.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#include <linux/types.h>
-
-#define SHA1_DIGEST_SIZE 20
-
-void sha1(const void *data, size_t len, u8 out[SHA1_DIGEST_SIZE]);

base-commit: bc04acf4aeca588496124a6cf54bfce3db327039
-- 
2.52.0

