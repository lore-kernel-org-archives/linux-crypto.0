Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EAA352C35;
	Thu, 30 Jul 2026 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785375320; cv=none; b=mgs0rSOG1jErE37PMKMif/mm1u6DTo2WzQdaCP/ft6EZkEqjLa5liDotMNcHvrAwvuLNshRi3TCgsGCksu40vUuOXM60xsTz587a8hF3bwnQCSUqSeNZJTrsp0ofu1/cQPprVzXSl43lp8xMO2YNIwRA6SHk7Q/oMpzDrpIE2Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785375320; c=relaxed/simple;
	bh=0l4p687WUXrB8uOsM9vzrN4+So01lMBoaYRGmOnzuD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNYLAvr3ojGX3q7MlCeRYMPaZZ9CtVrgU/ZYnkDtrK2JUPX8bST0Dqf1xAa2FSS7KwMHhoFfDYwjRd50MnDBYB6GaGApp6gj5XOUMGXXKIcDDG7JMp5oWCR0eYn6p/F5NSsSXQMM7oGhRwNc7w24caIbCdGgzwMYwL2Pn7xeFDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ia2qs89I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ia2qs89I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342CD1F00A3E;
	Thu, 30 Jul 2026 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785375318;
	bh=eIW0FfZNdHKISJ+gL+EL/lTM4Ka+PZECQLkNauj+eNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ia2qs89IL4fHqM6yezaVE4PNE8HLLG7+7g/yzqsAUn4vDxi49Avs8HGk4VglADWos
	 37CAQrcxRI3ej3ZR1fJ153ApBWicUFzURPq+Dsx5YEc3DHYiKy54o2PDlI44mgaAFq
	 vo17K7+UiF5xLeMdGbaM55X4Ihk76MjQDLAQbjTIRdO2+RTsso+h1wPez2A9TX6ez/
	 BTH0WIr0HX/Bpvt7Af6M0gALrmw388vJtxlN/UFajI8PqHylvf8w4wt5ehLSJ3Mw6+
	 Qrm4KYRvf8ljzn0VhG01vyT2qBsR6TmDmDqWEqaIU7uMRz+mHb8rnaNDMy+rgocYeI
	 1jDoD8FUMIjvg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/5] lib/crypto: tests: Create test-utils.h
Date: Wed, 29 Jul 2026 18:32:56 -0700
Message-ID: <20260730013301.160203-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730013301.160203-1-ebiggers@kernel.org>
References: <20260730013301.160203-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move hash-test-template's test RNG code and the buffer allocation code
from various test suites into a header test-utils.h.  This allows them
to be shared by other test suites.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/chacha20poly1305_kunit.c |   9 +-
 lib/crypto/tests/hash-test-template.h     |  58 +----------
 lib/crypto/tests/mldsa_kunit.c            |  19 ++--
 lib/crypto/tests/nh_kunit.c               |   5 +-
 lib/crypto/tests/sha256_kunit.c           |  21 +---
 lib/crypto/tests/test-utils.h             | 111 ++++++++++++++++++++++
 6 files changed, 124 insertions(+), 99 deletions(-)
 create mode 100644 lib/crypto/tests/test-utils.h

diff --git a/lib/crypto/tests/chacha20poly1305_kunit.c b/lib/crypto/tests/chacha20poly1305_kunit.c
index 97a68fab88a7..d5504d0f4ad7 100644
--- a/lib/crypto/tests/chacha20poly1305_kunit.c
+++ b/lib/crypto/tests/chacha20poly1305_kunit.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
+#include "test-utils.h"
 
 struct chacha20poly1305_testvec {
 	const u8 *input, *output, *assoc, *nonce, *key;
@@ -8890,11 +8890,8 @@ static void test_chacha20poly1305(struct kunit *test)
 	bool ret;
 	struct scatterlist sg_src[3];
 
-	computed_output = kunit_kmalloc(test, MAXIMUM_TEST_BUFFER_LEN,
-					GFP_KERNEL);
-	input = kunit_kmalloc(test, MAXIMUM_TEST_BUFFER_LEN, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_NULL(test, computed_output);
-	KUNIT_ASSERT_NOT_NULL(test, input);
+	computed_output = alloc_buf(test, MAXIMUM_TEST_BUFFER_LEN);
+	input = alloc_buf(test, MAXIMUM_TEST_BUFFER_LEN);
 
 	for (i = 0; i < ARRAY_SIZE(chacha20poly1305_enc_vectors); ++i) {
 		memset(computed_output, 0, MAXIMUM_TEST_BUFFER_LEN);
diff --git a/lib/crypto/tests/hash-test-template.h b/lib/crypto/tests/hash-test-template.h
index 61b43e62779f..e6ab1dc8f9d7 100644
--- a/lib/crypto/tests/hash-test-template.h
+++ b/lib/crypto/tests/hash-test-template.h
@@ -8,69 +8,13 @@
 #include <kunit/run-in-irq-context.h>
 #include <kunit/test.h>
 #include <linux/vmalloc.h>
+#include "test-utils.h"
 
 /* test_buf is a guarded buffer, i.e. &test_buf[TEST_BUF_LEN] is not mapped. */
 #define TEST_BUF_LEN 16384
 static u8 *test_buf;
-
 static u8 *orig_test_buf;
 
-static u64 random_seed;
-
-/*
- * This is a simple linear congruential generator.  It is used only for testing,
- * which does not require cryptographically secure random numbers.  A hard-coded
- * algorithm is used instead of <linux/prandom.h> so that it matches the
- * algorithm used by the test vector generation script.  This allows the input
- * data in random test vectors to be concisely stored as just the seed.
- */
-static u32 rand32(void)
-{
-	random_seed = (random_seed * 25214903917 + 11) & ((1ULL << 48) - 1);
-	return random_seed >> 16;
-}
-
-static void rand_bytes(u8 *out, size_t len)
-{
-	for (size_t i = 0; i < len; i++)
-		out[i] = rand32();
-}
-
-static void rand_bytes_seeded_from_len(u8 *out, size_t len)
-{
-	random_seed = len;
-	rand_bytes(out, len);
-}
-
-static bool rand_bool(void)
-{
-	return rand32() % 2;
-}
-
-/* Generate a random length, preferring small lengths. */
-static size_t rand_length(size_t max_len)
-{
-	size_t len;
-
-	switch (rand32() % 3) {
-	case 0:
-		len = rand32() % 128;
-		break;
-	case 1:
-		len = rand32() % 3072;
-		break;
-	default:
-		len = rand32();
-		break;
-	}
-	return len % (max_len + 1);
-}
-
-static size_t rand_offset(size_t max_offset)
-{
-	return min(rand32() % 128, max_offset);
-}
-
 static int hash_suite_init(struct kunit_suite *suite)
 {
 	/*
diff --git a/lib/crypto/tests/mldsa_kunit.c b/lib/crypto/tests/mldsa_kunit.c
index 67f8f93e3dc6..ec64e10c97f2 100644
--- a/lib/crypto/tests/mldsa_kunit.c
+++ b/lib/crypto/tests/mldsa_kunit.c
@@ -8,6 +8,7 @@
 #include <kunit/test.h>
 #include <linux/random.h>
 #include <linux/unaligned.h>
+#include "test-utils.h"
 
 #define Q 8380417 /* The prime q = 2^23 - 2^13 + 1 */
 
@@ -60,14 +61,6 @@ static void do_mldsa_and_assert_success(struct kunit *test,
 	KUNIT_ASSERT_EQ(test, err, 0);
 }
 
-static u8 *kunit_kmemdup_or_fail(struct kunit *test, const u8 *src, size_t len)
-{
-	u8 *dst = kunit_kmalloc(test, len, GFP_KERNEL);
-
-	KUNIT_ASSERT_NOT_NULL(test, dst);
-	return memcpy(dst, src, len);
-}
-
 /*
  * Test that changing coefficients in a valid signature's z vector results in
  * the following behavior from mldsa_verify():
@@ -83,7 +76,7 @@ static u8 *kunit_kmemdup_or_fail(struct kunit *test, const u8 *src, size_t len)
 static void test_mldsa_z_range(struct kunit *test,
 			       const struct mldsa_testvector *tv)
 {
-	u8 *sig = kunit_kmemdup_or_fail(test, tv->sig, tv->sig_len);
+	u8 *sig = memdup_buf(test, tv->sig, tv->sig_len);
 	const int lambda = params[tv->alg].lambda;
 	const s32 gamma1 = params[tv->alg].gamma1;
 	const int beta = params[tv->alg].beta;
@@ -146,7 +139,7 @@ static void test_mldsa_bad_hints(struct kunit *test,
 {
 	const int omega = params[tv->alg].omega;
 	const int k = params[tv->alg].k;
-	u8 *sig = kunit_kmemdup_or_fail(test, tv->sig, tv->sig_len);
+	u8 *sig = memdup_buf(test, tv->sig, tv->sig_len);
 	/* Pointer to the encoded hint vector in the signature */
 	u8 *hintvec = &sig[tv->sig_len - omega - k];
 	u8 h;
@@ -202,9 +195,9 @@ static void test_mldsa_mutation(struct kunit *test,
 	const int msg_len = tv->msg_len;
 	const int pk_len = tv->pk_len;
 	const int num_iter = 200;
-	u8 *sig = kunit_kmemdup_or_fail(test, tv->sig, sig_len);
-	u8 *msg = kunit_kmemdup_or_fail(test, tv->msg, msg_len);
-	u8 *pk = kunit_kmemdup_or_fail(test, tv->pk, pk_len);
+	u8 *sig = memdup_buf(test, tv->sig, sig_len);
+	u8 *msg = memdup_buf(test, tv->msg, msg_len);
+	u8 *pk = memdup_buf(test, tv->pk, pk_len);
 
 	/* Initially the signature is valid. */
 	do_mldsa_and_assert_success(test, tv);
diff --git a/lib/crypto/tests/nh_kunit.c b/lib/crypto/tests/nh_kunit.c
index a8a3c3f345cb..49e0fb3dd294 100644
--- a/lib/crypto/tests/nh_kunit.c
+++ b/lib/crypto/tests/nh_kunit.c
@@ -5,14 +5,13 @@
 #include <crypto/nh.h>
 #include <kunit/test.h>
 #include "nh-testvecs.h"
+#include "test-utils.h"
 
 static void test_nh(struct kunit *test)
 {
-	u32 *key = kunit_kmalloc(test, NH_KEY_BYTES, GFP_KERNEL);
+	u32 *key = memdup_buf(test, nh_test_key, NH_KEY_BYTES);
 	__le64 hash[NH_NUM_PASSES];
 
-	KUNIT_ASSERT_NOT_NULL(test, key);
-	memcpy(key, nh_test_key, NH_KEY_BYTES);
 	le32_to_cpu_array(key, NH_KEY_WORDS);
 
 	nh(key, nh_test_msg, 16, hash);
diff --git a/lib/crypto/tests/sha256_kunit.c b/lib/crypto/tests/sha256_kunit.c
index 5dccdee79693..8758db3673c7 100644
--- a/lib/crypto/tests/sha256_kunit.c
+++ b/lib/crypto/tests/sha256_kunit.c
@@ -4,6 +4,7 @@
  */
 #include <crypto/sha2.h>
 #include "sha256-testvecs.h"
+#include "test-utils.h"
 
 /* Generate the HASH_KUNIT_CASES using hash-test-template.h. */
 #define HASH sha256
@@ -22,26 +23,6 @@
 #define HMAC_USINGRAWKEY hmac_sha256_usingrawkey
 #include "hash-test-template.h"
 
-static void free_guarded_buf(void *buf)
-{
-	vfree(buf);
-}
-
-/*
- * Allocate a KUnit-managed buffer that has length @len bytes immediately
- * followed by an unmapped page, and assert that the allocation succeeds.
- */
-static void *alloc_guarded_buf(struct kunit *test, size_t len)
-{
-	size_t full_len = round_up(len, PAGE_SIZE);
-	void *buf = vmalloc(full_len);
-
-	KUNIT_ASSERT_NOT_NULL(test, buf);
-	KUNIT_ASSERT_EQ(test, 0,
-			kunit_add_action_or_reset(test, free_guarded_buf, buf));
-	return buf + full_len - len;
-}
-
 /*
  * Test for sha256_finup_2x().  Specifically, choose various data lengths and
  * salt lengths, and for each one, verify that sha256_finup_2x() produces the
diff --git a/lib/crypto/tests/test-utils.h b/lib/crypto/tests/test-utils.h
new file mode 100644
index 000000000000..73ca21f9176e
--- /dev/null
+++ b/lib/crypto/tests/test-utils.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Test utility functions shared by the crypto library tests.
+ *
+ * For now this is simply a header that's included into the KUnit test suites
+ * that need it.  If this gets too large it could be made its own translation
+ * unit and libcrypto_test_utils module, but that seems overkill for now.
+ */
+#ifndef LIB_CRYPTO_TEST_UTILS_H
+#define LIB_CRYPTO_TEST_UTILS_H
+
+#include <kunit/test.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+
+static u64 random_seed;
+
+static __maybe_unused void action_free_guarded_buf(void *buf)
+{
+	vfree(buf);
+}
+
+/*
+ * Allocate a KUnit-managed buffer that has length @size bytes (> 0) immediately
+ * followed by an unmapped page, and assert that the allocation succeeds.
+ */
+static __maybe_unused void *alloc_guarded_buf(struct kunit *test, size_t size)
+{
+	size_t full_size = round_up(size, PAGE_SIZE);
+	void *buf = vmalloc(full_size);
+
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	KUNIT_ASSERT_EQ(test, 0,
+			kunit_add_action_or_reset(test, action_free_guarded_buf,
+						  buf));
+	return buf + full_size - size;
+}
+
+static __maybe_unused void *alloc_buf(struct kunit *test, size_t size)
+{
+	void *buf = kunit_kmalloc(test, size, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	return buf;
+}
+
+static __maybe_unused void *memdup_buf(struct kunit *test, const void *src,
+				       size_t size)
+{
+	void *dst = alloc_buf(test, size);
+
+	return memcpy(dst, src, size);
+}
+
+/*
+ * This is a simple linear congruential generator.  It is used only for testing,
+ * which does not require cryptographically secure random numbers.  A hard-coded
+ * algorithm is used instead of <linux/prandom.h> so that it matches the
+ * algorithm used by the test vector generation script.  This allows the input
+ * data in random test vectors to be concisely stored as just the seed.
+ */
+static __maybe_unused u32 rand32(void)
+{
+	random_seed = (random_seed * 25214903917 + 11) & ((1ULL << 48) - 1);
+	return random_seed >> 16;
+}
+
+static __maybe_unused void rand_bytes(u8 *out, size_t len)
+{
+	for (size_t i = 0; i < len; i++)
+		out[i] = rand32();
+}
+
+static __maybe_unused void rand_bytes_seeded_from_len(u8 *out, size_t len)
+{
+	random_seed = len;
+	rand_bytes(out, len);
+}
+
+static __maybe_unused bool rand_bool(void)
+{
+	return rand32() % 2;
+}
+
+/* Generate a random length, preferring small lengths. */
+static __maybe_unused size_t rand_length(size_t max_len)
+{
+	size_t len;
+
+	switch (rand32() % 3) {
+	case 0:
+		len = rand32() % 128;
+		break;
+	case 1:
+		len = rand32() % 3072;
+		break;
+	default:
+		len = rand32();
+		break;
+	}
+	return len % (max_len + 1);
+}
+
+static __maybe_unused size_t rand_offset(size_t max_offset)
+{
+	return min(rand32() % 128, max_offset);
+}
+
+#endif /* LIB_CRYPTO_TEST_UTILS_H */

base-commit: f70ad727d1d60a4dfcb1a22152d4169f9a205af9
-- 
2.55.0

