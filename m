Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF6F37EFF0;
	Sun,  2 Aug 2026 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785713440; cv=none; b=AnJ/QNVO4PH2aM9zrOUqJ5hD+AaF20irqmElHorGzwQsrbYJRXwEbXs0NoaECkgamZPC+/P3m6HyCPmWLTNwF5m9v9S7rlJ6ponrryjFLRNciS8IEa+hmVmRV3yKa40dJdUT8a7/v2Vv11N5xvdbC4LUfjqEFJvJZDYS4iCcthI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785713440; c=relaxed/simple;
	bh=w5RuzfAKdpyLqvnXJDCaVY5fI2Ccr6spM9UxS/qkrTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uunl+HgKx2pyQDBw3+eIoClaR1AlW1wx++YOEYG0A2osuKPBTw5L2xiucmiCcJo/JQ4rXQkn5RtLz/jKDM88E+DoV8TpxQdkqNUgBw7PrIKy8n6AqOLrZsA4lLDgQxx9dokb9+LLT6QFusB1a7po7p3IkvDaApQg4zmxzdn4R50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebtItqCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebtItqCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0621F00AC4;
	Sun,  2 Aug 2026 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785713438;
	bh=vzwH2qWsxgV/XMH35bbgcEfcrdg4yz8tFnER9STGfYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebtItqCSTIWLOO0/dGMrW3vV+QAzqq5YLoNg4AHzbodCgUVepgf13ZVTkpJ9UaZVe
	 spzy+UDz36Irox5FEmiP8yZ3/bG/1efrGegwdK1lyt3S1oSfCTf2isvSf/nJeQu6/L
	 LWk2mbegLA5MfUnr20hyZ4A0+r3b1RvMUA8fllJcuVVYv+PMuYE45IIHFu/ajcRHxU
	 F+ThmIRiONOxQUvQTFUOZQHa4Ub6u4/ev04rzBbFhbcBWSBxRzBP0nPGTbDL05I1it
	 YhCR+CFSODgzlFbM4ZjoQ5w8Tfb5+StS30O8CTmc/R8FBctultTSj2qeVawj1/4Yo6
	 XdWaJi/5s7sTg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 4/5] lib/crypto: tests: Add KUnit test suite for AES-CCM
Date: Sun,  2 Aug 2026 16:30:04 -0700
Message-ID: <20260802233005.161467-5-ebiggers@kernel.org>
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

Add a KUnit test suite for the AES-CCM library API.

It consists of:

- All the shared test cases from aead-test-template.h.  These include
  extensive consistency tests, a "Monte-Carlo test", and a benchmark.

- Tests against hardcoded AES-CCM test vectors from external sources.

- Tests for CCM-specific message length validation.

To generate the expected aes_ccm_monte_carlo_checksum[] value, add a
script gen-aead-testvecs.py which computes it using python-cryptography.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig             |   1 +
 lib/crypto/tests/Kconfig            |   9 +
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/aes_ccm_kunit.c    | 356 ++++++++++++++++++++++++++++
 scripts/crypto/gen-aead-testvecs.py |  60 +++++
 5 files changed, 427 insertions(+)
 create mode 100644 lib/crypto/tests/aes_ccm_kunit.c
 create mode 100755 scripts/crypto/gen-aead-testvecs.py

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 3efc854a2c08..f0237e602f28 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -3,6 +3,7 @@ CONFIG_KUNIT=y
 CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index bc084dde424f..320236e996b1 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -9,6 +9,15 @@ config CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST
 	  KUnit tests for the AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC message
 	  authentication codes.
 
+config CRYPTO_LIB_AES_CCM_KUNIT_TEST
+	tristate "KUnit tests for AES-CCM" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_AES_CCM
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# This test uses BLAKE2s, but that's always built-in.
+	help
+	  KUnit tests for the AES-CCM authenticated encryption algorithm.
+
 config CRYPTO_LIB_BLAKE2B_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2b" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_BLAKE2B
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index a739413500b6..085852ba008b 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305_KUNIT_TEST) += chacha20poly1305_kunit.o
diff --git a/lib/crypto/tests/aes_ccm_kunit.c b/lib/crypto/tests/aes_ccm_kunit.c
new file mode 100644
index 000000000000..e8f2b3446017
--- /dev/null
+++ b/lib/crypto/tests/aes_ccm_kunit.c
@@ -0,0 +1,356 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AES-CCM
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/aes-ccm.h>
+#include <crypto/blake2s.h>
+#include "test-utils.h"
+
+/* AES-CCM test vectors from external sources */
+static const struct aes_ccm_testvec {
+	const char *name;
+	const char *key;
+	size_t key_len;
+	const char *nonce;
+	size_t nonce_len;
+	const char *ad;
+	size_t ad_len;
+	const char *ptext;
+	const char *ctext;
+	size_t data_len;
+	const char *tag;
+	size_t tag_len;
+} aes_ccm_testvecs[] = {
+	{
+		.name = "RFC 3610 Packet Vector #1",
+		.key = "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+		       "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
+		.key_len = 16,
+		.nonce = "\x00\x00\x00\x03\x02\x01\x00\xa0"
+			 "\xa1\xa2\xa3\xa4\xa5",
+		.nonce_len = 13,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07",
+		.ad_len = 8,
+		.ptext = "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			 "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e",
+		.ctext = "\x58\x8c\x97\x9a\x61\xc6\x63\xd2"
+			 "\xf0\x66\xd0\xc2\xc0\xf9\x89\x80"
+			 "\x6d\x5f\x6b\x61\xda\xc3\x84",
+		.data_len = 23,
+		.tag = "\x17\xe8\xd1\x2c\xfd\xf9\x26\xe0",
+		.tag_len = 8,
+	},
+	{
+		.name = "RFC 3610 Packet Vector #5",
+		.key = "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+		       "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
+		.key_len = 16,
+		.nonce = "\x00\x00\x00\x07\x06\x05\x04\xa0"
+			 "\xa1\xa2\xa3\xa4\xa5",
+		.nonce_len = 13,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b",
+		.ad_len = 12,
+		.ptext = "\x0c\x0d\x0e\x0f\x10\x11\x12\x13"
+			 "\x14\x15\x16\x17\x18\x19\x1a\x1b"
+			 "\x1c\x1d\x1e\x1f",
+		.ctext = "\xdc\xf1\xfb\x7b\x5d\x9e\x23\xfb"
+			 "\x9d\x4e\x13\x12\x53\x65\x8a\xd8"
+			 "\x6e\xbd\xca\x3e",
+		.data_len = 20,
+		.tag = "\x51\xe8\x3f\x07\x7d\x9c\x2d\x93",
+		.tag_len = 8,
+	},
+	{
+		.name = "RFC 3610 Packet Vector #9",
+		.key = "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+		       "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
+		.key_len = 16,
+		.nonce = "\x00\x00\x00\x0b\x0a\x09\x08\xa0"
+			 "\xa1\xa2\xa3\xa4\xa5",
+		.nonce_len = 13,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07",
+		.ad_len = 8,
+		.ptext = "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			 "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
+			 "\x20",
+		.ctext = "\x82\x53\x1a\x60\xcc\x24\x94\x5a"
+			 "\x4b\x82\x79\x18\x1a\xb5\xc8\x4d"
+			 "\xf2\x1c\xe7\xf9\xb7\x3f\x42\xe1"
+			 "\x97",
+		.data_len = 25,
+		.tag = "\xea\x9c\x07\xe5\x6b\x5e\xb1\x7e"
+		       "\x5f\x4e",
+		.tag_len = 10,
+	},
+	{
+		.name = "NIST SP 800-38C Example 1",
+		.key = "\x40\x41\x42\x43\x44\x45\x46\x47"
+		       "\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f",
+		.key_len = 16,
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16",
+		.nonce_len = 7,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07",
+		.ad_len = 8,
+		.ptext = "\x20\x21\x22\x23",
+		.ctext = "\x71\x62\x01\x5b",
+		.data_len = 4,
+		.tag = "\x4d\xac\x25\x5d",
+		.tag_len = 4,
+	},
+	{
+		.name = "NIST SP 800-38C Example 2",
+		.key = "\x40\x41\x42\x43\x44\x45\x46\x47"
+		       "\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f",
+		.key_len = 16,
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17",
+		.nonce_len = 8,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ad_len = 16,
+		.ptext = "\x20\x21\x22\x23\x24\x25\x26\x27"
+			 "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f",
+		.ctext = "\xd2\xa1\xf0\xe0\x51\xea\x5f\x62"
+			 "\x08\x1a\x77\x92\x07\x3d\x59\x3d",
+		.data_len = 16,
+		.tag = "\x1f\xc6\x4f\xbf\xac\xcd",
+		.tag_len = 6,
+	},
+	{
+		.name = "NIST SP 800-38C Example 3",
+		.key = "\x40\x41\x42\x43\x44\x45\x46\x47"
+		       "\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f",
+		.key_len = 16,
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b",
+		.nonce_len = 12,
+		.ad = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+		      "\x10\x11\x12\x13",
+		.ad_len = 20,
+		.ptext = "\x20\x21\x22\x23\x24\x25\x26\x27"
+			 "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			 "\x30\x31\x32\x33\x34\x35\x36\x37",
+		.ctext = "\xe3\xb2\x01\xa9\xf5\xb7\x1a\x7a"
+			 "\x9b\x1c\xea\xec\xcd\x97\xe7\x0b"
+			 "\x61\x76\xaa\xd9\xa4\x42\x8a\xa5",
+		.data_len = 24,
+		.tag = "\x48\x43\x92\xfb\xc1\xb0\x99\x51",
+		.tag_len = 8,
+	},
+};
+
+static void test_aes_ccm_one_test_vector(struct kunit *test,
+					 const struct aes_ccm_testvec *tv)
+{
+	u8 *ctext = alloc_buf(test, tv->data_len);
+	u8 *decrypted = alloc_buf(test, tv->data_len);
+	u8 *tag = alloc_buf(test, tv->tag_len);
+	struct aes_ccm_key key;
+	int err;
+
+	err = aes_ccm_preparekey(&key, tv->key, tv->key_len, tv->tag_len);
+	KUNIT_ASSERT_EQ_MSG(test, 0, err, "Failed to prepare key for %s",
+			    tv->name);
+
+	err = aes_ccm_encrypt(ctext, tv->ptext, tv->data_len, tag, tv->ad,
+			      tv->ad_len, tv->nonce, tv->nonce_len, &key);
+	KUNIT_ASSERT_EQ_MSG(test, 0, err, "Encryption failed for %s", tv->name);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tv->ctext, ctext, tv->data_len,
+			       "Wrong ciphertext for %s", tv->name);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tag, tv->tag, tv->tag_len,
+			       "Wrong tag for %s", tv->name);
+
+	err = aes_ccm_decrypt(decrypted, ctext, tv->data_len, tag, tv->ad,
+			      tv->ad_len, tv->nonce, tv->nonce_len, &key);
+	KUNIT_ASSERT_EQ_MSG(test, 0, err, "Decryption failed for %s", tv->name);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tv->ptext, decrypted, tv->data_len,
+			       "Wrong plaintext for %s", tv->name);
+}
+
+static void test_aes_ccm_test_vectors(struct kunit *test)
+{
+	for (size_t i = 0; i < ARRAY_SIZE(aes_ccm_testvecs); i++)
+		test_aes_ccm_one_test_vector(test, &aes_ccm_testvecs[i]);
+}
+
+/*
+ * Test NIST SP 800-38C Example 4, which uses a deterministically-generated
+ * 65536-byte associated data string.
+ */
+static void test_aes_ccm_nist_sp800_38c_example4(struct kunit *test)
+{
+	struct aes_ccm_testvec tv = {
+		.name = "NIST SP 800-38C Example 4",
+		.key_len = 16,
+		.nonce_len = 13,
+		.ad_len = 65536,
+		.ctext = "\x69\x91\x5d\xad\x1e\x84\xc6\x37"
+			 "\x6a\x68\xc2\x96\x7e\x4d\xab\x61"
+			 "\x5a\xe0\xfd\x1f\xae\xc4\x4c\xc4"
+			 "\x84\x82\x85\x29\x46\x3c\xcf\x72",
+		.data_len = 32,
+		.tag = "\xb4\xac\x6b\xec\x93\xe8\x59\x8e"
+		       "\x7f\x0d\xad\xbc\xea\x5b",
+		.tag_len = 14,
+	};
+	u8 *key, *nonce, *ad, *ptext;
+
+	key = alloc_buf(test, tv.key_len);
+	for (size_t i = 0; i < tv.key_len; i++)
+		key[i] = 0x40 + i;
+
+	nonce = alloc_guarded_buf(test, tv.nonce_len);
+	for (size_t i = 0; i < tv.nonce_len; i++)
+		nonce[i] = 0x10 + i;
+
+	ad = alloc_guarded_buf(test, tv.ad_len);
+	for (size_t i = 0; i < tv.ad_len; i++)
+		ad[i] = (u8)i;
+
+	ptext = alloc_guarded_buf(test, tv.data_len);
+	for (size_t i = 0; i < tv.data_len; i++)
+		ptext[i] = 0x20 + i;
+
+	tv.key = key;
+	tv.nonce = nonce;
+	tv.ad = ad;
+	tv.ptext = ptext;
+
+	test_aes_ccm_one_test_vector(test, &tv);
+}
+
+static const size_t aes_ccm_valid_key_lens[] = { 16, 24, 32 };
+#define AEAD_MAX_KEY_LEN 32
+#define AEAD_VALID_KEY_LENS aes_ccm_valid_key_lens
+
+static const size_t aes_ccm_valid_nonce_lens[] = { 7, 8, 9, 10, 11, 12, 13 };
+#define AEAD_MAX_NONCE_LEN 13
+#define AEAD_VALID_NONCE_LENS aes_ccm_valid_nonce_lens
+
+static const size_t aes_ccm_valid_tag_lens[] = { 4, 6, 8, 10, 12, 14, 16 };
+#define AEAD_MAX_TAG_LEN 16
+#define AEAD_VALID_TAG_LENS aes_ccm_valid_tag_lens
+
+#define AEAD_KEY aes_ccm_key
+#define AEAD_CTX aes_ccm_ctx
+#define AEAD_PREPAREKEY aes_ccm_preparekey
+#define AEAD_ENCRYPT aes_ccm_encrypt
+#define AEAD_DECRYPT aes_ccm_decrypt
+
+#define AEAD_INIT aes_ccm_init
+#define AEAD_AUTH_UPDATE aes_ccm_auth_update
+#define AEAD_ENCRYPT_UPDATE aes_ccm_encrypt_update
+#define AEAD_DECRYPT_UPDATE aes_ccm_decrypt_update
+#define AEAD_ENCRYPT_FINAL aes_ccm_encrypt_final
+#define AEAD_DECRYPT_FINAL aes_ccm_decrypt_final
+
+/* This value was generated by gen-aead-testvecs.py. */
+static const u8 aes_ccm_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x70, 0x1c, 0xde, 0xa4, 0xe2, 0x03, 0x50, 0xb2, 0xf5, 0x9e, 0x61,
+	0x66, 0xe4, 0xe5, 0x13, 0x1a, 0x00, 0x95, 0x34, 0x03, 0xb7, 0x61,
+	0x2c, 0xdb, 0xc3, 0x15, 0x36, 0x84, 0x93, 0x7f, 0xb4, 0x5b,
+};
+#define AEAD_MONTE_CARLO_CHECKSUM aes_ccm_monte_carlo_checksum
+
+#include "aead-test-template.h"
+
+/*
+ * Test that for each AES-CCM nonce length, the message length is validated
+ * against the correct corresponding maximum message length.
+ */
+static void test_aes_ccm_data_len_too_large(struct kunit *test)
+{
+	static const struct {
+		size_t nonce_len;
+		u64 max_data_len;
+	} lens[] = {
+		/* clang-format off */
+		{ 7, 0xffffffffffffffff }, /* U64_MAX */
+		{ 8, 0xffffffffffffff },
+		{ 9, 0xffffffffffff },
+		{ 10, 0xffffffffff },
+		{ 11, 0xffffffff },
+		{ 12, 0xffffff },
+		{ 13, 0xffff },
+		/* clang-format on */
+	};
+	u8 nonce[13] = {};
+	u8 raw_key[AES_KEYSIZE_256] = {};
+	int err;
+	struct aes_ccm_key *key = alloc_buf(test, sizeof(*key));
+	struct aes_ccm_ctx ctx;
+
+	err = aes_ccm_preparekey(key, raw_key, sizeof(raw_key), 16);
+	KUNIT_ASSERT_EQ(test, 0, err);
+
+	for (size_t i = 0; i < ARRAY_SIZE(lens); i++) {
+		size_t nonce_len = lens[i].nonce_len;
+		u64 max_data_len = lens[i].max_data_len;
+
+		/* data_len <= max_data_len should be accepted. */
+		err = aes_ccm_init(&ctx, 0, 0, nonce, nonce_len, key);
+		KUNIT_ASSERT_EQ_MSG(
+			test, 0, err,
+			"data_len=0 wasn't accepted with nonce_len=%zu",
+			nonce_len);
+		err = aes_ccm_init(&ctx, max_data_len, 0, nonce, nonce_len,
+				   key);
+		KUNIT_ASSERT_EQ_MSG(
+			test, 0, err,
+			"data_len=%llu wasn't accepted with nonce_len=%zu",
+			max_data_len, nonce_len);
+
+		/* data_len > max_data_len should be rejected. */
+		if (max_data_len == U64_MAX)
+			continue;
+		err = aes_ccm_init(&ctx, max_data_len + 1, 0, nonce, nonce_len,
+				   key);
+		KUNIT_ASSERT_EQ_MSG(
+			test, -EOVERFLOW, err,
+			"data_len=%llu wasn't rejected with -EOVERFLOW with nonce_len=%zu (aes_ccm_init)",
+			max_data_len + 1, nonce_len);
+		if (max_data_len + 1 <= SIZE_MAX) {
+			err = aes_ccm_encrypt(NULL, NULL, max_data_len + 1,
+					      NULL, NULL, 0, nonce, nonce_len,
+					      key);
+			KUNIT_ASSERT_EQ_MSG(
+				test, -EOVERFLOW, err,
+				"data_len=%llu wasn't rejected with -EOVERFLOW with nonce_len=%zu (aes_ccm_encrypt)",
+				max_data_len + 1, nonce_len);
+			err = aes_ccm_decrypt(NULL, NULL, max_data_len + 1,
+					      NULL, NULL, 0, nonce, nonce_len,
+					      key);
+			KUNIT_ASSERT_EQ_MSG(
+				test, -EOVERFLOW, err,
+				"data_len=%llu wasn't rejected with -EOVERFLOW with nonce_len=%zu (aes_ccm_decrypt)",
+				max_data_len + 1, nonce_len);
+		}
+		err = aes_ccm_init(&ctx, U64_MAX, 0, nonce, nonce_len, key);
+		KUNIT_ASSERT_EQ_MSG(
+			test, -EOVERFLOW, err,
+			"data_len=U64_MAX wasn't rejected with -EOVERFLOW with nonce_len=%zu (aes_ccm_init)",
+			nonce_len);
+	}
+}
+
+static struct kunit_case aes_ccm_test_cases[] = {
+	KUNIT_CASE(test_aes_ccm_test_vectors),
+	KUNIT_CASE(test_aes_ccm_nist_sp800_38c_example4),
+	KUNIT_CASE(test_aes_ccm_data_len_too_large),
+	AEAD_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aes_ccm_test_suite = {
+	.name = "aes_ccm",
+	.test_cases = aes_ccm_test_cases,
+};
+kunit_test_suite(aes_ccm_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-CCM");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-aead-testvecs.py b/scripts/crypto/gen-aead-testvecs.py
new file mode 100755
index 000000000000..048043735819
--- /dev/null
+++ b/scripts/crypto/gen-aead-testvecs.py
@@ -0,0 +1,60 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Script that generates known-good data used in the AEAD tests.
+#
+# Requires that python-cryptography be installed.
+#
+# Copyright 2026 Google LLC
+
+import hashlib
+import sys
+import cryptography.hazmat.primitives.ciphers.aead
+
+
+# Deterministically generate 'length' random bytes.
+def rand_bytes(length):
+    seed = length
+    out = []
+    for _ in range(length):
+        seed = (seed * 25214903917 + 11) % 2**48
+        out.append((seed >> 16) % 256)
+    return bytes(out)
+
+
+# Deterministically generate many different AEAD inputs using exactly the same
+# method that the test uses; encrypt them using an independent implementation of
+# the algorithm; compute the checksum of all the resulting (ciphertext, authtag)
+# pairs concatenated to each other; and print the checksum as a C struct.
+def gen_monte_carlo_checksum(alg):
+    blake2s = hashlib.blake2s()
+    for data_len in range(1025):
+        ad_len = data_len % 293
+        pt = rand_bytes(data_len)
+        ad = rand_bytes(ad_len)
+        if alg == "aes-ccm":
+            key_len = [16, 24, 32][data_len % 3]
+            key = rand_bytes(key_len)
+            nonce = rand_bytes([7, 8, 9, 10, 11, 12, 13][data_len % 7])
+            tag_len = [4, 6, 8, 10, 12, 14, 16][data_len % 7]
+            ccm = cryptography.hazmat.primitives.ciphers.aead.AESCCM(
+                key, tag_length=tag_len
+            )
+            ct_and_tag = ccm.encrypt(nonce, pt, ad)
+
+        blake2s.update(ct_and_tag)
+
+    name = f"{alg.replace('-', '_')}_monte_carlo_checksum"
+    value = blake2s.digest()
+    print(f"static const u8 {name}[BLAKE2S_HASH_SIZE] = {{")
+    for i in range(0, len(value), 11):
+        line = "\t" + "".join(f"0x{b:02x}, " for b in value[i : i + 11])
+        print(f"{line.rstrip()}")
+    print("};")
+
+
+if len(sys.argv) != 2 or sys.argv[1] not in ("aes-ccm"):
+    sys.stderr.write("Usage: gen-aead-testvecs.py [aes-ccm]\n")
+    sys.exit(1)
+
+gen_monte_carlo_checksum(sys.argv[1])
-- 
2.55.0

