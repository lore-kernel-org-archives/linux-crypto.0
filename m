Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722329E10F;
	Sun,  6 Jul 2025 23:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751844728; cv=none; b=beD/U/M9OR6ZsU2wGpg92peTuAL6kCJePKurcEtHT2JiIA7EONE7qgwRA56427MyACj9kbZ0Bt4Yj2MS6+f3gTI8diDRrZZiGVenjgAcDU1DBCplHG16LP7AeD7otI7o6oorT7/kYnodEZePSMtc3Qe6tzxKqv2H5qr1RLY+muo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751844728; c=relaxed/simple;
	bh=I+PfUKlRRSLcV4aOifuyiUHhqcYXA+cgzSR+qlGG/L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9qGgkHJmcgdx/ZVIcsHnMmnwcpkFzECMsF12d4KZqSvhW2JQiHX8mtTfWvmC0i8lQvB+awwWwF0h6WkwGmp3/23V6LImaBTxJ2dxxmSEdRvFNdVkdUnvLUoHzjiAzbu/8UCMj+RjXk35QkPfiISD8LchtWdABY7xVBDWZQpkfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BijOAxjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BijOAxjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A403DC4CEF3;
	Sun,  6 Jul 2025 23:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751844728;
	bh=I+PfUKlRRSLcV4aOifuyiUHhqcYXA+cgzSR+qlGG/L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BijOAxjcAucI4PAH2TL1NcwYm1kpEPk+HxE2VGS/aoqdKVCmpFOgujPiyzd6CbRVd
	 CS9uaqLL2yViboPVlPRKs/wOFgCo52W9RaN/X6yFnjhO5cuqe+AQ+KDn1EhdnN9WdB
	 YXhDqPgN64LyfyJz8d0584Db1ZxQGfBKyF7nsmVtl2hpIMBT5vgEjKdSgO3xUl8Nrm
	 QxqYRk0yNx/A1WhYJeQ/3QTQsbUpiFf6gv6PTTpxtkWbTklxr3w8VrI4ET3k70fUl4
	 R6ljMqFpID0CkFz9W5ST5burdDNdizRSMAQvJ5tdv9U3FwVgjHxjT5O4n3YFO4ZD/n
	 byTrQwOpxnvoQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 4/4] lib/crypto: tests: Add KUnit tests for Poly1305
Date: Sun,  6 Jul 2025 16:28:17 -0700
Message-ID: <20250706232817.179500-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250706232817.179500-1-ebiggers@kernel.org>
References: <20250706232817.179500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for the Poly1305 functions.  Most of its test
cases are instantiated from hash-test-template.h, which is also used by
the SHA-2 tests.  A couple additional test cases are also included to
test edge cases specific to Poly1305.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig             |   9 ++
 lib/crypto/tests/Makefile            |   1 +
 lib/crypto/tests/poly1305-testvecs.h | 186 +++++++++++++++++++++++++++
 lib/crypto/tests/poly1305_kunit.c    | 165 ++++++++++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py  |  48 ++++++-
 5 files changed, 407 insertions(+), 2 deletions(-)
 create mode 100644 lib/crypto/tests/poly1305-testvecs.h
 create mode 100644 lib/crypto/tests/poly1305_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index c76667e5af3f..c43ff41778d2 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,7 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+config CRYPTO_LIB_POLY1305_KUNIT_TEST
+	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	select CRYPTO_LIB_POLY1305
+	help
+	  KUnit tests for the Poly1305 library functions.
+
 config CRYPTO_LIB_SHA256_KUNIT_TEST
 	tristate "KUnit tests for SHA-224 and SHA-256" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index a963429061dc..d33f6d85ecaa 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+obj-$(CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST) += poly1305_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
diff --git a/lib/crypto/tests/poly1305-testvecs.h b/lib/crypto/tests/poly1305-testvecs.h
new file mode 100644
index 000000000000..ecf8662225c8
--- /dev/null
+++ b/lib/crypto/tests/poly1305-testvecs.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by: ./scripts/crypto/gen-hash-testvecs.py poly1305 */
+
+static const struct {
+	size_t data_len;
+	u8 digest[POLY1305_DIGEST_SIZE];
+} hash_testvecs[] = {
+	{
+		.data_len = 0,
+		.digest = {
+			0xe8, 0x2d, 0x67, 0x2c, 0x01, 0x48, 0xf9, 0xb7,
+			0x87, 0x85, 0x3f, 0xcf, 0x18, 0x66, 0x8c, 0xd3,
+		},
+	},
+	{
+		.data_len = 1,
+		.digest = {
+			0xb8, 0xad, 0xca, 0x6b, 0x32, 0xba, 0x34, 0x42,
+			0x54, 0x10, 0x28, 0xf5, 0x0f, 0x7e, 0x8e, 0xe3,
+		},
+	},
+	{
+		.data_len = 2,
+		.digest = {
+			0xb8, 0xf7, 0xf4, 0xc2, 0x85, 0x33, 0x80, 0x63,
+			0xd1, 0x45, 0xda, 0xf8, 0x7c, 0x79, 0x42, 0xd1,
+		},
+	},
+	{
+		.data_len = 3,
+		.digest = {
+			0xf3, 0x73, 0x7b, 0x60, 0x24, 0xcc, 0x5d, 0x3e,
+			0xd1, 0x95, 0x86, 0xce, 0x89, 0x0a, 0x33, 0xba,
+		},
+	},
+	{
+		.data_len = 16,
+		.digest = {
+			0x0a, 0x1a, 0x2d, 0x39, 0xea, 0x49, 0x8f, 0xb7,
+			0x90, 0xb6, 0x74, 0x3b, 0x41, 0x3b, 0x96, 0x11,
+		},
+	},
+	{
+		.data_len = 32,
+		.digest = {
+			0x99, 0x05, 0xe3, 0xa7, 0x9e, 0x2a, 0xd2, 0x42,
+			0xb9, 0x45, 0x0c, 0x08, 0xe7, 0x10, 0xe4, 0xe1,
+		},
+	},
+	{
+		.data_len = 48,
+		.digest = {
+			0xe1, 0xb2, 0x15, 0xee, 0xa2, 0xf3, 0x04, 0xac,
+			0xdd, 0x27, 0x57, 0x95, 0x2f, 0x45, 0xa8, 0xd3,
+		},
+	},
+	{
+		.data_len = 49,
+		.digest = {
+			0x1c, 0xf3, 0xab, 0x39, 0xc0, 0x69, 0x49, 0x69,
+			0x89, 0x6f, 0x1f, 0x03, 0x16, 0xe7, 0xc0, 0xf0,
+		},
+	},
+	{
+		.data_len = 63,
+		.digest = {
+			0x30, 0xb0, 0x32, 0x87, 0x51, 0x55, 0x9c, 0x39,
+			0x38, 0x42, 0x06, 0xe9, 0x2a, 0x3e, 0x2c, 0x92,
+		},
+	},
+	{
+		.data_len = 64,
+		.digest = {
+			0x2c, 0x04, 0x16, 0x36, 0x55, 0x25, 0x2d, 0xc6,
+			0x3d, 0x70, 0x5b, 0x88, 0x46, 0xb6, 0x71, 0x77,
+		},
+	},
+	{
+		.data_len = 65,
+		.digest = {
+			0x03, 0x87, 0xdd, 0xbe, 0xe8, 0x30, 0xf2, 0x15,
+			0x40, 0x44, 0x29, 0x7b, 0xb1, 0xe9, 0x9d, 0xe7,
+		},
+	},
+	{
+		.data_len = 127,
+		.digest = {
+			0x29, 0x83, 0x4f, 0xcb, 0x5a, 0x93, 0x25, 0xad,
+			0x05, 0xa4, 0xb3, 0x24, 0x77, 0x62, 0x2d, 0x3d,
+		},
+	},
+	{
+		.data_len = 128,
+		.digest = {
+			0x20, 0x0e, 0x2c, 0x05, 0xe2, 0x0b, 0x85, 0xa0,
+			0x24, 0x73, 0x7f, 0x65, 0x70, 0x6c, 0x3e, 0xb0,
+		},
+	},
+	{
+		.data_len = 129,
+		.digest = {
+			0xef, 0x2f, 0x98, 0x42, 0xc2, 0x90, 0x55, 0xea,
+			0xba, 0x28, 0x76, 0xfd, 0x9e, 0x3e, 0x4d, 0x53,
+		},
+	},
+	{
+		.data_len = 256,
+		.digest = {
+			0x9e, 0x75, 0x4b, 0xc7, 0x69, 0x68, 0x51, 0x90,
+			0xdc, 0x29, 0xc8, 0xfa, 0x86, 0xf1, 0xc9, 0xb3,
+		},
+	},
+	{
+		.data_len = 511,
+		.digest = {
+			0x9d, 0x13, 0xf5, 0x54, 0xe6, 0xe3, 0x45, 0x38,
+			0x8b, 0x6d, 0x5c, 0xc4, 0x50, 0xeb, 0x90, 0xcb,
+		},
+	},
+	{
+		.data_len = 513,
+		.digest = {
+			0xaa, 0xb2, 0x3e, 0x3c, 0x2a, 0xfc, 0x62, 0x0e,
+			0xd4, 0xe6, 0xe5, 0x5c, 0x6b, 0x9f, 0x3d, 0xc7,
+		},
+	},
+	{
+		.data_len = 1000,
+		.digest = {
+			0xd6, 0x8c, 0xea, 0x8a, 0x0f, 0x68, 0xa9, 0xa8,
+			0x67, 0x86, 0xf9, 0xc1, 0x4c, 0x26, 0x10, 0x6d,
+		},
+	},
+	{
+		.data_len = 3333,
+		.digest = {
+			0xdc, 0xc1, 0x54, 0xe7, 0x38, 0xc6, 0xdb, 0x24,
+			0xa7, 0x0b, 0xff, 0xd3, 0x1b, 0x93, 0x01, 0xa6,
+		},
+	},
+	{
+		.data_len = 4096,
+		.digest = {
+			0x8f, 0x88, 0x3e, 0x9c, 0x7b, 0x2e, 0x82, 0x5a,
+			0x1d, 0x31, 0x82, 0xcc, 0x69, 0xb4, 0x16, 0x26,
+		},
+	},
+	{
+		.data_len = 4128,
+		.digest = {
+			0x23, 0x45, 0x94, 0xa8, 0x11, 0x54, 0x9d, 0xf2,
+			0xa1, 0x9a, 0xca, 0xf9, 0x3e, 0x65, 0x52, 0xfd,
+		},
+	},
+	{
+		.data_len = 4160,
+		.digest = {
+			0x7b, 0xfc, 0xa9, 0x1e, 0x03, 0xad, 0xef, 0x03,
+			0xe2, 0x20, 0x92, 0xc7, 0x54, 0x83, 0xfa, 0x37,
+		},
+	},
+	{
+		.data_len = 4224,
+		.digest = {
+			0x46, 0xab, 0x8c, 0x75, 0xb3, 0x10, 0xa6, 0x3f,
+			0x74, 0x55, 0x42, 0x6d, 0x69, 0x35, 0xd2, 0xf5,
+		},
+	},
+	{
+		.data_len = 16384,
+		.digest = {
+			0xd0, 0xfe, 0x26, 0xc2, 0xca, 0x94, 0x2d, 0x52,
+			0x2d, 0xe1, 0x11, 0xdd, 0x42, 0x28, 0x83, 0xa6,
+		},
+	},
+};
+
+static const u8 hash_testvec_consolidated[POLY1305_DIGEST_SIZE] = {
+	0x9d, 0x07, 0x5d, 0xc9, 0x6c, 0xeb, 0x62, 0x5d,
+	0x02, 0x5f, 0xe1, 0xe3, 0xd1, 0x71, 0x69, 0x34,
+};
+
+static const u8 poly1305_allones_macofmacs[POLY1305_DIGEST_SIZE] = {
+	0x0c, 0x26, 0x6b, 0x45, 0x87, 0x06, 0xcf, 0xc4,
+	0x3f, 0x70, 0x7d, 0xb3, 0x50, 0xdd, 0x81, 0x25,
+};
diff --git a/lib/crypto/tests/poly1305_kunit.c b/lib/crypto/tests/poly1305_kunit.c
new file mode 100644
index 000000000000..7ac191bd96b6
--- /dev/null
+++ b/lib/crypto/tests/poly1305_kunit.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/poly1305.h>
+#include "poly1305-testvecs.h"
+
+/*
+ * A fixed key used when presenting Poly1305 as an unkeyed hash function in
+ * order to reuse hash-test-template.h.  At the beginning of the test suite,
+ * this is initialized to bytes generated from a fixed seed.
+ */
+static u8 test_key[POLY1305_KEY_SIZE];
+
+/* This probably should be in the actual API, but just define it here for now */
+static void poly1305(const u8 key[POLY1305_KEY_SIZE], const u8 *data,
+		     size_t len, u8 out[POLY1305_DIGEST_SIZE])
+{
+	struct poly1305_desc_ctx ctx;
+
+	poly1305_init(&ctx, key);
+	poly1305_update(&ctx, data, len);
+	poly1305_final(&ctx, out);
+}
+
+static void poly1305_init_withtestkey(struct poly1305_desc_ctx *ctx)
+{
+	poly1305_init(ctx, test_key);
+}
+
+static void poly1305_withtestkey(const u8 *data, size_t len,
+				 u8 out[POLY1305_DIGEST_SIZE])
+{
+	poly1305(test_key, data, len, out);
+}
+
+/* Generate the HASH_KUNIT_CASES using hash-test-template.h. */
+#define HASH poly1305_withtestkey
+#define HASH_CTX poly1305_desc_ctx
+#define HASH_SIZE POLY1305_DIGEST_SIZE
+#define HASH_INIT poly1305_init_withtestkey
+#define HASH_UPDATE poly1305_update
+#define HASH_FINAL poly1305_final
+#include "hash-test-template.h"
+
+static int poly1305_suite_init(struct kunit_suite *suite)
+{
+	rand_bytes_seeded_from_len(test_key, POLY1305_KEY_SIZE);
+	return hash_suite_init(suite);
+}
+
+static void poly1305_suite_exit(struct kunit_suite *suite)
+{
+	hash_suite_exit(suite);
+}
+
+/*
+ * Poly1305 test case which uses a key and message consisting only of one bits:
+ *
+ * - Using an all-one-bits r_key tests the key clamping.
+ * - Using an all-one-bits s_key tests carries in implementations of the
+ *   addition mod 2**128 during finalization.
+ * - Using all-one-bits message, and to a lesser extent r_key, tends to maximize
+ *   any intermediate accumulator values.  This increases the chance of
+ *   detecting bugs that occur only in rare cases where the accumulator values
+ *   get very large, for example the bug fixed by commit 678cce4019d746da
+ *   ("crypto: x86/poly1305 - fix overflow during partial reduction").
+ *
+ * Accumulator overflow bugs may be specific to particular update lengths (in
+ * blocks) and/or particular values of the previous acculumator.  Note that the
+ * accumulator starts at 0 which gives the lowest chance of an overflow.  Thus,
+ * a single all-one-bits test vector may be insufficient.
+ *
+ * Considering that, do the following test: continuously update a single
+ * Poly1305 context with all-one-bits data of varying lengths (0, 16, 32, ...,
+ * 4096 bytes).  After each update, generate the MAC from the current context,
+ * and feed that MAC into a separate Poly1305 context.  Repeat that entire
+ * sequence of updates 32 times without re-initializing either context,
+ * resulting in a total of 8224 MAC computations from a long-running, cumulative
+ * context.  Finally, generate and verify the MAC of all the MACs.
+ */
+static void test_poly1305_allones_keys_and_message(struct kunit *test)
+{
+	struct poly1305_desc_ctx mac_ctx, macofmacs_ctx;
+	u8 mac[POLY1305_DIGEST_SIZE];
+
+	static_assert(TEST_BUF_LEN >= 4096);
+	memset(test_buf, 0xff, 4096);
+
+	poly1305_init(&mac_ctx, test_buf);
+	poly1305_init(&macofmacs_ctx, test_buf);
+	for (int i = 0; i < 32; i++) {
+		for (size_t len = 0; len <= 4096; len += 16) {
+			struct poly1305_desc_ctx tmp_ctx;
+
+			poly1305_update(&mac_ctx, test_buf, len);
+			tmp_ctx = mac_ctx;
+			poly1305_final(&tmp_ctx, mac);
+			poly1305_update(&macofmacs_ctx, mac,
+					POLY1305_DIGEST_SIZE);
+		}
+	}
+	poly1305_final(&macofmacs_ctx, mac);
+	KUNIT_ASSERT_MEMEQ(test, mac, poly1305_allones_macofmacs,
+			   POLY1305_DIGEST_SIZE);
+}
+
+/*
+ * Poly1305 test case which uses r_key=1, s_key=0, and a 48-byte message
+ * consisting of three blocks with integer values [2**128 - i, 0, 0].  In this
+ * case, the result of the polynomial evaluation is 2**130 - i.  For small
+ * values of i, this is very close to the modulus 2**130 - 5, which helps catch
+ * edge case bugs in the modular reduction logic.
+ */
+static void test_poly1305_reduction_edge_cases(struct kunit *test)
+{
+	static const u8 key[POLY1305_KEY_SIZE] = { 1 }; /* r_key=1, s_key=0 */
+	u8 data[3 * POLY1305_BLOCK_SIZE] = {};
+	u8 expected_mac[POLY1305_DIGEST_SIZE];
+	u8 actual_mac[POLY1305_DIGEST_SIZE];
+
+	for (int i = 1; i <= 10; i++) {
+		/* Set the first data block to 2**128 - i. */
+		data[0] = -i;
+		memset(&data[1], 0xff, POLY1305_BLOCK_SIZE - 1);
+
+		/*
+		 * Assuming s_key=0, the expected MAC as an integer is
+		 * (2**130 - i mod 2**130 - 5) + 0 mod 2**128.  If 1 <= i <= 5,
+		 * that's 5 - i.  If 6 <= i <= 10, that's 2**128 - i.
+		 */
+		if (i <= 5) {
+			expected_mac[0] = 5 - i;
+			memset(&expected_mac[1], 0, POLY1305_DIGEST_SIZE - 1);
+		} else {
+			expected_mac[0] = -i;
+			memset(&expected_mac[1], 0xff,
+			       POLY1305_DIGEST_SIZE - 1);
+		}
+
+		/* Compute and verify the MAC. */
+		poly1305(key, data, sizeof(data), actual_mac);
+		KUNIT_ASSERT_MEMEQ(test, actual_mac, expected_mac,
+				   POLY1305_DIGEST_SIZE);
+	}
+}
+
+static struct kunit_case poly1305_test_cases[] = {
+	HASH_KUNIT_CASES,
+	KUNIT_CASE(test_poly1305_allones_keys_and_message),
+	KUNIT_CASE(test_poly1305_reduction_edge_cases),
+	KUNIT_CASE(benchmark_hash),
+	{},
+};
+
+static struct kunit_suite poly1305_test_suite = {
+	.name = "poly1305",
+	.test_cases = poly1305_test_cases,
+	.suite_init = poly1305_suite_init,
+	.suite_exit = poly1305_suite_exit,
+};
+kunit_test_suite(poly1305_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for Poly1305");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
index 55f1010339a6..0461f39d3cf0 100755
--- a/scripts/crypto/gen-hash-testvecs.py
+++ b/scripts/crypto/gen-hash-testvecs.py
@@ -22,11 +22,40 @@ def rand_bytes(length):
     for _ in range(length):
         seed = (seed * 25214903917 + 11) % 2**48
         out.append((seed >> 16) % 256)
     return bytes(out)
 
+POLY1305_KEY_SIZE = 32
+
+# A straightforward, unoptimized implementation of Poly1305.
+class Poly1305:
+    def __init__(self, key):
+        assert len(key) == POLY1305_KEY_SIZE
+        self.h = 0
+        rclamp = 0x0ffffffc0ffffffc0ffffffc0fffffff
+        self.r = int.from_bytes(key[:16], byteorder='little') & rclamp
+        self.s = int.from_bytes(key[16:], byteorder='little')
+
+    # Note: this supports partial blocks only at the end.
+    def update(self, data):
+        for i in range(0, len(data), 16):
+            chunk = data[i:i+16]
+            c = int.from_bytes(chunk, byteorder='little') + 2**(8 * len(chunk))
+            self.h = ((self.h + c) * self.r) % (2**130 - 5)
+        return self
+
+    # Note: gen_additional_poly1305_testvecs() relies on this being
+    # nondestructive, i.e. not changing any field of self.
+    def digest(self):
+        m = (self.h + self.s) % 2**128
+        return m.to_bytes(16, byteorder='little')
+
 def hash_init(alg):
+    if alg == 'poly1305':
+        # Use a fixed random key here, to present Poly1305 as an unkeyed hash.
+        # This allows all the test cases for unkeyed hashes to work on Poly1305.
+        return Poly1305(rand_bytes(POLY1305_KEY_SIZE))
     return hashlib.new(alg)
 
 def hash_update(ctx, data):
     ctx.update(data)
 
@@ -87,16 +116,31 @@ def gen_hmac_testvecs(alg):
         ctx.update(mac)
     print_static_u8_array_definition(
             f'hmac_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
             ctx.digest())
 
+def gen_additional_poly1305_testvecs():
+    key = b'\xff' * POLY1305_KEY_SIZE
+    data = b''
+    ctx = Poly1305(key)
+    for _ in range(32):
+        for j in range(0, 4097, 16):
+            ctx.update(b'\xff' * j)
+            data += ctx.digest()
+    print_static_u8_array_definition(
+            'poly1305_allones_macofmacs[POLY1305_DIGEST_SIZE]',
+            Poly1305(key).update(data).digest())
+
 if len(sys.argv) != 2:
     sys.stderr.write('Usage: gen-hash-testvecs.py ALGORITHM\n')
-    sys.stderr.write('ALGORITHM may be any supported by Python hashlib.\n')
+    sys.stderr.write('ALGORITHM may be any supported by Python hashlib, or poly1305.\n')
     sys.stderr.write('Example: gen-hash-testvecs.py sha512\n')
     sys.exit(1)
 
 alg = sys.argv[1]
 print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
 print(f'/* This file was generated by: {sys.argv[0]} {" ".join(sys.argv[1:])} */')
 gen_unkeyed_testvecs(alg)
-gen_hmac_testvecs(alg)
+if alg == 'poly1305':
+    gen_additional_poly1305_testvecs()
+else:
+    gen_hmac_testvecs(alg)
-- 
2.50.0

