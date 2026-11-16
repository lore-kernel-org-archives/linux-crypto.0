Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810849;
	b=gGnMFhBLc6YIlGbiH42Zbws/QtM3mEvKZkCES+BnzjJReCNaLNoATLOy8Ff0ik2hPyL+
	 F/Vu1pNjgNX9DY3pDUi67nMMDaf9ykSfdE+eE/qHm80MF3cROPPq1uX+9ZkcHj3kUH5y8
	 8ApDs3OYOQrF1uosOJ+0kZTpHuh56GIOYb0F/UqzLO55EYu/muijjTJ9BC3l8UxxPSJJc
	 X1Z5K1qlNdH5QpxKUC8Hsn7mNANBdIoxb5bma6jrU3sRqpw6La195llgazakzXxg+H45v
	 xm3+7tICLZd/IQq9UnuHZtAR4Yvvpb0zsJNcGerpaWebKPd7F9rome+4o3FBY5sOATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dqyd2GmqGrftialjwhR5Dfnb+byejBl8L2kNY1Gw8S4=;
	b=5c3ZgaVBCiKzgn68Z/vd7/XNQ/jyb4jl1PmN+MVJyPyNuKi9EXe+EVMKG5sOdYLYWALv
	 8DnFow8G9WZNGga0uOERuDByj5UpzBeai4hS1nbJFrpntrhDOg+DhhBK/EGXJZdtaabuH
	 0wcJiEyS6qHOSs2kBLc+JgSu9Fe3kcmy4JT8JcJnSOT5j/oOOk7W8GUv7gKhscCAoGBPL
	 z25s/TEw8lCtIuWw4BajVFxt7VIJInoMZguL5TUbI3X8M9Xon2rCv1AtHRMoLTH58dTjB
	 krvjeOsIIKrkgE9NLxHv2Z0bSmrFxTTeuM0zcmQGFL5MilJt9MQqgEo7c14UKVQJykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxpRYWT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94523606A337
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxpRYWT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D58D1F000C5;
	Mon, 16 Nov 2026 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810849;
	bh=dqyd2GmqGrftialjwhR5Dfnb+byejBl8L2kNY1Gw8S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxpRYWT5q1dfM6vGHMNNzVaEIGo7thPgFNjaTxve+GbukGgYusDEIVSXQ3p83/8Fl
	 WtGH8pADfSzuAEMJUyyGXcybbhbml6Ggg23F9aQzrhzEuWNL6V9Dq6ssCR9HIUPkW6
	 A/7+BQ0TWdL8P5PKS+xwsK+XUNictHlpUVXOrcBRh1ORixm3Ek+tSI08XcFV7+wYPU
	 Y6UIYtTkhurD3NHX6I4vC47QaSceWAOUKxKk6O+pVrU6K3hpKeTxQYfwVe1T5YIsTN
	 DBhSQkMmWLPsOLua+frS9VZLTzsYR1YOceI2Z2xBP6pcmt0BRDWZcXH+uoygou393A
	 EYbNqUdYD5cGA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/7] lib/crypto: tests: Add KUnit test suite for AES-CBC
Date: Sun, 15 Nov 2026 22:28:45 -0800
Message-ID: <20261116062849.1071038-4-ebiggers@kernel.org>
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

Add a KUnit test suite for the AES-CBC library API.

It consists of:

- All the shared test cases from skcipher-test-template.h.  These
  include extensive consistency tests, a "Monte-Carlo test", and a
  benchmark.

- Tests against hardcoded AES-CBC test vectors from NIST SP 800-38A.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig          |   1 +
 lib/crypto/tests/Kconfig         |   9 ++
 lib/crypto/tests/Makefile        |   1 +
 lib/crypto/tests/aes_cbc_kunit.c | 137 +++++++++++++++++++++++++++++++
 4 files changed, 148 insertions(+)
 create mode 100644 lib/crypto/tests/aes_cbc_kunit.c

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index e323e955ceff..c3ac80ccb695 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -2,6 +2,7 @@ CONFIG_KUNIT=y
 
 CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
+CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 54af41f3c07d..7076ea606ce8 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,5 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+config CRYPTO_LIB_AES_CBC_KUNIT_TEST
+	tristate "KUnit tests for AES-CBC" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_AES_CBC
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# This test uses BLAKE2s, but that's always built-in.
+	help
+	  KUnit tests for the AES-CBC encryption mode.
+
 config CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST
 	tristate "KUnit tests for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_CBC_MACS
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 1a5be11ce378..e7b7efee663a 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+obj-$(CONFIG_CRYPTO_LIB_AES_CBC_KUNIT_TEST) += aes_cbc_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_ECB_KUNIT_TEST) += aes_ecb_kunit.o
diff --git a/lib/crypto/tests/aes_cbc_kunit.c b/lib/crypto/tests/aes_cbc_kunit.c
new file mode 100644
index 000000000000..775a67b48359
--- /dev/null
+++ b/lib/crypto/tests/aes_cbc_kunit.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-CBC
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-cbc.h>
+#include <crypto/blake2s.h>
+#include "sp800-38a-data.h"
+#include "test-utils.h"
+
+static void aes_cbc_encrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				 aes_encrypt_arg key, bool cont)
+{
+	aes_cbc_encrypt(dst, src, len, iv, key);
+}
+
+static void aes_cbc_decrypt_test(u8 *dst, const u8 *src, size_t len, u8 *iv,
+				 const struct aes_key *key, bool cont)
+{
+	aes_cbc_decrypt(dst, src, len, iv, key);
+}
+
+static const size_t aes_cbc_valid_key_lens[] = { AES_KEYSIZE_128,
+						 AES_KEYSIZE_192,
+						 AES_KEYSIZE_256 };
+#define SKCIPHER_VALID_KEY_LENS aes_cbc_valid_key_lens
+#define SKCIPHER_MAX_KEY_LEN AES_MAX_KEY_SIZE
+#define SKCIPHER_IV_LEN AES_BLOCK_SIZE
+#define SKCIPHER_MIN_DATA_LEN 0
+#define SKCIPHER_DATA_LEN_ALIGN AES_BLOCK_SIZE
+
+#define SKCIPHER_KEY aes_key
+#define SKCIPHER_PREPAREKEY aes_preparekey
+#define SKCIPHER_ENCRYPT aes_cbc_encrypt_test
+#define SKCIPHER_DECRYPT aes_cbc_decrypt_test
+
+#define SKCIPHER_ENCKEY aes_enckey
+#define SKCIPHER_PREPAREENCKEY aes_prepareenckey
+#define SKCIPHER_INCREMENTAL
+#define SKCIPHER_NONFINAL_DATA_LEN_ALIGN AES_BLOCK_SIZE
+
+/* This value was generated by gen-skcipher-testvecs.py. */
+static const u8 aes_cbc_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x87, 0xfd, 0xb4, 0x92, 0xde, 0x3e, 0x69, 0xac, 0xe2, 0x78, 0xdf,
+	0x23, 0xbe, 0x6f, 0x2f, 0xcc, 0x32, 0x98, 0x10, 0x89, 0x63, 0x64,
+	0x1c, 0xff, 0x76, 0xe5, 0x4f, 0x31, 0x90, 0xf3, 0x2c, 0x7a,
+};
+#define SKCIPHER_MONTE_CARLO_CHECKSUM aes_cbc_monte_carlo_checksum
+
+#include "skcipher-test-template.h"
+
+#define SP800_38A_CBC_IV                   \
+	"\x00\x01\x02\x03\x04\x05\x06\x07" \
+	"\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+
+/* AES-CBC test vectors from NIST SP 800-38A */
+static const struct skcipher_testvec aes_cbc_testvecs[] = {
+	{
+		.name = "SP 800-38A F.2.1 (CBC-AES128)",
+		.key = SP800_38A_KEY128,
+		.key_len = 16,
+		.iv = SP800_38A_CBC_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x76\x49\xab\xac\x81\x19\xb2\x46"
+			 "\xce\xe9\x8e\x9b\x12\xe9\x19\x7d"
+			 "\x50\x86\xcb\x9b\x50\x72\x19\xee"
+			 "\x95\xdb\x11\x3a\x91\x76\x78\xb2"
+			 "\x73\xbe\xd6\xb8\xe3\xc1\x74\x3b"
+			 "\x71\x16\xe6\x9e\x22\x22\x95\x16"
+			 "\x3f\xf1\xca\xa1\x68\x1f\xac\x09"
+			 "\x12\x0e\xca\x30\x75\x86\xe1\xa7",
+		.data_len = 64,
+		/* The last ciphertext block */
+		.next_iv = "\x3f\xf1\xca\xa1\x68\x1f\xac\x09"
+			   "\x12\x0e\xca\x30\x75\x86\xe1\xa7",
+	},
+	{
+		.name = "SP 800-38A F.2.3 (CBC-AES192)",
+		.key = SP800_38A_KEY192,
+		.key_len = 24,
+		.iv = SP800_38A_CBC_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\x4f\x02\x1d\xb2\x43\xbc\x63\x3d"
+			 "\x71\x78\x18\x3a\x9f\xa0\x71\xe8"
+			 "\xb4\xd9\xad\xa9\xad\x7d\xed\xf4"
+			 "\xe5\xe7\x38\x76\x3f\x69\x14\x5a"
+			 "\x57\x1b\x24\x20\x12\xfb\x7a\xe0"
+			 "\x7f\xa9\xba\xac\x3d\xf1\x02\xe0"
+			 "\x08\xb0\xe2\x79\x88\x59\x88\x81"
+			 "\xd9\x20\xa9\xe6\x4f\x56\x15\xcd",
+		.data_len = 64,
+		/* The last ciphertext block */
+		.next_iv = "\x08\xb0\xe2\x79\x88\x59\x88\x81"
+			   "\xd9\x20\xa9\xe6\x4f\x56\x15\xcd",
+	},
+	{
+		.name = "SP 800-38A F.2.5 (CBC-AES256)",
+		.key = SP800_38A_KEY256,
+		.key_len = 32,
+		.iv = SP800_38A_CBC_IV,
+		.ptext = SP800_38A_PTEXT,
+		.ctext = "\xf5\x8c\x4c\x04\xd6\xe5\xf1\xba"
+			 "\x77\x9e\xab\xfb\x5f\x7b\xfb\xd6"
+			 "\x9c\xfc\x4e\x96\x7e\xdb\x80\x8d"
+			 "\x67\x9f\x77\x7b\xc6\x70\x2c\x7d"
+			 "\x39\xf2\x33\x69\xa9\xd9\xba\xcf"
+			 "\xa5\x30\xe2\x63\x04\x23\x14\x61"
+			 "\xb2\xeb\x05\xe2\xc3\x9b\xe9\xfc"
+			 "\xda\x6c\x19\x07\x8c\x6a\x9d\x1b",
+		.data_len = 64,
+		/* The last ciphertext block */
+		.next_iv = "\xb2\xeb\x05\xe2\xc3\x9b\xe9\xfc"
+			   "\xda\x6c\x19\x07\x8c\x6a\x9d\x1b",
+	},
+};
+
+static void test_aes_cbc_test_vectors(struct kunit *test)
+{
+	skcipher_run_testvecs(test, aes_cbc_testvecs,
+			      ARRAY_SIZE(aes_cbc_testvecs));
+}
+
+static struct kunit_case aes_cbc_test_cases[] = {
+	KUNIT_CASE(test_aes_cbc_test_vectors),
+	SKCIPHER_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_cbc_test_suite = {
+	.name = "aes_cbc",
+	.test_cases = aes_cbc_test_cases,
+};
+kunit_test_suite(aes_cbc_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-CBC");
+MODULE_LICENSE("GPL");
-- 
2.56.1

