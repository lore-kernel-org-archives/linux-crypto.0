Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B7334D929;
	Mon, 25 May 2026 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779734780; cv=none; b=BhKgIHd9HRI52KJpqqN686euriPxNFTafO95TjJmHYtMCzPY3zVA9jrTCiAtdUZNYg6FaFWL1NpnuBLWWxJDfxVDNO3+mM8ccDXU57r4XB+t/ZkYzqzNvmxNmuuQuNv2YE2qIO0zRl+OmG6G7WPnM4mPiqL+obEb0VJK+edVXFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779734780; c=relaxed/simple;
	bh=ONa/z/wh2yp8q6YNFz/SORRY5v/ZgxGahlYFEnLm+zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCRU+Sy/S7FlbC3q8hwirjFfgRiyb9RlPPnwr0obrlF+mniIi3MgfLHosiyS7aBgopEl5psxdIEtIS74hXhFtLpTarpL6oCxPN3Gvqhk6Ebx8MtcHSbqfUJXgWtWFfjB6w/+lEeAHVDzWZztQBBQ7W2vXHVqNkN2qLYDHVv64jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOzcbfEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOzcbfEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86A21F00A3E;
	Mon, 25 May 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779734772;
	bh=W/FmrHvlhLGvOsbMYCNEUApSzrdreWnYrhUk2lzfEUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOzcbfEzkMgcDNf/YlPAovVUZ0Qahf03s1u8a3mPpZGHTSZhCN5olp40atCyyTG+l
	 7i70/m3JeMWDRUxfWin5GeTHQV6SYoM1yerUAHBmAjVri1RwVppZJh9jksGOfTS6dC
	 qyDepxW2+2VZi4LtVFWpIw6JZxiFldfaO/K2k7MXLZ8oA4GrKPhcWW0ZQH1zNz2M1k
	 xrGLNwwVDoSnOjL8tpGUC10ncW1LOiE1MN53LKCvigHTLKmDpa4djd330lBAHIjg7a
	 /jdStIEQW2BvvPKRNAMhZ8nbCyy7XorQhSwBMmawWlHfkMmbxhp9XqQoS0I0NB063/
	 exee2KZ+/etTA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ryan Appel <ryan.appel.333@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/5] lib/crypto: mlkem: Add KUnit tests for ML-KEM
Date: Mon, 25 May 2026 13:44:00 -0500
Message-ID: <20260525184403.101818-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525184403.101818-1-ebiggers@kernel.org>
References: <20260525184403.101818-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for ML-KEM.

For each supported ML-KEM parameter set, it includes:

- Test key generation, encapsulation, and decapsulation against the
  first 1000 test vectors from the reference implementation
- Test encapsulation/decapsulation round trips
- Test validation of malformed keys
- Test that every byte of the ciphertext is validated
- Test the reduce_once(), reduce(), compress_d(), and decompress_d()
  functions with all allowed inputs
- Benchmark key generation, encapsulation, and decapsulation

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/mlkem.h                  |   8 +
 lib/crypto/.kunitconfig                 |   1 +
 lib/crypto/mlkem.c                      |  27 ++
 lib/crypto/tests/Kconfig                |   9 +
 lib/crypto/tests/Makefile               |   1 +
 lib/crypto/tests/mlkem-testvecs.h       |  19 +
 lib/crypto/tests/mlkem_kunit.c          | 520 ++++++++++++++++++++++++
 scripts/crypto/import-mlkem-testvecs.py | 117 ++++++
 8 files changed, 702 insertions(+)
 create mode 100644 lib/crypto/tests/mlkem-testvecs.h
 create mode 100644 lib/crypto/tests/mlkem_kunit.c
 create mode 100755 scripts/crypto/import-mlkem-testvecs.py

diff --git a/include/crypto/mlkem.h b/include/crypto/mlkem.h
index e33d065c5442..679bd47c8c0b 100644
--- a/include/crypto/mlkem.h
+++ b/include/crypto/mlkem.h
@@ -146,6 +146,14 @@ int mlkem1024_keygen_internal(u8 pk[MLKEM1024_PUBLIC_KEY_BYTES],
 int mlkem1024_encaps_internal(u8 ct[MLKEM1024_CIPHERTEXT_BYTES],
 			      u8 ss[MLKEM_SHARED_SECRET_BYTES],
 			      const u8 pk[MLKEM1024_PUBLIC_KEY_BYTES],
 			      const u8 eseed[MLKEM_ESEED_BYTES]);
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_MLKEM_KUNIT_TEST)
+/* Functions exported for KUnit testing only */
+u16 mlkem_reduce_once(u16 x);
+u16 mlkem_reduce(u32 x);
+u16 mlkem_compress_d(u16 x, int d);
+u16 mlkem_decompress_d(u16 x, int d);
+#endif
+
 #endif /* _CRYPTO_MLKEM_H */
diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 3efc854a2c08..32e5b4471da8 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -8,10 +8,11 @@ CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_GHASH_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_MLKEM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_NH_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
diff --git a/lib/crypto/mlkem.c b/lib/crypto/mlkem.c
index b800ecb49f24..5e499e5de636 100644
--- a/lib/crypto/mlkem.c
+++ b/lib/crypto/mlkem.c
@@ -8,10 +8,11 @@
  */
 
 #include <crypto/mlkem.h>
 #include <crypto/sha3.h>
 #include <crypto/utils.h>
+#include <kunit/visibility.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -888,7 +889,33 @@ int mlkem1024_decaps(u8 ss[MLKEM_SHARED_SECRET_BYTES],
 {
 	return mlkem_decaps(ss, ct, sk, &mlkem1024);
 }
 EXPORT_SYMBOL_NS_GPL(mlkem1024_decaps, "CRYPTO_INTERNAL");
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_MLKEM_KUNIT_TEST)
+u16 mlkem_reduce_once(u16 x)
+{
+	return reduce_once(x);
+}
+EXPORT_SYMBOL_IF_KUNIT(mlkem_reduce_once);
+
+u16 mlkem_reduce(u32 x)
+{
+	return reduce(x);
+}
+EXPORT_SYMBOL_IF_KUNIT(mlkem_reduce);
+
+u16 mlkem_compress_d(u16 x, int d)
+{
+	return compress_d(x, d);
+}
+EXPORT_SYMBOL_IF_KUNIT(mlkem_compress_d);
+
+u16 mlkem_decompress_d(u16 x, int d)
+{
+	return decompress_d(x, d);
+}
+EXPORT_SYMBOL_IF_KUNIT(mlkem_decompress_d);
+#endif /* CONFIG_CRYPTO_LIB_MLKEM_KUNIT_TEST */
+
 MODULE_DESCRIPTION("ML-KEM (Module-Lattice-Based Key Encapsulation Mechanism)");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 9409c1a935c3..0a110a0733d2 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -67,10 +67,18 @@ config CRYPTO_LIB_MLDSA_KUNIT_TEST
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the ML-DSA digital signature algorithm.
 
+config CRYPTO_LIB_MLKEM_KUNIT_TEST
+	tristate "KUnit tests for ML-KEM" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_MLKEM
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	help
+	  KUnit tests for the ML-KEM key encapsulation mechanism.
+
 config CRYPTO_LIB_NH_KUNIT_TEST
 	tristate "KUnit tests for NH" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_NH
 	default KUNIT_ALL_TESTS
 	help
@@ -149,10 +157,11 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	select CRYPTO_LIB_CHACHA20POLY1305
 	select CRYPTO_LIB_CURVE25519
 	select CRYPTO_LIB_GF128HASH
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_MLDSA
+	select CRYPTO_LIB_MLKEM
 	select CRYPTO_LIB_NH
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index a739413500b6..3a73d2f33f75 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -6,10 +6,11 @@ obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305_KUNIT_TEST) += chacha20poly1305_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST) += curve25519_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_GHASH_KUNIT_TEST) += ghash_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST) += md5_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST) += mldsa_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_MLKEM_KUNIT_TEST) += mlkem_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_NH_KUNIT_TEST) += nh_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST) += poly1305_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST) += polyval_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
diff --git a/lib/crypto/tests/mlkem-testvecs.h b/lib/crypto/tests/mlkem-testvecs.h
new file mode 100644
index 000000000000..207bf38529b2
--- /dev/null
+++ b/lib/crypto/tests/mlkem-testvecs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by import-mlkem-testvecs.py */
+/* clang-format off */
+
+#define MLKEM768_NUM_TESTVECS 1000
+
+static const u8 mlkem768_hash[32] = {
+	0x81, 0xa6, 0x72, 0x68, 0x1c, 0x57, 0xaf, 0xc5, 0x1b, 0xdb, 0xc2, 0xfc,
+	0x08, 0xc0, 0x4a, 0xbe, 0x01, 0xd9, 0xad, 0x5f, 0x1c, 0x77, 0x89, 0xa4,
+	0xa5, 0x98, 0xdf, 0x9d, 0xb2, 0x91, 0xa6, 0x56,
+};
+
+#define MLKEM1024_NUM_TESTVECS 1000
+
+static const u8 mlkem1024_hash[32] = {
+	0x64, 0x4e, 0x58, 0xca, 0x6c, 0xf9, 0xb6, 0x08, 0x07, 0x50, 0xa8, 0x76,
+	0xe6, 0xae, 0xf5, 0xe0, 0x44, 0xce, 0xe1, 0xd9, 0x42, 0x36, 0xb6, 0xc1,
+	0x14, 0xc7, 0x5f, 0x2c, 0x8b, 0xd7, 0x73, 0x77,
+};
diff --git a/lib/crypto/tests/mlkem_kunit.c b/lib/crypto/tests/mlkem_kunit.c
new file mode 100644
index 000000000000..2e9a9203e9a2
--- /dev/null
+++ b/lib/crypto/tests/mlkem_kunit.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit tests and benchmark for ML-KEM
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/mlkem.h>
+#include <crypto/sha3.h>
+#include <kunit/test.h>
+#include "mlkem-testvecs.h"
+
+#define Q 3329
+
+enum mlkem_paramset {
+	MLKEM768,
+	MLKEM1024,
+};
+
+struct mlkem_bufs {
+	u8 *pk, *sk, *ct;
+	size_t pk_len, sk_len, ct_len;
+	u8 ss[MLKEM_SHARED_SECRET_BYTES];
+	u8 seed[MLKEM_SEED_BYTES];
+	u8 eseed[MLKEM_ESEED_BYTES];
+};
+
+static const struct {
+	const char *name;
+	int k;
+	size_t pk_len;
+	size_t sk_len;
+	size_t ct_len;
+} mlkem_paramsets[] = {
+	[MLKEM768] = {
+		.name = "ML-KEM-768",
+		.k = 3,
+		.pk_len = MLKEM768_PUBLIC_KEY_BYTES,
+		.sk_len = MLKEM768_SECRET_KEY_BYTES,
+		.ct_len = MLKEM768_CIPHERTEXT_BYTES,
+	},
+	[MLKEM1024] = {
+		.name = "ML-KEM-1024",
+		.k = 4,
+		.pk_len = MLKEM1024_PUBLIC_KEY_BYTES,
+		.sk_len = MLKEM1024_SECRET_KEY_BYTES,
+		.ct_len = MLKEM1024_CIPHERTEXT_BYTES,
+	},
+};
+
+static struct mlkem_bufs *alloc_bufs(struct kunit *test,
+				     enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs =
+		kunit_kmalloc(test, sizeof(*bufs), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, bufs);
+
+	bufs->pk_len = mlkem_paramsets[paramset].pk_len;
+	bufs->pk = kunit_kmalloc(test, bufs->pk_len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bufs->pk);
+
+	bufs->sk_len = mlkem_paramsets[paramset].sk_len;
+	bufs->sk = kunit_kmalloc(test, bufs->sk_len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bufs->sk);
+
+	bufs->ct_len = mlkem_paramsets[paramset].ct_len;
+	bufs->ct = kunit_kmalloc(test, bufs->ct_len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bufs->ct);
+
+	return bufs;
+}
+
+static int keygen(u8 *pk, u8 *sk, enum mlkem_paramset paramset)
+{
+	switch (paramset) {
+	case MLKEM768:
+		return mlkem768_keygen(pk, sk);
+	case MLKEM1024:
+		return mlkem1024_keygen(pk, sk);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int keygen_internal(u8 *pk, u8 *sk, const u8 seed[MLKEM_SEED_BYTES],
+			   enum mlkem_paramset paramset)
+{
+	switch (paramset) {
+	case MLKEM768:
+		return mlkem768_keygen_internal(pk, sk, seed);
+	case MLKEM1024:
+		return mlkem1024_keygen_internal(pk, sk, seed);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int encaps(u8 *ct, u8 ss[MLKEM_SHARED_SECRET_BYTES], const u8 *pk,
+		  enum mlkem_paramset paramset)
+{
+	switch (paramset) {
+	case MLKEM768:
+		return mlkem768_encaps(ct, ss, pk);
+	case MLKEM1024:
+		return mlkem1024_encaps(ct, ss, pk);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int encaps_internal(u8 *ct, u8 ss[MLKEM_SHARED_SECRET_BYTES],
+			   const u8 *pk, const u8 eseed[MLKEM_ESEED_BYTES],
+			   enum mlkem_paramset paramset)
+{
+	switch (paramset) {
+	case MLKEM768:
+		return mlkem768_encaps_internal(ct, ss, pk, eseed);
+	case MLKEM1024:
+		return mlkem1024_encaps_internal(ct, ss, pk, eseed);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int decaps(u8 ss[MLKEM_SHARED_SECRET_BYTES], const u8 *ct, const u8 *sk,
+		  enum mlkem_paramset paramset)
+{
+	switch (paramset) {
+	case MLKEM768:
+		return mlkem768_decaps(ss, ct, sk);
+	case MLKEM1024:
+		return mlkem1024_decaps(ss, ct, sk);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+/*
+ * Test the ML-KEM implementation against the first 1000 test vectors from the
+ * reference implementation.
+ *
+ * To do this without explicitly including all these test vectors, which would
+ * result in a massive source and binary size, we take advantage of the fact
+ * that the reference test vectors are generated deterministically (by
+ * kyber/ref/tests/test_vectors.c).  We just regenerate them at runtime using
+ * the same algorithm.  We hash all the outputs, then verify that hash against
+ * @expected_cumulative_hash, which proves that all the outputs were correct.
+ */
+static void
+test_mlkem_against_ref_testvecs(struct kunit *test, size_t num_testvecs,
+				const u8 expected_cumulative_hash[32],
+				enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	struct shake_ctx cumulative_hash_ctx;
+	struct shake_ctx seed_ctx;
+	u8 cumulative_hash[32];
+
+	shake128_init(&cumulative_hash_ctx);
+	shake128_init(&seed_ctx);
+	for (size_t i = 0; i < num_testvecs; i++) {
+		/*
+		 * Deterministically generate the next seeds using the same
+		 * algorithm as the reference code's test_vectors.c.
+		 */
+		shake_squeeze(&seed_ctx, bufs->seed, sizeof(bufs->seed));
+		shake_squeeze(&seed_ctx, bufs->eseed, sizeof(bufs->eseed));
+
+		/* KeyGen, then update with (pk, sk) */
+		KUNIT_ASSERT_EQ(test, 0,
+				keygen_internal(bufs->pk, bufs->sk, bufs->seed,
+						paramset));
+		shake_update(&cumulative_hash_ctx, bufs->pk, bufs->pk_len);
+		shake_update(&cumulative_hash_ctx, bufs->sk, bufs->sk_len);
+
+		/* Encaps, then update with (ct, ss) */
+		KUNIT_ASSERT_EQ(test, 0,
+				encaps_internal(bufs->ct, bufs->ss, bufs->pk,
+						bufs->eseed, paramset));
+		shake_update(&cumulative_hash_ctx, bufs->ct, bufs->ct_len);
+		shake_update(&cumulative_hash_ctx, bufs->ss, sizeof(bufs->ss));
+
+		/* Decaps, then update with ss */
+		memset(bufs->ss, 0xff, sizeof(bufs->ss));
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+		shake_update(&cumulative_hash_ctx, bufs->ss, sizeof(bufs->ss));
+
+		/*
+		 * Deterministically generate an invalid ciphertext, using the
+		 * same algorithm as test_vectors.c.  Then do Decaps and update
+		 * with ss_rejected.  This tests the implicit rejection case.
+		 */
+		shake_squeeze(&seed_ctx, bufs->ct, bufs->ct_len);
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+		shake_update(&cumulative_hash_ctx, bufs->ss, sizeof(bufs->ss));
+	}
+	/*
+	 * Finalize and verify the cumulative hash.  This verifies that every
+	 * (pk, sk, ct, ss, ss, ss_rejected) tuple was correct.
+	 */
+	shake_squeeze(&cumulative_hash_ctx, cumulative_hash,
+		      sizeof(cumulative_hash));
+	KUNIT_ASSERT_MEMEQ(test, expected_cumulative_hash, cumulative_hash,
+			   sizeof(cumulative_hash));
+}
+
+static void test_mlkem_round_trip(struct kunit *test,
+				  enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	u8 ss2[MLKEM_SHARED_SECRET_BYTES];
+
+	for (int i = 0; i < 20; i++) {
+		KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+		KUNIT_ASSERT_EQ(test, 0,
+				encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(ss2, bufs->ct, bufs->sk, paramset));
+		KUNIT_ASSERT_MEMEQ(test, bufs->ss, ss2, sizeof(bufs->ss));
+	}
+}
+
+/*
+ * Test that changing any part of the ciphertext results in a different shared
+ * secret due to implicit rejection.
+ */
+static void test_mlkem_rejection(struct kunit *test,
+				 enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	u8 ss2[MLKEM_SHARED_SECRET_BYTES];
+
+	KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+	KUNIT_ASSERT_EQ(test, 0,
+			encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+
+	/* Decapsulate a valid ciphertext. */
+	KUNIT_ASSERT_EQ(test, 0, decaps(ss2, bufs->ct, bufs->sk, paramset));
+	KUNIT_ASSERT_MEMEQ(test, bufs->ss, ss2, sizeof(bufs->ss));
+
+	for (size_t i = 0; i < bufs->ct_len; i++) {
+		/* Corrupt byte i of the ciphertext. */
+		bufs->ct[i] ^= 1;
+
+		/* Decapsulate an invalid ciphertext and assert ss differs. */
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(ss2, bufs->ct, bufs->sk, paramset));
+		KUNIT_ASSERT_MEMNEQ(test, bufs->ss, ss2, sizeof(bufs->ss));
+		/* Undo the ciphertext corruption. */
+		bufs->ct[i] ^= 1;
+	}
+}
+
+/*
+ * Test that the encapsulation function returns -EBADMSG if a coefficient in
+ * NTT(t) in the public key is outside the interval [0, Q - 1].
+ */
+static void test_mlkem_invalid_pk(struct kunit *test,
+				  enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	const size_t ntt_t_len = 384 * mlkem_paramsets[paramset].k;
+
+	for (int i = 0; i < 4; i++) {
+		u16 c;
+
+		KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+		KUNIT_ASSERT_EQ(test, 0,
+				encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+		/*
+		 * Corrupt a coefficient of NTT(t), which is an array of 256*k
+		 * 12-bit coefficients starting at the beginning of pk.
+		 */
+		if (i % 2 == 0)
+			c = Q; /* Low end of invalid range */
+		else
+			c = 0xfff; /* High end of invalid range */
+		if (i < 2) {
+			/* Corrupt the first 12-bit coefficient in NTT(t). */
+			bufs->pk[0] = (c & 0xff);
+			bufs->pk[1] = (bufs->pk[1] & 0xf0) | (c >> 8);
+		} else {
+			/* Corrupt the last 12-bit coefficient in NTT(t). */
+			bufs->pk[ntt_t_len - 2] =
+				(bufs->pk[ntt_t_len - 2] & 0xf) |
+				((c & 0xf) << 4);
+			bufs->pk[ntt_t_len - 1] = c >> 4;
+		}
+		KUNIT_ASSERT_EQ(test, -EBADMSG,
+				encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+	}
+}
+
+/*
+ * Test that the decapsulation function returns -EBADMSG if either:
+ *
+ *    - H(pk) is corrupt
+ *    - A coefficient in NTT(s) is outside the interval [0, Q - 1]
+ */
+static void test_mlkem_invalid_sk(struct kunit *test,
+				  enum mlkem_paramset paramset)
+{
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	const size_t ntt_s_len = 384 * mlkem_paramsets[paramset].k;
+
+	KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+	KUNIT_ASSERT_EQ(test, 0,
+			encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+	KUNIT_ASSERT_EQ(test, 0,
+			decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+
+	/* Corrupt H(pk) in the sk. */
+	bufs->sk[bufs->sk_len - 33] ^= 0x80;
+	KUNIT_ASSERT_EQ(test, -EBADMSG,
+			decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+
+	for (int i = 0; i < 4; i++) {
+		u16 c;
+
+		KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+		KUNIT_ASSERT_EQ(test, 0,
+				encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+
+		/*
+		 * Corrupt a coefficient of NTT(s), which is an array of 256*k
+		 * 12-bit coefficients starting at the beginning of sk.
+		 */
+		if (i % 2 == 0)
+			c = Q; /* Low end of invalid range */
+		else
+			c = 0xfff; /* High end of invalid range */
+		if (i < 2) {
+			/* Corrupt the first 12-bit coefficient in NTT(s). */
+			bufs->sk[0] = (c & 0xff);
+			bufs->sk[1] = (bufs->sk[1] & 0xf0) | (c >> 8);
+		} else {
+			/* Corrupt the last 12-bit coefficient in NTT(s). */
+			bufs->sk[ntt_s_len - 2] =
+				(bufs->sk[ntt_s_len - 2] & 0xf) |
+				((c & 0xf) << 4);
+			bufs->sk[ntt_s_len - 1] = c >> 4;
+		}
+		KUNIT_ASSERT_EQ(test, -EBADMSG,
+				decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+	}
+}
+
+static void test_mlkem(struct kunit *test, size_t num_testvecs,
+		       const u8 expected_cumulative_hash[32],
+		       enum mlkem_paramset paramset)
+{
+	test_mlkem_against_ref_testvecs(test, num_testvecs,
+					expected_cumulative_hash, paramset);
+	test_mlkem_round_trip(test, paramset);
+	test_mlkem_rejection(test, paramset);
+	test_mlkem_invalid_pk(test, paramset);
+	test_mlkem_invalid_sk(test, paramset);
+}
+
+static void test_mlkem768(struct kunit *test)
+{
+	test_mlkem(test, MLKEM768_NUM_TESTVECS, mlkem768_hash, MLKEM768);
+}
+
+static void test_mlkem1024(struct kunit *test)
+{
+	test_mlkem(test, MLKEM1024_NUM_TESTVECS, mlkem1024_hash, MLKEM1024);
+}
+
+static u16 mod_q(s32 x)
+{
+	x %= Q;
+	if (x < 0)
+		x += Q;
+	return x;
+}
+
+/*
+ * Test that mlkem_reduce_once() and mlkem_reduce() produce the correct output
+ * for every supported input.
+ */
+static void test_mlkem_reduce(struct kunit *test)
+{
+	/* mlkem_reduce_once() supports 0 <= x < 2*Q */
+	for (u16 x = 0; x < 2 * Q; x++)
+		KUNIT_ASSERT_EQ(test, mod_q(x), mlkem_reduce_once(x));
+
+	/* mlkem_reduce() supports 0 <= x < Q + 2*Q*Q */
+	for (u32 x = 0; x < Q + 2 * Q * Q; x++)
+		KUNIT_ASSERT_EQ(test, mod_q(x), mlkem_reduce(x));
+}
+
+/* round((2^d / Q) * x) mod 2^d */
+static u16 compress_d_ref(u16 x, int d)
+{
+	u64 quotient, remainder;
+
+	quotient = div64_u64_rem((u64)x << d, Q, &remainder);
+	if (remainder >= (Q + 1) / 2)
+		quotient++;
+	return quotient & ((1 << d) - 1);
+}
+
+/* round((Q / 2^d) * y) */
+static u16 decompress_d_ref(u16 y, int d)
+{
+	u64 quotient, remainder;
+
+	quotient = div64_u64_rem((u64)y * Q, 1 << d, &remainder);
+	if (remainder >= 1 << (d - 1))
+		quotient++;
+	return quotient;
+}
+
+/*
+ * Test that mlkem_compress_d() produces the correct output for every supported
+ * input.
+ */
+static void test_mlkem_compress(struct kunit *test)
+{
+	/* compress_d() supports 0 <= x < Q and 1 <= d <= 11. */
+	for (int d = 1; d <= 11; d++) {
+		for (int x = 0; x < Q; x++) {
+			KUNIT_ASSERT_EQ(test, compress_d_ref(x, d),
+					mlkem_compress_d(x, d));
+		}
+	}
+}
+
+/*
+ * Test that mlkem_decompress_d() produces the correct output for every
+ * supported input.
+ */
+static void test_mlkem_decompress(struct kunit *test)
+{
+	for (int d = 1; d <= 11; d++) {
+		for (int y = 0; y < (1 << d); y++) {
+			KUNIT_ASSERT_EQ(test, decompress_d_ref(y, d),
+					mlkem_decompress_d(y, d));
+		}
+	}
+}
+
+/* Benchmark ML-KEM performance. */
+static void benchmark_mlkem(struct kunit *test, enum mlkem_paramset paramset)
+{
+	const char *name = mlkem_paramsets[paramset].name;
+	struct mlkem_bufs *bufs = alloc_bufs(test, paramset);
+	const int iterations = 100;
+	ktime_t start, end;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0, keygen(bufs->pk, bufs->sk, paramset));
+	end = ktime_get();
+	kunit_info(test, "%s_KeyGen: %llu ns/op\n", name,
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0,
+				encaps(bufs->ct, bufs->ss, bufs->pk, paramset));
+	end = ktime_get();
+	kunit_info(test, "%s_Encaps: %llu ns/op\n", name,
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0,
+				decaps(bufs->ss, bufs->ct, bufs->sk, paramset));
+	end = ktime_get();
+	kunit_info(test, "%s_Decaps: %llu ns/op\n", name,
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+}
+
+static void benchmark_mlkem768(struct kunit *test)
+{
+	benchmark_mlkem(test, MLKEM768);
+}
+
+static void benchmark_mlkem1024(struct kunit *test)
+{
+	benchmark_mlkem(test, MLKEM1024);
+}
+
+/* clang-format off */
+static struct kunit_case mlkem_test_cases[] = {
+	KUNIT_CASE(test_mlkem768),
+	KUNIT_CASE(test_mlkem1024),
+	KUNIT_CASE(test_mlkem_reduce),
+	KUNIT_CASE(test_mlkem_compress),
+	KUNIT_CASE(test_mlkem_decompress),
+	KUNIT_CASE(benchmark_mlkem768),
+	KUNIT_CASE(benchmark_mlkem1024),
+	{},
+};
+/* clang-format on */
+
+static struct kunit_suite mlkem_test_suite = {
+	.name = "mlkem",
+	.test_cases = mlkem_test_cases,
+};
+kunit_test_suite(mlkem_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for ML-KEM");
+MODULE_IMPORT_NS("CRYPTO_INTERNAL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/import-mlkem-testvecs.py b/scripts/crypto/import-mlkem-testvecs.py
new file mode 100755
index 000000000000..1d5681ccfee1
--- /dev/null
+++ b/scripts/crypto/import-mlkem-testvecs.py
@@ -0,0 +1,117 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# This script imports test vectors from the Kyber reference code.  To use:
+#
+#   git clone https://github.com/pq-crystals/kyber
+#   cd kyber/ref
+#   make
+#   ./test/test_vectors768 > ./test/tvecs768
+#   ./test/test_vectors1024 > ./test/tvecs1024
+#   $PATH_TO_THIS_SCRIPT ./test/
+#
+# This script generates the following files:
+#
+#   lib/crypto/tests/mlkem-testvecs.h
+
+import hashlib
+import os
+import sys
+
+SCRIPT_NAME = os.path.basename(__file__)
+LINUX_DIR = os.path.dirname(os.path.realpath(__file__)) + "/../.."
+
+MLKEM_LENGTHS = {
+    768: {
+        "pk_len": 1184,
+        "sk_len": 2400,
+        "ct_len": 1088,
+    },
+    1024: {
+        "pk_len": 1568,
+        "sk_len": 3168,
+        "ct_len": 1568,
+    },
+}
+
+
+def print_header(file):
+    print("/* SPDX-License-Identifier: GPL-2.0-or-later */", file=file)
+    print(f"/* This file was generated by {SCRIPT_NAME} */", file=file)
+    print(f"/* clang-format off */", file=file)
+
+
+def hex_to_bytes(hex_string, expected_bin_len):
+    res = bytes.fromhex(hex_string)
+    assert len(res) == expected_bin_len
+    return res
+
+
+def print_bytes(file, prefix, value, bytes_per_line):
+    for i in range(0, len(value), bytes_per_line):
+        line = prefix + "".join(f"0x{b:02x}, " for b in value[i : i + bytes_per_line])
+        print(f"{line.rstrip()}", file=file)
+
+
+def print_static_u8_array_definition(file, name, value):
+    print("", file=file)
+    print(f"static const u8 {name} = {{", file=file)
+    print_bytes(file, "\t", value, 12)
+    print("};", file=file)
+
+
+class Testvec:
+    def __init__(self, dict, paramset):
+        lens = MLKEM_LENGTHS[paramset]
+        self.pk = hex_to_bytes(dict["Public Key"], lens["pk_len"])
+        self.sk = hex_to_bytes(dict["Secret Key"], lens["sk_len"])
+        self.ct = hex_to_bytes(dict["Ciphertext"], lens["ct_len"])
+        assert dict["Shared Secret A"] == dict["Shared Secret B"]
+        self.ss = hex_to_bytes(dict["Shared Secret A"], 32)
+        self.ss_rejected = hex_to_bytes(dict["Pseudorandom shared Secret A"], 32)
+
+
+def load_testvecs(tvecs_file, paramset):
+    testvecs = []
+    cur = None
+    with open(tvecs_file) as f:
+        for line in f:
+            (name, value) = line.split(":")
+            if name == "Public Key":
+                if cur:
+                    testvecs.append(Testvec(cur, paramset))
+                cur = {}
+            cur[name] = value.strip()
+    if cur:
+        testvecs.append(Testvec(cur, paramset))
+    return testvecs
+
+
+def hash_testvecs(testvecs):
+    h = hashlib.shake_128()
+    for tv in testvecs:
+        h.update(tv.pk)
+        h.update(tv.sk)
+        h.update(tv.ct)
+        h.update(tv.ss)  # From encapsulation
+        h.update(tv.ss)  # From decapsulation
+        h.update(tv.ss_rejected)
+    return h.digest(length=32)
+
+
+if len(sys.argv) != 2:
+    sys.stderr.write(f"Usage: {SCRIPT_NAME} TESTVECS_DIR\n")
+    sys.exit(2)
+testvecs_dir = sys.argv[1]
+
+with open(LINUX_DIR + "/lib/crypto/tests/mlkem-testvecs.h", "w") as file:
+    print_header(file)
+    for paramset in [768, 1024]:
+        testvecs = load_testvecs(testvecs_dir + f"/tvecs{paramset}", paramset)
+        # There are 10000 test vectors, which take a bit long for a KUnit test.
+        # Trim them down to just the first 1000.
+        num_testvecs = min(len(testvecs), 1000)
+        testvecs = testvecs[:num_testvecs]
+        hash = hash_testvecs(testvecs)
+        print(f"\n#define MLKEM{paramset}_NUM_TESTVECS {num_testvecs}", file=file)
+        print_static_u8_array_definition(file, f"mlkem{paramset}_hash[32]", hash)
-- 
2.54.0

