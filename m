Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BE27260B;
	Sat,  7 Jun 2025 03:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749266603; cv=none; b=Rsu8CB5+yFazX7T77+qwZ+Vkgs9VdiRk9pytrAhwhqbAXkgL6l7O5+Sf5/T3FxlJxPFmBL2x3m61xdnVzmftB+gZlOgg5hdeWkok7CglINvQodewiTUwJ/DtdHWWfMb1F78AbpeaIU6SmqAbqg6LRbLy7+OFAFOg1w16rCC2n2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749266603; c=relaxed/simple;
	bh=4KkaeERUTza7ud5U3Lid+c15+viOHMNi1hI6jY0buFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BQcj6I1CGx4rcZioZdeKFCb2QhzFNwCJWf2sn09iB7e/cj9ktZ+GXwl+wCFARZwVohL6pWpKocdJdoBfpGgVDKO/LtaHv7kkF2bgpnHFHDnh6ICYf+4Xc6Rw3vGi069tJB7RfXJFlJMWruWDtmiWA+kasOIkPC0Lc/wVW0Jo1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMDff+EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMDff+EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3135C4CEE4;
	Sat,  7 Jun 2025 03:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749266602;
	bh=4KkaeERUTza7ud5U3Lid+c15+viOHMNi1hI6jY0buFw=;
	h=From:To:Cc:Subject:Date:From;
	b=QMDff+EHn50k39KtDFelpVUgwESch/vhZfXQTVvCvvhivYwoQWeZKLhq3t+SOP0UJ
	 Gfq+fLfIqh/HEnNJGklu9ImPZEHAmK0BbYn/itNv8PfMSopPuGSwu+bkZgPWOTg1G6
	 jiGy4aNvyhGhIg+qBi7LaeNzYZkr7OZoampwAK2l/Xg6/+K0tYTQqznc2foqkBWatF
	 cOxBFVzxzAyVb6Zx003H62NTCe3aZLoESxw9ZmRLDSk5XX23jD/gWP8M7j1R/9D8vs
	 NouM+QcEbhE5eGY/XW0qhkyzYlqXCUt/MftdDmLyNK0aN2crYnNAlIhmdQYMjNK8L5
	 DqCz70QVCc13Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc32: remove unused combination support
Date: Fri,  6 Jun 2025 20:22:28 -0700
Message-ID: <20250607032228.27868-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove crc32_le_combine() and crc32_le_shift(), since they are no longer
used.

Although combination is an interesting thing that can be done with CRCs,
it turned out that none of the users of it in the kernel were even close
to being worthwhile.  All were much better off simply chaining the CRCs
or processing zeroes.

Let's remove the CRC32 combination code for now.  It can come back
(potentially optimized with carryless multiplication instructions) if
there is ever a case where it would actually be worthwhile.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc32.h | 25 ----------------
 lib/crc32.c           | 67 -------------------------------------------
 lib/tests/crc_kunit.c | 39 +------------------------
 3 files changed, 1 insertion(+), 130 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index 8c1883b81b420..36bbc0405aa04 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -46,35 +46,10 @@ static inline u32 crc32c(u32 crc, const void *p, size_t len)
 u32 crc32_optimizations(void);
 #else
 static inline u32 crc32_optimizations(void) { return 0; }
 #endif
 
-/**
- * crc32_le_combine - Combine two crc32 check values into one. For two
- * 		      sequences of bytes, seq1 and seq2 with lengths len1
- * 		      and len2, crc32_le() check values were calculated
- * 		      for each, crc1 and crc2.
- *
- * @crc1: crc32 of the first block
- * @crc2: crc32 of the second block
- * @len2: length of the second block
- *
- * Return: The crc32_le() check value of seq1 and seq2 concatenated,
- * 	   requiring only crc1, crc2, and len2. Note: If seq_full denotes
- * 	   the concatenated memory area of seq1 with seq2, and crc_full
- * 	   the crc32_le() value of seq_full, then crc_full ==
- * 	   crc32_le_combine(crc1, crc2, len2) when crc_full was seeded
- * 	   with the same initializer as crc1, and crc2 seed was 0. See
- * 	   also crc32_combine_test().
- */
-u32 crc32_le_shift(u32 crc, size_t len);
-
-static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
-{
-	return crc32_le_shift(crc1, len2) ^ crc2;
-}
-
 #define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
 
 /*
  * Helpers for hash table generation of ethernet nics:
  *
diff --git a/lib/crc32.c b/lib/crc32.c
index 95429861d3aca..6811b37df2aad 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -23,11 +23,10 @@
  */
 
 /* see: Documentation/staging/crc32.rst for a description of algorithms */
 
 #include <linux/crc32.h>
-#include <linux/crc32poly.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
 #include "crc32table.h"
 
@@ -49,76 +48,10 @@ u32 crc32c_base(u32 crc, const u8 *p, size_t len)
 		crc = (crc >> 8) ^ crc32ctable_le[(crc & 255) ^ *p++];
 	return crc;
 }
 EXPORT_SYMBOL(crc32c_base);
 
-/*
- * This multiplies the polynomials x and y modulo the given modulus.
- * This follows the "little-endian" CRC convention that the lsbit
- * represents the highest power of x, and the msbit represents x^0.
- */
-static u32 gf2_multiply(u32 x, u32 y, u32 modulus)
-{
-	u32 product = x & 1 ? y : 0;
-	int i;
-
-	for (i = 0; i < 31; i++) {
-		product = (product >> 1) ^ (product & 1 ? modulus : 0);
-		x >>= 1;
-		product ^= x & 1 ? y : 0;
-	}
-
-	return product;
-}
-
-/**
- * crc32_generic_shift - Append @len 0 bytes to crc, in logarithmic time
- * @crc: The original little-endian CRC (i.e. lsbit is x^31 coefficient)
- * @len: The number of bytes. @crc is multiplied by x^(8*@len)
- * @polynomial: The modulus used to reduce the result to 32 bits.
- *
- * It's possible to parallelize CRC computations by computing a CRC
- * over separate ranges of a buffer, then summing them.
- * This shifts the given CRC by 8*len bits (i.e. produces the same effect
- * as appending len bytes of zero to the data), in time proportional
- * to log(len).
- */
-static u32 crc32_generic_shift(u32 crc, size_t len, u32 polynomial)
-{
-	u32 power = polynomial;	/* CRC of x^32 */
-	int i;
-
-	/* Shift up to 32 bits in the simple linear way */
-	for (i = 0; i < 8 * (int)(len & 3); i++)
-		crc = (crc >> 1) ^ (crc & 1 ? polynomial : 0);
-
-	len >>= 2;
-	if (!len)
-		return crc;
-
-	for (;;) {
-		/* "power" is x^(2^i), modulo the polynomial */
-		if (len & 1)
-			crc = gf2_multiply(crc, power, polynomial);
-
-		len >>= 1;
-		if (!len)
-			break;
-
-		/* Square power, advancing to x^(2^(i+1)) */
-		power = gf2_multiply(power, power, polynomial);
-	}
-
-	return crc;
-}
-
-u32 crc32_le_shift(u32 crc, size_t len)
-{
-	return crc32_generic_shift(crc, len, CRC32_POLY_LE);
-}
-EXPORT_SYMBOL(crc32_le_shift);
-
 u32 crc32_be_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ crc32table_be[(crc >> 24) ^ *p++];
 	return crc;
diff --git a/lib/tests/crc_kunit.c b/lib/tests/crc_kunit.c
index 064c2d5815579..f08d985d8860e 100644
--- a/lib/tests/crc_kunit.c
+++ b/lib/tests/crc_kunit.c
@@ -34,18 +34,16 @@ static size_t test_buflen;
  *	  Bit-reversed if @le is true.
  * @func: The function to compute a CRC.  The type signature uses u64 so that it
  *	  can fit any CRC up to CRC-64.  The CRC is passed in, and is expected
  *	  to be returned in, the least significant bits of the u64.  The
  *	  function is expected to *not* invert the CRC at the beginning and end.
- * @combine_func: Optional function to combine two CRCs.
  */
 struct crc_variant {
 	int bits;
 	bool le;
 	u64 poly;
 	u64 (*func)(u64 crc, const u8 *p, size_t len);
-	u64 (*combine_func)(u64 crc1, u64 crc2, size_t len2);
 };
 
 static u32 rand32(void)
 {
 	return prandom_u32_state(&rng);
@@ -142,11 +140,11 @@ static size_t generate_random_length(size_t max_length)
 	}
 	return len % (max_length + 1);
 }
 
 /* Test that v->func gives the same CRCs as a reference implementation. */
-static void crc_main_test(struct kunit *test, const struct crc_variant *v)
+static void crc_test(struct kunit *test, const struct crc_variant *v)
 {
 	size_t i;
 
 	for (i = 0; i < CRC_KUNIT_NUM_TEST_ITERS; i++) {
 		u64 init_crc, expected_crc, actual_crc;
@@ -186,39 +184,10 @@ static void crc_main_test(struct kunit *test, const struct crc_variant *v)
 				    "Wrong result with len=%zu offset=%zu nosimd=%d",
 				    len, offset, nosimd);
 	}
 }
 
-/* Test that CRC(concat(A, B)) == combine_CRCs(CRC(A), CRC(B), len(B)). */
-static void crc_combine_test(struct kunit *test, const struct crc_variant *v)
-{
-	int i;
-
-	for (i = 0; i < 100; i++) {
-		u64 init_crc = generate_random_initial_crc(v);
-		size_t len1 = generate_random_length(CRC_KUNIT_MAX_LEN);
-		size_t len2 = generate_random_length(CRC_KUNIT_MAX_LEN - len1);
-		u64 crc1, crc2, expected_crc, actual_crc;
-
-		prandom_bytes_state(&rng, test_buffer, len1 + len2);
-		crc1 = v->func(init_crc, test_buffer, len1);
-		crc2 = v->func(0, &test_buffer[len1], len2);
-		expected_crc = v->func(init_crc, test_buffer, len1 + len2);
-		actual_crc = v->combine_func(crc1, crc2, len2);
-		KUNIT_EXPECT_EQ_MSG(test, expected_crc, actual_crc,
-				    "CRC combination gave wrong result with len1=%zu len2=%zu\n",
-				    len1, len2);
-	}
-}
-
-static void crc_test(struct kunit *test, const struct crc_variant *v)
-{
-	crc_main_test(test, v);
-	if (v->combine_func)
-		crc_combine_test(test, v);
-}
-
 static __always_inline void
 crc_benchmark(struct kunit *test,
 	      u64 (*crc_func)(u64 crc, const u8 *p, size_t len))
 {
 	static const size_t lens_to_test[] = {
@@ -335,21 +304,15 @@ static void crc_t10dif_benchmark(struct kunit *test)
 static u64 crc32_le_wrapper(u64 crc, const u8 *p, size_t len)
 {
 	return crc32_le(crc, p, len);
 }
 
-static u64 crc32_le_combine_wrapper(u64 crc1, u64 crc2, size_t len2)
-{
-	return crc32_le_combine(crc1, crc2, len2);
-}
-
 static const struct crc_variant crc_variant_crc32_le = {
 	.bits = 32,
 	.le = true,
 	.poly = 0xedb88320,
 	.func = crc32_le_wrapper,
-	.combine_func = crc32_le_combine_wrapper,
 };
 
 static void crc32_le_test(struct kunit *test)
 {
 	crc_test(test, &crc_variant_crc32_le);

base-commit: 119b1e61a769aa98e68599f44721661a4d8c55f3
-- 
2.49.0

