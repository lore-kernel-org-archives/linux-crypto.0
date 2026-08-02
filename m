Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B90F2F619D;
	Sun,  2 Aug 2026 23:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785713439; cv=none; b=PH2qFWumSIaVwmtYk4//HCxwEw18+n1+eyQwdDyZfKqWKb+oiK9u5G77lA8EjsDwwKIH2EyLlq6BbiutRY5f7DEVqg8erS/s22XM6Z7gZ1NoR5komFPiO2XK10bp6PqTuPrzcbL71UW0OQJETQQJduzWaLTNJ/e4Du99UQsMDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785713439; c=relaxed/simple;
	bh=UtJkLYwgaEyYOkKeXwIttZx+5M4IcU1yGeYuBpdb/Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/EtUNlf64AdnaNd7d+sW5Ijz8Tblzs0zZm0vmEyYX37LhVMlDakyUTVsdZHt4yP07w8xbibJAFfaSDcUDeMH8nU17ym4fRJBgkyq1SliJfDbEpRo21QaDlMSIqPZpZNSExkBoBBzZ8g6v5TKOQ4AVW8GXd+FfpxCfARhU0j+9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egJXA4Xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egJXA4Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE0B1F00A3F;
	Sun,  2 Aug 2026 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785713436;
	bh=dVMcnwCUCc94a6CxfOjZFh4PR1mZQD2RLs4Mu/XQVhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egJXA4XzJCWXO6xoRosvhdgJ8zajAM80gKKGtWuRu6Kl1KzRTmrC32SZKhDsz3c4/
	 u7FaF4R+IYBA92K92tgdVJSbXP8Ir34sy/UbL/SWxvVd/Z9lDx6PF6cJwvSQYNQoPf
	 a9HS4iChpA07OMF4z/ocz1xLTd4TAOppegzceFZ1kYtl5F5TFPmFU/paDgfA2G2xd4
	 gf938oJRtgZ9J6a1eU1oRKOzf2OAFLNu4P8zm5/IvdIieDMlHVLtH9Xeu5MoibOrGp
	 aqlXfY9h2b1kyM9MVcnYfIJnYf7QdH2Ns8z8aJgVTxfpOJ5uaZmZ9MbGoa0dugUS5E
	 51ZKaKkEuF4jQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/5] lib/crypto: tests: Use per-test-case buffers in hash tests
Date: Sun,  2 Aug 2026 16:30:02 -0700
Message-ID: <20260802233005.161467-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802233005.161467-1-ebiggers@kernel.org>
References: <20260802233005.161467-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the test cases more self-contained by replacing the test suite
scoped guarded buffer ('test_buf') with buffers allocated by each test
case using the helper functions in test-utils.h.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/aes_cbc_macs_kunit.c |  12 +-
 lib/crypto/tests/blake2b_kunit.c      |  33 ++---
 lib/crypto/tests/blake2s_kunit.c      |  33 ++---
 lib/crypto/tests/ghash_kunit.c        |  37 +++--
 lib/crypto/tests/hash-test-template.h | 191 +++++++++++++-------------
 lib/crypto/tests/md5_kunit.c          |   2 -
 lib/crypto/tests/poly1305_kunit.c     |  21 ++-
 lib/crypto/tests/polyval_kunit.c      |  38 +++--
 lib/crypto/tests/sha1_kunit.c         |   2 -
 lib/crypto/tests/sha224_kunit.c       |   2 -
 lib/crypto/tests/sha256_kunit.c       |  27 ++--
 lib/crypto/tests/sha384_kunit.c       |   2 -
 lib/crypto/tests/sha3_kunit.c         |  30 ++--
 lib/crypto/tests/sha512_kunit.c       |   2 -
 lib/crypto/tests/sm3_kunit.c          |   2 -
 15 files changed, 193 insertions(+), 241 deletions(-)

diff --git a/lib/crypto/tests/aes_cbc_macs_kunit.c b/lib/crypto/tests/aes_cbc_macs_kunit.c
index ae3745212f03..6afdb3a04c17 100644
--- a/lib/crypto/tests/aes_cbc_macs_kunit.c
+++ b/lib/crypto/tests/aes_cbc_macs_kunit.c
@@ -34,18 +34,9 @@ static void aes_cmac_withtestkey(const u8 *data, size_t data_len,
 static int aes_cbc_macs_suite_init(struct kunit_suite *suite)
 {
 	u8 raw_key[AES_KEYSIZE_256];
-	int err;
 
 	rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
-	err = aes_cmac_preparekey(&test_key, raw_key, sizeof(raw_key));
-	if (err)
-		return err;
-	return hash_suite_init(suite);
-}
-
-static void aes_cbc_macs_suite_exit(struct kunit_suite *suite)
-{
-	hash_suite_exit(suite);
+	return aes_cmac_preparekey(&test_key, raw_key, sizeof(raw_key));
 }
 
 /* Verify compatibility of the AES-CMAC implementation with RFC 4493. */
@@ -218,7 +209,6 @@ static struct kunit_suite aes_cbc_macs_test_suite = {
 	.name = "aes_cbc_macs",
 	.test_cases = aes_cbc_macs_test_cases,
 	.suite_init = aes_cbc_macs_suite_init,
-	.suite_exit = aes_cbc_macs_suite_exit,
 };
 kunit_test_suite(aes_cbc_macs_test_suite);
 
diff --git a/lib/crypto/tests/blake2b_kunit.c b/lib/crypto/tests/blake2b_kunit.c
index bc0be7da1e76..e2ce6cf3a99d 100644
--- a/lib/crypto/tests/blake2b_kunit.c
+++ b/lib/crypto/tests/blake2b_kunit.c
@@ -41,9 +41,9 @@ static void blake2b_init_default(struct blake2b_ctx *ctx)
 static void test_blake2b_all_key_and_hash_lens(struct kunit *test)
 {
 	const size_t data_len = 100;
-	u8 *data = &test_buf[0];
-	u8 *key = data + data_len;
-	u8 *hash = key + BLAKE2B_KEY_SIZE;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *key = alloc_buf(test, BLAKE2B_KEY_SIZE);
+	u8 *hash = alloc_buf(test, BLAKE2B_HASH_SIZE);
 	struct blake2b_ctx main_ctx;
 	u8 main_hash[BLAKE2B_HASH_SIZE];
 
@@ -68,11 +68,13 @@ static void test_blake2b_all_key_and_hash_lens(struct kunit *test)
 static void test_blake2b_with_guarded_key_buf(struct kunit *test)
 {
 	const size_t data_len = 100;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *guarded_key_buf = alloc_guarded_buf(test, BLAKE2B_KEY_SIZE);
 
-	rand_bytes(test_buf, data_len);
+	rand_bytes(data, data_len);
 	for (int key_len = 0; key_len <= BLAKE2B_KEY_SIZE; key_len++) {
 		u8 key[BLAKE2B_KEY_SIZE];
-		u8 *guarded_key = &test_buf[TEST_BUF_LEN - key_len];
+		u8 *guarded_key = &guarded_key_buf[BLAKE2B_KEY_SIZE - key_len];
 		u8 hash1[BLAKE2B_HASH_SIZE];
 		u8 hash2[BLAKE2B_HASH_SIZE];
 		struct blake2b_ctx ctx;
@@ -80,14 +82,13 @@ static void test_blake2b_with_guarded_key_buf(struct kunit *test)
 		rand_bytes(key, key_len);
 		memcpy(guarded_key, key, key_len);
 
-		blake2b(key, key_len, test_buf, data_len,
-			hash1, BLAKE2B_HASH_SIZE);
-		blake2b(guarded_key, key_len, test_buf, data_len,
-			hash2, BLAKE2B_HASH_SIZE);
+		blake2b(key, key_len, data, data_len, hash1, BLAKE2B_HASH_SIZE);
+		blake2b(guarded_key, key_len, data, data_len, hash2,
+			BLAKE2B_HASH_SIZE);
 		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2B_HASH_SIZE);
 
 		blake2b_init_key(&ctx, BLAKE2B_HASH_SIZE, guarded_key, key_len);
-		blake2b_update(&ctx, test_buf, data_len);
+		blake2b_update(&ctx, data, data_len);
 		blake2b_final(&ctx, hash2);
 		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2B_HASH_SIZE);
 	}
@@ -100,14 +101,16 @@ static void test_blake2b_with_guarded_key_buf(struct kunit *test)
 static void test_blake2b_with_guarded_out_buf(struct kunit *test)
 {
 	const size_t data_len = 100;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *out_buf = alloc_guarded_buf(test, BLAKE2B_HASH_SIZE);
 
-	rand_bytes(test_buf, data_len);
+	rand_bytes(data, data_len);
 	for (int out_len = 1; out_len <= BLAKE2B_HASH_SIZE; out_len++) {
 		u8 hash[BLAKE2B_HASH_SIZE];
-		u8 *guarded_hash = &test_buf[TEST_BUF_LEN - out_len];
+		u8 *guarded_hash = &out_buf[BLAKE2B_HASH_SIZE - out_len];
 
-		blake2b(NULL, 0, test_buf, data_len, hash, out_len);
-		blake2b(NULL, 0, test_buf, data_len, guarded_hash, out_len);
+		blake2b(NULL, 0, data, data_len, hash, out_len);
+		blake2b(NULL, 0, data, data_len, guarded_hash, out_len);
 		KUNIT_ASSERT_MEMEQ(test, hash, guarded_hash, out_len);
 	}
 }
@@ -124,8 +127,6 @@ static struct kunit_case blake2b_test_cases[] = {
 static struct kunit_suite blake2b_test_suite = {
 	.name = "blake2b",
 	.test_cases = blake2b_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(blake2b_test_suite);
 
diff --git a/lib/crypto/tests/blake2s_kunit.c b/lib/crypto/tests/blake2s_kunit.c
index 6832d9aa7b82..682f695f8a09 100644
--- a/lib/crypto/tests/blake2s_kunit.c
+++ b/lib/crypto/tests/blake2s_kunit.c
@@ -41,9 +41,9 @@ static void blake2s_init_default(struct blake2s_ctx *ctx)
 static void test_blake2s_all_key_and_hash_lens(struct kunit *test)
 {
 	const size_t data_len = 100;
-	u8 *data = &test_buf[0];
-	u8 *key = data + data_len;
-	u8 *hash = key + BLAKE2S_KEY_SIZE;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *key = alloc_buf(test, BLAKE2S_KEY_SIZE);
+	u8 *hash = alloc_buf(test, BLAKE2S_HASH_SIZE);
 	struct blake2s_ctx main_ctx;
 	u8 main_hash[BLAKE2S_HASH_SIZE];
 
@@ -68,11 +68,13 @@ static void test_blake2s_all_key_and_hash_lens(struct kunit *test)
 static void test_blake2s_with_guarded_key_buf(struct kunit *test)
 {
 	const size_t data_len = 100;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *guarded_key_buf = alloc_guarded_buf(test, BLAKE2S_KEY_SIZE);
 
-	rand_bytes(test_buf, data_len);
+	rand_bytes(data, data_len);
 	for (int key_len = 0; key_len <= BLAKE2S_KEY_SIZE; key_len++) {
 		u8 key[BLAKE2S_KEY_SIZE];
-		u8 *guarded_key = &test_buf[TEST_BUF_LEN - key_len];
+		u8 *guarded_key = &guarded_key_buf[BLAKE2S_KEY_SIZE - key_len];
 		u8 hash1[BLAKE2S_HASH_SIZE];
 		u8 hash2[BLAKE2S_HASH_SIZE];
 		struct blake2s_ctx ctx;
@@ -80,14 +82,13 @@ static void test_blake2s_with_guarded_key_buf(struct kunit *test)
 		rand_bytes(key, key_len);
 		memcpy(guarded_key, key, key_len);
 
-		blake2s(key, key_len, test_buf, data_len,
-			hash1, BLAKE2S_HASH_SIZE);
-		blake2s(guarded_key, key_len, test_buf, data_len,
-			hash2, BLAKE2S_HASH_SIZE);
+		blake2s(key, key_len, data, data_len, hash1, BLAKE2S_HASH_SIZE);
+		blake2s(guarded_key, key_len, data, data_len, hash2,
+			BLAKE2S_HASH_SIZE);
 		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2S_HASH_SIZE);
 
 		blake2s_init_key(&ctx, BLAKE2S_HASH_SIZE, guarded_key, key_len);
-		blake2s_update(&ctx, test_buf, data_len);
+		blake2s_update(&ctx, data, data_len);
 		blake2s_final(&ctx, hash2);
 		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2S_HASH_SIZE);
 	}
@@ -100,14 +101,16 @@ static void test_blake2s_with_guarded_key_buf(struct kunit *test)
 static void test_blake2s_with_guarded_out_buf(struct kunit *test)
 {
 	const size_t data_len = 100;
+	u8 *data = alloc_buf(test, data_len);
+	u8 *out_buf = alloc_guarded_buf(test, BLAKE2S_HASH_SIZE);
 
-	rand_bytes(test_buf, data_len);
+	rand_bytes(data, data_len);
 	for (int out_len = 1; out_len <= BLAKE2S_HASH_SIZE; out_len++) {
 		u8 hash[BLAKE2S_HASH_SIZE];
-		u8 *guarded_hash = &test_buf[TEST_BUF_LEN - out_len];
+		u8 *guarded_hash = &out_buf[BLAKE2S_HASH_SIZE - out_len];
 
-		blake2s(NULL, 0, test_buf, data_len, hash, out_len);
-		blake2s(NULL, 0, test_buf, data_len, guarded_hash, out_len);
+		blake2s(NULL, 0, data, data_len, hash, out_len);
+		blake2s(NULL, 0, data, data_len, guarded_hash, out_len);
 		KUNIT_ASSERT_MEMEQ(test, hash, guarded_hash, out_len);
 	}
 }
@@ -124,8 +127,6 @@ static struct kunit_case blake2s_test_cases[] = {
 static struct kunit_suite blake2s_test_suite = {
 	.name = "blake2s",
 	.test_cases = blake2s_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(blake2s_test_suite);
 
diff --git a/lib/crypto/tests/ghash_kunit.c b/lib/crypto/tests/ghash_kunit.c
index 68b3837a3607..4d7aa79b3cb2 100644
--- a/lib/crypto/tests/ghash_kunit.c
+++ b/lib/crypto/tests/ghash_kunit.c
@@ -39,17 +39,18 @@ static void ghash_withtestkey(const u8 *data, size_t len,
  */
 static void test_ghash_allones_key_and_message(struct kunit *test)
 {
+	const size_t max_len = 4096;
+	u8 *data = alloc_buf(test, max_len);
 	struct ghash_key key;
 	struct ghash_ctx hashofhashes_ctx;
 	u8 hash[GHASH_BLOCK_SIZE];
 
-	static_assert(TEST_BUF_LEN >= 4096);
-	memset(test_buf, 0xff, 4096);
+	memset(data, 0xff, max_len);
 
-	ghash_preparekey(&key, test_buf);
+	ghash_preparekey(&key, data);
 	ghash_init(&hashofhashes_ctx, &key);
-	for (size_t len = 0; len <= 4096; len += 16) {
-		ghash(&key, test_buf, len, hash);
+	for (size_t len = 0; len <= max_len; len += 16) {
+		ghash(&key, data, len, hash);
 		ghash_update(&hashofhashes_ctx, hash, sizeof(hash));
 	}
 	ghash_final(&hashofhashes_ctx, hash);
@@ -68,7 +69,7 @@ static void check_key_consistency(struct kunit *test,
 				  const struct ghash_key *key1,
 				  const struct ghash_key *key2)
 {
-	u8 *data = test_buf;
+	u8 *data = alloc_buf(test, MAX_LEN_FOR_KEY_CHECK);
 	u8 hash1[GHASH_BLOCK_SIZE];
 	u8 hash2[GHASH_BLOCK_SIZE];
 
@@ -88,10 +89,10 @@ static void check_key_consistency(struct kunit *test,
 static void test_ghash_with_guarded_key(struct kunit *test)
 {
 	u8 raw_key[GHASH_BLOCK_SIZE];
-	u8 *guarded_raw_key = &test_buf[TEST_BUF_LEN - sizeof(raw_key)];
+	u8 *guarded_raw_key = alloc_guarded_buf(test, sizeof(raw_key));
 	struct ghash_key key1, key2;
 	struct ghash_key *guarded_key =
-		(struct ghash_key *)&test_buf[TEST_BUF_LEN - sizeof(key1)];
+		alloc_guarded_buf(test, sizeof(*guarded_key));
 
 	/* Prepare with regular buffers. */
 	rand_bytes(raw_key, sizeof(raw_key));
@@ -116,14 +117,14 @@ static void test_ghash_with_minimally_aligned_key(struct kunit *test)
 {
 	u8 raw_key[GHASH_BLOCK_SIZE];
 	struct ghash_key key;
+	const size_t align = __alignof__(struct ghash_key);
+	u8 *key_buf = alloc_buf(test, sizeof(struct ghash_key) + 3 * align);
 	struct ghash_key *minaligned_key =
-		(struct ghash_key *)&test_buf[MAX_LEN_FOR_KEY_CHECK +
-					      __alignof__(struct ghash_key)];
+		(struct ghash_key *)(PTR_ALIGN(key_buf, 2 * align) + align);
 
-	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key,
-					   __alignof__(struct ghash_key)));
-	KUNIT_ASSERT_TRUE(test, !IS_ALIGNED((uintptr_t)minaligned_key,
-					    2 * __alignof__(struct ghash_key)));
+	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key, align));
+	KUNIT_ASSERT_TRUE(test,
+			  !IS_ALIGNED((uintptr_t)minaligned_key, 2 * align));
 
 	rand_bytes(raw_key, sizeof(raw_key));
 	ghash_preparekey(&key, raw_key);
@@ -164,12 +165,7 @@ static int ghash_suite_init(struct kunit_suite *suite)
 
 	rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
 	ghash_preparekey(&test_key, raw_key);
-	return hash_suite_init(suite);
-}
-
-static void ghash_suite_exit(struct kunit_suite *suite)
-{
-	hash_suite_exit(suite);
+	return 0;
 }
 
 static struct kunit_case ghash_test_cases[] = {
@@ -186,7 +182,6 @@ static struct kunit_suite ghash_test_suite = {
 	.name = "ghash",
 	.test_cases = ghash_test_cases,
 	.suite_init = ghash_suite_init,
-	.suite_exit = ghash_suite_exit,
 };
 kunit_test_suite(ghash_test_suite);
 
diff --git a/lib/crypto/tests/hash-test-template.h b/lib/crypto/tests/hash-test-template.h
index e6ab1dc8f9d7..bb6eaa509d0f 100644
--- a/lib/crypto/tests/hash-test-template.h
+++ b/lib/crypto/tests/hash-test-template.h
@@ -7,38 +7,8 @@
  */
 #include <kunit/run-in-irq-context.h>
 #include <kunit/test.h>
-#include <linux/vmalloc.h>
 #include "test-utils.h"
 
-/* test_buf is a guarded buffer, i.e. &test_buf[TEST_BUF_LEN] is not mapped. */
-#define TEST_BUF_LEN 16384
-static u8 *test_buf;
-static u8 *orig_test_buf;
-
-static int hash_suite_init(struct kunit_suite *suite)
-{
-	/*
-	 * Allocate the test buffer using vmalloc() with a page-aligned length
-	 * so that it is immediately followed by a guard page.  This allows
-	 * buffer overreads to be detected, even in assembly code.
-	 */
-	size_t alloc_len = round_up(TEST_BUF_LEN, PAGE_SIZE);
-
-	orig_test_buf = vmalloc(alloc_len);
-	if (!orig_test_buf)
-		return -ENOMEM;
-
-	test_buf = orig_test_buf + alloc_len - TEST_BUF_LEN;
-	return 0;
-}
-
-static void hash_suite_exit(struct kunit_suite *suite)
-{
-	vfree(orig_test_buf);
-	orig_test_buf = NULL;
-	test_buf = NULL;
-}
-
 /*
  * Test the hash function against a list of test vectors.
  *
@@ -48,14 +18,16 @@ static void hash_suite_exit(struct kunit_suite *suite)
  */
 static void test_hash_test_vectors(struct kunit *test)
 {
+	const size_t max_len = 16384;
+	u8 *data = alloc_buf(test, max_len);
+
 	for (size_t i = 0; i < ARRAY_SIZE(hash_testvecs); i++) {
 		size_t data_len = hash_testvecs[i].data_len;
 		u8 actual_hash[HASH_SIZE];
 
-		KUNIT_ASSERT_LE(test, data_len, TEST_BUF_LEN);
-		rand_bytes_seeded_from_len(test_buf, data_len);
-
-		HASH(test_buf, data_len, actual_hash);
+		KUNIT_ASSERT_LE(test, data_len, max_len);
+		rand_bytes_seeded_from_len(data, data_len);
+		HASH(data, data_len, actual_hash);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, actual_hash, hash_testvecs[i].digest, HASH_SIZE,
 			"Wrong result with test vector %zu; data_len=%zu", i,
@@ -71,14 +43,15 @@ static void test_hash_test_vectors(struct kunit *test)
  */
 static void test_hash_all_lens_up_to_4096(struct kunit *test)
 {
+	const size_t max_len = 4096;
+	u8 *data = alloc_buf(test, max_len);
 	struct HASH_CTX ctx;
 	u8 hash[HASH_SIZE];
 
-	static_assert(TEST_BUF_LEN >= 4096);
-	rand_bytes_seeded_from_len(test_buf, 4096);
+	rand_bytes_seeded_from_len(data, max_len);
 	HASH_INIT(&ctx);
-	for (size_t len = 0; len <= 4096; len++) {
-		HASH(test_buf, len, hash);
+	for (size_t len = 0; len <= max_len; len++) {
+		HASH(data, len, hash);
 		HASH_UPDATE(&ctx, hash, HASH_SIZE);
 	}
 	HASH_FINAL(&ctx, hash);
@@ -91,6 +64,9 @@ static void test_hash_all_lens_up_to_4096(struct kunit *test)
  */
 static void test_hash_incremental_updates(struct kunit *test)
 {
+	const size_t max_len = 16384;
+	u8 *data = alloc_guarded_buf(test, max_len);
+
 	for (int i = 0; i < 1000; i++) {
 		size_t total_len, offset;
 		struct HASH_CTX ctx;
@@ -99,12 +75,12 @@ static void test_hash_incremental_updates(struct kunit *test)
 		size_t num_parts = 0;
 		size_t remaining_len, cur_offset;
 
-		total_len = rand_length(TEST_BUF_LEN);
-		offset = rand_offset(TEST_BUF_LEN - total_len);
-		rand_bytes(&test_buf[offset], total_len);
+		total_len = rand_length(max_len);
+		offset = rand_offset(max_len - total_len);
+		rand_bytes(&data[offset], total_len);
 
 		/* Compute the hash value in one shot. */
-		HASH(&test_buf[offset], total_len, hash1);
+		HASH(&data[offset], total_len, hash1);
 
 		/*
 		 * Compute the hash value incrementally, using a randomly
@@ -116,13 +92,13 @@ static void test_hash_incremental_updates(struct kunit *test)
 		while (rand_bool()) {
 			size_t part_len = rand_length(remaining_len);
 
-			HASH_UPDATE(&ctx, &test_buf[cur_offset], part_len);
+			HASH_UPDATE(&ctx, &data[cur_offset], part_len);
 			num_parts++;
 			cur_offset += part_len;
 			remaining_len -= part_len;
 		}
 		if (remaining_len != 0 || rand_bool()) {
-			HASH_UPDATE(&ctx, &test_buf[cur_offset], remaining_len);
+			HASH_UPDATE(&ctx, &data[cur_offset], remaining_len);
 			num_parts++;
 		}
 		HASH_FINAL(&ctx, hash2);
@@ -141,11 +117,13 @@ static void test_hash_incremental_updates(struct kunit *test)
  */
 static void test_hash_buffer_overruns(struct kunit *test)
 {
-	const size_t max_tested_len = TEST_BUF_LEN - sizeof(struct HASH_CTX);
-	void *const buf_end = &test_buf[TEST_BUF_LEN];
+	const size_t buf_len = 16384;
+	u8 *buf = alloc_guarded_buf(test, buf_len);
+	void *const buf_end = &buf[buf_len];
+	const size_t max_tested_len = buf_len - sizeof(struct HASH_CTX);
 	struct HASH_CTX *guarded_ctx = buf_end - sizeof(*guarded_ctx);
 
-	rand_bytes(test_buf, TEST_BUF_LEN);
+	rand_bytes(buf, buf_len);
 
 	for (int i = 0; i < 100; i++) {
 		size_t len = rand_length(max_tested_len);
@@ -159,14 +137,14 @@ static void test_hash_buffer_overruns(struct kunit *test)
 		HASH_FINAL(&ctx, hash);
 
 		/* Check for overruns of the hash value buffer. */
-		HASH(test_buf, len, buf_end - HASH_SIZE);
+		HASH(buf, len, buf_end - HASH_SIZE);
 		HASH_INIT(&ctx);
-		HASH_UPDATE(&ctx, test_buf, len);
+		HASH_UPDATE(&ctx, buf, len);
 		HASH_FINAL(&ctx, buf_end - HASH_SIZE);
 
-		/* Check for overuns of the hash context. */
+		/* Check for overruns of the hash context. */
 		HASH_INIT(guarded_ctx);
-		HASH_UPDATE(guarded_ctx, test_buf, len);
+		HASH_UPDATE(guarded_ctx, buf, len);
 		HASH_FINAL(guarded_ctx, hash);
 	}
 }
@@ -177,30 +155,32 @@ static void test_hash_buffer_overruns(struct kunit *test)
  */
 static void test_hash_overlaps(struct kunit *test)
 {
-	const size_t max_tested_len = TEST_BUF_LEN - HASH_SIZE;
+	const size_t buf_len = 16384;
+	u8 *buf = alloc_guarded_buf(test, buf_len);
+	const size_t max_tested_len = buf_len - HASH_SIZE;
 	struct HASH_CTX ctx;
 	u8 hash[HASH_SIZE];
 
-	rand_bytes(test_buf, TEST_BUF_LEN);
+	rand_bytes(buf, buf_len);
 
 	for (int i = 0; i < 100; i++) {
 		size_t len = rand_length(max_tested_len);
 		size_t offset = HASH_SIZE + rand_offset(max_tested_len - len);
 		bool left_end = rand_bool();
-		u8 *ovl_hash = left_end ? &test_buf[offset] :
-					  &test_buf[offset + len - HASH_SIZE];
+		u8 *ovl_hash = left_end ? &buf[offset] :
+					  &buf[offset + len - HASH_SIZE];
 
-		HASH(&test_buf[offset], len, hash);
-		HASH(&test_buf[offset], len, ovl_hash);
+		HASH(&buf[offset], len, hash);
+		HASH(&buf[offset], len, ovl_hash);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, hash, ovl_hash, HASH_SIZE,
 			"Overlap test 1 failed with len=%zu offset=%zu left_end=%d",
 			len, offset, left_end);
 
 		/* Repeat the above test, but this time use init+update+final */
-		HASH(&test_buf[offset], len, hash);
+		HASH(&buf[offset], len, hash);
 		HASH_INIT(&ctx);
-		HASH_UPDATE(&ctx, &test_buf[offset], len);
+		HASH_UPDATE(&ctx, &buf[offset], len);
 		HASH_FINAL(&ctx, ovl_hash);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, hash, ovl_hash, HASH_SIZE,
@@ -208,10 +188,10 @@ static void test_hash_overlaps(struct kunit *test)
 			len, offset, left_end);
 
 		/* Test modifying the source data after it was used. */
-		HASH(&test_buf[offset], len, hash);
+		HASH(&buf[offset], len, hash);
 		HASH_INIT(&ctx);
-		HASH_UPDATE(&ctx, &test_buf[offset], len);
-		rand_bytes(&test_buf[offset], len);
+		HASH_UPDATE(&ctx, &buf[offset], len);
+		rand_bytes(&buf[offset], len);
 		HASH_FINAL(&ctx, ovl_hash);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, hash, ovl_hash, HASH_SIZE,
@@ -226,20 +206,22 @@ static void test_hash_overlaps(struct kunit *test)
  */
 static void test_hash_alignment_consistency(struct kunit *test)
 {
+	const size_t max_len = 16384;
+	u8 *data = alloc_guarded_buf(test, max_len);
 	u8 hash1[128 + HASH_SIZE];
 	u8 hash2[128 + HASH_SIZE];
 
 	for (int i = 0; i < 100; i++) {
-		size_t len = rand_length(TEST_BUF_LEN);
-		size_t data_offs1 = rand_offset(TEST_BUF_LEN - len);
-		size_t data_offs2 = rand_offset(TEST_BUF_LEN - len);
+		size_t len = rand_length(max_len);
+		size_t data_offs1 = rand_offset(max_len - len);
+		size_t data_offs2 = rand_offset(max_len - len);
 		size_t hash_offs1 = rand_offset(128);
 		size_t hash_offs2 = rand_offset(128);
 
-		rand_bytes(&test_buf[data_offs1], len);
-		HASH(&test_buf[data_offs1], len, &hash1[hash_offs1]);
-		memmove(&test_buf[data_offs2], &test_buf[data_offs1], len);
-		HASH(&test_buf[data_offs2], len, &hash2[hash_offs2]);
+		rand_bytes(&data[data_offs1], len);
+		HASH(&data[data_offs1], len, &hash1[hash_offs1]);
+		memmove(&data[data_offs2], &data[data_offs1], len);
+		HASH(&data[data_offs2], len, &hash2[hash_offs2]);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, &hash1[hash_offs1], &hash2[hash_offs2], HASH_SIZE,
 			"Alignment consistency test failed with len=%zu data_offs=(%zu,%zu) hash_offs=(%zu,%zu)",
@@ -252,11 +234,14 @@ static void test_hash_ctx_zeroization(struct kunit *test)
 {
 	static const u8 zeroes[sizeof(struct HASH_CTX)];
 	struct HASH_CTX ctx;
+	const size_t data_len = 128;
+	u8 *data = alloc_buf(test, data_len);
+	u8 hash[HASH_SIZE];
 
-	rand_bytes(test_buf, 128);
+	rand_bytes(data, data_len);
 	HASH_INIT(&ctx);
-	HASH_UPDATE(&ctx, test_buf, 128);
-	HASH_FINAL(&ctx, test_buf);
+	HASH_UPDATE(&ctx, data, data_len);
+	HASH_FINAL(&ctx, hash);
 	KUNIT_ASSERT_MEMEQ_MSG(test, &ctx, zeroes, sizeof(ctx),
 			       "Hash context was not zeroized by finalization");
 }
@@ -265,6 +250,7 @@ static void test_hash_ctx_zeroization(struct kunit *test)
 #define IRQ_TEST_NUM_BUFFERS 3 /* matches max concurrency level */
 
 struct hash_irq_test1_state {
+	u8 *data;
 	u8 expected_hashes[IRQ_TEST_NUM_BUFFERS][HASH_SIZE];
 	atomic_t seqno;
 };
@@ -280,7 +266,8 @@ static bool hash_irq_test1_func(void *state_)
 	u32 i = (u32)atomic_inc_return(&state->seqno) % IRQ_TEST_NUM_BUFFERS;
 	u8 actual_hash[HASH_SIZE];
 
-	HASH(&test_buf[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN, actual_hash);
+	HASH(&state->data[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN,
+	     actual_hash);
 	return memcmp(actual_hash, state->expected_hashes[i], HASH_SIZE) == 0;
 }
 
@@ -290,12 +277,14 @@ static bool hash_irq_test1_func(void *state_)
  */
 static void test_hash_interrupt_context_1(struct kunit *test)
 {
+	const size_t total_data_len = IRQ_TEST_NUM_BUFFERS * IRQ_TEST_DATA_LEN;
 	struct hash_irq_test1_state state = {};
 
 	/* Prepare some test messages and compute the expected hash of each. */
-	rand_bytes(test_buf, IRQ_TEST_NUM_BUFFERS * IRQ_TEST_DATA_LEN);
+	state.data = alloc_buf(test, total_data_len);
+	rand_bytes(state.data, total_data_len);
 	for (int i = 0; i < IRQ_TEST_NUM_BUFFERS; i++)
-		HASH(&test_buf[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN,
+		HASH(&state.data[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN,
 		     state.expected_hashes[i]);
 
 	kunit_run_irq_test(test, hash_irq_test1_func, 100000, &state);
@@ -309,6 +298,8 @@ struct hash_irq_test2_hash_ctx {
 };
 
 struct hash_irq_test2_state {
+	u8 *data;
+	size_t data_len;
 	struct hash_irq_test2_hash_ctx ctxs[IRQ_TEST_NUM_BUFFERS];
 	u8 expected_hash[HASH_SIZE];
 	u16 update_lens[32];
@@ -341,7 +332,7 @@ static bool hash_irq_test2_func(void *state_)
 		ctx->step++;
 	} else if (ctx->step < state->num_steps - 1) {
 		/* Update step */
-		HASH_UPDATE(&ctx->hash_ctx, &test_buf[ctx->offset],
+		HASH_UPDATE(&ctx->hash_ctx, &state->data[ctx->offset],
 			    state->update_lens[ctx->step - 1]);
 		ctx->offset += state->update_lens[ctx->step - 1];
 		ctx->step++;
@@ -349,7 +340,7 @@ static bool hash_irq_test2_func(void *state_)
 		/* Final step */
 		u8 actual_hash[HASH_SIZE];
 
-		if (WARN_ON_ONCE(ctx->offset != TEST_BUF_LEN))
+		if (WARN_ON_ONCE(ctx->offset != state->data_len))
 			ret = false;
 		HASH_FINAL(&ctx->hash_ctx, actual_hash);
 		if (memcmp(actual_hash, state->expected_hash, HASH_SIZE) != 0)
@@ -370,20 +361,23 @@ static bool hash_irq_test2_func(void *state_)
  */
 static void test_hash_interrupt_context_2(struct kunit *test)
 {
+	const size_t data_len = 16384;
 	struct hash_irq_test2_state *state;
-	int remaining = TEST_BUF_LEN;
+	size_t remaining = data_len;
 
 	state = kunit_kzalloc(test, sizeof(*state), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, state);
+	state->data_len = data_len;
+	state->data = alloc_buf(test, data_len);
 
-	rand_bytes(test_buf, TEST_BUF_LEN);
-	HASH(test_buf, TEST_BUF_LEN, state->expected_hash);
+	rand_bytes(state->data, data_len);
+	HASH(state->data, data_len, state->expected_hash);
 
 	/*
 	 * Generate a list of update lengths to use.  Ensure that it contains
 	 * multiple entries but is limited to a maximum length.
 	 */
-	static_assert(TEST_BUF_LEN / 4096 > 1);
+	KUNIT_ASSERT_GT(test, data_len / 4096, 1);
 	for (state->num_steps = 0;
 	     state->num_steps < ARRAY_SIZE(state->update_lens) - 1 && remaining;
 	     state->num_steps++) {
@@ -429,21 +423,23 @@ static void test_hash_interrupt_context_2(struct kunit *test)
  */
 static void test_hmac(struct kunit *test)
 {
+	const size_t max_data_len = 4096;
+	const size_t max_key_len = 293;
+	const size_t outer_key_len = 32;
+	u8 *data = alloc_guarded_buf(test, max_data_len);
+	u8 *raw_key = alloc_guarded_buf(test, max_key_len);
 	static const u8 zeroes[sizeof(struct HMAC_CTX)];
-	u8 *raw_key;
 	struct HMAC_KEY key;
 	struct HMAC_CTX ctx;
 	u8 mac[HASH_SIZE];
 	u8 mac2[HASH_SIZE];
 
-	static_assert(TEST_BUF_LEN >= 4096 + 293);
-	rand_bytes_seeded_from_len(test_buf, 4096);
-	raw_key = &test_buf[4096];
+	rand_bytes_seeded_from_len(data, max_data_len);
+	rand_bytes_seeded_from_len(raw_key, outer_key_len);
 
-	rand_bytes_seeded_from_len(raw_key, 32);
-	HMAC_PREPAREKEY(&key, raw_key, 32);
+	HMAC_PREPAREKEY(&key, raw_key, outer_key_len);
 	HMAC_INIT(&ctx, &key);
-	for (size_t data_len = 0; data_len <= 4096; data_len++) {
+	for (size_t data_len = 0; data_len <= max_data_len; data_len++) {
 		/*
 		 * Cycle through key lengths as well.  Somewhat arbitrarily go
 		 * up to 293, which is somewhat larger than the largest hash
@@ -451,17 +447,17 @@ static void test_hmac(struct kunit *test)
 		 * hashed down to one block); going higher would not be useful.
 		 * To reduce correlation with data_len, use a prime number here.
 		 */
-		size_t key_len = data_len % 293;
+		size_t key_len = data_len % max_key_len;
 
-		HMAC_UPDATE(&ctx, test_buf, data_len);
+		HMAC_UPDATE(&ctx, data, data_len);
 
 		rand_bytes_seeded_from_len(raw_key, key_len);
-		HMAC_USINGRAWKEY(raw_key, key_len, test_buf, data_len, mac);
+		HMAC_USINGRAWKEY(raw_key, key_len, data, data_len, mac);
 		HMAC_UPDATE(&ctx, mac, HASH_SIZE);
 
 		/* Verify that HMAC() is consistent with HMAC_USINGRAWKEY(). */
 		HMAC_PREPAREKEY(&key, raw_key, key_len);
-		HMAC(&key, test_buf, data_len, mac2);
+		HMAC(&key, data, data_len, mac2);
 		KUNIT_ASSERT_MEMEQ_MSG(
 			test, mac, mac2, HASH_SIZE,
 			"HMAC gave different results with raw and prepared keys");
@@ -484,14 +480,17 @@ static void benchmark_hash(struct kunit *test)
 		1,   16,  64,	127,  128,  200,   256,
 		511, 512, 1024, 3173, 4096, 16384,
 	};
+	const size_t max_len = 16384;
+	u8 *data = alloc_buf(test, max_len);
 	u8 hash[HASH_SIZE];
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
 		kunit_skip(test, "not enabled");
 
 	/* Warm-up */
-	for (size_t i = 0; i < 10000000; i += TEST_BUF_LEN)
-		HASH(test_buf, TEST_BUF_LEN, hash);
+	memset(data, 0, max_len);
+	for (size_t i = 0; i < 10000000; i += max_len)
+		HASH(data, max_len, hash);
 
 	for (size_t i = 0; i < ARRAY_SIZE(lens_to_test); i++) {
 		size_t len = lens_to_test[i];
@@ -499,11 +498,11 @@ static void benchmark_hash(struct kunit *test)
 		size_t num_iters = 10000000 / (len + 128);
 		u64 t;
 
-		KUNIT_ASSERT_LE(test, len, TEST_BUF_LEN);
+		KUNIT_ASSERT_LE(test, len, max_len);
 		preempt_disable();
 		t = ktime_get_ns();
 		for (size_t j = 0; j < num_iters; j++)
-			HASH(test_buf, len, hash);
+			HASH(data, len, hash);
 		t = ktime_get_ns() - t;
 		preempt_enable();
 		kunit_info(test, "len=%zu: %llu MB/s", len,
diff --git a/lib/crypto/tests/md5_kunit.c b/lib/crypto/tests/md5_kunit.c
index 38bd52c25ae3..1598f8585b45 100644
--- a/lib/crypto/tests/md5_kunit.c
+++ b/lib/crypto/tests/md5_kunit.c
@@ -30,8 +30,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "md5",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/poly1305_kunit.c b/lib/crypto/tests/poly1305_kunit.c
index 7ac191bd96b6..f3cb6245bc29 100644
--- a/lib/crypto/tests/poly1305_kunit.c
+++ b/lib/crypto/tests/poly1305_kunit.c
@@ -46,12 +46,7 @@ static void poly1305_withtestkey(const u8 *data, size_t len,
 static int poly1305_suite_init(struct kunit_suite *suite)
 {
 	rand_bytes_seeded_from_len(test_key, POLY1305_KEY_SIZE);
-	return hash_suite_init(suite);
-}
-
-static void poly1305_suite_exit(struct kunit_suite *suite)
-{
-	hash_suite_exit(suite);
+	return 0;
 }
 
 /*
@@ -81,19 +76,20 @@ static void poly1305_suite_exit(struct kunit_suite *suite)
  */
 static void test_poly1305_allones_keys_and_message(struct kunit *test)
 {
+	const size_t max_len = 4096;
+	u8 *data = alloc_buf(test, max_len);
 	struct poly1305_desc_ctx mac_ctx, macofmacs_ctx;
 	u8 mac[POLY1305_DIGEST_SIZE];
 
-	static_assert(TEST_BUF_LEN >= 4096);
-	memset(test_buf, 0xff, 4096);
+	memset(data, 0xff, max_len);
 
-	poly1305_init(&mac_ctx, test_buf);
-	poly1305_init(&macofmacs_ctx, test_buf);
+	poly1305_init(&mac_ctx, data);
+	poly1305_init(&macofmacs_ctx, data);
 	for (int i = 0; i < 32; i++) {
-		for (size_t len = 0; len <= 4096; len += 16) {
+		for (size_t len = 0; len <= max_len; len += 16) {
 			struct poly1305_desc_ctx tmp_ctx;
 
-			poly1305_update(&mac_ctx, test_buf, len);
+			poly1305_update(&mac_ctx, data, len);
 			tmp_ctx = mac_ctx;
 			poly1305_final(&tmp_ctx, mac);
 			poly1305_update(&macofmacs_ctx, mac,
@@ -157,7 +153,6 @@ static struct kunit_suite poly1305_test_suite = {
 	.name = "poly1305",
 	.test_cases = poly1305_test_cases,
 	.suite_init = poly1305_suite_init,
-	.suite_exit = poly1305_suite_exit,
 };
 kunit_test_suite(poly1305_test_suite);
 
diff --git a/lib/crypto/tests/polyval_kunit.c b/lib/crypto/tests/polyval_kunit.c
index d1f53a690ab8..2835929e890c 100644
--- a/lib/crypto/tests/polyval_kunit.c
+++ b/lib/crypto/tests/polyval_kunit.c
@@ -66,17 +66,18 @@ static void test_polyval_rfc8452_testvec(struct kunit *test)
  */
 static void test_polyval_allones_key_and_message(struct kunit *test)
 {
+	const size_t max_len = 4096;
+	u8 *data = alloc_buf(test, max_len);
 	struct polyval_key key;
 	struct polyval_ctx hashofhashes_ctx;
 	u8 hash[POLYVAL_BLOCK_SIZE];
 
-	static_assert(TEST_BUF_LEN >= 4096);
-	memset(test_buf, 0xff, 4096);
+	memset(data, 0xff, max_len);
 
-	polyval_preparekey(&key, test_buf);
+	polyval_preparekey(&key, data);
 	polyval_init(&hashofhashes_ctx, &key);
-	for (size_t len = 0; len <= 4096; len += 16) {
-		polyval(&key, test_buf, len, hash);
+	for (size_t len = 0; len <= max_len; len += 16) {
+		polyval(&key, data, len, hash);
 		polyval_update(&hashofhashes_ctx, hash, sizeof(hash));
 	}
 	polyval_final(&hashofhashes_ctx, hash);
@@ -95,7 +96,7 @@ static void check_key_consistency(struct kunit *test,
 				  const struct polyval_key *key1,
 				  const struct polyval_key *key2)
 {
-	u8 *data = test_buf;
+	u8 *data = alloc_buf(test, MAX_LEN_FOR_KEY_CHECK);
 	u8 hash1[POLYVAL_BLOCK_SIZE];
 	u8 hash2[POLYVAL_BLOCK_SIZE];
 
@@ -115,10 +116,10 @@ static void check_key_consistency(struct kunit *test,
 static void test_polyval_with_guarded_key(struct kunit *test)
 {
 	u8 raw_key[POLYVAL_BLOCK_SIZE];
-	u8 *guarded_raw_key = &test_buf[TEST_BUF_LEN - sizeof(raw_key)];
+	u8 *guarded_raw_key = alloc_guarded_buf(test, sizeof(raw_key));
 	struct polyval_key key1, key2;
 	struct polyval_key *guarded_key =
-		(struct polyval_key *)&test_buf[TEST_BUF_LEN - sizeof(key1)];
+		alloc_guarded_buf(test, sizeof(*guarded_key));
 
 	/* Prepare with regular buffers. */
 	rand_bytes(raw_key, sizeof(raw_key));
@@ -137,21 +138,20 @@ static void test_polyval_with_guarded_key(struct kunit *test)
 /*
  * Test that polyval_key only needs to be aligned to
  * __alignof__(struct polyval_key), i.e. 8 bytes.  The assembly code may prefer
- * 16-byte or higher alignment, but it musn't require it.
+ * 16-byte or higher alignment, but it mustn't require it.
  */
 static void test_polyval_with_minimally_aligned_key(struct kunit *test)
 {
 	u8 raw_key[POLYVAL_BLOCK_SIZE];
 	struct polyval_key key;
+	const size_t align = __alignof__(struct polyval_key);
+	u8 *key_buf = alloc_buf(test, sizeof(struct polyval_key) + 3 * align);
 	struct polyval_key *minaligned_key =
-		(struct polyval_key *)&test_buf[MAX_LEN_FOR_KEY_CHECK +
-						__alignof__(struct polyval_key)];
+		(struct polyval_key *)(PTR_ALIGN(key_buf, 2 * align) + align);
 
-	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key,
-					   __alignof__(struct polyval_key)));
+	KUNIT_ASSERT_TRUE(test, IS_ALIGNED((uintptr_t)minaligned_key, align));
 	KUNIT_ASSERT_TRUE(test,
-			  !IS_ALIGNED((uintptr_t)minaligned_key,
-				      2 * __alignof__(struct polyval_key)));
+			  !IS_ALIGNED((uintptr_t)minaligned_key, 2 * align));
 
 	rand_bytes(raw_key, sizeof(raw_key));
 	polyval_preparekey(&key, raw_key);
@@ -192,12 +192,7 @@ static int polyval_suite_init(struct kunit_suite *suite)
 
 	rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
 	polyval_preparekey(&test_key, raw_key);
-	return hash_suite_init(suite);
-}
-
-static void polyval_suite_exit(struct kunit_suite *suite)
-{
-	hash_suite_exit(suite);
+	return 0;
 }
 
 static struct kunit_case polyval_test_cases[] = {
@@ -215,7 +210,6 @@ static struct kunit_suite polyval_test_suite = {
 	.name = "polyval",
 	.test_cases = polyval_test_cases,
 	.suite_init = polyval_suite_init,
-	.suite_exit = polyval_suite_exit,
 };
 kunit_test_suite(polyval_test_suite);
 
diff --git a/lib/crypto/tests/sha1_kunit.c b/lib/crypto/tests/sha1_kunit.c
index 24ba8d5669c8..27286afaa407 100644
--- a/lib/crypto/tests/sha1_kunit.c
+++ b/lib/crypto/tests/sha1_kunit.c
@@ -30,8 +30,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "sha1",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/sha224_kunit.c b/lib/crypto/tests/sha224_kunit.c
index 962ad46b9c99..bcf8b90f9ae2 100644
--- a/lib/crypto/tests/sha224_kunit.c
+++ b/lib/crypto/tests/sha224_kunit.c
@@ -30,8 +30,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "sha224",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/sha256_kunit.c b/lib/crypto/tests/sha256_kunit.c
index 8758db3673c7..17daa09adfe7 100644
--- a/lib/crypto/tests/sha256_kunit.c
+++ b/lib/crypto/tests/sha256_kunit.c
@@ -86,19 +86,20 @@ static void test_sha256_finup_2x(struct kunit *test)
 static void test_sha256_finup_2x_defaultctx(struct kunit *test)
 {
 	const size_t data_len = 128;
+	u8 *data = alloc_buf(test, 2 * data_len);
 	struct sha256_ctx ctx;
 	u8 hash1_a[SHA256_DIGEST_SIZE];
 	u8 hash2_a[SHA256_DIGEST_SIZE];
 	u8 hash1_b[SHA256_DIGEST_SIZE];
 	u8 hash2_b[SHA256_DIGEST_SIZE];
 
-	rand_bytes(test_buf, 2 * data_len);
+	rand_bytes(data, 2 * data_len);
 
 	sha256_init(&ctx);
-	sha256_finup_2x(&ctx, test_buf, &test_buf[data_len], data_len, hash1_a,
+	sha256_finup_2x(&ctx, data, &data[data_len], data_len, hash1_a,
 			hash2_a);
 
-	sha256_finup_2x(NULL, test_buf, &test_buf[data_len], data_len, hash1_b,
+	sha256_finup_2x(NULL, data, &data[data_len], data_len, hash1_b,
 			hash2_b);
 
 	KUNIT_ASSERT_MEMEQ(test, hash1_a, hash1_b, SHA256_DIGEST_SIZE);
@@ -112,18 +113,19 @@ static void test_sha256_finup_2x_defaultctx(struct kunit *test)
 static void test_sha256_finup_2x_hugelen(struct kunit *test)
 {
 	const size_t data_len = 4 * SHA256_BLOCK_SIZE;
+	u8 *data = alloc_buf(test, data_len);
 	struct sha256_ctx ctx = {};
 	u8 expected_hash[SHA256_DIGEST_SIZE];
 	u8 hash[SHA256_DIGEST_SIZE];
 
-	rand_bytes(test_buf, data_len);
+	rand_bytes(data, data_len);
 	for (size_t align = 0; align < SHA256_BLOCK_SIZE; align++) {
 		sha256_init(&ctx);
 		ctx.ctx.bytecount = 0x123456789abcd00 + align;
 
-		sha256_finup_2x(&ctx, test_buf, test_buf, data_len, hash, hash);
+		sha256_finup_2x(&ctx, data, data, data_len, hash, hash);
 
-		sha256_update(&ctx, test_buf, data_len);
+		sha256_update(&ctx, data, data_len);
 		sha256_final(&ctx, expected_hash);
 
 		KUNIT_ASSERT_MEMEQ(test, hash, expected_hash,
@@ -142,6 +144,7 @@ static void benchmark_sha256_finup_2x(struct kunit *test)
 	static const size_t salt_lens_to_test[] = { 0, 32, 64 };
 	const size_t data_len = 4096;
 	const size_t num_iters = 4096;
+	u8 *data = alloc_buf(test, data_len * 2);
 	struct sha256_ctx ctx;
 	u8 hash1[SHA256_DIGEST_SIZE];
 	u8 hash2[SHA256_DIGEST_SIZE];
@@ -151,12 +154,12 @@ static void benchmark_sha256_finup_2x(struct kunit *test)
 	if (!sha256_finup_2x_is_optimized())
 		kunit_skip(test, "not relevant");
 
-	rand_bytes(test_buf, data_len * 2);
+	rand_bytes(data, data_len * 2);
 
 	/* Warm-up */
 	for (size_t i = 0; i < num_iters; i++)
-		sha256_finup_2x(NULL, &test_buf[0], &test_buf[data_len],
-				data_len, hash1, hash2);
+		sha256_finup_2x(NULL, &data[0], &data[data_len], data_len,
+				hash1, hash2);
 
 	for (size_t i = 0; i < ARRAY_SIZE(salt_lens_to_test); i++) {
 		size_t salt_len = salt_lens_to_test[i];
@@ -167,12 +170,12 @@ static void benchmark_sha256_finup_2x(struct kunit *test)
 		 * not measured; we're just interested in sha256_finup_2x().
 		 */
 		sha256_init(&ctx);
-		sha256_update(&ctx, test_buf, salt_len);
+		sha256_update(&ctx, data, salt_len);
 
 		preempt_disable();
 		t0 = ktime_get_ns();
 		for (size_t j = 0; j < num_iters; j++)
-			sha256_finup_2x(&ctx, &test_buf[0], &test_buf[data_len],
+			sha256_finup_2x(&ctx, &data[0], &data[data_len],
 					data_len, hash1, hash2);
 		t1 = ktime_get_ns();
 		preempt_enable();
@@ -196,8 +199,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "sha256",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/sha384_kunit.c b/lib/crypto/tests/sha384_kunit.c
index e1ef5c995bb6..76409822d965 100644
--- a/lib/crypto/tests/sha384_kunit.c
+++ b/lib/crypto/tests/sha384_kunit.c
@@ -30,8 +30,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "sha384",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/sha3_kunit.c b/lib/crypto/tests/sha3_kunit.c
index ed5fbe80337f..81b113079755 100644
--- a/lib/crypto/tests/sha3_kunit.c
+++ b/lib/crypto/tests/sha3_kunit.c
@@ -273,12 +273,10 @@ static void test_shake_all_lens_up_to_4096(struct kunit *test)
 {
 	struct sha3_ctx main_ctx;
 	const size_t max_len = 4096;
-	u8 *const in = test_buf;
-	u8 *const out = &test_buf[TEST_BUF_LEN - max_len];
+	u8 *const in = alloc_buf(test, max_len);
+	u8 *const out = alloc_buf(test, max_len);
 	u8 main_hash[SHA3_256_DIGEST_SIZE];
 
-	KUNIT_ASSERT_LE(test, 2 * max_len, TEST_BUF_LEN);
-
 	rand_bytes_seeded_from_len(in, max_len);
 	for (int alg = 0; alg < 2; alg++) {
 		sha3_256_init(&main_ctx);
@@ -309,12 +307,8 @@ static void test_shake_all_lens_up_to_4096(struct kunit *test)
 static void test_shake_multiple_squeezes(struct kunit *test)
 {
 	const size_t max_len = 512;
-	u8 *ref_out;
-
-	KUNIT_ASSERT_GE(test, TEST_BUF_LEN, 2 * max_len);
-
-	ref_out = kunit_kzalloc(test, max_len, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_NULL(test, ref_out);
+	u8 *buf = alloc_buf(test, max_len);
+	u8 *ref_out = alloc_buf(test, max_len);
 
 	for (int i = 0; i < 2000; i++) {
 		const int alg = rand32() % 2;
@@ -322,8 +316,8 @@ static void test_shake_multiple_squeezes(struct kunit *test)
 		const size_t out_len = rand_length(max_len);
 		const size_t in_offs = rand_offset(max_len - in_len);
 		const size_t out_offs = rand_offset(max_len - out_len);
-		u8 *const in = &test_buf[in_offs];
-		u8 *const out = &test_buf[out_offs];
+		u8 *const in = &buf[in_offs];
+		u8 *const out = &buf[out_offs];
 		struct shake_ctx ctx;
 		size_t remaining_len, j, num_parts;
 
@@ -368,16 +362,12 @@ static void test_shake_multiple_squeezes(struct kunit *test)
 static void test_shake_with_guarded_bufs(struct kunit *test)
 {
 	const size_t max_len = 512;
-	u8 *reg_buf;
-
-	KUNIT_ASSERT_GE(test, TEST_BUF_LEN, max_len);
-
-	reg_buf = kunit_kzalloc(test, max_len, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_NULL(test, reg_buf);
+	u8 *buf = alloc_guarded_buf(test, max_len);
+	u8 *reg_buf = alloc_buf(test, max_len);
 
 	for (int alg = 0; alg < 2; alg++) {
 		for (size_t len = 0; len <= max_len; len++) {
-			u8 *guarded_buf = &test_buf[TEST_BUF_LEN - len];
+			u8 *guarded_buf = &buf[max_len - len];
 
 			rand_bytes(reg_buf, len);
 			memcpy(guarded_buf, reg_buf, len);
@@ -413,8 +403,6 @@ static struct kunit_case sha3_test_cases[] = {
 static struct kunit_suite sha3_test_suite = {
 	.name = "sha3",
 	.test_cases = sha3_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(sha3_test_suite);
 
diff --git a/lib/crypto/tests/sha512_kunit.c b/lib/crypto/tests/sha512_kunit.c
index 8923e2d7d3d4..e03926c24403 100644
--- a/lib/crypto/tests/sha512_kunit.c
+++ b/lib/crypto/tests/sha512_kunit.c
@@ -30,8 +30,6 @@ static struct kunit_case hash_test_cases[] = {
 static struct kunit_suite hash_test_suite = {
 	.name = "sha512",
 	.test_cases = hash_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(hash_test_suite);
 
diff --git a/lib/crypto/tests/sm3_kunit.c b/lib/crypto/tests/sm3_kunit.c
index dc8136acdff6..1cba384946e9 100644
--- a/lib/crypto/tests/sm3_kunit.c
+++ b/lib/crypto/tests/sm3_kunit.c
@@ -22,8 +22,6 @@ static struct kunit_case sm3_test_cases[] = {
 static struct kunit_suite sm3_test_suite = {
 	.name = "sm3",
 	.test_cases = sm3_test_cases,
-	.suite_init = hash_suite_init,
-	.suite_exit = hash_suite_exit,
 };
 kunit_test_suite(sm3_test_suite);
 
-- 
2.55.0

