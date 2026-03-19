Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBEA346E6C;
	Thu, 19 Mar 2026 06:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901156; cv=none; b=cZUdc+rNdw6iKXl+8MAo5T5xoXwJCYqRd+7gujj8RE3G0Q6K+75yW4peVdaYRdRsuKUzlCvwHzWqRqSEtU9f8WXsljpff6xxB4MaE/3ZmSl9DxjnixGLsUIcRtwOfirfa+DR1Nd6ZldXwYgI2ihJ2p+K/3k/9EUzdFYhQ3268wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901156; c=relaxed/simple;
	bh=XUHU2r86SR48mQ3AE6CcnrCUHzAbQqfAQdblCGnw44Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7cbS3XDEZXS8Ne2V5IHHTs0ICnhhE68gkuZW8K6BXeIyjJok8YErk3kn8nKSiomWYfKqwGdXYCguCIknj19qvp7FevVRMW8MuXc1OaH5LExAp50PD4J45U6ZH+mZVptbampuxHICAUgQYctgepJ3yUFVtUIqZSFKi+0WNdFxGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uw8zDhbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uw8zDhbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47733C2BCB0;
	Thu, 19 Mar 2026 06:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901156;
	bh=XUHU2r86SR48mQ3AE6CcnrCUHzAbQqfAQdblCGnw44Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw8zDhbSvx+0bDfe49vNP7qxI4XvC7y/00dzjALest3xnJ6DnvxDCmylSODAjFt3o
	 e8uG5uW6fjK6blRywulpbwIhV34QJLV1BcQQH9FMeLKMKnVLCylVZovOutL220lAld
	 R6QcZAgmBaVebxt8eGh4UZRV19fLzHMU3FGkM+3e0MyBvaUMBJOz/DQpbHkt5GOAOx
	 /+HHE6mgINMhNK6wsCQf3cqgIqMJVg7A9sWGyDFVhvh4uEig95DQM8xxG2mc+wmdQr
	 tVme4a8MU1QqzKOJjFh8Kv20uPE6WFtaFjUiA1p/HxGWpJTbOipPg2eeHrP2G2b1fT
	 XkrLTWlMOgOWQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/19] lib/crypto: tests: Add KUnit tests for GHASH
Date: Wed, 18 Mar 2026 23:17:05 -0700
Message-ID: <20260319061723.1140720-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for the GHASH library functions.

It closely mirrors the POLYVAL test suite.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig             |   1 +
 lib/crypto/tests/Kconfig            |   8 ++
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/ghash-testvecs.h   | 186 ++++++++++++++++++++++++++
 lib/crypto/tests/ghash_kunit.c      | 194 ++++++++++++++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py |  63 ++++++++-
 6 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100644 lib/crypto/tests/ghash-testvecs.h
 create mode 100644 lib/crypto/tests/ghash_kunit.c

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 63a592731d1d..391836511c8b 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -4,10 +4,11 @@ CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_GHASH_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_NH_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index aa627b6b9855..279ff1a339be 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -33,10 +33,18 @@ config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
 
+config CRYPTO_LIB_GHASH_KUNIT_TEST
+	tristate "KUnit tests for GHASH" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_GF128HASH
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	help
+	  KUnit tests for GHASH library functions.
+
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_MD5
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index f864e0ffbee4..751ae507fdd0 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -2,10 +2,11 @@
 
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST) += curve25519_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_GHASH_KUNIT_TEST) += ghash_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST) += md5_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST) += mldsa_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_NH_KUNIT_TEST) += nh_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST) += poly1305_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST) += polyval_kunit.o
diff --git a/lib/crypto/tests/ghash-testvecs.h b/lib/crypto/tests/ghash-testvecs.h
new file mode 100644
index 000000000000..759eb4072336
--- /dev/null
+++ b/lib/crypto/tests/ghash-testvecs.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by: ./scripts/crypto/gen-hash-testvecs.py ghash */
+
+static const struct {
+	size_t data_len;
+	u8 digest[GHASH_DIGEST_SIZE];
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
+			0x13, 0x91, 0xa1, 0x11, 0x08, 0xc3, 0x7e, 0xeb,
+			0x21, 0x42, 0x4a, 0xd6, 0x45, 0x0f, 0x41, 0xa7,
+		},
+	},
+	{
+		.data_len = 2,
+		.digest = {
+			0xde, 0x00, 0x63, 0x3f, 0x71, 0x0f, 0xc6, 0x29,
+			0x53, 0x2e, 0x49, 0xd9, 0xc2, 0xb7, 0x73, 0xce,
+		},
+	},
+	{
+		.data_len = 3,
+		.digest = {
+			0xcf, 0xc7, 0xa8, 0x20, 0x24, 0xe9, 0x7a, 0x6c,
+			0x2c, 0x2a, 0x34, 0x70, 0x26, 0xba, 0xd5, 0x9a,
+		},
+	},
+	{
+		.data_len = 16,
+		.digest = {
+			0xaa, 0xe0, 0xdc, 0x7f, 0xcf, 0x8b, 0xe6, 0x0c,
+			0x2e, 0x93, 0x89, 0x7d, 0x68, 0x4e, 0xc2, 0x63,
+		},
+	},
+	{
+		.data_len = 32,
+		.digest = {
+			0x4b, 0x8b, 0x93, 0x5c, 0x79, 0xad, 0x85, 0x08,
+			0xd3, 0x8a, 0xcd, 0xdd, 0x4c, 0x6e, 0x0e, 0x6f,
+		},
+	},
+	{
+		.data_len = 48,
+		.digest = {
+			0xfa, 0xa0, 0x25, 0xdd, 0x61, 0x9a, 0x52, 0x9a,
+			0xea, 0xee, 0xc6, 0x62, 0xb2, 0xba, 0x11, 0x49,
+		},
+	},
+	{
+		.data_len = 49,
+		.digest = {
+			0x23, 0xf1, 0x05, 0xeb, 0x30, 0x40, 0xb9, 0x1d,
+			0xe6, 0x35, 0x51, 0x4e, 0x0f, 0xc0, 0x1b, 0x9e,
+		},
+	},
+	{
+		.data_len = 63,
+		.digest = {
+			0x8d, 0xcf, 0xa0, 0xc8, 0x83, 0x21, 0x06, 0x81,
+			0xc6, 0x36, 0xd5, 0x62, 0xbf, 0xa0, 0xcd, 0x9c,
+		},
+	},
+	{
+		.data_len = 64,
+		.digest = {
+			0xe7, 0xca, 0xbe, 0xe7, 0x66, 0xc8, 0x85, 0xad,
+			0xbc, 0xaf, 0x58, 0x21, 0xd7, 0x67, 0x82, 0x15,
+		},
+	},
+	{
+		.data_len = 65,
+		.digest = {
+			0x9f, 0x48, 0x10, 0xd9, 0xa2, 0x6b, 0x9d, 0xe0,
+			0xb1, 0x87, 0xe1, 0x39, 0xc3, 0xd7, 0xee, 0x09,
+		},
+	},
+	{
+		.data_len = 127,
+		.digest = {
+			0xa4, 0x36, 0xb7, 0x82, 0xd2, 0x67, 0x7e, 0xaf,
+			0x5d, 0xfd, 0x67, 0x9c, 0x1d, 0x9f, 0xe4, 0xf7,
+		},
+	},
+	{
+		.data_len = 128,
+		.digest = {
+			0x57, 0xe7, 0x1d, 0x78, 0xf0, 0x8e, 0xc7, 0x0c,
+			0x15, 0xee, 0x18, 0xc4, 0xd1, 0x75, 0x90, 0xaa,
+		},
+	},
+	{
+		.data_len = 129,
+		.digest = {
+			0x9b, 0xad, 0x81, 0xa9, 0x22, 0xb2, 0x19, 0x53,
+			0x60, 0x30, 0xe7, 0xa0, 0x4f, 0xd6, 0x72, 0x42,
+		},
+	},
+	{
+		.data_len = 256,
+		.digest = {
+			0xf7, 0x33, 0x42, 0xbf, 0x58, 0xde, 0x88, 0x0f,
+			0x8d, 0x3d, 0xa6, 0x11, 0x14, 0xc3, 0xf1, 0xdc,
+		},
+	},
+	{
+		.data_len = 511,
+		.digest = {
+			0x59, 0xdc, 0xa9, 0xc0, 0x4e, 0xd6, 0x97, 0xb3,
+			0x60, 0xaf, 0xa8, 0xa0, 0xea, 0x54, 0x8e, 0xc3,
+		},
+	},
+	{
+		.data_len = 513,
+		.digest = {
+			0xa2, 0x23, 0x37, 0xcc, 0x97, 0xec, 0xea, 0xbe,
+			0xd6, 0xc7, 0x13, 0xf7, 0x93, 0x73, 0xc0, 0x64,
+		},
+	},
+	{
+		.data_len = 1000,
+		.digest = {
+			0x46, 0x8b, 0x43, 0x77, 0x9b, 0xc2, 0xfc, 0xa4,
+			0x68, 0x6a, 0x6c, 0x07, 0xa4, 0x6f, 0x47, 0x65,
+		},
+	},
+	{
+		.data_len = 3333,
+		.digest = {
+			0x69, 0x7f, 0x19, 0xc3, 0xb9, 0xa4, 0xff, 0x40,
+			0xe3, 0x03, 0x71, 0xa3, 0x88, 0x8a, 0xf1, 0xbd,
+		},
+	},
+	{
+		.data_len = 4096,
+		.digest = {
+			0x4d, 0x65, 0xe6, 0x9c, 0xeb, 0x6a, 0x46, 0x8d,
+			0xe9, 0x32, 0x96, 0x72, 0xb3, 0x0d, 0x08, 0xa9,
+		},
+	},
+	{
+		.data_len = 4128,
+		.digest = {
+			0xfc, 0xa1, 0x74, 0x46, 0x21, 0x64, 0xa7, 0x64,
+			0xbe, 0x47, 0x03, 0x1e, 0x05, 0xf7, 0xd8, 0x37,
+		},
+	},
+	{
+		.data_len = 4160,
+		.digest = {
+			0x70, 0x5b, 0xe9, 0x17, 0xab, 0xd5, 0xa2, 0xee,
+			0xcb, 0x39, 0xa4, 0x81, 0x2f, 0x41, 0x70, 0xae,
+		},
+	},
+	{
+		.data_len = 4224,
+		.digest = {
+			0x07, 0xbd, 0xb6, 0x52, 0xe2, 0x75, 0x2c, 0x33,
+			0x6d, 0x1b, 0x63, 0x56, 0x58, 0xda, 0x98, 0x55,
+		},
+	},
+	{
+		.data_len = 16384,
+		.digest = {
+			0x9c, 0xb5, 0xf4, 0x14, 0xe8, 0xa8, 0x4a, 0xde,
+			0xee, 0x7b, 0xbb, 0xd6, 0x21, 0x6d, 0x6a, 0x69,
+		},
+	},
+};
+
+static const u8 hash_testvec_consolidated[GHASH_DIGEST_SIZE] = {
+	0x08, 0xef, 0xf5, 0x27, 0xb1, 0xca, 0xd4, 0x1d,
+	0xad, 0x38, 0x69, 0x88, 0x6b, 0x16, 0xdf, 0xa8,
+};
+
+static const u8 ghash_allones_hashofhashes[GHASH_DIGEST_SIZE] = {
+	0xef, 0x85, 0x58, 0xf8, 0x54, 0x9c, 0x5e, 0x54,
+	0xd9, 0xbe, 0x04, 0x1f, 0xff, 0xff, 0xff, 0xff,
+};
diff --git a/lib/crypto/tests/ghash_kunit.c b/lib/crypto/tests/ghash_kunit.c
new file mode 100644
index 000000000000..68b3837a3607
--- /dev/null
+++ b/lib/crypto/tests/ghash_kunit.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/gf128hash.h>
+#include "ghash-testvecs.h"
+
+/*
+ * A fixed key used when presenting GHASH as an unkeyed hash function in order
+ * to reuse hash-test-template.h.  At the beginning of the test suite, this is
+ * initialized to a key prepared from bytes generated from a fixed seed.
+ */
+static struct ghash_key test_key;
+
+static void ghash_init_withtestkey(struct ghash_ctx *ctx)
+{
+	ghash_init(ctx, &test_key);
+}
+
+static void ghash_withtestkey(const u8 *data, size_t len,
+			      u8 out[GHASH_BLOCK_SIZE])
+{
+	ghash(&test_key, data, len, out);
+}
+
+/* Generate the HASH_KUNIT_CASES using hash-test-template.h. */
+#define HASH ghash_withtestkey
+#define HASH_CTX ghash_ctx
+#define HASH_SIZE GHASH_BLOCK_SIZE
+#define HASH_INIT ghash_init_withtestkey
+#define HASH_UPDATE ghash_update
+#define HASH_FINAL ghash_final
+#include "hash-test-template.h"
+
+/*
+ * Test a key and messages containing all one bits.  This is useful to detect
+ * overflow bugs in implementations that emulate carryless multiplication using
+ * a series of standard multiplications with the bits spread out.
+ */
+static void test_ghash_allones_key_and_message(struct kunit *test)
+{
+	struct ghash_key key;
+	struct ghash_ctx hashofhashes_ctx;
+	u8 hash[GHASH_BLOCK_SIZE];
+
+	static_assert(TEST_BUF_LEN >= 4096);
+	memset(test_buf, 0xff, 4096);
+
+	ghash_preparekey(&key, test_buf);
+	ghash_init(&hashofhashes_ctx, &key);
+	for (size_t len = 0; len <= 4096; len += 16) {
+		ghash(&key, test_buf, len, hash);
+		ghash_update(&hashofhashes_ctx, hash, sizeof(hash));
+	}
+	ghash_final(&hashofhashes_ctx, hash);
+	KUNIT_ASSERT_MEMEQ(test, hash, ghash_allones_hashofhashes,
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
+				  const struct ghash_key *key1,
+				  const struct ghash_key *key2)
+{
+	u8 *data = test_buf;
+	u8 hash1[GHASH_BLOCK_SIZE];
+	u8 hash2[GHASH_BLOCK_SIZE];
+
+	rand_bytes(data, MAX_LEN_FOR_KEY_CHECK);
+	KUNIT_ASSERT_MEMEQ(test, key1, key2, sizeof(*key1));
+
+	for (int i = 0; i < 100; i++) {
+		size_t len = rand_length(MAX_LEN_FOR_KEY_CHECK);
+
+		ghash(key1, data, len, hash1);
+		ghash(key2, data, len, hash2);
+		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, sizeof(hash1));
+	}
+}
+
+/* Test that no buffer overreads occur on either raw_key or ghash_key. */
+static void test_ghash_with_guarded_key(struct kunit *test)
+{
+	u8 raw_key[GHASH_BLOCK_SIZE];
+	u8 *guarded_raw_key = &test_buf[TEST_BUF_LEN - sizeof(raw_key)];
+	struct ghash_key key1, key2;
+	struct ghash_key *guarded_key =
+		(struct ghash_key *)&test_buf[TEST_BUF_LEN - sizeof(key1)];
+
+	/* Prepare with regular buffers. */
+	rand_bytes(raw_key, sizeof(raw_key));
+	ghash_preparekey(&key1, raw_key);
+
+	/* Prepare with guarded raw_key, then check that it works. */
+	memcpy(guarded_raw_key, raw_key, sizeof(raw_key));
+	ghash_preparekey(&key2, guarded_raw_key);
+	check_key_consistency(test, &key1, &key2);
+
+	/* Prepare guarded ghash_key, then check that it works. */
+	ghash_preparekey(guarded_key, raw_key);
+	check_key_consistency(test, &key1, guarded_key);
+}
+
+/*
+ * Test that ghash_key only needs to be aligned to
+ * __alignof__(struct ghash_key), i.e. 8 bytes.  The assembly code may prefer
+ * 16-byte or higher alignment, but it mustn't require it.
+ */
+static void test_ghash_with_minimally_aligned_key(struct kunit *test)
+{
+	u8 raw_key[GHASH_BLOCK_SIZE];
+	struct ghash_key key;
+	struct ghash_key *minaligned_key =
+		(struct ghash_key *)&test_buf[MAX_LEN_FOR_KEY_CHECK +
+					      __alignof__(struct ghash_key)];
+
+	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key,
+					   __alignof__(struct ghash_key)));
+	KUNIT_ASSERT_TRUE(test, !IS_ALIGNED((uintptr_t)minaligned_key,
+					    2 * __alignof__(struct ghash_key)));
+
+	rand_bytes(raw_key, sizeof(raw_key));
+	ghash_preparekey(&key, raw_key);
+	ghash_preparekey(minaligned_key, raw_key);
+	check_key_consistency(test, &key, minaligned_key);
+}
+
+struct ghash_irq_test_state {
+	struct ghash_key expected_key;
+	u8 raw_key[GHASH_BLOCK_SIZE];
+};
+
+static bool ghash_irq_test_func(void *state_)
+{
+	struct ghash_irq_test_state *state = state_;
+	struct ghash_key key;
+
+	ghash_preparekey(&key, state->raw_key);
+	return memcmp(&key, &state->expected_key, sizeof(key)) == 0;
+}
+
+/*
+ * Test that ghash_preparekey() produces the same output regardless of whether
+ * FPU or vector registers are usable when it is called.
+ */
+static void test_ghash_preparekey_in_irqs(struct kunit *test)
+{
+	struct ghash_irq_test_state state;
+
+	rand_bytes(state.raw_key, sizeof(state.raw_key));
+	ghash_preparekey(&state.expected_key, state.raw_key);
+	kunit_run_irq_test(test, ghash_irq_test_func, 200000, &state);
+}
+
+static int ghash_suite_init(struct kunit_suite *suite)
+{
+	u8 raw_key[GHASH_BLOCK_SIZE];
+
+	rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
+	ghash_preparekey(&test_key, raw_key);
+	return hash_suite_init(suite);
+}
+
+static void ghash_suite_exit(struct kunit_suite *suite)
+{
+	hash_suite_exit(suite);
+}
+
+static struct kunit_case ghash_test_cases[] = {
+	HASH_KUNIT_CASES,
+	KUNIT_CASE(test_ghash_allones_key_and_message),
+	KUNIT_CASE(test_ghash_with_guarded_key),
+	KUNIT_CASE(test_ghash_with_minimally_aligned_key),
+	KUNIT_CASE(test_ghash_preparekey_in_irqs),
+	KUNIT_CASE(benchmark_hash),
+	{},
+};
+
+static struct kunit_suite ghash_test_suite = {
+	.name = "ghash",
+	.test_cases = ghash_test_cases,
+	.suite_init = ghash_suite_init,
+	.suite_exit = ghash_suite_exit,
+};
+kunit_test_suite(ghash_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for GHASH");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
index 34b7c48f3456..e69ce213fb33 100755
--- a/scripts/crypto/gen-hash-testvecs.py
+++ b/scripts/crypto/gen-hash-testvecs.py
@@ -66,10 +66,56 @@ class Poly1305:
     # nondestructive, i.e. not changing any field of self.
     def digest(self):
         m = (self.h + self.s) % 2**128
         return m.to_bytes(16, byteorder='little')
 
+GHASH_POLY = sum((1 << i) for i in [128, 7, 2, 1, 0])
+GHASH_BLOCK_SIZE = 16
+
+# A straightforward, unoptimized implementation of GHASH.
+class Ghash:
+
+    @staticmethod
+    def reflect_bits_in_bytes(v):
+        res = 0
+        for offs in range(0, 128, 8):
+            for bit in range(8):
+                if (v & (1 << (offs + bit))) != 0:
+                    res ^= 1 << (offs + 7 - bit)
+        return res
+
+    @staticmethod
+    def bytes_to_poly(data):
+        return Ghash.reflect_bits_in_bytes(int.from_bytes(data, byteorder='little'))
+
+    @staticmethod
+    def poly_to_bytes(poly):
+        return Ghash.reflect_bits_in_bytes(poly).to_bytes(16, byteorder='little')
+
+    def __init__(self, key):
+        assert len(key) == 16
+        self.h = Ghash.bytes_to_poly(key)
+        self.acc = 0
+
+    # Note: this supports partial blocks only at the end.
+    def update(self, data):
+        for i in range(0, len(data), 16):
+            # acc += block
+            self.acc ^= Ghash.bytes_to_poly(data[i:i+16])
+            # acc = (acc * h) mod GHASH_POLY
+            product = 0
+            for j in range(127, -1, -1):
+                if (self.h & (1 << j)) != 0:
+                    product ^= self.acc << j
+                if (product & (1 << (128 + j))) != 0:
+                    product ^= GHASH_POLY << j
+            self.acc = product
+        return self
+
+    def digest(self):
+        return Ghash.poly_to_bytes(self.acc)
+
 POLYVAL_POLY = sum((1 << i) for i in [128, 127, 126, 121, 0])
 POLYVAL_BLOCK_SIZE = 16
 
 # A straightforward, unoptimized implementation of POLYVAL.
 # Reference: https://datatracker.ietf.org/doc/html/rfc8452
@@ -101,10 +147,12 @@ def hash_init(alg):
     # The keyed hash functions are assigned a fixed random key here, to present
     # them as unkeyed hash functions.  This allows all the test cases for
     # unkeyed hash functions to work on them.
     if alg == 'aes-cmac':
         return AesCmac(rand_bytes(AES_256_KEY_SIZE))
+    if alg == 'ghash':
+        return Ghash(rand_bytes(GHASH_BLOCK_SIZE))
     if alg == 'poly1305':
         return Poly1305(rand_bytes(POLY1305_KEY_SIZE))
     if alg == 'polyval':
         return Polyval(rand_bytes(POLYVAL_BLOCK_SIZE))
     return hashlib.new(alg)
@@ -255,10 +303,19 @@ def gen_additional_poly1305_testvecs():
             data += ctx.digest()
     print_static_u8_array_definition(
             'poly1305_allones_macofmacs[POLY1305_DIGEST_SIZE]',
             Poly1305(key).update(data).digest())
 
+def gen_additional_ghash_testvecs():
+    key = b'\xff' * GHASH_BLOCK_SIZE
+    hashes = b''
+    for data_len in range(0, 4097, 16):
+        hashes += Ghash(key).update(b'\xff' * data_len).digest()
+    print_static_u8_array_definition(
+            'ghash_allones_hashofhashes[GHASH_DIGEST_SIZE]',
+            Ghash(key).update(hashes).digest())
+
 def gen_additional_polyval_testvecs():
     key = b'\xff' * POLYVAL_BLOCK_SIZE
     hashes = b''
     for data_len in range(0, 4097, 16):
         hashes += Polyval(key).update(b'\xff' * data_len).digest()
@@ -266,11 +323,12 @@ def gen_additional_polyval_testvecs():
             'polyval_allones_hashofhashes[POLYVAL_DIGEST_SIZE]',
             Polyval(key).update(hashes).digest())
 
 if len(sys.argv) != 2:
     sys.stderr.write('Usage: gen-hash-testvecs.py ALGORITHM\n')
-    sys.stderr.write('ALGORITHM may be any supported by Python hashlib; or poly1305, polyval, or sha3.\n')
+    sys.stderr.write('ALGORITHM may be any supported by Python hashlib;\n')
+    sys.stderr.write('  or aes-cmac, ghash, nh, poly1305, polyval, or sha3.\n')
     sys.stderr.write('Example: gen-hash-testvecs.py sha512\n')
     sys.exit(1)
 
 alg = sys.argv[1]
 print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
@@ -278,10 +336,13 @@ print(f'/* This file was generated by: {sys.argv[0]} {" ".join(sys.argv[1:])} */
 if alg == 'aes-cmac':
     gen_unkeyed_testvecs(alg)
 elif alg.startswith('blake2'):
     gen_unkeyed_testvecs(alg)
     gen_additional_blake2_testvecs(alg)
+elif alg == 'ghash':
+    gen_unkeyed_testvecs(alg)
+    gen_additional_ghash_testvecs()
 elif alg == 'nh':
     gen_nh_testvecs()
 elif alg == 'poly1305':
     gen_unkeyed_testvecs(alg)
     gen_additional_poly1305_testvecs()
-- 
2.53.0

