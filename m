Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810850;
	b=rZxlwQYUYD/zkmKzfUafcx/LpFnzEQ4PhIl1UFXiGB8N4XynXjpN0aJrgf4u/ohSOT4J
	 00U/B/CqsBFBx6gLSJRvmyzvJYoHpjVQ8nemCiMIZGP4VDIUJE6fvNHxFsZjTgu6FomcH
	 n8YlFIjVXa9Koqf63yFKsCuJjRVCEaMhOPoL/gUizUT12BQl5y3tHxfIqyAepB6h2i5YQ
	 UVU23xdhSoSUNeeENutE5QEafzdVr7+zZ19FKr2zV0whbiMPy7nDMkmV0pHYN0+XCT11Y
	 RDrx9f3M9p+KCNO2VyjXSvT1Ra0pGNX77kep+C8QODfeHrQ5Hj7us57KOQBPyjT5xGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=a51QapgjKF9KvpJMyhh31m8hE0X2l4gH47LkrQxMibE=;
	b=WXnTh24ZefrVgs8flIGnGzquqeX8TLWuNA5NpdwSFUdAtB0mloj1yy9eActZJEYpOiMR
	 sLTiCBFBaEhKhz8PxJNqe5xkYxoR63P0uHubsk8TGNfKHuzKE2h9RIs35fwserkuCNxjr
	 oLcFui9XAooLENFPji0w7T+/HMtIm4pyCWZNagtZltOFdlE2cnbHjHht/YGjOfC45PM5j
	 Wb5O3UM3t5SX29w70Erf+fX4g9o9l6Bz5cYCWgSM0Qmyjo5jJXsU6ddf1BR/9J08vTooa
	 4ZaADp/nTSkuNiEn6D5ymGZPZVhEEpYVUajAun44gz0CvUTQCbwYEuXufcu+s31R3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oL8B2q+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D4F606A885
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oL8B2q+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC6D1F000C7;
	Mon, 16 Nov 2026 06:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810850;
	bh=a51QapgjKF9KvpJMyhh31m8hE0X2l4gH47LkrQxMibE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oL8B2q+UMj9XjHxFmbubrJ2e22DRQnKXqM2yAnlet3fnbUDhLyjJv2/xlHGrt6yLZ
	 ZxM6A2E0YKNOsFxjGHC4w2XDfZwH7jRJ7SmqC/GUHsHHasAUwXS9C83TYSxkHxBGov
	 ucljYMBmDdmadIvv0KaHW/syADbkC2G9w+nqERDmPY1Rzxxj7ikisoiNC+41CkGhip
	 I2a/AMcGaN5qFSKWcWe9oU87hOlY7iwoBGn74c6iC44ld2/SgGtSP8zgUNlfIXW7XM
	 SOz65Gz0fw1wHg/tWyc+j+Nn3xHwe9MbICcj3MnvG6/aE6rlj5Xc5HfrcSmgpw6E+b
	 XvXE3Md3IRuDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/7] lib/crypto: tests: Add KUnit test suite for AES-XCTR
Date: Sun, 15 Nov 2026 22:28:48 -0800
Message-ID: <20261116062849.1071038-7-ebiggers@kernel.org>
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

Add a KUnit test suite for the AES-XCTR library API.

It consists of:

- All the shared test cases from skcipher-test-template.h.  These
  include extensive consistency tests, a "Monte-Carlo test", and a
  benchmark.

- Tests against hardcoded AES-XCTR test vectors from the HCTR2 reference
  implementation.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig          |   4 +-
 lib/crypto/tests/Makefile         |   2 +-
 lib/crypto/tests/aes_xctr_kunit.c | 149 ++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 3 deletions(-)
 create mode 100644 lib/crypto/tests/aes_xctr_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 0d13ce05f2de..4f7a07b0e3c0 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -28,13 +28,13 @@ config CRYPTO_LIB_AES_CCM_KUNIT_TEST
 	  KUnit tests for the AES-CCM authenticated encryption algorithm.
 
 config CRYPTO_LIB_AES_CTR_KUNIT_TEST
-	tristate "KUnit tests for AES-CTR" if !KUNIT_ALL_TESTS
+	tristate "KUnit tests for AES-CTR and AES-XCTR" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_CTR
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	# This test uses BLAKE2s, but that's always built-in.
 	help
-	  KUnit tests for the AES-CTR stream cipher.
+	  KUnit tests for the AES-CTR and AES-XCTR stream ciphers.
 
 config CRYPTO_LIB_AES_ECB_KUNIT_TEST
 	tristate "KUnit tests for AES-ECB" if !KUNIT_ALL_TESTS
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 1deb07c2558f..50e4a3f70ebf 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST) += aes_cbc_kunit.o aes_cbc_cts_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
-obj-$(CONFIG_CRYPTO_LIB_AES_CTR_KUNIT_TEST) += aes_ctr_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_CTR_KUNIT_TEST) += aes_ctr_kunit.o aes_xctr_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST) += aes_ecb_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST) += aes_gcm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
diff --git a/lib/crypto/tests/aes_xctr_kunit.c b/lib/crypto/tests/aes_xctr_kunit.c
new file mode 100644
index 000000000000..86fe4356cb66
--- /dev/null
+++ b/lib/crypto/tests/aes_xctr_kunit.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-XCTR
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-ctr.h>
+#include <crypto/blake2s.h>
+#include <linux/unaligned.h>
+#include "test-utils.h"
+
+/*
+ * For the purpose of the tests, the IV state for AES-XCTR is the 64-bit little
+ * endian block counter followed by the 16-byte IV.  The IV is placed last so
+ * that when the IV state is in a guarded buffer, over-reads of the IV in
+ * aes_xctr() are detected.
+ */
+#define AES_XCTR_STATE_SIZE (sizeof(__le64) + AES_BLOCK_SIZE)
+
+static void aes_xctr_test(u8 *dst, const u8 *src, size_t len, u8 *state,
+			  aes_encrypt_arg key, bool cont)
+{
+	u64 ctr = get_unaligned_le64(state);
+
+	aes_xctr(dst, src, len, &ctr, &state[sizeof(__le64)], key);
+	put_unaligned_le64(ctr, state);
+}
+
+static const size_t aes_xctr_valid_key_lens[] = { AES_KEYSIZE_128,
+						  AES_KEYSIZE_192,
+						  AES_KEYSIZE_256 };
+#define SKCIPHER_VALID_KEY_LENS aes_xctr_valid_key_lens
+#define SKCIPHER_MAX_KEY_LEN AES_MAX_KEY_SIZE
+#define SKCIPHER_IV_LEN AES_XCTR_STATE_SIZE
+#define SKCIPHER_MIN_DATA_LEN 0
+#define SKCIPHER_DATA_LEN_ALIGN 1
+
+#define SKCIPHER_KEY aes_key
+#define SKCIPHER_PREPAREKEY aes_preparekey
+#define SKCIPHER_ENCRYPT aes_xctr_test
+#define SKCIPHER_DECRYPT aes_xctr_test
+
+#define SKCIPHER_ENCKEY aes_enckey
+#define SKCIPHER_PREPAREENCKEY aes_prepareenckey
+#define SKCIPHER_INCREMENTAL
+#define SKCIPHER_NONFINAL_DATA_LEN_ALIGN AES_BLOCK_SIZE
+#define SKCIPHER_NEXT_IV_ALWAYS_DEFINED
+
+/* This value was generated by gen-skcipher-testvecs.py. */
+static const u8 aes_xctr_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x40, 0xc0, 0x13, 0x02, 0xc6, 0x12, 0x5c, 0x86, 0xce, 0x85, 0x9d,
+	0xcb, 0x8f, 0x9b, 0xda, 0x17, 0x6f, 0x15, 0x73, 0x71, 0x0f, 0x6c,
+	0x68, 0x41, 0xb5, 0x7d, 0x29, 0xe9, 0xb1, 0xb5, 0xa4, 0xb5,
+};
+#define SKCIPHER_MONTE_CARLO_CHECKSUM aes_xctr_monte_carlo_checksum
+
+#include "skcipher-test-template.h"
+
+/* Initial XCTR block counter of 1, in the format of the IV state */
+#define AES_XCTR_CTR1 "\x01\x00\x00\x00\x00\x00\x00\x00"
+
+/* XCTR block counter after 2 blocks (initial counter 1 + 2 = 3) */
+#define AES_XCTR_CTR3 "\x03\x00\x00\x00\x00\x00\x00\x00"
+
+/*
+ * AES-XCTR test vectors generated by the HCTR2 reference implementation
+ * (https://github.com/google/hctr2).
+ */
+static const struct skcipher_testvec aes_xctr_testvecs[] = {
+	{
+		.name = "HCTR2 reference AES-128-XCTR, 31 bytes",
+		.key = "\x44\x03\xbf\x4c\x30\xf0\xa7\xd6"
+		       "\xbd\x54\xbb\x66\x8e\xa6\x0e\x8a",
+		.key_len = 16,
+		.iv = AES_XCTR_CTR1 "\xe6\xf7\x26\xdf\x8c\x3c\xaa\x88"
+				    "\xce\xc1\xbd\x43\x3b\x09\x62\xad",
+		.ptext = "\x3c\xe3\x46\xb9\x8f\x9d\x3f\x8d"
+			 "\xef\xf2\x53\xab\x24\xe2\x29\x08"
+			 "\xf8\x7e\x1d\xa6\x6d\x86\x7d\x60"
+			 "\x97\x63\x93\x29\x71\x94\xb4",
+		.ctext = "\xd4\xa3\xc6\xb8\xc1\x6f\x70\x1a"
+			 "\x52\x0c\xed\x4c\xaf\x51\x56\x23"
+			 "\x48\x45\x07\x10\x34\xc5\xba\x71"
+			 "\xe5\xf8\x1e\xd8\xcb\xa6\xe7",
+		.data_len = 31,
+		.next_iv = AES_XCTR_CTR3 "\xe6\xf7\x26\xdf\x8c\x3c\xaa\x88"
+					 "\xce\xc1\xbd\x43\x3b\x09\x62\xad",
+	},
+	{
+		.name = "HCTR2 reference AES-192-XCTR, 17 bytes",
+		.key = "\xc8\xa0\x27\x67\x04\x3f\xed\xa5"
+		       "\xb4\x0c\x51\x91\x2d\x27\x77\x33"
+		       "\xa5\xfc\x2a\x9f\x78\xd8\x1c\x68",
+		.key_len = 24,
+		.iv = AES_XCTR_CTR1 "\x83\x99\x1a\xe2\x84\xca\xa9\x16"
+				    "\x8d\xc4\x2d\x1b\x67\xc8\x86\x21",
+		.ptext = "\xd6\x22\x85\xb8\x5d\x7e\x26\x2e"
+			 "\xbe\x04\x9d\x0c\x03\x91\x45\x4a"
+			 "\x36",
+		.ctext = "\x0f\x44\xa9\x62\x72\xec\x12\x26"
+			 "\x3a\xc6\x83\x26\x62\x5e\xb7\x13"
+			 "\x05",
+		.data_len = 17,
+		.next_iv = AES_XCTR_CTR3 "\x83\x99\x1a\xe2\x84\xca\xa9\x16"
+					 "\x8d\xc4\x2d\x1b\x67\xc8\x86\x21",
+	},
+	{
+		.name = "HCTR2 reference AES-256-XCTR, 31 bytes",
+		.key = "\x77\x5c\xc0\x73\x9a\x64\x97\x91"
+		       "\x2f\xee\xe0\x20\xc2\x04\x59\x2e"
+		       "\x97\xd2\xa7\x70\xb3\xb0\x21\x6b"
+		       "\x8f\xbf\xb8\x51\xa8\xea\x0f\x62",
+		.key_len = 32,
+		.iv = AES_XCTR_CTR1 "\x31\x8e\x1f\xcd\xfd\x23\xeb\x7f"
+				    "\x8a\x1f\x1b\x23\x53\x27\x44\xe5",
+		.ptext = "\xcd\xff\x8c\x9b\x94\x5a\x51\x3f"
+			 "\x40\x93\x56\x93\x66\x39\x63\x1f"
+			 "\xbf\xe6\xa4\xfa\xbe\x79\x93\x03"
+			 "\xf5\x66\x74\x16\xfc\xe4\xce",
+		.ctext = "\x8b\xd3\xc3\xce\x66\xf8\x66\x4c"
+			 "\xad\xd6\xf5\x0f\xd8\x99\x5a\x75"
+			 "\xa1\x3c\xab\x0b\x21\x36\x57\x72"
+			 "\x88\x29\xe9\xea\x4a\x8d\xe9",
+		.data_len = 31,
+		.next_iv = AES_XCTR_CTR3 "\x31\x8e\x1f\xcd\xfd\x23\xeb\x7f"
+					 "\x8a\x1f\x1b\x23\x53\x27\x44\xe5",
+	},
+};
+
+static void test_aes_xctr_test_vectors(struct kunit *test)
+{
+	skcipher_run_testvecs(test, aes_xctr_testvecs,
+			      ARRAY_SIZE(aes_xctr_testvecs));
+}
+
+static struct kunit_case aes_xctr_test_cases[] = {
+	KUNIT_CASE(test_aes_xctr_test_vectors),
+	SKCIPHER_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_xctr_test_suite = {
+	.name = "aes_xctr",
+	.test_cases = aes_xctr_test_cases,
+};
+kunit_test_suite(aes_xctr_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-XCTR");
+MODULE_LICENSE("GPL");
-- 
2.56.1

