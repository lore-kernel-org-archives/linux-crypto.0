Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794BC274FE8;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732198; cv=none; b=gsMDi1tNaZskBsVKCQ+psR1rhbuV70cr1apwzoHs+5JRsAco1OsRprI25UPSv5CV+H2TuHS0pqsirdq6JYUOoRjWYq5zF0RejbLhloVNMGR7s06dSwIAw6prVsvk0hVyABMK27pZ4LSGgC4z30d+tjlSQqdkkkTa5l7Kzuxmn+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732198; c=relaxed/simple;
	bh=y919u1v+MtlZR4u2oYCQjGN0x4jfhBz4y3Z9Fztktow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHFGUhJYXGnhlsi9dEbKMg8CYZXw4qogITmwMkbRAp8ojfvJPULvS3OWVGz1ZOpCCaTInWwj9u7xbmtJOeJoT/edEbEWedloJn2m0wUk+WBtnumu8beNCBX5asdj4CanLNk3YCv7HdtT+NpUYh5eUfD8hhfGAXHft7mUZevWUOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EF8tyt0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EF8tyt0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0957C4CEF7;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732198;
	bh=y919u1v+MtlZR4u2oYCQjGN0x4jfhBz4y3Z9Fztktow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EF8tyt0T+HKt81YJjUihiwiM6YKtli8gmXV3BkzrU77IhacgLXG7TwGwMLxhnwkW3
	 Vhog3eQCw/TZkuYl5Wi4RgyWpfY7wdTDZkogRmztvtop7hqX0qGhtrK+qHf/2HZn4x
	 2Rln+4TmNzAXkRwvC7abNe5/fpzXHeMkUih/FqyaXLui90ZjpIcXq/Tl/P7DIQMZpn
	 cbITds/gh6HfOhiazi0NT1LHYE/z/8dw3blHSQ4Qbc/RhPZyoBoqEOYsAHYLZGnJ+h
	 DUETTVLFpcWvBJL7Oh3sOd5TxbscxRPLoROCmOc/8m2xHfBfT+sQPKjkcwXy6l7ATW
	 qyzRnjNQfDSSQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/9] lib/crypto: tests: Add KUnit tests for POLYVAL
Date: Sun,  9 Nov 2025 15:47:18 -0800
Message-ID: <20251109234726.638437-4-ebiggers@kernel.org>
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

Add a test suite for the POLYVAL library, including:

- All the standard tests and the benchmark from hash-test-template.h
- Comparison with a test vector from the RFC
- Test with key and message containing all one bits
- Additional tests related to the key struct

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig            |   9 ++
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/polyval-testvecs.h | 186 +++++++++++++++++++++++
 lib/crypto/tests/polyval_kunit.c    | 223 ++++++++++++++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py |  47 +++++-
 5 files changed, 464 insertions(+), 2 deletions(-)
 create mode 100644 lib/crypto/tests/polyval-testvecs.h
 create mode 100644 lib/crypto/tests/polyval_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 140afd1714ba..61d435c450bb 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -45,10 +45,19 @@ config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	select CRYPTO_LIB_POLY1305
 	help
 	  KUnit tests for the Poly1305 library functions.
 
+config CRYPTO_LIB_POLYVAL_KUNIT_TEST
+	tristate "KUnit tests for POLYVAL" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	select CRYPTO_LIB_POLYVAL
+	help
+	  KUnit tests for the POLYVAL library functions.
+
 config CRYPTO_LIB_SHA1_KUNIT_TEST
 	tristate "KUnit tests for SHA-1" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index f7d1392dc847..5109a0651925 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -3,9 +3,10 @@
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST) += curve25519_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST) += md5_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST) += poly1305_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST) += polyval_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
diff --git a/lib/crypto/tests/polyval-testvecs.h b/lib/crypto/tests/polyval-testvecs.h
new file mode 100644
index 000000000000..3d33f60d58bb
--- /dev/null
+++ b/lib/crypto/tests/polyval-testvecs.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by: ./scripts/crypto/gen-hash-testvecs.py polyval */
+
+static const struct {
+	size_t data_len;
+	u8 digest[POLYVAL_DIGEST_SIZE];
+} hash_testvecs[] = {
+	{
+		.data_len = 0,
+		.digest = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		},
+	},
+	{
+		.data_len = 1,
+		.digest = {
+			0xb5, 0x51, 0x69, 0x89, 0xd4, 0x3c, 0x59, 0xca,
+			0x6a, 0x1c, 0x2a, 0xe9, 0xa1, 0x9c, 0x6c, 0x83,
+		},
+	},
+	{
+		.data_len = 2,
+		.digest = {
+			0xf4, 0x50, 0xaf, 0x07, 0xda, 0x42, 0xa7, 0x41,
+			0x4d, 0x24, 0x88, 0x87, 0xe3, 0x40, 0x73, 0x7c,
+		},
+	},
+	{
+		.data_len = 3,
+		.digest = {
+			0x9e, 0x88, 0x78, 0x71, 0x4c, 0x55, 0x87, 0xe8,
+			0xb4, 0x96, 0x3d, 0x56, 0xc8, 0xb2, 0xe1, 0x68,
+		},
+	},
+	{
+		.data_len = 16,
+		.digest = {
+			0x9e, 0x81, 0x37, 0x8f, 0x49, 0xf7, 0xa2, 0xe4,
+			0x04, 0x45, 0x12, 0x78, 0x45, 0x42, 0x27, 0xad,
+		},
+	},
+	{
+		.data_len = 32,
+		.digest = {
+			0x60, 0x19, 0xd0, 0xa4, 0xf0, 0xde, 0x9e, 0xe7,
+			0x6a, 0x89, 0x1a, 0xea, 0x80, 0x14, 0xa9, 0xa3,
+		},
+	},
+	{
+		.data_len = 48,
+		.digest = {
+			0x0c, 0xa2, 0x70, 0x4d, 0x7c, 0x89, 0xac, 0x41,
+			0xc2, 0x9e, 0x0d, 0x07, 0x07, 0x6a, 0x7f, 0xd5,
+		},
+	},
+	{
+		.data_len = 49,
+		.digest = {
+			0x91, 0xd3, 0xa9, 0x5c, 0x79, 0x3d, 0x6b, 0x84,
+			0x99, 0x54, 0xa7, 0xb4, 0x06, 0x66, 0xfd, 0x1c,
+		},
+	},
+	{
+		.data_len = 63,
+		.digest = {
+			0x29, 0x37, 0xb8, 0xe5, 0xd8, 0x27, 0x4d, 0xfb,
+			0x83, 0x4f, 0x67, 0xf7, 0xf9, 0xc1, 0x0a, 0x9d,
+		},
+	},
+	{
+		.data_len = 64,
+		.digest = {
+			0x17, 0xa9, 0x06, 0x2c, 0xf3, 0xe8, 0x2e, 0xa6,
+			0x6b, 0xb2, 0x1f, 0x5d, 0x94, 0x3c, 0x02, 0xa2,
+		},
+	},
+	{
+		.data_len = 65,
+		.digest = {
+			0x7c, 0x80, 0x74, 0xd7, 0xa1, 0x37, 0x30, 0x64,
+			0x3b, 0xa4, 0xa3, 0x98, 0xde, 0x47, 0x10, 0x23,
+		},
+	},
+	{
+		.data_len = 127,
+		.digest = {
+			0x27, 0x3a, 0xcf, 0xf5, 0xaf, 0x9f, 0xd8, 0xd8,
+			0x2d, 0x6a, 0x91, 0xfb, 0xb8, 0xfa, 0xbe, 0x0c,
+		},
+	},
+	{
+		.data_len = 128,
+		.digest = {
+			0x97, 0x6e, 0xc4, 0xbe, 0x6b, 0x15, 0xa6, 0x7c,
+			0xc4, 0xa2, 0xb8, 0x0a, 0x0e, 0x9c, 0xc7, 0x3a,
+		},
+	},
+	{
+		.data_len = 129,
+		.digest = {
+			0x2b, 0xc3, 0x98, 0xba, 0x6e, 0x42, 0xf8, 0x18,
+			0x85, 0x69, 0x15, 0x37, 0x10, 0x60, 0xe6, 0xac,
+		},
+	},
+	{
+		.data_len = 256,
+		.digest = {
+			0x88, 0x21, 0x77, 0x89, 0xd7, 0x93, 0x90, 0xfc,
+			0xf3, 0xb0, 0xe3, 0xfb, 0x14, 0xe2, 0xcf, 0x74,
+		},
+	},
+	{
+		.data_len = 511,
+		.digest = {
+			0x66, 0x3d, 0x3e, 0x08, 0xa0, 0x49, 0x81, 0x68,
+			0x3e, 0x3b, 0xc8, 0x80, 0x55, 0xd4, 0x15, 0xe9,
+		},
+	},
+	{
+		.data_len = 513,
+		.digest = {
+			0x05, 0xf5, 0x06, 0x66, 0xe7, 0x11, 0x08, 0x84,
+			0xff, 0x94, 0x50, 0x85, 0x65, 0x95, 0x2a, 0x20,
+		},
+	},
+	{
+		.data_len = 1000,
+		.digest = {
+			0xd3, 0xa0, 0x51, 0x69, 0xb5, 0x38, 0xae, 0x1b,
+			0xe1, 0xa2, 0x89, 0xc6, 0x8d, 0x2b, 0x62, 0x37,
+		},
+	},
+	{
+		.data_len = 3333,
+		.digest = {
+			0x37, 0x6d, 0x6a, 0x14, 0xdc, 0xa5, 0x37, 0xfc,
+			0xfe, 0x67, 0x76, 0xb2, 0x64, 0x68, 0x64, 0x05,
+		},
+	},
+	{
+		.data_len = 4096,
+		.digest = {
+			0xe3, 0x12, 0x0c, 0x58, 0x46, 0x45, 0x27, 0x7a,
+			0x0e, 0xa2, 0xfa, 0x2c, 0x35, 0x73, 0x6c, 0x94,
+		},
+	},
+	{
+		.data_len = 4128,
+		.digest = {
+			0x63, 0x0d, 0xa1, 0xbc, 0x6e, 0x3e, 0xd3, 0x1d,
+			0x28, 0x52, 0xd2, 0xf4, 0x30, 0x2d, 0xff, 0xc4,
+		},
+	},
+	{
+		.data_len = 4160,
+		.digest = {
+			0xb2, 0x91, 0x49, 0xe2, 0x02, 0x98, 0x00, 0x79,
+			0x71, 0xb9, 0xd7, 0xd4, 0xb5, 0x94, 0x6d, 0x7d,
+		},
+	},
+	{
+		.data_len = 4224,
+		.digest = {
+			0x58, 0x96, 0x48, 0x69, 0x05, 0x17, 0xe1, 0x6d,
+			0xbc, 0xf2, 0x3d, 0x10, 0x96, 0x00, 0x74, 0x58,
+		},
+	},
+	{
+		.data_len = 16384,
+		.digest = {
+			0x99, 0x3c, 0xcb, 0x4d, 0x64, 0xc9, 0xa9, 0x41,
+			0x52, 0x93, 0xfd, 0x65, 0xc4, 0xcc, 0xa5, 0xe5,
+		},
+	},
+};
+
+static const u8 hash_testvec_consolidated[POLYVAL_DIGEST_SIZE] = {
+	0xdf, 0x68, 0x52, 0x99, 0x92, 0xc3, 0xe8, 0x88,
+	0x29, 0x13, 0xc8, 0x35, 0x67, 0xa3, 0xd3, 0xad,
+};
+
+static const u8 polyval_allones_hashofhashes[POLYVAL_DIGEST_SIZE] = {
+	0xd5, 0xf7, 0xfd, 0xb2, 0xa6, 0xef, 0x0b, 0x85,
+	0x0d, 0x0a, 0x06, 0x10, 0xbc, 0x64, 0x94, 0x73,
+};
diff --git a/lib/crypto/tests/polyval_kunit.c b/lib/crypto/tests/polyval_kunit.c
new file mode 100644
index 000000000000..e59f598c1572
--- /dev/null
+++ b/lib/crypto/tests/polyval_kunit.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/polyval.h>
+#include "polyval-testvecs.h"
+
+/*
+ * A fixed key used when presenting POLYVAL as an unkeyed hash function in order
+ * to reuse hash-test-template.h.  At the beginning of the test suite, this is
+ * initialized to a key prepared from bytes generated from a fixed seed.
+ */
+static struct polyval_key test_key;
+
+static void polyval_init_withtestkey(struct polyval_ctx *ctx)
+{
+	polyval_init(ctx, &test_key);
+}
+
+static void polyval_withtestkey(const u8 *data, size_t len,
+				u8 out[POLYVAL_BLOCK_SIZE])
+{
+	polyval(&test_key, data, len, out);
+}
+
+/* Generate the HASH_KUNIT_CASES using hash-test-template.h. */
+#define HASH polyval_withtestkey
+#define HASH_CTX polyval_ctx
+#define HASH_SIZE POLYVAL_BLOCK_SIZE
+#define HASH_INIT polyval_init_withtestkey
+#define HASH_UPDATE polyval_update
+#define HASH_FINAL polyval_final
+#include "hash-test-template.h"
+
+/*
+ * Test an example from RFC8452 ("AES-GCM-SIV: Nonce Misuse-Resistant
+ * Authenticated Encryption") to ensure compatibility with that.
+ */
+static void test_polyval_rfc8452_testvec(struct kunit *test)
+{
+	static const u8 raw_key[POLYVAL_BLOCK_SIZE] =
+		"\x31\x07\x28\xd9\x91\x1f\x1f\x38"
+		"\x37\xb2\x43\x16\xc3\xfa\xb9\xa0";
+	static const u8 data[48] =
+		"\x65\x78\x61\x6d\x70\x6c\x65\x00"
+		"\x00\x00\x00\x00\x00\x00\x00\x00"
+		"\x48\x65\x6c\x6c\x6f\x20\x77\x6f"
+		"\x72\x6c\x64\x00\x00\x00\x00\x00"
+		"\x38\x00\x00\x00\x00\x00\x00\x00"
+		"\x58\x00\x00\x00\x00\x00\x00\x00";
+	static const u8 expected_hash[POLYVAL_BLOCK_SIZE] =
+		"\xad\x7f\xcf\x0b\x51\x69\x85\x16"
+		"\x62\x67\x2f\x3c\x5f\x95\x13\x8f";
+	u8 hash[POLYVAL_BLOCK_SIZE];
+	struct polyval_key key;
+
+	polyval_preparekey(&key, raw_key);
+	polyval(&key, data, sizeof(data), hash);
+	KUNIT_ASSERT_MEMEQ(test, hash, expected_hash, sizeof(hash));
+}
+
+/*
+ * Test a key and messages containing all one bits.  This is useful to detect
+ * overflow bugs in implementations that emulate carryless multiplication using
+ * a series of standard multiplications with the bits spread out.
+ */
+static void test_polyval_allones_key_and_message(struct kunit *test)
+{
+	struct polyval_key key;
+	struct polyval_ctx hashofhashes_ctx;
+	u8 hash[POLYVAL_BLOCK_SIZE];
+
+	static_assert(TEST_BUF_LEN >= 4096);
+	memset(test_buf, 0xff, 4096);
+
+	polyval_preparekey(&key, test_buf);
+	polyval_init(&hashofhashes_ctx, &key);
+	for (size_t len = 0; len <= 4096; len += 16) {
+		polyval(&key, test_buf, len, hash);
+		polyval_update(&hashofhashes_ctx, hash, sizeof(hash));
+	}
+	polyval_final(&hashofhashes_ctx, hash);
+	KUNIT_ASSERT_MEMEQ(test, hash, polyval_allones_hashofhashes,
+			   sizeof(hash));
+}
+
+#define MAX_LEN_FOR_KEY_CHECK 1024
+
+/*
+ * Given two prepared keys which should be identical (but may differ in
+ * alignment and/or whether they are followed by a guard page or not), verify
+ * that they produce consistent results on various data lengths.
+ */
+static void check_key_consistency(struct kunit *test,
+				  const struct polyval_key *key1,
+				  const struct polyval_key *key2)
+{
+	u8 *data = test_buf;
+	u8 hash1[POLYVAL_BLOCK_SIZE];
+	u8 hash2[POLYVAL_BLOCK_SIZE];
+
+	rand_bytes(data, MAX_LEN_FOR_KEY_CHECK);
+	KUNIT_ASSERT_MEMEQ(test, key1, key2, sizeof(*key1));
+
+	for (int i = 0; i < 100; i++) {
+		size_t len = rand_length(MAX_LEN_FOR_KEY_CHECK);
+
+		polyval(key1, data, len, hash1);
+		polyval(key2, data, len, hash2);
+		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, sizeof(hash1));
+	}
+}
+
+/* Test that no buffer overreads occur on either raw_key or polyval_key. */
+static void test_polyval_with_guarded_key(struct kunit *test)
+{
+	u8 raw_key[POLYVAL_BLOCK_SIZE];
+	u8 *guarded_raw_key = &test_buf[TEST_BUF_LEN - sizeof(raw_key)];
+	struct polyval_key key1, key2;
+	struct polyval_key *guarded_key =
+		(struct polyval_key *)&test_buf[TEST_BUF_LEN - sizeof(key1)];
+
+	/* Prepare with regular buffers. */
+	rand_bytes(raw_key, sizeof(raw_key));
+	polyval_preparekey(&key1, raw_key);
+
+	/* Prepare with guarded raw_key, then check that it works. */
+	memcpy(guarded_raw_key, raw_key, sizeof(raw_key));
+	polyval_preparekey(&key2, guarded_raw_key);
+	check_key_consistency(test, &key1, &key2);
+
+	/* Prepare guarded polyval_key, then check that it works. */
+	polyval_preparekey(guarded_key, raw_key);
+	check_key_consistency(test, &key1, guarded_key);
+}
+
+/*
+ * Test that polyval_key only needs to be aligned to
+ * __alignof__(struct polyval_key), i.e. 8 bytes.  The assembly code may prefer
+ * 16-byte or higher alignment, but it musn't require it.
+ */
+static void test_polyval_with_minimally_aligned_key(struct kunit *test)
+{
+	u8 raw_key[POLYVAL_BLOCK_SIZE];
+	struct polyval_key key;
+	struct polyval_key *minaligned_key =
+		(struct polyval_key *)&test_buf[MAX_LEN_FOR_KEY_CHECK +
+						__alignof__(struct polyval_key)];
+
+	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key,
+					   __alignof__(struct polyval_key)));
+	KUNIT_ASSERT_TRUE(test,
+			  !IS_ALIGNED((uintptr_t)minaligned_key,
+				      2 * __alignof__(struct polyval_key)));
+
+	rand_bytes(raw_key, sizeof(raw_key));
+	polyval_preparekey(&key, raw_key);
+	polyval_preparekey(minaligned_key, raw_key);
+	check_key_consistency(test, &key, minaligned_key);
+}
+
+struct polyval_irq_test_state {
+	struct polyval_key expected_key;
+	u8 raw_key[POLYVAL_BLOCK_SIZE];
+};
+
+static bool polyval_irq_test_func(void *state_)
+{
+	struct polyval_irq_test_state *state = state_;
+	struct polyval_key key;
+
+	polyval_preparekey(&key, state->raw_key);
+	return memcmp(&key, &state->expected_key, sizeof(key)) == 0;
+}
+
+/*
+ * Test that polyval_preparekey() produces the same output regardless of whether
+ * FPU or vector registers are usable when it is called.
+ */
+static void test_polyval_preparekey_in_irqs(struct kunit *test)
+{
+	struct polyval_irq_test_state state;
+
+	rand_bytes(state.raw_key, sizeof(state.raw_key));
+	polyval_preparekey(&state.expected_key, state.raw_key);
+	kunit_run_irq_test(test, polyval_irq_test_func, 20000, &state);
+}
+
+static int polyval_suite_init(struct kunit_suite *suite)
+{
+	u8 raw_key[POLYVAL_BLOCK_SIZE];
+
+	rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
+	polyval_preparekey(&test_key, raw_key);
+	return hash_suite_init(suite);
+}
+
+static void polyval_suite_exit(struct kunit_suite *suite)
+{
+	hash_suite_exit(suite);
+}
+
+static struct kunit_case polyval_test_cases[] = {
+	HASH_KUNIT_CASES,
+	KUNIT_CASE(test_polyval_rfc8452_testvec),
+	KUNIT_CASE(test_polyval_allones_key_and_message),
+	KUNIT_CASE(test_polyval_with_guarded_key),
+	KUNIT_CASE(test_polyval_with_minimally_aligned_key),
+	KUNIT_CASE(test_polyval_preparekey_in_irqs),
+	KUNIT_CASE(benchmark_hash),
+	{},
+};
+
+static struct kunit_suite polyval_test_suite = {
+	.name = "polyval",
+	.test_cases = polyval_test_cases,
+	.suite_init = polyval_suite_init,
+	.suite_exit = polyval_suite_exit,
+};
+kunit_test_suite(polyval_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for POLYVAL");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
index ae2682882cd1..c1d0517140bd 100755
--- a/scripts/crypto/gen-hash-testvecs.py
+++ b/scripts/crypto/gen-hash-testvecs.py
@@ -1,9 +1,9 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0-or-later
 #
-# Script that generates test vectors for the given cryptographic hash function.
+# Script that generates test vectors for the given hash function.
 #
 # Copyright 2025 Google LLC
 
 import hashlib
 import hmac
@@ -48,15 +48,46 @@ class Poly1305:
     # nondestructive, i.e. not changing any field of self.
     def digest(self):
         m = (self.h + self.s) % 2**128
         return m.to_bytes(16, byteorder='little')
 
+POLYVAL_POLY = sum((1 << i) for i in [128, 127, 126, 121, 0])
+POLYVAL_BLOCK_SIZE = 16
+
+# A straightforward, unoptimized implementation of POLYVAL.
+# Reference: https://datatracker.ietf.org/doc/html/rfc8452
+class Polyval:
+    def __init__(self, key):
+        assert len(key) == 16
+        self.h = int.from_bytes(key, byteorder='little')
+        self.acc = 0
+
+    # Note: this supports partial blocks only at the end.
+    def update(self, data):
+        for i in range(0, len(data), 16):
+            # acc += block
+            self.acc ^= int.from_bytes(data[i:i+16], byteorder='little')
+            # acc = (acc * h * x^-128) mod POLYVAL_POLY
+            product = 0
+            for j in range(128):
+                if (self.h & (1 << j)) != 0:
+                    product ^= self.acc << j
+                if (product & (1 << j)) != 0:
+                    product ^= POLYVAL_POLY << j
+            self.acc = product >> 128
+        return self
+
+    def digest(self):
+        return self.acc.to_bytes(16, byteorder='little')
+
 def hash_init(alg):
     if alg == 'poly1305':
         # Use a fixed random key here, to present Poly1305 as an unkeyed hash.
         # This allows all the test cases for unkeyed hashes to work on Poly1305.
         return Poly1305(rand_bytes(POLY1305_KEY_SIZE))
+    if alg == 'polyval':
+        return Polyval(rand_bytes(POLYVAL_BLOCK_SIZE))
     return hashlib.new(alg)
 
 def hash_update(ctx, data):
     ctx.update(data)
 
@@ -163,13 +194,22 @@ def gen_additional_poly1305_testvecs():
             data += ctx.digest()
     print_static_u8_array_definition(
             'poly1305_allones_macofmacs[POLY1305_DIGEST_SIZE]',
             Poly1305(key).update(data).digest())
 
+def gen_additional_polyval_testvecs():
+    key = b'\xff' * POLYVAL_BLOCK_SIZE
+    hashes = b''
+    for data_len in range(0, 4097, 16):
+        hashes += Polyval(key).update(b'\xff' * data_len).digest()
+    print_static_u8_array_definition(
+            'polyval_allones_hashofhashes[POLYVAL_DIGEST_SIZE]',
+            Polyval(key).update(hashes).digest())
+
 if len(sys.argv) != 2:
     sys.stderr.write('Usage: gen-hash-testvecs.py ALGORITHM\n')
-    sys.stderr.write('ALGORITHM may be any supported by Python hashlib, or poly1305 or sha3.\n')
+    sys.stderr.write('ALGORITHM may be any supported by Python hashlib; or poly1305, polyval, or sha3.\n')
     sys.stderr.write('Example: gen-hash-testvecs.py sha512\n')
     sys.exit(1)
 
 alg = sys.argv[1]
 print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
@@ -178,10 +218,13 @@ if alg.startswith('blake2'):
     gen_unkeyed_testvecs(alg)
     gen_additional_blake2_testvecs(alg)
 elif alg == 'poly1305':
     gen_unkeyed_testvecs(alg)
     gen_additional_poly1305_testvecs()
+elif alg == 'polyval':
+    gen_unkeyed_testvecs(alg)
+    gen_additional_polyval_testvecs()
 elif alg == 'sha3':
     print()
     print('/* SHA3-256 test vectors */')
     gen_unkeyed_testvecs('sha3-256')
     print()
-- 
2.51.2

