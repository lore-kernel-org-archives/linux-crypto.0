Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3022CBE9;
	Sun,  6 Jul 2025 23:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751844726; cv=none; b=KSfr8ITN78D1uQ0mKnAwOm/KIlPhwqgWeyUnhG/cn8OGyqNFZfwkj5OEWUB3yBjzFDQvH1xdTgFjjpbTFQzul6knjWUr+n7/8ht68auH1A04A3ObdCZ9SnP2pUTz3PlGpqBkw0MJ624u+xlMXkI1bz7z9Dya4FS0FQ7N2xbWZds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751844726; c=relaxed/simple;
	bh=AX6oFbmUVxtsITrgtUvIUasBzxfIBuJiTP/CfapuDls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouiincy1C2yDQBJiKrRrWokRDUqfnMc24lxUq2kMuL1c6z1JXuDnfGAK7FCOvnGeojYuQpPa+815o4wxCkAqxO23hN+6mZwybkxK58X2mevh+C4i6jXU+a9xta2etQFO/rTY18bNullE7cVsHdui7KvUQGeXwN3WYuLd9pQ+5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMDswcAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMDswcAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909A6C4CEF1;
	Sun,  6 Jul 2025 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751844726;
	bh=AX6oFbmUVxtsITrgtUvIUasBzxfIBuJiTP/CfapuDls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMDswcAOKxw7/wQ2dW/nZVEjZTKxJaUSN4LbINlnIvZbl+Kx+awB3LxTyeh8kyJc0
	 NKBH9uhYFa+qNhl6yj1lzOfw2r6OcfIGqWf5v8C9yCjnVbtSiRXHRCoD3H7JvZeARI
	 9DThLodwGBtvSiQ+229vPyO5XJAkuBUy+37OA7IOdDH4oBcpdtAGzLniHtv9wvnTCg
	 SYYI5lKoBY7pgYRAMEI42QLN87skLmbxYAyqlMsT7mBIhY3TDVxiELcCnxRNX0bIpr
	 aXV7XzH3zH5vjBUBqc9xcYrA+ngJ7jWdVvr4HL6CMxMwUyY1StjOnp2LbMRav+rrhO
	 O6EP70U52+RIQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 1/4] lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py
Date: Sun,  6 Jul 2025 16:28:14 -0700
Message-ID: <20250706232817.179500-2-ebiggers@kernel.org>
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

Add hash-test-template.h which generates the following KUnit test cases
for hash functions:

    test_hash_test_vectors
    test_hash_all_lens_up_to_4096
    test_hash_incremental_updates
    test_hash_buffer_overruns
    test_hash_overlaps
    test_hash_alignment_consistency
    test_hash_ctx_zeroization
    test_hash_interrupt_context_1
    test_hash_interrupt_context_2
    test_hmac  (when HMAC is supported)
    benchmark_hash  (when CONFIG_CRYPTO_LIB_BENCHMARK=y)

The initial use cases for this will be sha224_kunit, sha256_kunit,
sha384_kunit, sha512_kunit, and poly1305_kunit.

Add a Python script gen-hash-testvecs.py which generates the test
vectors required by test_hash_test_vectors,
test_hash_all_lens_up_to_4096, and test_hmac.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/hash-test-template.h | 680 ++++++++++++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py   | 102 ++++
 2 files changed, 782 insertions(+)
 create mode 100644 lib/crypto/tests/hash-test-template.h
 create mode 100755 scripts/crypto/gen-hash-testvecs.py

diff --git a/lib/crypto/tests/hash-test-template.h b/lib/crypto/tests/hash-test-template.h
new file mode 100644
index 000000000000..353457cf8a43
--- /dev/null
+++ b/lib/crypto/tests/hash-test-template.h
@@ -0,0 +1,680 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Test cases for hash functions, including a benchmark.  This is included by
+ * KUnit test suites that want to use it.  See sha512_kunit.c for an example.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <kunit/test.h>
+#include <linux/hrtimer.h>
+#include <linux/timekeeping.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+
+/* test_buf is a guarded buffer, i.e. &test_buf[TEST_BUF_LEN] is not mapped. */
+#define TEST_BUF_LEN 16384
+static u8 *test_buf;
+
+static u8 *orig_test_buf;
+
+static u64 random_seed;
+
+/*
+ * This is a simple linear congruential generator.  It is used only for testing,
+ * which does not require cryptographically secure random numbers.  A hard-coded
+ * algorithm is used instead of <linux/prandom.h> so that it matches the
+ * algorithm used by the test vector generation script.  This allows the input
+ * data in random test vectors to be concisely stored as just the seed.
+ */
+static u32 rand32(void)
+{
+	random_seed = (random_seed * 25214903917 + 11) & ((1ULL << 48) - 1);
+	return random_seed >> 16;
+}
+
+static void rand_bytes(u8 *out, size_t len)
+{
+	for (size_t i = 0; i < len; i++)
+		out[i] = rand32();
+}
+
+static void rand_bytes_seeded_from_len(u8 *out, size_t len)
+{
+	random_seed = len;
+	rand_bytes(out, len);
+}
+
+static bool rand_bool(void)
+{
+	return rand32() % 2;
+}
+
+/* Generate a random length, preferring small lengths. */
+static size_t rand_length(size_t max_len)
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
+static size_t rand_offset(size_t max_offset)
+{
+	return min(rand32() % 128, max_offset);
+}
+
+static int hash_suite_init(struct kunit_suite *suite)
+{
+	/*
+	 * Allocate the test buffer using vmalloc() with a page-aligned length
+	 * so that it is immediately followed by a guard page.  This allows
+	 * buffer overreads to be detected, even in assembly code.
+	 */
+	size_t alloc_len = round_up(TEST_BUF_LEN, PAGE_SIZE);
+
+	orig_test_buf = vmalloc(alloc_len);
+	if (!orig_test_buf)
+		return -ENOMEM;
+
+	test_buf = orig_test_buf + alloc_len - TEST_BUF_LEN;
+	return 0;
+}
+
+static void hash_suite_exit(struct kunit_suite *suite)
+{
+	vfree(orig_test_buf);
+	orig_test_buf = NULL;
+	test_buf = NULL;
+}
+
+/*
+ * Test the hash function against a list of test vectors.
+ *
+ * Note that it's only necessary to run each test vector in one way (e.g.,
+ * one-shot instead of incremental), since consistency between different ways of
+ * using the APIs is verified by other test cases.
+ */
+static void test_hash_test_vectors(struct kunit *test)
+{
+	for (size_t i = 0; i < ARRAY_SIZE(hash_testvecs); i++) {
+		size_t data_len = hash_testvecs[i].data_len;
+		u8 actual_hash[HASH_SIZE];
+
+		KUNIT_ASSERT_LE(test, data_len, TEST_BUF_LEN);
+		rand_bytes_seeded_from_len(test_buf, data_len);
+
+		HASH(test_buf, data_len, actual_hash);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, actual_hash, hash_testvecs[i].digest, HASH_SIZE,
+			"Wrong result with test vector %zu; data_len=%zu", i,
+			data_len);
+	}
+}
+
+/*
+ * Test that the hash function produces correct results for *every* length up to
+ * 4096 bytes.  To do this, generate seeded random data, then calculate a hash
+ * value for each length 0..4096, then hash the hash values.  Verify just the
+ * final hash value, which should match only when all hash values were correct.
+ */
+static void test_hash_all_lens_up_to_4096(struct kunit *test)
+{
+	struct HASH_CTX ctx;
+	u8 hash[HASH_SIZE];
+
+	static_assert(TEST_BUF_LEN >= 4096);
+	rand_bytes_seeded_from_len(test_buf, 4096);
+	HASH_INIT(&ctx);
+	for (size_t len = 0; len <= 4096; len++) {
+		HASH(test_buf, len, hash);
+		HASH_UPDATE(&ctx, hash, HASH_SIZE);
+	}
+	HASH_FINAL(&ctx, hash);
+	KUNIT_ASSERT_MEMEQ(test, hash, hash_testvec_consolidated, HASH_SIZE);
+}
+
+/*
+ * Test that the hash function produces the same result with a one-shot
+ * computation as it does with an incremental computation.
+ */
+static void test_hash_incremental_updates(struct kunit *test)
+{
+	for (int i = 0; i < 1000; i++) {
+		size_t total_len, offset;
+		struct HASH_CTX ctx;
+		u8 hash1[HASH_SIZE];
+		u8 hash2[HASH_SIZE];
+		size_t num_parts = 0;
+		size_t remaining_len, cur_offset;
+
+		total_len = rand_length(TEST_BUF_LEN);
+		offset = rand_offset(TEST_BUF_LEN - total_len);
+		rand_bytes(&test_buf[offset], total_len);
+
+		/* Compute the hash value in one shot. */
+		HASH(&test_buf[offset], total_len, hash1);
+
+		/*
+		 * Compute the hash value incrementally, using a randomly
+		 * selected sequence of update lengths that sum to total_len.
+		 */
+		HASH_INIT(&ctx);
+		remaining_len = total_len;
+		cur_offset = offset;
+		while (rand_bool()) {
+			size_t part_len = rand_length(remaining_len);
+
+			HASH_UPDATE(&ctx, &test_buf[cur_offset], part_len);
+			num_parts++;
+			cur_offset += part_len;
+			remaining_len -= part_len;
+		}
+		if (remaining_len != 0 || rand_bool()) {
+			HASH_UPDATE(&ctx, &test_buf[cur_offset], remaining_len);
+			num_parts++;
+		}
+		HASH_FINAL(&ctx, hash2);
+
+		/* Verify that the two hash values are the same. */
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, hash1, hash2, HASH_SIZE,
+			"Incremental test failed with total_len=%zu num_parts=%zu offset=%zu",
+			total_len, num_parts, offset);
+	}
+}
+
+/*
+ * Test that the hash function does not overrun any buffers.  Uses a guard page
+ * to catch buffer overruns even if they occur in assembly code.
+ */
+static void test_hash_buffer_overruns(struct kunit *test)
+{
+	const size_t max_tested_len = TEST_BUF_LEN - sizeof(struct HASH_CTX);
+	void *const buf_end = &test_buf[TEST_BUF_LEN];
+	struct HASH_CTX *guarded_ctx = buf_end - sizeof(*guarded_ctx);
+
+	rand_bytes(test_buf, TEST_BUF_LEN);
+
+	for (int i = 0; i < 100; i++) {
+		size_t len = rand_length(max_tested_len);
+		struct HASH_CTX ctx;
+		u8 hash[HASH_SIZE];
+
+		/* Check for overruns of the data buffer. */
+		HASH(buf_end - len, len, hash);
+		HASH_INIT(&ctx);
+		HASH_UPDATE(&ctx, buf_end - len, len);
+		HASH_FINAL(&ctx, hash);
+
+		/* Check for overruns of the hash value buffer. */
+		HASH(test_buf, len, buf_end - HASH_SIZE);
+		HASH_INIT(&ctx);
+		HASH_UPDATE(&ctx, test_buf, len);
+		HASH_FINAL(&ctx, buf_end - HASH_SIZE);
+
+		/* Check for overuns of the hash context. */
+		HASH_INIT(guarded_ctx);
+		HASH_UPDATE(guarded_ctx, test_buf, len);
+		HASH_FINAL(guarded_ctx, hash);
+	}
+}
+
+/*
+ * Test that the caller is permitted to alias the output digest and source data
+ * buffer, and also modify the source data buffer after it has been used.
+ */
+static void test_hash_overlaps(struct kunit *test)
+{
+	const size_t max_tested_len = TEST_BUF_LEN - HASH_SIZE;
+	struct HASH_CTX ctx;
+	u8 hash[HASH_SIZE];
+
+	rand_bytes(test_buf, TEST_BUF_LEN);
+
+	for (int i = 0; i < 100; i++) {
+		size_t len = rand_length(max_tested_len);
+		size_t offset = HASH_SIZE + rand_offset(max_tested_len - len);
+		bool left_end = rand_bool();
+		u8 *ovl_hash = left_end ? &test_buf[offset] :
+					  &test_buf[offset + len - HASH_SIZE];
+
+		HASH(&test_buf[offset], len, hash);
+		HASH(&test_buf[offset], len, ovl_hash);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, hash, ovl_hash, HASH_SIZE,
+			"Overlap test 1 failed with len=%zu offset=%zu left_end=%d",
+			len, offset, left_end);
+
+		/* Repeat the above test, but this time use init+update+final */
+		HASH(&test_buf[offset], len, hash);
+		HASH_INIT(&ctx);
+		HASH_UPDATE(&ctx, &test_buf[offset], len);
+		HASH_FINAL(&ctx, ovl_hash);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, hash, ovl_hash, HASH_SIZE,
+			"Overlap test 2 failed with len=%zu offset=%zu left_end=%d",
+			len, offset, left_end);
+
+		/* Test modifying the source data after it was used. */
+		HASH(&test_buf[offset], len, hash);
+		HASH_INIT(&ctx);
+		HASH_UPDATE(&ctx, &test_buf[offset], len);
+		rand_bytes(&test_buf[offset], len);
+		HASH_FINAL(&ctx, ovl_hash);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, hash, ovl_hash, HASH_SIZE,
+			"Overlap test 3 failed with len=%zu offset=%zu left_end=%d",
+			len, offset, left_end);
+	}
+}
+
+/*
+ * Test that if the same data is hashed at different alignments in memory, the
+ * results are the same.
+ */
+static void test_hash_alignment_consistency(struct kunit *test)
+{
+	u8 hash1[128 + HASH_SIZE];
+	u8 hash2[128 + HASH_SIZE];
+
+	for (int i = 0; i < 100; i++) {
+		size_t len = rand_length(TEST_BUF_LEN);
+		size_t data_offs1 = rand_offset(TEST_BUF_LEN - len);
+		size_t data_offs2 = rand_offset(TEST_BUF_LEN - len);
+		size_t hash_offs1 = rand_offset(128);
+		size_t hash_offs2 = rand_offset(128);
+
+		rand_bytes(&test_buf[data_offs1], len);
+		HASH(&test_buf[data_offs1], len, &hash1[hash_offs1]);
+		memmove(&test_buf[data_offs2], &test_buf[data_offs1], len);
+		HASH(&test_buf[data_offs2], len, &hash2[hash_offs2]);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, &hash1[hash_offs1], &hash2[hash_offs2], HASH_SIZE,
+			"Alignment consistency test failed with len=%zu data_offs=(%zu,%zu) hash_offs=(%zu,%zu)",
+			len, data_offs1, data_offs2, hash_offs1, hash_offs2);
+	}
+}
+
+/* Test that HASH_FINAL zeroizes the context. */
+static void test_hash_ctx_zeroization(struct kunit *test)
+{
+	static const u8 zeroes[sizeof(struct HASH_CTX)];
+	struct HASH_CTX ctx;
+
+	rand_bytes(test_buf, 128);
+	HASH_INIT(&ctx);
+	HASH_UPDATE(&ctx, test_buf, 128);
+	HASH_FINAL(&ctx, test_buf);
+	KUNIT_ASSERT_MEMEQ_MSG(test, &ctx, zeroes, sizeof(ctx),
+			       "Hash context was not zeroized by finalization");
+}
+
+#define IRQ_TEST_HRTIMER_INTERVAL us_to_ktime(5)
+
+struct hash_irq_test_state {
+	bool (*func)(void *test_specific_state);
+	void *test_specific_state;
+	bool task_func_reported_failure;
+	bool hardirq_func_reported_failure;
+	bool softirq_func_reported_failure;
+	unsigned long hardirq_func_calls;
+	unsigned long softirq_func_calls;
+	struct hrtimer timer;
+	struct work_struct bh_work;
+};
+
+static enum hrtimer_restart hash_irq_test_timer_func(struct hrtimer *timer)
+{
+	struct hash_irq_test_state *state =
+		container_of(timer, typeof(*state), timer);
+
+	WARN_ON_ONCE(!in_hardirq());
+	state->hardirq_func_calls++;
+
+	if (!state->func(state->test_specific_state))
+		state->hardirq_func_reported_failure = true;
+
+	hrtimer_forward_now(&state->timer, IRQ_TEST_HRTIMER_INTERVAL);
+	queue_work(system_bh_wq, &state->bh_work);
+	return HRTIMER_RESTART;
+}
+
+static void hash_irq_test_bh_work_func(struct work_struct *work)
+{
+	struct hash_irq_test_state *state =
+		container_of(work, typeof(*state), bh_work);
+
+	WARN_ON_ONCE(!in_serving_softirq());
+	state->softirq_func_calls++;
+
+	if (!state->func(state->test_specific_state))
+		state->softirq_func_reported_failure = true;
+}
+
+/*
+ * Helper function which repeatedly runs the given @func in task, softirq, and
+ * hardirq context concurrently, and reports a failure to KUnit if any
+ * invocation of @func in any context returns false.  @func is passed
+ * @test_specific_state as its argument.  At most 3 invocations of @func will
+ * run concurrently: one in each of task, softirq, and hardirq context.
+ *
+ * The main purpose of this interrupt context testing is to validate fallback
+ * code paths that run in contexts where the normal code path cannot be used,
+ * typically due to the FPU or vector registers already being in-use in kernel
+ * mode.  These code paths aren't covered when the test code is executed only by
+ * the KUnit test runner thread in task context.  The reason for the concurrency
+ * is because merely using hardirq context is not sufficient to reach a fallback
+ * code path on some architectures; the hardirq actually has to occur while the
+ * FPU or vector unit was already in-use in kernel mode.
+ *
+ * Another purpose of this testing is to detect issues with the architecture's
+ * irq_fpu_usable() and kernel_fpu_begin/end() or equivalent functions,
+ * especially in softirq context when the softirq may have interrupted a task
+ * already using kernel-mode FPU or vector (if the arch didn't prevent that).
+ * Crypto functions are often executed in softirqs, so this is important.
+ */
+static void run_irq_test(struct kunit *test, bool (*func)(void *),
+			 int max_iterations, void *test_specific_state)
+{
+	struct hash_irq_test_state state = {
+		.func = func,
+		.test_specific_state = test_specific_state,
+	};
+	unsigned long end_jiffies;
+
+	/*
+	 * Set up a hrtimer (the way we access hardirq context) and a work
+	 * struct for the BH workqueue (the way we access softirq context).
+	 */
+	hrtimer_setup_on_stack(&state.timer, hash_irq_test_timer_func,
+			       CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	INIT_WORK(&state.bh_work, hash_irq_test_bh_work_func);
+
+	/* Run for up to max_iterations or 1 second, whichever comes first. */
+	end_jiffies = jiffies + HZ;
+	hrtimer_start(&state.timer, IRQ_TEST_HRTIMER_INTERVAL,
+		      HRTIMER_MODE_REL);
+	for (int i = 0; i < max_iterations && !time_after(jiffies, end_jiffies);
+	     i++) {
+		if (!func(test_specific_state))
+			state.task_func_reported_failure = true;
+	}
+
+	/* Cancel the timer and work. */
+	hrtimer_cancel(&state.timer);
+	flush_work(&state.bh_work);
+
+	/* Sanity check: the timer and BH functions should have been run. */
+	KUNIT_EXPECT_GT_MSG(test, state.hardirq_func_calls, 0,
+			    "Timer function was not called");
+	KUNIT_EXPECT_GT_MSG(test, state.softirq_func_calls, 0,
+			    "BH work function was not called");
+
+	/* Check for incorrect hash values reported from any context. */
+	KUNIT_EXPECT_FALSE_MSG(
+		test, state.task_func_reported_failure,
+		"Incorrect hash values reported from task context");
+	KUNIT_EXPECT_FALSE_MSG(
+		test, state.hardirq_func_reported_failure,
+		"Incorrect hash values reported from hardirq context");
+	KUNIT_EXPECT_FALSE_MSG(
+		test, state.softirq_func_reported_failure,
+		"Incorrect hash values reported from softirq context");
+}
+
+#define IRQ_TEST_DATA_LEN 256
+#define IRQ_TEST_NUM_BUFFERS 3 /* matches max concurrency level */
+
+struct hash_irq_test1_state {
+	u8 expected_hashes[IRQ_TEST_NUM_BUFFERS][HASH_SIZE];
+	atomic_t seqno;
+};
+
+/*
+ * Compute the hash of one of the test messages and verify that it matches the
+ * expected hash from @state->expected_hashes.  To increase the chance of
+ * detecting problems, cycle through multiple messages.
+ */
+static bool hash_irq_test1_func(void *state_)
+{
+	struct hash_irq_test1_state *state = state_;
+	u32 i = (u32)atomic_inc_return(&state->seqno) % IRQ_TEST_NUM_BUFFERS;
+	u8 actual_hash[HASH_SIZE];
+
+	HASH(&test_buf[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN, actual_hash);
+	return memcmp(actual_hash, state->expected_hashes[i], HASH_SIZE) == 0;
+}
+
+/*
+ * Test that if hashes are computed in task, softirq, and hardirq context
+ * concurrently, then all results are as expected.
+ */
+static void test_hash_interrupt_context_1(struct kunit *test)
+{
+	struct hash_irq_test1_state state = {};
+
+	/* Prepare some test messages and compute the expected hash of each. */
+	rand_bytes(test_buf, IRQ_TEST_NUM_BUFFERS * IRQ_TEST_DATA_LEN);
+	for (int i = 0; i < IRQ_TEST_NUM_BUFFERS; i++)
+		HASH(&test_buf[i * IRQ_TEST_DATA_LEN], IRQ_TEST_DATA_LEN,
+		     state.expected_hashes[i]);
+
+	run_irq_test(test, hash_irq_test1_func, 100000, &state);
+}
+
+struct hash_irq_test2_hash_ctx {
+	struct HASH_CTX hash_ctx;
+	atomic_t in_use;
+	int offset;
+	int step;
+};
+
+struct hash_irq_test2_state {
+	struct hash_irq_test2_hash_ctx ctxs[IRQ_TEST_NUM_BUFFERS];
+	u8 expected_hash[HASH_SIZE];
+	u16 update_lens[32];
+	int num_steps;
+};
+
+static bool hash_irq_test2_func(void *state_)
+{
+	struct hash_irq_test2_state *state = state_;
+	struct hash_irq_test2_hash_ctx *ctx = &state->ctxs[0];
+	bool ret = true;
+
+	for (ctx = &state->ctxs[0]; ctx < &state->ctxs[ARRAY_SIZE(state->ctxs)];
+	     ctx++) {
+		if (atomic_cmpxchg(&ctx->in_use, 0, 1) == 0)
+			break;
+	}
+	if (WARN_ON_ONCE(ctx == &state->ctxs[ARRAY_SIZE(state->ctxs)])) {
+		/*
+		 * This should never happen, as the number of contexts is equal
+		 * to the maximum concurrency level of run_irq_test().
+		 */
+		return false;
+	}
+
+	if (ctx->step == 0) {
+		/* Init step */
+		HASH_INIT(&ctx->hash_ctx);
+		ctx->offset = 0;
+		ctx->step++;
+	} else if (ctx->step < state->num_steps - 1) {
+		/* Update step */
+		HASH_UPDATE(&ctx->hash_ctx, &test_buf[ctx->offset],
+			    state->update_lens[ctx->step - 1]);
+		ctx->offset += state->update_lens[ctx->step - 1];
+		ctx->step++;
+	} else {
+		/* Final step */
+		u8 actual_hash[HASH_SIZE];
+
+		if (WARN_ON_ONCE(ctx->offset != TEST_BUF_LEN))
+			ret = false;
+		HASH_FINAL(&ctx->hash_ctx, actual_hash);
+		if (memcmp(actual_hash, state->expected_hash, HASH_SIZE) != 0)
+			ret = false;
+		ctx->step = 0;
+	}
+	atomic_set_release(&ctx->in_use, 0);
+	return ret;
+}
+
+/*
+ * Test that if hashes are computed in task, softirq, and hardirq context
+ * concurrently, *including doing different parts of the same incremental
+ * computation in different contexts*, then all results are as expected.
+ * Besides detecting bugs similar to those that test_hash_interrupt_context_1
+ * can detect, this test case can also detect bugs where hash function
+ * implementations don't correctly handle these mixed incremental computations.
+ */
+static void test_hash_interrupt_context_2(struct kunit *test)
+{
+	struct hash_irq_test2_state state = {};
+	int remaining = TEST_BUF_LEN;
+
+	rand_bytes(test_buf, TEST_BUF_LEN);
+	HASH(test_buf, TEST_BUF_LEN, state.expected_hash);
+
+	/*
+	 * Generate a list of update lengths to use.  Ensure that it contains
+	 * multiple entries but is limited to a maximum length.
+	 */
+	static_assert(TEST_BUF_LEN / 4096 > 1);
+	for (state.num_steps = 0;
+	     state.num_steps < ARRAY_SIZE(state.update_lens) - 1 && remaining;
+	     state.num_steps++) {
+		state.update_lens[state.num_steps] =
+			rand_length(min(remaining, 4096));
+		remaining -= state.update_lens[state.num_steps];
+	}
+	if (remaining)
+		state.update_lens[state.num_steps++] = remaining;
+	state.num_steps += 2; /* for init and final */
+
+	run_irq_test(test, hash_irq_test2_func, 250000, &state);
+}
+
+#define UNKEYED_HASH_KUNIT_CASES                     \
+	KUNIT_CASE(test_hash_test_vectors),          \
+	KUNIT_CASE(test_hash_all_lens_up_to_4096),   \
+	KUNIT_CASE(test_hash_incremental_updates),   \
+	KUNIT_CASE(test_hash_buffer_overruns),       \
+	KUNIT_CASE(test_hash_overlaps),              \
+	KUNIT_CASE(test_hash_alignment_consistency), \
+	KUNIT_CASE(test_hash_ctx_zeroization),       \
+	KUNIT_CASE(test_hash_interrupt_context_1),   \
+	KUNIT_CASE(test_hash_interrupt_context_2)
+/* benchmark_hash is omitted so that the suites can put it last. */
+
+#ifdef HMAC
+/*
+ * Test the corresponding HMAC variant.
+ *
+ * This test case is fairly short, since HMAC is just a simple C wrapper around
+ * the underlying unkeyed hash function, which is already well-tested by the
+ * other test cases.  It's not useful to test things like data alignment or
+ * interrupt context again for HMAC, nor to have a long list of test vectors.
+ *
+ * Thus, just do a single consolidated test, which covers all data lengths up to
+ * 4096 bytes and all key lengths up to 292 bytes.  For each data length, select
+ * a key length, generate the inputs from a seed, and compute the HMAC value.
+ * Concatenate all these HMAC values together, and compute the HMAC of that.
+ * Verify that value.  If this fails, then the HMAC implementation is wrong.
+ * This won't show which specific input failed, but that should be fine.  Any
+ * failure would likely be non-input-specific or also show in the unkeyed tests.
+ */
+static void test_hmac(struct kunit *test)
+{
+	static const u8 zeroes[sizeof(struct HMAC_CTX)];
+	u8 *raw_key;
+	struct HMAC_KEY key;
+	struct HMAC_CTX ctx;
+	u8 mac[HASH_SIZE];
+	u8 mac2[HASH_SIZE];
+
+	static_assert(TEST_BUF_LEN >= 4096 + 293);
+	rand_bytes_seeded_from_len(test_buf, 4096);
+	raw_key = &test_buf[4096];
+
+	rand_bytes_seeded_from_len(raw_key, 32);
+	HMAC_PREPAREKEY(&key, raw_key, 32);
+	HMAC_INIT(&ctx, &key);
+	for (size_t data_len = 0; data_len <= 4096; data_len++) {
+		/*
+		 * Cycle through key lengths as well.  Somewhat arbitrarily go
+		 * up to 293, which is somewhat larger than the largest hash
+		 * block size (which is the size at which the key starts being
+		 * hashed down to one block); going higher would not be useful.
+		 * To reduce correlation with data_len, use a prime number here.
+		 */
+		size_t key_len = data_len % 293;
+
+		HMAC_UPDATE(&ctx, test_buf, data_len);
+
+		rand_bytes_seeded_from_len(raw_key, key_len);
+		HMAC_USINGRAWKEY(raw_key, key_len, test_buf, data_len, mac);
+		HMAC_UPDATE(&ctx, mac, HASH_SIZE);
+
+		/* Verify that HMAC() is consistent with HMAC_USINGRAWKEY(). */
+		HMAC_PREPAREKEY(&key, raw_key, key_len);
+		HMAC(&key, test_buf, data_len, mac2);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, mac, mac2, HASH_SIZE,
+			"HMAC gave different results with raw and prepared keys");
+	}
+	HMAC_FINAL(&ctx, mac);
+	KUNIT_EXPECT_MEMEQ_MSG(test, mac, hmac_testvec_consolidated, HASH_SIZE,
+			       "HMAC gave wrong result");
+	KUNIT_EXPECT_MEMEQ_MSG(test, &ctx, zeroes, sizeof(ctx),
+			       "HMAC context was not zeroized by finalization");
+}
+#define HASH_KUNIT_CASES UNKEYED_HASH_KUNIT_CASES, KUNIT_CASE(test_hmac)
+#else
+#define HASH_KUNIT_CASES UNKEYED_HASH_KUNIT_CASES
+#endif
+
+/* Benchmark the hash function on various data lengths. */
+static void benchmark_hash(struct kunit *test)
+{
+	static const size_t lens_to_test[] = {
+		1,   16,  64,	127,  128,  200,   256,
+		511, 512, 1024, 3173, 4096, 16384,
+	};
+	u8 hash[HASH_SIZE];
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* Warm-up */
+	for (size_t i = 0; i < 10000000; i += TEST_BUF_LEN)
+		HASH(test_buf, TEST_BUF_LEN, hash);
+
+	for (size_t i = 0; i < ARRAY_SIZE(lens_to_test); i++) {
+		size_t len = lens_to_test[i];
+		/* The '+ 128' tries to account for per-message overhead. */
+		size_t num_iters = 10000000 / (len + 128);
+		u64 t;
+
+		KUNIT_ASSERT_LE(test, len, TEST_BUF_LEN);
+		preempt_disable();
+		t = ktime_get_ns();
+		for (size_t j = 0; j < num_iters; j++)
+			HASH(test_buf, len, hash);
+		t = ktime_get_ns() - t;
+		preempt_enable();
+		kunit_info(test, "len=%zu: %llu MB/s", len,
+			   div64_u64((u64)len * num_iters * 1000, t ?: 1));
+	}
+}
diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
new file mode 100755
index 000000000000..55f1010339a6
--- /dev/null
+++ b/scripts/crypto/gen-hash-testvecs.py
@@ -0,0 +1,102 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Script that generates test vectors for the given cryptographic hash function.
+#
+# Copyright 2025 Google LLC
+
+import hashlib
+import hmac
+import sys
+
+DATA_LENS = [0, 1, 2, 3, 16, 32, 48, 49, 63, 64, 65, 127, 128, 129, 256, 511,
+             513, 1000, 3333, 4096, 4128, 4160, 4224, 16384]
+
+# Generate the given number of random bytes, using the length itself as the seed
+# for a simple linear congruential generator (LCG).  The C test code uses the
+# same LCG with the same seeding strategy to reconstruct the data, ensuring
+# reproducibility without explicitly storing the data in the test vectors.
+def rand_bytes(length):
+    seed = length
+    out = []
+    for _ in range(length):
+        seed = (seed * 25214903917 + 11) % 2**48
+        out.append((seed >> 16) % 256)
+    return bytes(out)
+
+def hash_init(alg):
+    return hashlib.new(alg)
+
+def hash_update(ctx, data):
+    ctx.update(data)
+
+def hash_final(ctx):
+    return ctx.digest()
+
+def compute_hash(alg, data):
+    ctx = hash_init(alg)
+    hash_update(ctx, data)
+    return hash_final(ctx)
+
+def print_bytes(prefix, value, bytes_per_line):
+    for i in range(0, len(value), bytes_per_line):
+        line = prefix + ''.join(f'0x{b:02x}, ' for b in value[i:i+bytes_per_line])
+        print(f'{line.rstrip()}')
+
+def print_static_u8_array_definition(name, value):
+    print('')
+    print(f'static const u8 {name} = {{')
+    print_bytes('\t', value, 8)
+    print('};')
+
+def print_c_struct_u8_array_field(name, value):
+    print(f'\t\t.{name} = {{')
+    print_bytes('\t\t\t', value, 8)
+    print('\t\t},')
+
+def gen_unkeyed_testvecs(alg):
+    print('')
+    print('static const struct {')
+    print('\tsize_t data_len;')
+    print(f'\tu8 digest[{alg.upper()}_DIGEST_SIZE];')
+    print('} hash_testvecs[] = {')
+    for data_len in DATA_LENS:
+        data = rand_bytes(data_len)
+        print('\t{')
+        print(f'\t\t.data_len = {data_len},')
+        print_c_struct_u8_array_field('digest', compute_hash(alg, data))
+        print('\t},')
+    print('};')
+
+    data = rand_bytes(4096)
+    ctx = hash_init(alg)
+    for data_len in range(len(data) + 1):
+        hash_update(ctx, compute_hash(alg, data[:data_len]))
+    print_static_u8_array_definition(
+            f'hash_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
+            hash_final(ctx))
+
+def gen_hmac_testvecs(alg):
+    ctx = hmac.new(rand_bytes(32), digestmod=alg)
+    data = rand_bytes(4096)
+    for data_len in range(len(data) + 1):
+        ctx.update(data[:data_len])
+        key_len = data_len % 293
+        key = rand_bytes(key_len)
+        mac = hmac.digest(key, data[:data_len], alg)
+        ctx.update(mac)
+    print_static_u8_array_definition(
+            f'hmac_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
+            ctx.digest())
+
+if len(sys.argv) != 2:
+    sys.stderr.write('Usage: gen-hash-testvecs.py ALGORITHM\n')
+    sys.stderr.write('ALGORITHM may be any supported by Python hashlib.\n')
+    sys.stderr.write('Example: gen-hash-testvecs.py sha512\n')
+    sys.exit(1)
+
+alg = sys.argv[1]
+print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
+print(f'/* This file was generated by: {sys.argv[0]} {" ".join(sys.argv[1:])} */')
+gen_unkeyed_testvecs(alg)
+gen_hmac_testvecs(alg)
-- 
2.50.0

