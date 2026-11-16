Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810849;
	b=HiIBLfOX1XZs0rpNgUm7fePdKFFRPztBAQC8eZDsc+SerKxwj/YcPAMQkJpE5ytOf8ao
	 iEtBCNiDdgNVVnn9TM0QBiV13YKJux055O1iyRs+arxU4gg4rC2KjWgveB9J8NnKCWOiq
	 jrqDIAt7KQQOgHfHoKO0b5EjoPWYyqVzcGf6nF0P9PpLMCGMLueC81MPoMWAqmgoHrQh+
	 CwRgordW2Bty60R60L8Iv+QXFu0HCJR1d2bw6mPxU1AlkYPQnVGE/QVsl8lgF1dF9S2KF
	 BLId/itNQrC5v40Vb+364v684BWmbijYMh25h+FJuujJ+DPqV/ZxVNHce0JaQkkZ54A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HKR6ten/6YjPuaZ47lymDUFoeE9afGGsFOU2PEXuip0=;
	b=u04YubqOpHuVdsi0XlwTISS0pfN1WlJj95JZaiGp/I/XHj/AytpK5QjY6s5ap5n8F+Yp
	 cmZMIVlP3lkhMJ8zdooqzztLtrcgHjUOAXs+iPdFbY2CcZOBS1MXD1nK1HN38mZ4GOZ3o
	 t+hd71NrcTK+2UpUSnJgXYRxKPS+eaMJDz7p0LYkZsetaNbni7PfDNTEFbq8OfdRTFdUu
	 yUMu+V+NCsCgcDJ4Q2dkSj6iqaJGEBtJkANX4sMd4mdbl8BjRs70pc3PbiROKbEyJX1Q3
	 ggsDZYwzrD9aG3HKiShNJsb6+qaoXvY6kgWEXkRO3qMfbzof/4X3xSP94PkQQQG//Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHYM+McR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE1606A33F
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHYM+McR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941741F000C6;
	Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810849;
	bh=HKR6ten/6YjPuaZ47lymDUFoeE9afGGsFOU2PEXuip0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHYM+McRf3ib9iLCoDo/LTeXiWhLtT96h34qb1/xqfcmUnD/wA8YaZ6wvQBQVITza
	 v0OqZCLBekhvt59Xpo2gHMQyeSMX0ouUljZrJ7VseZ5BwABfOOxOLOig3ojFJRC6X2
	 NGOd/uDXLNPwFMAiMXlZ+bcA+BPaedt5mvJckXEA7s5hcqbVQzkiwY1xDeJ5l6f0m7
	 ZKiP3Vc8jyXevhCk1FHx3BtDwe/faWz/49czBOBW17wKaihFRU2teC/KU/3H+97gsW
	 WjiBxxHzsXG6wqPq6G+AelDpNdeC87jH5F06lqrIXBejGX+EZgO2gsuCsibu/hnkzf
	 d8if+ZDg3A0Lg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/7] lib/crypto: tests: Add KUnit test suite for AES-CBC-CTS
Date: Sun, 15 Nov 2026 22:28:46 -0800
Message-ID: <20261116062849.1071038-5-ebiggers@kernel.org>
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

Add a KUnit test suite for the AES-CBC-CTS library API.

It consists of:

- All the shared test cases from skcipher-test-template.h.  These
  include extensive consistency tests, a "Monte-Carlo test", and a
  benchmark.

- Tests against hardcoded AES-CBC-CTS test vectors from RFC 3962.

- A test comparing AES-CBC-CTS against a reference implementation built
  on top of aes_cbc_encrypt().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig             |   4 +-
 lib/crypto/tests/Makefile            |   2 +-
 lib/crypto/tests/aes_cbc_cts_kunit.c | 239 +++++++++++++++++++++++++++
 3 files changed, 242 insertions(+), 3 deletions(-)
 create mode 100644 lib/crypto/tests/aes_cbc_cts_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 7076ea606ce8..b0b0ae84a02e 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 config CRYPTO_LIB_AES_CBC_KUNIT_TEST
-	tristate "KUnit tests for AES-CBC" if !KUNIT_ALL_TESTS
+	tristate "KUnit tests for AES-CBC and AES-CBC-CTS" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_CBC
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	# This test uses BLAKE2s, but that's always built-in.
 	help
-	  KUnit tests for the AES-CBC encryption mode.
+	  KUnit tests for the AES-CBC and AES-CBC-CTS encryption modes.
 
 config CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST
 	tristate "KUnit tests for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC" if !KUNIT_ALL_TESTS
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index e7b7efee663a..fa22a4138a68 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-obj-$(CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST) += aes_cbc_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST) += aes_cbc_kunit.o aes_cbc_cts_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST) += aes_ecb_kunit.o
diff --git a/lib/crypto/tests/aes_cbc_cts_kunit.c b/lib/crypto/tests/aes_cbc_cts_kunit.c
new file mode 100644
index 000000000000..2890515ded0f
--- /dev/null
+++ b/lib/crypto/tests/aes_cbc_cts_kunit.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-CBC-CTS
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-cbc.h>
+#include <crypto/blake2s.h>
+#include "test-utils.h"
+
+static void aes_cbc_cts_encrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				     aes_encrypt_arg key, bool cont)
+{
+	aes_cbc_cts_encrypt(dst, src, len, iv, key);
+}
+
+static void aes_cbc_cts_decrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				     const struct aes_key *key, bool cont)
+{
+	aes_cbc_cts_decrypt(dst, src, len, iv, key);
+}
+
+static const size_t aes_cbc_cts_valid_key_lens[] = { AES_KEYSIZE_128,
+						     AES_KEYSIZE_192,
+						     AES_KEYSIZE_256 };
+#define SKCIPHER_VALID_KEY_LENS aes_cbc_cts_valid_key_lens
+#define SKCIPHER_MAX_KEY_LEN AES_MAX_KEY_SIZE
+#define SKCIPHER_IV_LEN AES_BLOCK_SIZE
+#define SKCIPHER_MIN_DATA_LEN AES_BLOCK_SIZE
+#define SKCIPHER_DATA_LEN_ALIGN 1
+
+#define SKCIPHER_KEY aes_key
+#define SKCIPHER_PREPAREKEY aes_preparekey
+#define SKCIPHER_ENCRYPT aes_cbc_cts_encrypt_test
+#define SKCIPHER_DECRYPT aes_cbc_cts_decrypt_test
+
+#define SKCIPHER_ENCKEY aes_enckey
+#define SKCIPHER_PREPAREENCKEY aes_prepareenckey
+
+/* This value was generated by gen-skcipher-testvecs.py. */
+static const u8 aes_cbc_cts_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x9a, 0xc5, 0x99, 0xaf, 0x25, 0x2d, 0x56, 0x52, 0xd6, 0x50, 0x14,
+	0x33, 0x61, 0x0b, 0xb6, 0x40, 0x5e, 0xc5, 0x9c, 0x8e, 0xfd, 0x6c,
+	0xae, 0xa1, 0x1d, 0x47, 0x43, 0xd4, 0x19, 0x01, 0xc9, 0x6b,
+};
+#define SKCIPHER_MONTE_CARLO_CHECKSUM aes_cbc_cts_monte_carlo_checksum
+
+#include "skcipher-test-template.h"
+
+#define RFC3962_KEY "chicken teriyaki"
+#define RFC3962_IV "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
+#define RFC3962_PTEXT \
+	"I would like the General Gau's Chicken, please, and wonton soup."
+
+/*
+ * AES-CBC-CTS test vectors from RFC 3962 Appendix B.  The ciphertext stealing
+ * variant used in RFC 3962 is the same as CS3, i.e. the variant implemented by
+ * aes_cbc_cts_encrypt() and aes_cbc_cts_decrypt().
+ *
+ * RFC 3962 doesn't include a 16-byte test vector.  The one below was derived
+ * from the 32-byte one: when the length is exactly one block, CS3 is the same
+ * as plain CBC, so the ciphertext is just the first CBC ciphertext block.
+ */
+static const struct skcipher_testvec aes_cbc_cts_testvecs[] = {
+	{
+		.name = "Derived from RFC 3962 Appendix B, 16 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84",
+		.data_len = 16,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 17 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\xc6\x35\x35\x68\xf2\xbf\x8c\xb4"
+			 "\xd8\xa5\x80\x36\x2d\xa7\xff\x7f"
+			 "\x97",
+		.data_len = 17,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 31 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\xfc\x00\x78\x3e\x0e\xfd\xb2\xc1"
+			 "\xd4\x45\xd4\xc8\xef\xf7\xed\x22"
+			 "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5",
+		.data_len = 31,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 32 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\x39\x31\x25\x23\xa7\x86\x62\xd5"
+			 "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8"
+			 "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84",
+		.data_len = 32,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 47 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84"
+			 "\xb3\xff\xfd\x94\x0c\x16\xa1\x8c"
+			 "\x1b\x55\x49\xd2\xf8\x38\x02\x9e"
+			 "\x39\x31\x25\x23\xa7\x86\x62\xd5"
+			 "\xbe\x7f\xcb\xcc\x98\xeb\xf5",
+		.data_len = 47,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 48 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84"
+			 "\x9d\xad\x8b\xbb\x96\xc4\xcd\xc0"
+			 "\x3b\xc1\x03\xe1\xa1\x94\xbb\xd8"
+			 "\x39\x31\x25\x23\xa7\x86\x62\xd5"
+			 "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8",
+		.data_len = 48,
+	},
+	{
+		.name = "RFC 3962 Appendix B, 64 bytes",
+		.key = RFC3962_KEY,
+		.key_len = 16,
+		.iv = RFC3962_IV,
+		.ptext = RFC3962_PTEXT,
+		.ctext = "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
+			 "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84"
+			 "\x39\x31\x25\x23\xa7\x86\x62\xd5"
+			 "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8"
+			 "\x48\x07\xef\xe8\x36\xee\x89\xa5"
+			 "\x26\x73\x0d\xbc\x2f\x7b\xc8\x40"
+			 "\x9d\xad\x8b\xbb\x96\xc4\xcd\xc0"
+			 "\x3b\xc1\x03\xe1\xa1\x94\xbb\xd8",
+		.data_len = 64,
+	},
+};
+
+static void test_aes_cbc_cts_test_vectors(struct kunit *test)
+{
+	skcipher_run_testvecs(test, aes_cbc_cts_testvecs,
+			      ARRAY_SIZE(aes_cbc_cts_testvecs));
+}
+
+/*
+ * Test AES-CBC-CTS against a reference implementation built on top of AES-CBC,
+ * using random lengths up to 4096 bytes.  In the CS3 variant of CBC-CTS, the
+ * ciphertext is the AES-CBC encryption of the zero-padded plaintext, but with
+ * the last two blocks swapped and the (new) last block truncated to the length
+ * of the final plaintext block, which may be partial.  When the length is
+ * exactly one block, the ciphertext is the same as AES-CBC.
+ */
+static void test_aes_cbc_cts_vs_cbc(struct kunit *test)
+{
+	const size_t max_data_len = 4096;
+	const struct skcipher_test_keys *keys = skcipher_alloc_test_keys(test);
+	const u8 *pt = alloc_rand_buf(test, max_data_len);
+	u8 *padded_pt = alloc_buf(test, round_up(max_data_len, AES_BLOCK_SIZE));
+	u8 *ct = alloc_buf(test, max_data_len);
+	u8 *ref_ct = alloc_buf(test, round_up(max_data_len, AES_BLOCK_SIZE));
+	u8 *decrypted = alloc_buf(test, max_data_len);
+	u8 orig_iv[AES_BLOCK_SIZE];
+	u8 iv[AES_BLOCK_SIZE];
+
+	for (size_t i = 0; i < 200; i++) {
+		const struct aes_key *key = skcipher_pick_key(keys, i);
+		const size_t data_len =
+			i < keys->num_keys ?
+				AES_BLOCK_SIZE :
+				skcipher_rand_data_len(max_data_len);
+		const size_t padded_len = round_up(data_len, AES_BLOCK_SIZE);
+		const size_t pn_offset = padded_len - AES_BLOCK_SIZE;
+		const size_t pn_len = data_len - pn_offset;
+
+		rand_bytes(orig_iv, sizeof(orig_iv));
+
+		/* Compute the expected ciphertext using AES-CBC. */
+		memcpy(padded_pt, pt, data_len);
+		memset(&padded_pt[data_len], 0, padded_len - data_len);
+		memcpy(iv, orig_iv, sizeof(iv));
+		aes_cbc_encrypt(ref_ct, padded_pt, padded_len, iv, key);
+		if (padded_len > AES_BLOCK_SIZE) {
+			u8 tmp[AES_BLOCK_SIZE];
+
+			memcpy(tmp, &ref_ct[pn_offset - AES_BLOCK_SIZE],
+			       AES_BLOCK_SIZE);
+			memcpy(&ref_ct[pn_offset - AES_BLOCK_SIZE],
+			       &ref_ct[pn_offset], AES_BLOCK_SIZE);
+			memcpy(&ref_ct[pn_offset], tmp, pn_len);
+		}
+
+		memcpy(iv, orig_iv, sizeof(iv));
+		aes_cbc_cts_encrypt(ct, pt, data_len, iv, key);
+		KUNIT_ASSERT_MEMEQ_MSG(test, ref_ct, ct, data_len,
+				       "Wrong ciphertext; data_len=%zu",
+				       data_len);
+
+		memset(decrypted, 0, data_len);
+		memcpy(iv, orig_iv, sizeof(iv));
+		aes_cbc_cts_decrypt(decrypted, ct, data_len, iv, key);
+		KUNIT_ASSERT_MEMEQ_MSG(
+			test, pt, decrypted, data_len,
+			"Decryption didn't invert encryption; data_len=%zu",
+			data_len);
+	}
+}
+
+static struct kunit_case aes_cbc_cts_test_cases[] = {
+	KUNIT_CASE(test_aes_cbc_cts_test_vectors),
+	KUNIT_CASE(test_aes_cbc_cts_vs_cbc),
+	SKCIPHER_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_cbc_cts_test_suite = {
+	.name = "aes_cbc_cts",
+	.test_cases = aes_cbc_cts_test_cases,
+};
+kunit_test_suite(aes_cbc_cts_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-CBC-CTS");
+MODULE_LICENSE("GPL");
-- 
2.56.1

