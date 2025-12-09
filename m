Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EED30100E;
	Tue,  9 Dec 2025 01:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245490; cv=none; b=kQGPM6mT5BFfhsK8SfFn5qPPduTM9WM9nNo5nxR2cP5kdTAub7xrFstT+5cNMljVlMBEHUT5NsAzlKpPZJbQp6KIleHuOB/XdtFyB3cwoRWfqxvP/o34zwX4nIRC+p0ZJ7GGJGXzEpMQhs+G9aLRLarqU6wVA6WiCQEteWT6ZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245490; c=relaxed/simple;
	bh=cm/t/nkJi4XYRjRg4UCoPHKxHiy1d6tYPHHSUQ8dOvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQflHfW3kfolmXXuP/tazA1SAUaz9EUB85AJ9EbPKNy+iZH25YXRMQlyOPbkFBmXuOsMLqpRW/ikPGMJgr8Osj/Reqs4zyO3HhsAi/HP5w7iwRbJ2mCHHak1ZcOfe47V3mPm6dNS9Wx4jvIjl7M6xd+vcKgRS95diHTmET2nSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ti7VhSlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ti7VhSlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD0DC113D0;
	Tue,  9 Dec 2025 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765245490;
	bh=cm/t/nkJi4XYRjRg4UCoPHKxHiy1d6tYPHHSUQ8dOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti7VhSlpTCoG9v8pESxdWtbucHbx8i721vNs0MyWltgqI9JV19ycEreUoC4ap/CZv
	 TETCMDULIe2d6vGnmBABELWREowkwFLDQ1jOJsDOjQY0I8D9f3CUyl0nfVDiXzyBep
	 OJSh7mXktSp3Ogh0Yxtv0zNHnTvYqT9ac1vMsI45X0MZOhdRvWzupzidgo89Jaqec7
	 wVRRblwkOXuQA7Et8J4QPl9jKboqCCD6jal+DdI/Q/1VWXj5pZUmjfLbzwtbV0i1RD
	 AWdOy4YApEsI+g69pU8cDCjZJZlVq0OS2pRFZbvbTG31AzcGzZ4N1H/yLkU9ZjeUY7
	 a99k/ZWxPdOdw==
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
Subject: [PATCH v2 3/3] perf util: Remove SHA-1 code
Date: Mon,  8 Dec 2025 17:57:29 -0800
Message-ID: <20251209015729.23253-4-ebiggers@kernel.org>
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

Now that the SHA-1 code is no longer used, remove it.

Tested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/perf/tests/util.c | 49 ---------------------
 tools/perf/util/Build   |  1 -
 tools/perf/util/sha1.c  | 97 -----------------------------------------
 tools/perf/util/sha1.h  |  6 ---
 4 files changed, 153 deletions(-)
 delete mode 100644 tools/perf/util/sha1.c
 delete mode 100644 tools/perf/util/sha1.h

diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
index efc3e4e4c6fa..bf2c5b133884 100644
--- a/tools/perf/tests/util.c
+++ b/tools/perf/tests/util.c
@@ -1,10 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "tests.h"
 #include "util/blake2s.h"
 #include "util/debug.h"
-#include "util/sha1.h"
 
 #include <linux/compiler.h>
 #include <stdlib.h>
 #include <string2.h>
 
@@ -16,52 +15,10 @@ static int test_strreplace(char needle, const char *haystack,
 
 	free(new);
 	return ret == 0;
 }
 
-#define MAX_LEN 512
-
-/* Test sha1() for all lengths from 0 to MAX_LEN inclusively. */
-static int test_sha1(void)
-{
-	u8 data[MAX_LEN];
-	size_t digests_size = (MAX_LEN + 1) * SHA1_DIGEST_SIZE;
-	u8 *digests;
-	u8 digest_of_digests[SHA1_DIGEST_SIZE];
-	/*
-	 * The correctness of this value was verified by running this test with
-	 * sha1() replaced by OpenSSL's SHA1().
-	 */
-	static const u8 expected_digest_of_digests[SHA1_DIGEST_SIZE] = {
-		0x74, 0xcd, 0x4c, 0xb9, 0xd8, 0xa6, 0xd5, 0x95, 0x22, 0x8b,
-		0x7e, 0xd6, 0x8b, 0x7e, 0x46, 0x95, 0x31, 0x9b, 0xa2, 0x43,
-	};
-	size_t i;
-
-	digests = malloc(digests_size);
-	TEST_ASSERT_VAL("failed to allocate digests", digests != NULL);
-
-	/* Generate MAX_LEN bytes of data. */
-	for (i = 0; i < MAX_LEN; i++)
-		data[i] = i;
-
-	/* Calculate a SHA-1 for each length 0 through MAX_LEN inclusively. */
-	for (i = 0; i <= MAX_LEN; i++)
-		sha1(data, i, &digests[i * SHA1_DIGEST_SIZE]);
-
-	/* Calculate digest of all digests calculated above. */
-	sha1(digests, digests_size, digest_of_digests);
-
-	free(digests);
-
-	/* Check for the expected result. */
-	TEST_ASSERT_VAL("wrong output from sha1()",
-			memcmp(digest_of_digests, expected_digest_of_digests,
-			       SHA1_DIGEST_SIZE) == 0);
-	return 0;
-}
-
 /* Maximum data length tested by test_blake2s() */
 #define MAX_DATA_LEN 512
 
 /*
  * Hash length tested by test_blake2s().  BLAKE2s supports variable-length
@@ -129,22 +86,16 @@ static int test_blake2s(void)
 	return 0;
 }
 
 static int test__util(struct test_suite *t __maybe_unused, int subtest __maybe_unused)
 {
-	int ret;
-
 	TEST_ASSERT_VAL("empty string", test_strreplace(' ', "", "123", ""));
 	TEST_ASSERT_VAL("no match", test_strreplace('5', "123", "4", "123"));
 	TEST_ASSERT_VAL("replace 1", test_strreplace('3', "123", "4", "124"));
 	TEST_ASSERT_VAL("replace 2", test_strreplace('a', "abcabc", "ef", "efbcefbc"));
 	TEST_ASSERT_VAL("replace long", test_strreplace('a', "abcabc", "longlong",
 							"longlongbclonglongbc"));
 
-	ret = test_sha1();
-	if (ret != TEST_OK)
-		return ret;
-
 	return test_blake2s();
 }
 
 DEFINE_SUITE("util", util);
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index b500053332d2..2a9f3d015c1d 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -42,11 +42,10 @@ perf-util-y += rlimit.o
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
-- 
2.52.0

