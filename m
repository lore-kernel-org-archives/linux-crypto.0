Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810850;
	b=pr4j4nuRa9B0LRcYbMh1E+OuEVeltt0bcTjR/N4WjbYc2nGfgscxm5ksD0EsesQh3UyU
	 9RPgG9/lGrSrXu9Y3RDDpt+zAXNRVZcYHGPlZdbfr1jSlJSC56jV1+60PCZMKlaks/SRl
	 dFDDzk93nUb7Fx95lw0ntsWegn6qH8ohHMclrqTskllpfTCOsCgLOJAG8/4ZBkGLIz2wX
	 Ie0iQPdHofwJSTVzcOm9G6cgGlx7kLsMyR7GGBNocUMQBUjXepVCx3htdFcdeHL1D07Yr
	 qGjLzozA40ppAZRUO23sIlwbD5wYbSAJU29g5+v9SVf3gxrnNfLHHDOrJonAo971/Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LvSqrEZMarNVMQO8fw3XqhBkdUFgzPs3llLcNqZ8B+8=;
	b=2cp9wlc9JcqpUhPHkQtQ+GrrpygxGwuZLrPaSmhLPoxUVc54OM7sywMEZJ1CkGxKKQp8
	 DSYdRXANWPpHXyp+Nv9dfrMjMxVlbOMDl98l5PXbfLtXpaLCrFLZ+CTPr3+gZ6l8kAkb1
	 ZJp3S99w8hbOjsbx47xB8qS9SBVbsH1wVCRqt0oIiiX/bfSJ9bEw9WYRtj2IKUfUaiEu9
	 pM0j+xwlMD4mfdGzKE6CtTVBaKv3aviHR4e+vI7U/QG+E75pRgvH41cn0WmP7cp+SqgXB
	 pbvkxA6dW6y3yLYKO3u5wEtRRZOXfrva+6jJCsedEp1dl7Jy3CAfq3g0LXgCTVO0kKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W/CxLfCc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3E606A884
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/CxLfCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4C91F000C5;
	Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810850;
	bh=LvSqrEZMarNVMQO8fw3XqhBkdUFgzPs3llLcNqZ8B+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/CxLfCceuwLN7440n5BrpbSuiNaCI2UmWCer+jdfe+pnOwdd0k25l1SXO60c1YIc
	 c3onf3iEdUAgSGr6nbSYNe0bOvO/A/HVNQLlRjam5qD2kvc1FMeIurdRPy27bBLv6K
	 ph2cQVBHWx74VGFKzLDXg12MUqcHX5HmLL4CINoOMDIRxAsofk4/FLGv5qEPqFb+q7
	 Ai9uNDNkz+bRUNa+K40jy1swfzaW/WPrbIXGA6He47b/Bdps31nJAKQ3OTzh0xo7Iw
	 2hfsV6SWg2luGBcR39GMfNips7QNjdEoSKGHcSkd18NtjHdQ0CNilxeurnq51yqXQe
	 4a6vArGvZqtvw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/7] lib/crypto: tests: Add KUnit test suite for AES-CTR
Date: Sun, 15 Nov 2026 22:28:47 -0800
Message-ID: <20261116062849.1071038-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116062849.1071038-1-ebiggers@kernel.org>
References: <20261116062849.1071038-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for the AES-CTR library API.

It consists of:

- All the shared test cases from skcipher-test-template.h.  These
  include extensive consistency tests, a "Monte-Carlo test", and a
  benchmark.

- Tests against hardcoded AES-CTR test vectors from NIST SP 800-38A.

- A test for counter overflows across 8-bit, 32-bit, 64-bit, and 128-bit
  boundaries, comparing against a reference implementation built on top
  of aes_encrypt().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig          |   1 +
 lib/crypto/tests/Kconfig         |   9 ++
 lib/crypto/tests/Makefile        |   1 +
 lib/crypto/tests/aes_ctr_kunit.c | 196 +++++++++++++++++++++++++++++++
 4 files changed, 207 insertions(+)
 create mode 100644 lib/crypto/tests/aes_ctr_kunit.c

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index c3ac80ccb695..465375a1a14c 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -5,6 +5,7 @@ CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_AES_CTR_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index b0b0ae84a02e..0d13ce05f2de 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -27,6 +27,15 @@ config CRYPTO_LIB_AES_CCM_KUNIT_TEST
 	help
 	  KUnit tests for the AES-CCM authenticated encryption algorithm.
 
+config CRYPTO_LIB_AES_CTR_KUNIT_TEST
+	tristate "KUnit tests for AES-CTR" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_AES_CTR
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# This test uses BLAKE2s, but that's always built-in.
+	help
+	  KUnit tests for the AES-CTR stream cipher.
+
 config CRYPTO_LIB_AES_ECB_KUNIT_TEST
 	tristate "KUnit tests for AES-ECB" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_ECB
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index fa22a4138a68..1deb07c2558f 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST) += aes_cbc_kunit.o aes_cbc_cts_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_CTR_KUNIT_TEST) += aes_ctr_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST) += aes_ecb_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST) += aes_gcm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
diff --git a/lib/crypto/tests/aes_ctr_kunit.c b/lib/crypto/tests/aes_ctr_kunit.c
new file mode 100644
index 000000000000..344fc9e9571d
--- /dev/null
+++ b/lib/crypto/tests/aes_ctr_kunit.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-CTR
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-ctr.h>
+#include <crypto/blake2s.h>
+#include "sp800-38a-data.h"
+#include "test-utils.h"
+
+static void aes_ctr_test(u8 *dst, const u8 *src, size_t len, u8 *ctr,
+			 aes_encrypt_arg key, bool cont)
+{
+	aes_ctr(dst, src, len, ctr, key);
+}
+
+static const size_t aes_ctr_valid_key_lens[] = { AES_KEYSIZE_128,
+						 AES_KEYSIZE_192,
+						 AES_KEYSIZE_256 };
+#define SKCIPHER_VALID_KEY_LENS aes_ctr_valid_key_lens
+#define SKCIPHER_MAX_KEY_LEN AES_MAX_KEY_SIZE
+#define SKCIPHER_IV_LEN AES_BLOCK_SIZE /* the 128-bit big endian counter */
+#define SKCIPHER_MIN_DATA_LEN 0
+#define SKCIPHER_DATA_LEN_ALIGN 1
+
+#define SKCIPHER_KEY aes_key
+#define SKCIPHER_PREPAREKEY aes_preparekey
+#define SKCIPHER_ENCRYPT aes_ctr_test
+#define SKCIPHER_DECRYPT aes_ctr_test
+
+#define SKCIPHER_ENCKEY aes_enckey
+#define SKCIPHER_PREPAREENCKEY aes_prepareenckey
+#define SKCIPHER_INCREMENTAL
+#define SKCIPHER_NONFINAL_DATA_LEN_ALIGN AES_BLOCK_SIZE
+#define SKCIPHER_NEXT_IV_ALWAYS_DEFINED
+
+/* This value was generated by gen-skcipher-testvecs.py. */
+static const u8 aes_ctr_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x1e, 0x14, 0xcd, 0x03, 0x44, 0x7d, 0x85, 0xa3, 0x4b, 0xdc, 0x97,
+	0xd4, 0xb8, 0x0d, 0x06, 0xd8, 0x53, 0x66, 0x75, 0xde, 0x62, 0xd5,
+	0x4e, 0x01, 0xc8, 0xf0, 0x1b, 0xb6, 0xbd, 0xc6, 0xd8, 0x9e,
+};
+#define SKCIPHER_MONTE_CARLO_CHECKSUM aes_ctr_monte_carlo_checksum
+
+#include "skcipher-test-template.h"
+
+#define SP800_38A_CTR_IV                   \
+	"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7" \
+	"\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
+
+/* The initial counter plus 4, i.e. the counter after 64 bytes */
+#define SP800_38A_CTR_NEXT_IV              \
+	"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7" \
+	"\xf8\xf9\xfa\xfb\xfc\xfd\xff\x03"
+
+/* AES-CTR test vectors from NIST SP 800-38A */
+static const struct skcipher_testvec aes_ctr_testvecs[] = {
+	{
+		.name = "SP 800-38A F.5.1 (CTR-AES128)",
+		.key = SP800_38A_KEY128,
+		.key_len = 16,
+		.iv = SP800_38A_CTR_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x87\x4d\x61\x91\xb6\x20\xe3\x26"
+			 "\x1b\xef\x68\x64\x99\x0d\xb6\xce"
+			 "\x98\x06\xf6\x6b\x79\x70\xfd\xff"
+			 "\x86\x17\x18\x7b\xb9\xff\xfd\xff"
+			 "\x5a\xe4\xdf\x3e\xdb\xd5\xd3\x5e"
+			 "\x5b\x4f\x09\x02\x0d\xb0\x3e\xab"
+			 "\x1e\x03\x1d\xda\x2f\xbe\x03\xd1"
+			 "\x79\x21\x70\xa0\xf3\x00\x9c\xee",
+		.data_len = 64,
+		.next_iv = SP800_38A_CTR_NEXT_IV,
+	},
+	{
+		.name = "SP 800-38A F.5.3 (CTR-AES192)",
+		.key = SP800_38A_KEY192,
+		.key_len = 24,
+		.iv = SP800_38A_CTR_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x1a\xbc\x93\x24\x17\x52\x1c\xa2"
+			 "\x4f\x2b\x04\x59\xfe\x7e\x6e\x0b"
+			 "\x09\x03\x39\xec\x0a\xa6\xfa\xef"
+			 "\xd5\xcc\xc2\xc6\xf4\xce\x8e\x94"
+			 "\x1e\x36\xb2\x6b\xd1\xeb\xc6\x70"
+			 "\xd1\xbd\x1d\x66\x56\x20\xab\xf7"
+			 "\x4f\x78\xa7\xf6\xd2\x98\x09\x58"
+			 "\x5a\x97\xda\xec\x58\xc6\xb0\x50",
+		.data_len = 64,
+		.next_iv = SP800_38A_CTR_NEXT_IV,
+	},
+	{
+		.name = "SP 800-38A F.5.5 (CTR-AES256)",
+		.key = SP800_38A_KEY256,
+		.key_len = 32,
+		.iv = SP800_38A_CTR_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x60\x1e\xc3\x13\x77\x57\x89\xa5"
+			 "\xb7\xa7\xf5\x04\xbb\xf3\xd2\x28"
+			 "\xf4\x43\xe3\xca\x4d\x62\xb5\x9a"
+			 "\xca\x84\xe9\x90\xca\xca\xf5\xc5"
+			 "\x2b\x09\x30\xda\xa2\x3d\xe9\x4c"
+			 "\xe8\x70\x17\xba\x2d\x84\x98\x8d"
+			 "\xdf\xc9\xc5\x8d\xb6\x7a\xad\xa6"
+			 "\x13\xc2\xdd\x08\x45\x79\x41\xa6",
+		.data_len = 64,
+		.next_iv = SP800_38A_CTR_NEXT_IV,
+	},
+};
+
+static void test_aes_ctr_test_vectors(struct kunit *test)
+{
+	skcipher_run_testvecs(test, aes_ctr_testvecs,
+			      ARRAY_SIZE(aes_ctr_testvecs));
+}
+
+/* Reference implementation of AES-CTR, built on top of aes_encrypt() */
+static void aes_ctr_ref(u8 *dst, const u8 *src, size_t len,
+			u8 ctr[AES_BLOCK_SIZE], const struct aes_key *key)
+{
+	u8 keystream[AES_BLOCK_SIZE];
+
+	for (size_t i = 0; i < len; i += AES_BLOCK_SIZE) {
+		aes_encrypt(key, keystream, ctr);
+		for (size_t j = i; j < min(len, i + AES_BLOCK_SIZE); j++)
+			dst[j] = src[j] ^ keystream[j - i];
+		/* Increment the 128-bit big endian counter. */
+		for (int k = AES_BLOCK_SIZE - 1; k >= 0 && ++ctr[k] == 0; k--)
+			;
+	}
+}
+
+/*
+ * Test that AES-CTR correctly handles the counter crossing an 8-bit, 32-bit,
+ * 64-bit, or 128-bit boundary, which some optimized implementations handle
+ * specially.  The counter starts 1 to 64 blocks before the boundary.  Compare
+ * against a reference implementation, and also verify that the counter is
+ * advanced by the number of blocks (including any partial block) each time.
+ */
+static void test_aes_ctr_counter_overflow(struct kunit *test)
+{
+	static const int carry_bits[] = { 8, 32, 64, 128 };
+	const size_t max_data_len = 2048;
+	const struct skcipher_test_keys *keys = skcipher_alloc_test_keys(test);
+	const u8 *pt = alloc_rand_buf(test, max_data_len);
+	u8 *ct = alloc_buf(test, max_data_len);
+	u8 *ref_ct = alloc_buf(test, max_data_len);
+	u8 orig_ctr[AES_BLOCK_SIZE];
+	u8 ctr[AES_BLOCK_SIZE];
+	u8 ref_ctr[AES_BLOCK_SIZE];
+
+	for (int i = 0; i < 400; i++) {
+		const struct aes_key *key =
+			skcipher_pick_key(keys, i / ARRAY_SIZE(carry_bits));
+		const int bits = carry_bits[i % ARRAY_SIZE(carry_bits)];
+		const size_t data_len = rand_length(max_data_len);
+		size_t num_parts;
+
+		/* Set the counter's low 'bits' bits to 2^bits - (1..64). */
+		rand_bytes(orig_ctr, AES_BLOCK_SIZE);
+		memset(&orig_ctr[AES_BLOCK_SIZE - bits / 8], 0xff, bits / 8);
+		orig_ctr[AES_BLOCK_SIZE - 1] -= rand32() % 64;
+
+		memcpy(ref_ctr, orig_ctr, AES_BLOCK_SIZE);
+		aes_ctr_ref(ref_ct, pt, data_len, ref_ctr, key);
+
+		memcpy(ctr, orig_ctr, AES_BLOCK_SIZE);
+		num_parts = skcipher_crypt_incrementally(ct, pt, data_len, ctr,
+							 key, true);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, ref_ct, ct, data_len,
+			"Wrong ciphertext; data_len=%zu carry_bits=%d num_parts=%zu",
+			data_len, bits, num_parts);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, ref_ctr, ctr, AES_BLOCK_SIZE,
+			"Wrong next counter; data_len=%zu carry_bits=%d num_parts=%zu",
+			data_len, bits, num_parts);
+	}
+}
+
+static struct kunit_case aes_ctr_test_cases[] = {
+	KUNIT_CASE(test_aes_ctr_test_vectors),
+	KUNIT_CASE(test_aes_ctr_counter_overflow),
+	SKCIPHER_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_ctr_test_suite = {
+	.name = "aes_ctr",
+	.test_cases = aes_ctr_test_cases,
+};
+kunit_test_suite(aes_ctr_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-CTR");
+MODULE_LICENSE("GPL");
-- 
2.56.1

