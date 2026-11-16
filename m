Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810849;
	b=rxqBMXTFtQpNvsHgIFxz1kq8zGTuKBjxRLLeRSvr55Y1ORHywwaCF6xM1eDG5p2M2a2d
	 07g8L/xZqp7kA/+3PbWy1mVq8LPEI4I+NsfbpII/YXcWw+7S8rBVuIcDU86t2z0aGJAyE
	 kmPTVbGJRBLBkWi0ZC8JyCwngLEWn6Onui1dHtEpWxpMQMg+P+ewTDYW++w4lgq8C6nGT
	 DkBxKw/rxGw6U1ihUY3wTUZXncyPsHvLM70Pvj7DRu0yz90iI3aNuATUUh7AQrePVp+Fe
	 /RWlSO1JV7w8YRvPBb8FaODPXpfZDSYMCtbmInzQFod1tjLEHsPOtMv7/l2PoiHnVrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Yg+PRWJVnDj8nY0+R+bdx0DbMjnVjteS0NiZwNVHP/E=;
	b=ODEOQvoHirhCFb2j+2RlAAwRYEyL3R+JwNy/WT73bsHOtcDo3D6EUEPphymBzB4mr8Cs
	 64lRoFBoWdAHm4kTFrf4Boela1vznlROezOSVPLBQuQCC0j4GVexmoH1DfcgKa7gmSj6n
	 qab6q81Lk7p0W6cDq7bh/dx4QQ8r+LHjxyaPkG8BLt3WeUqushyBMGiqf3kqA0O+BBB2x
	 DQ4kvyRveK7FChQ3HF2xCjqGT9wr+uKpXykNTzEgaI1oym3X1bci7mLeE6osYGlhH1CRI
	 AVoJpa9FddSEoMgP1PYxSa9dxh1lDf5L4vEjTDg9yi0r3kFs+nfYqVaZCfYfFHi9ELA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODsk+qrr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDAC606A334
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODsk+qrr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071D91F000C8;
	Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810849;
	bh=Yg+PRWJVnDj8nY0+R+bdx0DbMjnVjteS0NiZwNVHP/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODsk+qrrWzEuz/arHq6zLY/QOI+o1uFv7MlSFrk/aUYpKMzRuy9c167UEdoC7u2kt
	 N2JOdbVKiXWgdGiRsaMx08u6qLV0tj/yj3VHXZWta7sl2+ZPCrfHNO284MBLvWfrmz
	 S8WhEGMVl0Bn/6tWuSqaLxbH52yf8hrgqUlNRBISfYyBpm4Wc2lGberHrKPmvNBZkL
	 szlfvLBVGOhAIU5DAwvJ5GWONkr3dS6RtozB/Lf3mwJf9oyleWa3nq0MsEok38Cfo+
	 SnA3YwwMUnjz58nP9K7XThGgFw9v3kWl9kqZBlT3/m2qvIqkqoECEnOsx2PKhP/hn7
	 xIannDuJ9nl6g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/7] lib/crypto: tests: Add KUnit test suite for AES-ECB
Date: Sun, 15 Nov 2026 22:28:44 -0800
Message-ID: <20261116062849.1071038-3-ebiggers@kernel.org>
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

Add a KUnit test suite for the AES-ECB library API.

It consists of:

- All the shared test cases from skcipher-test-template.h.  These
  include extensive consistency tests, a "Monte-Carlo test", and a
  benchmark.

- Tests against hardcoded AES-ECB test vectors from NIST SP 800-38A.

- A test comparing multi-block AES-ECB en/decryption against
  single-block aes_encrypt() and aes_decrypt(), which also provides test
  coverage for the single-block AES functions.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig           |   1 +
 lib/crypto/tests/Kconfig          |   9 ++
 lib/crypto/tests/Makefile         |   1 +
 lib/crypto/tests/aes_ecb_kunit.c  | 227 ++++++++++++++++++++++++++++++
 lib/crypto/tests/sp800-38a-data.h |  36 +++++
 5 files changed, 274 insertions(+)
 create mode 100644 lib/crypto/tests/aes_ecb_kunit.c
 create mode 100644 lib/crypto/tests/sp800-38a-data.h

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 6d83badf4292..e323e955ceff 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 5a86a02d25b7..54af41f3c07d 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -18,6 +18,15 @@ config CRYPTO_LIB_AES_CCM_KUNIT_TEST
 	help
 	  KUnit tests for the AES-CCM authenticated encryption algorithm.
 
+config CRYPTO_LIB_AES_ECB_KUNIT_TEST
+	tristate "KUnit tests for AES-ECB" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_AES_ECB
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# This test uses BLAKE2s, but that's always built-in.
+	help
+	  KUnit tests for the AES-ECB encryption mode.
+
 config CRYPTO_LIB_AES_GCM_KUNIT_TEST
 	tristate "KUnit tests for AES-GCM" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_GCM
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 40c9624eaaa8..1a5be11ce378 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -2,6 +2,7 @@
 
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST) += aes_ecb_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST) += aes_gcm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
diff --git a/lib/crypto/tests/aes_ecb_kunit.c b/lib/crypto/tests/aes_ecb_kunit.c
new file mode 100644
index 000000000000..b73e2c7f725a
--- /dev/null
+++ b/lib/crypto/tests/aes_ecb_kunit.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-ECB
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-ecb.h>
+#include <crypto/blake2s.h>
+#include "sp800-38a-data.h"
+#include "test-utils.h"
+
+static void aes_ecb_encrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				 aes_encrypt_arg key, bool cont)
+{
+	aes_ecb_encrypt(dst, src, len, key);
+}
+
+static void aes_ecb_decrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				 const struct aes_key *key, bool cont)
+{
+	aes_ecb_decrypt(dst, src, len, key);
+}
+
+static const size_t aes_ecb_valid_key_lens[] = { AES_KEYSIZE_128,
+						 AES_KEYSIZE_192,
+						 AES_KEYSIZE_256 };
+#define SKCIPHER_VALID_KEY_LENS aes_ecb_valid_key_lens
+#define SKCIPHER_MAX_KEY_LEN AES_MAX_KEY_SIZE
+#define SKCIPHER_IV_LEN 0
+#define SKCIPHER_MIN_DATA_LEN 0
+#define SKCIPHER_DATA_LEN_ALIGN AES_BLOCK_SIZE
+
+#define SKCIPHER_KEY aes_key
+#define SKCIPHER_PREPAREKEY aes_preparekey
+#define SKCIPHER_ENCRYPT aes_ecb_encrypt_test
+#define SKCIPHER_DECRYPT aes_ecb_decrypt_test
+
+#define SKCIPHER_ENCKEY aes_enckey
+#define SKCIPHER_PREPAREENCKEY aes_prepareenckey
+#define SKCIPHER_INCREMENTAL
+#define SKCIPHER_NONFINAL_DATA_LEN_ALIGN AES_BLOCK_SIZE
+
+/* This value was generated by gen-skcipher-testvecs.py. */
+static const u8 aes_ecb_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0xf7, 0x96, 0x84, 0x87, 0xc7, 0xcb, 0x57, 0xb5, 0xb3, 0x5a, 0xbe,
+	0x57, 0xf6, 0x0e, 0x90, 0x3a, 0x8e, 0x64, 0xd8, 0x7f, 0xbc, 0x3e,
+	0x8f, 0x6f, 0x57, 0x32, 0xc2, 0x56, 0x73, 0x44, 0xf1, 0x9a,
+};
+#define SKCIPHER_MONTE_CARLO_CHECKSUM aes_ecb_monte_carlo_checksum
+
+#include "skcipher-test-template.h"
+
+/* AES-ECB test vectors from NIST SP 800-38A */
+static const struct skcipher_testvec aes_ecb_testvecs[] = {
+	{
+		.name = "SP 800-38A F.1.1 (ECB-AES128)",
+		.key = SP800_38A_KEY128,
+		.key_len = 16,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x3a\xd7\x7b\xb4\x0d\x7a\x36\x60"
+			 "\xa8\x9e\xca\xf3\x24\x66\xef\x97"
+			 "\xf5\xd3\xd5\x85\x03\xb9\x69\x9d"
+			 "\xe7\x85\x89\x5a\x96\xfd\xba\xaf"
+			 "\x43\xb1\xcd\x7f\x59\x8e\xce\x23"
+			 "\x88\x1b\x00\xe3\xed\x03\x06\x88"
+			 "\x7b\x0c\x78\x5e\x27\xe8\xad\x3f"
+			 "\x82\x23\x20\x71\x04\x72\x5d\xd4",
+		.data_len = 64,
+	},
+	{
+		.name = "SP 800-38A F.1.3 (ECB-AES192)",
+		.key = SP800_38A_KEY192,
+		.key_len = 24,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\xbd\x33\x4f\x1d\x6e\x45\xf2\x5f"
+			 "\xf7\x12\xa2\x14\x57\x1f\xa5\xcc"
+			 "\x97\x41\x04\x84\x6d\x0a\xd3\xad"
+			 "\x77\x34\xec\xb3\xec\xee\x4e\xef"
+			 "\xef\x7a\xfd\x22\x70\xe2\xe6\x0a"
+			 "\xdc\xe0\xba\x2f\xac\xe6\x44\x4e"
+			 "\x9a\x4b\x41\xba\x73\x8d\x6c\x72"
+			 "\xfb\x16\x69\x16\x03\xc1\x8e\x0e",
+		.data_len = 64,
+	},
+	{
+		.name = "SP 800-38A F.1.5 (ECB-AES256)",
+		.key = SP800_38A_KEY256,
+		.key_len = 32,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\xf3\xee\xd1\xbd\xb5\xd2\xa0\x3c"
+			 "\x06\x4b\x5a\x7e\x3d\xb1\x81\xf8"
+			 "\x59\x1c\xcb\x10\xd4\x10\xed\x26"
+			 "\xdc\x5b\xa7\x4a\x31\x36\x28\x70"
+			 "\xb6\xed\x21\xb9\x9c\xa6\xf4\xf9"
+			 "\xf1\x53\xe7\xb1\xbe\xaf\xed\x1d"
+			 "\x23\x30\x4b\x7a\x39\xf9\xf3\xff"
+			 "\x06\x7d\x8d\x8f\x9e\x24\xec\xc7",
+		.data_len = 64,
+	},
+};
+
+static void test_aes_ecb_test_vectors(struct kunit *test)
+{
+	skcipher_run_testvecs(test, aes_ecb_testvecs,
+			      ARRAY_SIZE(aes_ecb_testvecs));
+}
+
+/*
+ * Test that AES-ECB en/decryption of multiple blocks gives the same results as
+ * en/decrypting each block individually using aes_encrypt() and aes_decrypt().
+ * Also test aes_encrypt() with struct aes_enckey, and test both functions with
+ * unaligned buffers, variously-aligned key structs, in-place operation, and
+ * guarded single-block buffers and key structs.
+ */
+static void test_aes_ecb_vs_block_cipher(struct kunit *test)
+{
+	const size_t max_data_len = 1024;
+	const size_t max_offset = 128;
+	const size_t key_align = __alignof__(struct aes_key);
+	const size_t enckey_align = __alignof__(struct aes_enckey);
+	u8 raw_key[AES_MAX_KEY_SIZE];
+	u8 *key_buf = alloc_buf(test, sizeof(struct aes_key) + max_offset +
+					      key_align - 1);
+	u8 *enckey_buf = alloc_buf(test, sizeof(struct aes_enckey) +
+						 max_offset + enckey_align - 1);
+	struct aes_key *guarded_key =
+		alloc_guarded_buf(test, sizeof(*guarded_key));
+	struct aes_enckey *guarded_enckey =
+		alloc_guarded_buf(test, sizeof(*guarded_enckey));
+	const u8 *pt = alloc_rand_buf(test, max_data_len);
+	u8 *ct = alloc_buf(test, max_data_len);
+	u8 *buf1 = alloc_buf(test, max_data_len + max_offset);
+	u8 *buf2 = alloc_buf(test, max_data_len + max_offset);
+	u8 *guarded_in = alloc_guarded_buf(test, AES_BLOCK_SIZE);
+	u8 *guarded_out = alloc_guarded_buf(test, AES_BLOCK_SIZE);
+	int err;
+
+	for (int i = 0; i < 100; i++) {
+		const size_t key_len = skcipher_rand_key_len();
+		const size_t data_len = skcipher_rand_data_len(max_data_len);
+		struct aes_key *key = (void *)PTR_ALIGN(
+			key_buf + rand_offset(max_offset), key_align);
+		struct aes_enckey *enckey = (void *)PTR_ALIGN(
+			enckey_buf + rand_offset(max_offset), enckey_align);
+		u8 *p1 = &buf1[rand_offset(max_offset)];
+		u8 *p2 = &buf2[rand_offset(max_offset)];
+
+		rand_bytes(raw_key, key_len);
+		err = aes_preparekey(key, raw_key, key_len);
+		KUNIT_ASSERT_EQ(test, 0, err);
+		err = aes_prepareenckey(enckey, raw_key, key_len);
+		KUNIT_ASSERT_EQ(test, 0, err);
+
+		aes_ecb_encrypt(ct, pt, data_len, key);
+
+		/* Out-of-place aes_encrypt() and aes_decrypt() (unaligned) */
+		memcpy(p1, pt, data_len);
+		for (size_t j = 0; j < data_len; j += AES_BLOCK_SIZE)
+			aes_encrypt(key, &p2[j], &p1[j]);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, ct, p2, data_len,
+			"AES-ECB encryption differs from aes_encrypt(); data_len=%zu",
+			data_len);
+
+		memset(p1, 0, data_len);
+		for (size_t j = 0; j < data_len; j += AES_BLOCK_SIZE)
+			aes_decrypt(key, &p1[j], &p2[j]);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, pt, p1, data_len,
+			"aes_decrypt() didn't invert encryption; data_len=%zu",
+			data_len);
+
+		/* In-place aes_encrypt() (with aes_enckey) and aes_decrypt() */
+		for (size_t j = 0; j < data_len; j += AES_BLOCK_SIZE)
+			aes_encrypt(enckey, &p1[j], &p1[j]);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, ct, p1, data_len,
+			"In-place aes_encrypt() with aes_enckey differs; data_len=%zu",
+			data_len);
+		for (size_t j = 0; j < data_len; j += AES_BLOCK_SIZE)
+			aes_decrypt(key, &p1[j], &p1[j]);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, pt, p1, data_len,
+			"In-place aes_decrypt() didn't invert encryption; data_len=%zu",
+			data_len);
+
+		/* Guarded single-block buffers and guarded key structs */
+		if (data_len >= AES_BLOCK_SIZE) {
+			err = aes_preparekey(guarded_key, raw_key, key_len);
+			KUNIT_ASSERT_EQ(test, 0, err);
+			err = aes_prepareenckey(guarded_enckey, raw_key,
+						key_len);
+			KUNIT_ASSERT_EQ(test, 0, err);
+
+			memcpy(guarded_in, pt, AES_BLOCK_SIZE);
+			memset(guarded_out, 0, AES_BLOCK_SIZE);
+			aes_encrypt(guarded_key, guarded_out, guarded_in);
+			KUNIT_ASSERT_MEMEQ(test, ct, guarded_out,
+					   AES_BLOCK_SIZE);
+			memset(guarded_out, 0, AES_BLOCK_SIZE);
+			aes_encrypt(guarded_enckey, guarded_out, guarded_in);
+			KUNIT_ASSERT_MEMEQ(test, ct, guarded_out,
+					   AES_BLOCK_SIZE);
+			memcpy(guarded_in, ct, AES_BLOCK_SIZE);
+			memset(guarded_out, 0, AES_BLOCK_SIZE);
+			aes_decrypt(guarded_key, guarded_out, guarded_in);
+			KUNIT_ASSERT_MEMEQ(test, pt, guarded_out,
+					   AES_BLOCK_SIZE);
+		}
+	}
+}
+
+static struct kunit_case aes_ecb_test_cases[] = {
+	KUNIT_CASE(test_aes_ecb_test_vectors),
+	KUNIT_CASE(test_aes_ecb_vs_block_cipher),
+	SKCIPHER_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_ecb_test_suite = {
+	.name = "aes_ecb",
+	.test_cases = aes_ecb_test_cases,
+};
+kunit_test_suite(aes_ecb_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-ECB");
+MODULE_LICENSE("GPL");
diff --git a/lib/crypto/tests/sp800-38a-data.h b/lib/crypto/tests/sp800-38a-data.h
new file mode 100644
index 000000000000..73517f1fef91
--- /dev/null
+++ b/lib/crypto/tests/sp800-38a-data.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Shared data from the AES test vectors in NIST SP 800-38A Appendix F
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef LIB_CRYPTO_TESTS_SP800_38A_DATA_H
+#define LIB_CRYPTO_TESTS_SP800_38A_DATA_H
+
+#define SP800_38A_KEY128                   \
+	"\x2b\x7e\x15\x16\x28\xae\xd2\xa6" \
+	"\xab\xf7\x15\x88\x09\xcf\x4f\x3c"
+
+#define SP800_38A_KEY192                   \
+	"\x8e\x73\xb0\xf7\xda\x0e\x64\x52" \
+	"\xc8\x10\xf3\x2b\x80\x90\x79\xe5" \
+	"\x62\xf8\xea\xd2\x52\x2c\x6b\x7b"
+
+#define SP800_38A_KEY256                   \
+	"\x60\x3d\xeb\x10\x15\xca\x71\xbe" \
+	"\x2b\x73\xae\xf0\x85\x7d\x77\x81" \
+	"\x1f\x35\x2c\x07\x3b\x61\x08\xd7" \
+	"\x2d\x98\x10\xa3\x09\x14\xdf\xf4"
+
+/* The plaintext, which is 64 bytes long */
+#define SP800_38A_PTEXT                    \
+	"\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96" \
+	"\xe9\x3d\x7e\x11\x73\x93\x17\x2a" \
+	"\xae\x2d\x8a\x57\x1e\x03\xac\x9c" \
+	"\x9e\xb7\x6f\xac\x45\xaf\x8e\x51" \
+	"\x30\xc8\x1c\x46\xa3\x5c\xe4\x11" \
+	"\xe5\xfb\xc1\x19\x1a\x0a\x52\xef" \
+	"\xf6\x9f\x24\x45\xdf\x4f\x9b\x17" \
+	"\xad\x2b\x41\x7b\xe6\x6c\x37\x10"
+
+#endif /* LIB_CRYPTO_TESTS_SP800_38A_DATA_H */
-- 
2.56.1

