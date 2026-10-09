Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4322637F01C
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 12:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550498; cv=none; b=Xwyq0vixDfAV6HeRS5x+z7SGqHaGvJzQAQjElylhn+0Nqf2Axwj8wHi5Bzp1FHdscZyDq3i7CLKPZZgJ0JlL35VUZgW9053tJcc71k206bzAP43cpt1ulKUm3J/FJCC0MWTVeUxHT9pks52kcgwr+1biPhzEDs1GzMld2DgaOv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550498; c=relaxed/simple;
	bh=ms73bpaRQ14Wm2xvALq8u6ImiX6hH6fwQNRHoChOF64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFJGwkRAAycwDSG9sWKJEGJua2q+nF14pENuKBax/cgCAL+5Djp7LGrBeW8uBdJH9JT4P+Ust2WLJkmCP0dhvV9YSUofrx/uHK8hwaYXJwVxVWu3e+L8KfJ6aZE4bjyVXR0VqhwmK89q+QY7yKu0KXnTn1QTkoRM2IbuxAsaurg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhhcVz2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhhcVz2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B426D1F000FF;
	Fri,  9 Oct 2026 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550494;
	bh=/NbVMXyUZ5inxdgY2SLFCR/wfTPMAAJ5LYcvDhvians=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhhcVz2dcyR9Az8s/vN+8Z5V2P0Qh+R5tpwg5CFrNdL/J6N1au8J41Rh0mbhIJv//
	 jouk4ElWrEEEF12aO/DNsj9kfTIJkzCyaAVmXls7gsOyIHEoBOXHJCCkTZOeTRO1Xj
	 6N8G4qP5KTCleIUiD7wLOBWeTmgJANL0/zJcmcslTpzmptDTyNADOh5BqM0+Ndfisy
	 9dFr1mKoJYDJLkahmT0g7rJvMjVC+f1yDF9Qm1RGjIuzyI/nnNr2YhObGntKNSFAcN
	 eloItB4kmmzXLb0EK/uBriGfkTCyw8d9qcYtHzTnI4I3XlEZTmnN2IkNM9SRJSJRHk
	 fruVls0en554w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 2/2] lib/crypto: tests: Add Poly1305 split-update carry regression test
Date: Fri,  9 Oct 2026 14:53:54 +0200
Message-ID: <20261009125354.315476-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009125354.315476-1-ebiggers@kernel.org>
References: <20261009125354.315476-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test case which reproduces the bug fixed by commit f5602ce803dc
("lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state").
It is written in a fairly general way, such that it should also be able
to reproduce similar bugs in other implementations.

Update the comment on test_poly1305_allones_keys_and_message() to more
accurately describe what it does and differentiate it from the new test.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/poly1305_kunit.c | 97 ++++++++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 9 deletions(-)

diff --git a/lib/crypto/tests/poly1305_kunit.c b/lib/crypto/tests/poly1305_kunit.c
index f3cb6245bc29..d065d8b6442f 100644
--- a/lib/crypto/tests/poly1305_kunit.c
+++ b/lib/crypto/tests/poly1305_kunit.c
@@ -55,16 +55,17 @@ static int poly1305_suite_init(struct kunit_suite *suite)
  * - Using an all-one-bits r_key tests the key clamping.
  * - Using an all-one-bits s_key tests carries in implementations of the
  *   addition mod 2**128 during finalization.
- * - Using all-one-bits message, and to a lesser extent r_key, tends to maximize
- *   any intermediate accumulator values.  This increases the chance of
- *   detecting bugs that occur only in rare cases where the accumulator values
- *   get very large, for example the bug fixed by commit 678cce4019d746da
- *   ("crypto: x86/poly1305 - fix overflow during partial reduction").
+ * - Using all-one-bits message and r_key results in large values for the
+ *   internal products of r_key by (accumulator + message block).  This
+ *   increases the chance of detecting bugs that occur only in rare cases where
+ *   the sum of these internal products is very large, for example the bug fixed
+ *   by commit 678cce4019d746da ("crypto: x86/poly1305 - fix overflow during
+ *   partial reduction").
  *
- * Accumulator overflow bugs may be specific to particular update lengths (in
- * blocks) and/or particular values of the previous acculumator.  Note that the
- * accumulator starts at 0 which gives the lowest chance of an overflow.  Thus,
- * a single all-one-bits test vector may be insufficient.
+ * Bugs with the handling of large internal product sums may be specific to
+ * particular update lengths (in blocks) and/or require that the accumulator
+ * also have a large value.  Note that the accumulator starts at 0.  Thus, a
+ * single all-one-bits test vector may be insufficient.
  *
  * Considering that, do the following test: continuously update a single
  * Poly1305 context with all-one-bits data of varying lengths (0, 16, 32, ...,
@@ -141,10 +142,88 @@ static void test_poly1305_reduction_edge_cases(struct kunit *test)
 	}
 }
 
+/*
+ * Test that Poly1305 MACs are computed correctly when r_key=1, s_key=0, and the
+ * message consists of all-ones blocks.
+ *
+ * With r_key=1 and s_key=0, Poly1305 degrades to the sum of the padded blocks
+ * mod 2**130 - 5, then reduced mod 2**128.  A padded all-ones block maps to
+ * 2**128 + (2**128 - 1) = 2**129 - 1.  Two such blocks sum to 2**130 - 2, which
+ * is congruent to 3 mod 2**130 - 5.  Thus, the expected MAC is just 3 *
+ * floor(nblocks / 2), minus 1 if nblocks is odd, then reduced mod 2**128.  If
+ * nblocks == 1 this is 2**128 - 1, otherwise it's just a small integer.
+ *
+ * Inside the Poly1305 implementation in this case, the multiplication does
+ * nothing and each block just adds 2**129 - 1 to the accumulator.  Without the
+ * multiplication to mix things up, this results in some interesting values
+ * being reached where the limbs are at or near their maximum values, even after
+ * (lazy) reduction.  This can reproduce bugs that happen only in such cases.
+ *
+ * For example, this test case reproduces the bug fixed by commit f5602ce803dc
+ * ("lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state").
+ *
+ * However, reaching that bug required two consecutive updates: one with >= 8
+ * blocks to cause NEON code to be used and leave the accumulator in base 2**26
+ * with its limbs in a certain pattern, then one with an odd number of blocks >=
+ * 9 to cause NEON to be used again, but first processing one block using scalar
+ * code as a special case, triggering a conversion to base 2**64 where the carry
+ * into the 2**128 bit was lost.  To cover this and other similar edge cases
+ * that may exist in other Poly1305 implementations, just test all possible
+ * block-aligned splits between three poly1305_update() calls.
+ */
+static void test_poly1305_split_update_carry(struct kunit *test)
+{
+	static const u8 key[POLY1305_KEY_SIZE] = { 1 }; /* r_key=1, s_key=0 */
+	/*
+	 * Use max_nblocks=66 so that it's a bit more than twice the AVX-512
+	 * threshold of 32 blocks.
+	 */
+	const int max_nblocks = 66;
+	u8 *data = alloc_buf(test, max_nblocks * POLY1305_BLOCK_SIZE);
+	u8 expected_mac[POLY1305_DIGEST_SIZE];
+	u8 actual_mac[POLY1305_DIGEST_SIZE];
+	struct poly1305_desc_ctx ctx;
+
+	KUNIT_ASSERT_LE(test, 3 * (max_nblocks / 2), U8_MAX);
+
+	memset(data, 0xff, max_nblocks * POLY1305_BLOCK_SIZE);
+
+	for (int nblocks = 0; nblocks <= max_nblocks; nblocks++) {
+		size_t len = nblocks * POLY1305_BLOCK_SIZE;
+
+		expected_mac[0] = 3 * (nblocks / 2) - (nblocks % 2);
+		memset(&expected_mac[1], nblocks == 1 ? 0xff : 0,
+		       POLY1305_DIGEST_SIZE - 1);
+		for (size_t part1_len = 0; part1_len <= len;
+		     part1_len += POLY1305_BLOCK_SIZE) {
+			for (size_t part2_len = 0; part2_len <= len - part1_len;
+			     part2_len += POLY1305_BLOCK_SIZE) {
+				size_t part3_len = len - part1_len - part2_len;
+
+				poly1305_init(&ctx, key);
+				poly1305_update(&ctx, data, part1_len);
+				poly1305_update(&ctx, &data[part1_len],
+						part2_len);
+				poly1305_update(&ctx,
+						&data[part1_len + part2_len],
+						part3_len);
+				poly1305_final(&ctx, actual_mac);
+				KUNIT_ASSERT_MEMEQ_MSG(
+					test, actual_mac, expected_mac,
+					POLY1305_DIGEST_SIZE,
+					"Failed with nblocks=%d, part1_len=%zu, part2_len=%zu, part3_len=%zu",
+					nblocks, part1_len, part2_len,
+					part3_len);
+			}
+		}
+	}
+}
+
 static struct kunit_case poly1305_test_cases[] = {
 	HASH_KUNIT_CASES,
 	KUNIT_CASE(test_poly1305_allones_keys_and_message),
 	KUNIT_CASE(test_poly1305_reduction_edge_cases),
+	KUNIT_CASE(test_poly1305_split_update_carry),
 	KUNIT_CASE(benchmark_hash),
 	{},
 };
-- 
2.56.0

