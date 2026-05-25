Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9461B3806B3;
	Mon, 25 May 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779734781; cv=none; b=ZzyuB82wnips36TKZBLKMUpU/oFpq9wU/WtzVQwazD8zBOdQz6TXK+wx2kzEJc4hrlPP+bp3eKwA6vRjBGnLD8mKPve/ghtd91rzFlnKNJLgVZJSw7bq1nOaSFJVoLbHPpz33BDMEdedb9HHUx/uhUcUyM6I8egiunrv2xUHKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779734781; c=relaxed/simple;
	bh=k3ASMflhdpyc05U2qF1XqUUAJlRlOdHgrkFRSls081I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUBD12fAUU+XxGI+PT9Ej0oqqmK94mGVn6L0w4oU12KXQU6uHx/WmfqZm56BAJLKCMCYP96lRfCJPW4iNoTIdE9K2+un6DR8YmzrStSJpdJqc6mgH0qIND8hmGYDWZzxeuGqN7Xl55go3QcTwUv81qW7QkrdIIrB6Ery+Rj64tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAdMyPX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAdMyPX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4497B1F00ACF;
	Mon, 25 May 2026 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779734774;
	bh=fFXbVaHvCTBsufnxi0mxN9Ep3h34qAHfanI3JPSWrXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAdMyPX5RWV2O2HGDsiFry+RxxMPB/6RXlXjdC2eILVj862WyfPrDM71qtyEy8ZuW
	 +W+WGWywNGCVVDFXch/X+lF34lHma6C5NDzJi74PpolYIs+iWCdS3hc8MyC855IkBS
	 bHGHoGKEjdwf+O7F4sDjOmGoCGr97L4GErG4o8chM48N20QzKPWXvwtd+lYxZlbbDQ
	 DggfP0dzvv+H7kmOn3QlVI5TS3rjx5zs1+Vl2+2CVr4zKR+BCVEM+cGmmxt272D614
	 8m0t2qv7PcxE1cpi146bKAnafFeY/L/BXPWq70R1jlFJjY+HOoSwQyi4aH+8vqvBCq
	 jUK9C/fLOtnZQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ryan Appel <ryan.appel.333@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/5] lib/crypto: xwing: Add KUnit tests for X-Wing KEM
Date: Mon, 25 May 2026 13:44:03 -0500
Message-ID: <20260525184403.101818-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525184403.101818-1-ebiggers@kernel.org>
References: <20260525184403.101818-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for the X-Wing key encapsulation mechanism.

This includes:

- Test key generation, encapsulation, and decapsulation against the
  test vectors from the X-Wing specification
- Test encapsulation/decapsulation round trips
- Benchmark key generation, encapsulation, and decapsulation

This isn't intended to fully test the underlying KEMs.  Those already
have their own KUnit tests.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig                 |   1 +
 lib/crypto/tests/Kconfig                |   9 ++
 lib/crypto/tests/Makefile               |   1 +
 lib/crypto/tests/xwing-testvecs.h       | 138 ++++++++++++++++++++++++
 lib/crypto/tests/xwing_kunit.c          | 129 ++++++++++++++++++++++
 scripts/crypto/import-xwing-testvecs.py | 111 +++++++++++++++++++
 6 files changed, 389 insertions(+)
 create mode 100644 lib/crypto/tests/xwing-testvecs.h
 create mode 100644 lib/crypto/tests/xwing_kunit.c
 create mode 100755 scripts/crypto/import-xwing-testvecs.py

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 32e5b4471da8..b42d8aaed244 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -17,5 +17,6 @@ CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SM3_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_XWING_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 0a110a0733d2..485b5fd81539 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -147,10 +147,18 @@ config CRYPTO_LIB_SM3_KUNIT_TEST
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SM3 cryptographic hash function.
 
+config CRYPTO_LIB_XWING_KUNIT_TEST
+	tristate "KUnit tests for X-Wing" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_XWING
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	help
+	  KUnit tests for the X-Wing key encapsulation mechanism.
+
 config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	tristate "Enable all crypto library code for KUnit tests"
 	depends on KUNIT
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_BLAKE2B
@@ -165,10 +173,11 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_SHA3
 	select CRYPTO_LIB_SM3
+	select CRYPTO_LIB_XWING
 	help
 	  Enable all the crypto library code that has KUnit tests.
 
 	  Enable this only if you'd like to test all the crypto library code,
 	  even code that wouldn't otherwise need to be built.
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 3a73d2f33f75..acc8ddc19978 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -15,5 +15,6 @@ obj-$(CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST) += polyval_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SM3_KUNIT_TEST) += sm3_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_XWING_KUNIT_TEST) += xwing_kunit.o
diff --git a/lib/crypto/tests/xwing-testvecs.h b/lib/crypto/tests/xwing-testvecs.h
new file mode 100644
index 000000000000..057ca37c7ef7
--- /dev/null
+++ b/lib/crypto/tests/xwing-testvecs.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by import-xwing-testvecs.py */
+
+static const struct xwing_testvec {
+	u8 seed[XWING_SEED_BYTES];
+	u8 pk_hash[SHA3_256_DIGEST_SIZE];
+	u8 sk_hash[SHA3_256_DIGEST_SIZE];
+	u8 eseed[XWING_ESEED_BYTES];
+	u8 ct_hash[SHA3_256_DIGEST_SIZE];
+	u8 ss[XWING_SHARED_SECRET_BYTES];
+} xwing_testvecs[] = {
+	{
+		.seed = {
+			0x7f, 0x9c, 0x2b, 0xa4, 0xe8, 0x8f, 0x82, 0x7d,
+			0x61, 0x60, 0x45, 0x50, 0x76, 0x05, 0x85, 0x3e,
+			0xd7, 0x3b, 0x80, 0x93, 0xf6, 0xef, 0xbc, 0x88,
+			0xeb, 0x1a, 0x6e, 0xac, 0xfa, 0x66, 0xef, 0x26,
+		},
+		.pk_hash = {
+			0x51, 0x21, 0x74, 0x59, 0x04, 0x64, 0x3a, 0xd9,
+			0xdf, 0xac, 0xca, 0x78, 0x69, 0x29, 0x2c, 0x19,
+			0xa8, 0xa6, 0x95, 0x33, 0xb5, 0x3e, 0x60, 0x66,
+			0x6b, 0x7d, 0xb9, 0x10, 0xb4, 0xad, 0x63, 0x67,
+		},
+		.sk_hash = {
+			0x1f, 0x32, 0xc4, 0xb1, 0xa9, 0x65, 0xfa, 0x90,
+			0x33, 0xb7, 0x85, 0xc2, 0xa2, 0x4b, 0x81, 0xdc,
+			0xd1, 0xbc, 0x81, 0xe9, 0xbe, 0x0c, 0x20, 0x4f,
+			0x20, 0xfd, 0xd1, 0x50, 0x92, 0xbb, 0x6d, 0x4a,
+		},
+		.eseed = {
+			0x3c, 0xb1, 0xee, 0xa9, 0x88, 0x00, 0x4b, 0x93,
+			0x10, 0x3c, 0xfb, 0x0a, 0xee, 0xfd, 0x2a, 0x68,
+			0x6e, 0x01, 0xfa, 0x4a, 0x58, 0xe8, 0xa3, 0x63,
+			0x9c, 0xa8, 0xa1, 0xe3, 0xf9, 0xae, 0x57, 0xe2,
+			0x35, 0xb8, 0xcc, 0x87, 0x3c, 0x23, 0xdc, 0x62,
+			0xb8, 0xd2, 0x60, 0x16, 0x9a, 0xfa, 0x2f, 0x75,
+			0xab, 0x91, 0x6a, 0x58, 0xd9, 0x74, 0x91, 0x88,
+			0x35, 0xd2, 0x5e, 0x6a, 0x43, 0x50, 0x85, 0xb2,
+		},
+		.ct_hash = {
+			0xc0, 0xab, 0xd1, 0x49, 0xf8, 0x3f, 0x45, 0x32,
+			0x4a, 0xc3, 0xa7, 0xdd, 0xc7, 0x60, 0x6c, 0x71,
+			0xf2, 0x57, 0xe5, 0xea, 0x86, 0x11, 0x35, 0x22,
+			0x83, 0x4a, 0x0e, 0xe1, 0xbc, 0xb3, 0x4e, 0x3e,
+		},
+		.ss = {
+			0xd2, 0xdf, 0x05, 0x22, 0x12, 0x8f, 0x09, 0xdd,
+			0x8e, 0x2c, 0x92, 0xb1, 0xe9, 0x05, 0xc7, 0x93,
+			0xd8, 0xf5, 0x7a, 0x54, 0xc3, 0xda, 0x25, 0x86,
+			0x1f, 0x10, 0xbf, 0x4c, 0xa6, 0x13, 0xe3, 0x84,
+		},
+	},
+	{
+		.seed = {
+			0xba, 0xdf, 0xd6, 0xdf, 0xaa, 0xc3, 0x59, 0xa5,
+			0xef, 0xbb, 0x7b, 0xcc, 0x4b, 0x59, 0xd5, 0x38,
+			0xdf, 0x9a, 0x04, 0x30, 0x2e, 0x10, 0xc8, 0xbc,
+			0x1c, 0xbf, 0x1a, 0x0b, 0x3a, 0x51, 0x20, 0xea,
+		},
+		.pk_hash = {
+			0x79, 0x9b, 0x60, 0x16, 0xe5, 0xda, 0xa5, 0x6f,
+			0xfa, 0x1b, 0x5e, 0x79, 0xf7, 0xca, 0xf7, 0x34,
+			0x13, 0xce, 0xec, 0xd6, 0xdf, 0x42, 0x86, 0x42,
+			0x40, 0x4c, 0xac, 0x41, 0xdd, 0xee, 0x48, 0x53,
+		},
+		.sk_hash = {
+			0x1d, 0x31, 0x12, 0xef, 0x3c, 0xb6, 0x68, 0x10,
+			0xd3, 0xad, 0x64, 0x18, 0x57, 0x9a, 0x5c, 0x8c,
+			0xd9, 0xd1, 0xfa, 0x13, 0xf6, 0xdd, 0xc7, 0xc1,
+			0x29, 0x7c, 0x09, 0x63, 0xe8, 0xbb, 0xb0, 0x24,
+		},
+		.eseed = {
+			0x17, 0xcd, 0xa7, 0xcf, 0xad, 0x76, 0x5f, 0x56,
+			0x23, 0x47, 0x4d, 0x36, 0x8c, 0xcc, 0xa8, 0xaf,
+			0x00, 0x07, 0xcd, 0x9f, 0x5e, 0x4c, 0x84, 0x9f,
+			0x16, 0x7a, 0x58, 0x0b, 0x14, 0xaa, 0xbd, 0xef,
+			0xae, 0xe7, 0xee, 0xf4, 0x7c, 0xb0, 0xfc, 0xa9,
+			0x76, 0x7b, 0xe1, 0xfd, 0xa6, 0x94, 0x19, 0xdf,
+			0xb9, 0x27, 0xe9, 0xdf, 0x07, 0x34, 0x8b, 0x19,
+			0x66, 0x91, 0xab, 0xae, 0xb5, 0x80, 0xb3, 0x2d,
+		},
+		.ct_hash = {
+			0x76, 0x80, 0xb7, 0xba, 0x47, 0xae, 0x09, 0xba,
+			0xc4, 0xb4, 0x30, 0x01, 0xed, 0xce, 0xf9, 0xd9,
+			0x8e, 0x50, 0xdf, 0x20, 0x02, 0x6e, 0x70, 0xba,
+			0x6a, 0x42, 0x44, 0x47, 0xe1, 0xf2, 0xb9, 0x61,
+		},
+		.ss = {
+			0xf2, 0xe8, 0x62, 0x41, 0xc6, 0x4d, 0x60, 0xf6,
+			0x64, 0x9f, 0xbc, 0x6c, 0x5b, 0x7d, 0x17, 0x18,
+			0x0b, 0x78, 0x0a, 0x3f, 0x34, 0x35, 0x5e, 0x64,
+			0xa8, 0x57, 0x49, 0x94, 0x9c, 0x45, 0xf1, 0x50,
+		},
+	},
+	{
+		.seed = {
+			0xef, 0x58, 0x53, 0x8b, 0x8d, 0x23, 0xf8, 0x77,
+			0x32, 0xea, 0x63, 0xb0, 0x2b, 0x4f, 0xa0, 0xf4,
+			0x87, 0x33, 0x60, 0xe2, 0x84, 0x19, 0x28, 0xcd,
+			0x60, 0xdd, 0x4c, 0xee, 0x8c, 0xc0, 0xd4, 0xc9,
+		},
+		.pk_hash = {
+			0x1e, 0xf0, 0xc9, 0x9a, 0x06, 0x02, 0x64, 0x50,
+			0x56, 0x49, 0x57, 0xa5, 0x40, 0x2a, 0x78, 0x8f,
+			0xef, 0xfb, 0xbe, 0xfd, 0xcc, 0xe5, 0x5d, 0x25,
+			0xde, 0x25, 0x4d, 0x0a, 0x49, 0xeb, 0x09, 0x5a,
+		},
+		.sk_hash = {
+			0x75, 0x1b, 0x92, 0x96, 0x9e, 0xc1, 0x7a, 0x6a,
+			0x5b, 0x4f, 0x95, 0xc0, 0xd2, 0xd9, 0x7d, 0xbc,
+			0x0d, 0xa7, 0xb0, 0x98, 0x96, 0xaf, 0x69, 0xbd,
+			0x69, 0xac, 0x7a, 0xb6, 0x19, 0x9e, 0x40, 0x3d,
+		},
+		.eseed = {
+			0x22, 0xa9, 0x61, 0x88, 0xd0, 0x32, 0x67, 0x5c,
+			0x8a, 0xc8, 0x50, 0x93, 0x3c, 0x7a, 0xff, 0x15,
+			0x33, 0xb9, 0x4c, 0x83, 0x4a, 0xdb, 0xb6, 0x9c,
+			0x61, 0x15, 0xba, 0xd4, 0x69, 0x2d, 0x86, 0x19,
+			0xf9, 0x0b, 0x0c, 0xdf, 0x8a, 0x7b, 0x9c, 0x26,
+			0x40, 0x29, 0xac, 0x18, 0x5b, 0x70, 0xb8, 0x3f,
+			0x28, 0x01, 0xf2, 0xf4, 0xb3, 0xf7, 0x0c, 0x59,
+			0x3e, 0xa3, 0xae, 0xeb, 0x61, 0x3a, 0x7f, 0x1b,
+		},
+		.ct_hash = {
+			0x30, 0x88, 0x68, 0x8d, 0x63, 0x20, 0x1d, 0x5d,
+			0x84, 0x41, 0x70, 0xb7, 0x9f, 0x14, 0x8b, 0x27,
+			0x91, 0xc1, 0x5f, 0x34, 0x6f, 0xf6, 0xf8, 0xbd,
+			0x55, 0x98, 0x07, 0xfb, 0xd4, 0x42, 0xf9, 0x1f,
+		},
+		.ss = {
+			0x95, 0x3f, 0x7f, 0x4e, 0x8c, 0x5b, 0x50, 0x49,
+			0xbd, 0xc7, 0x71, 0xd1, 0xdf, 0xfa, 0xda, 0x0d,
+			0xd9, 0x61, 0x47, 0x7d, 0x1a, 0x2a, 0xe0, 0x98,
+			0x8b, 0xaa, 0x7e, 0xa6, 0x89, 0x8d, 0x89, 0x3f,
+		},
+	},
+};
diff --git a/lib/crypto/tests/xwing_kunit.c b/lib/crypto/tests/xwing_kunit.c
new file mode 100644
index 000000000000..81c4f41e9cab
--- /dev/null
+++ b/lib/crypto/tests/xwing_kunit.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit tests for X-Wing
+ *
+ * This should be run together with the mlkem and curve25519 KUnit tests.
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <crypto/sha3.h>
+#include <crypto/xwing.h>
+#include <kunit/test.h>
+
+#include "xwing-testvecs.h"
+
+struct xwing_bufs {
+	u8 pk[XWING_PUBLIC_KEY_BYTES];
+	u8 sk[XWING_SECRET_KEY_BYTES];
+	u8 ct[XWING_CIPHERTEXT_BYTES];
+	u8 ss[XWING_SHARED_SECRET_BYTES];
+	u8 pk_hash[SHA3_256_DIGEST_SIZE];
+	u8 sk_hash[SHA3_256_DIGEST_SIZE];
+	u8 ct_hash[SHA3_256_DIGEST_SIZE];
+};
+
+static struct xwing_bufs *alloc_bufs(struct kunit *test)
+{
+	struct xwing_bufs *bufs =
+		kunit_kmalloc(test, sizeof(*bufs), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, bufs);
+	return bufs;
+}
+
+static void test_xwing_rfc_testvecs(struct kunit *test)
+{
+	struct xwing_bufs *bufs = alloc_bufs(test);
+
+	for (size_t i = 0; i < ARRAY_SIZE(xwing_testvecs); i++) {
+		const struct xwing_testvec *tv = &xwing_testvecs[i];
+
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_keygen_internal(bufs->pk, bufs->sk,
+						      tv->seed));
+		sha3_256(bufs->pk, sizeof(bufs->pk), bufs->pk_hash);
+		sha3_256(bufs->sk, sizeof(bufs->sk), bufs->sk_hash);
+		KUNIT_ASSERT_MEMEQ(test, tv->pk_hash, bufs->pk_hash,
+				   sizeof(tv->pk_hash));
+		KUNIT_ASSERT_MEMEQ(test, tv->sk_hash, bufs->sk_hash,
+				   sizeof(tv->sk_hash));
+
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_encaps_internal(bufs->ct, bufs->ss,
+						      bufs->pk, tv->eseed));
+		sha3_256(bufs->ct, sizeof(bufs->ct), bufs->ct_hash);
+		KUNIT_ASSERT_MEMEQ(test, tv->ct_hash, bufs->ct_hash,
+				   sizeof(tv->ct_hash));
+		KUNIT_ASSERT_MEMEQ(test, tv->ss, bufs->ss, sizeof(bufs->ss));
+
+		memset(bufs->ss, 0xff, sizeof(bufs->ss));
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_decaps(bufs->ss, bufs->ct, bufs->sk));
+		KUNIT_ASSERT_MEMEQ(test, tv->ss, bufs->ss, sizeof(bufs->ss));
+	}
+}
+
+static void test_xwing_round_trip(struct kunit *test)
+{
+	struct xwing_bufs *bufs = alloc_bufs(test);
+	u8 ss2[XWING_SHARED_SECRET_BYTES];
+
+	for (int i = 0; i < 20; i++) {
+		KUNIT_ASSERT_EQ(test, 0, xwing_keygen(bufs->pk, bufs->sk));
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_encaps(bufs->ct, bufs->ss, bufs->pk));
+		KUNIT_ASSERT_EQ(test, 0, xwing_decaps(ss2, bufs->ct, bufs->sk));
+		KUNIT_ASSERT_MEMEQ(test, bufs->ss, ss2, sizeof(bufs->ss));
+	}
+}
+
+/* Benchmark X-Wing performance. */
+static void benchmark_xwing(struct kunit *test)
+{
+	struct xwing_bufs *bufs = alloc_bufs(test);
+	const int iterations = 100;
+	ktime_t start, end;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0, xwing_keygen(bufs->pk, bufs->sk));
+	end = ktime_get();
+	kunit_info(test, "XWing_KeyGen: %llu ns/op\n",
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_encaps(bufs->ct, bufs->ss, bufs->pk));
+	end = ktime_get();
+	kunit_info(test, "XWing_Encaps: %llu ns/op\n",
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+
+	start = ktime_get();
+	for (int i = 0; i < iterations; i++)
+		KUNIT_ASSERT_EQ(test, 0,
+				xwing_decaps(bufs->ss, bufs->ct, bufs->sk));
+	end = ktime_get();
+	kunit_info(test, "XWing_Decaps: %llu ns/op\n",
+		   div64_u64(ktime_to_ns(ktime_sub(end, start)), iterations));
+}
+
+static struct kunit_case xwing_test_cases[] = {
+	KUNIT_CASE(test_xwing_rfc_testvecs),
+	KUNIT_CASE(test_xwing_round_trip),
+	KUNIT_CASE(benchmark_xwing),
+	{}
+};
+
+static struct kunit_suite xwing_test_suite = {
+	.name = "xwing",
+	.test_cases = xwing_test_cases,
+};
+kunit_test_suite(xwing_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for X-Wing");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/import-xwing-testvecs.py b/scripts/crypto/import-xwing-testvecs.py
new file mode 100755
index 000000000000..380685212838
--- /dev/null
+++ b/scripts/crypto/import-xwing-testvecs.py
@@ -0,0 +1,111 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# This script imports test vectors from the X-Wing draft.  To use:
+#
+#    wget https://www.ietf.org/archive/id/draft-connolly-cfrg-xwing-kem-10.txt
+#    $PATH_TO_THIS_SCRIPT draft-connolly-cfrg-xwing-kem-10.txt > lib/crypto/tests/xwing-testvecs.h
+
+import hashlib
+import os
+import sys
+
+SCRIPT_NAME = os.path.basename(__file__)
+FIELD_NAMES = set(["seed", "sk", "pk", "eseed", "ct", "ss"])
+FIRST_FIELD = "seed"
+
+XWING_SEED_BYTES = 32
+XWING_PUBLIC_KEY_BYTES = 1216
+XWING_SECRET_KEY_BYTES = 32
+XWING_ESEED_BYTES = 64
+XWING_CIPHERTEXT_BYTES = 1120
+XWING_SHARED_SECRET_BYTES = 32
+
+
+def check_length(val, expected_len):
+    assert len(val) == expected_len
+    return val
+
+
+class Testvec:
+    def __init__(self, tv):
+        self.seed = check_length(tv["seed"], XWING_SEED_BYTES)
+        self.pk = check_length(tv["pk"], XWING_PUBLIC_KEY_BYTES)
+        self.sk = check_length(tv["sk"], XWING_SECRET_KEY_BYTES)
+        self.eseed = check_length(tv["eseed"], XWING_ESEED_BYTES)
+        self.ct = check_length(tv["ct"], XWING_CIPHERTEXT_BYTES)
+        self.ss = check_length(tv["ss"], XWING_SHARED_SECRET_BYTES)
+
+
+def load_testvecs(file):
+    testvecs = []
+    with open(file) as file:
+        in_appendix = False
+        tv = None
+        cur_field = None
+        for line in file:
+            if line.startswith("Appendix C."):
+                in_appendix = True
+            elif line.startswith("Appendix D."):
+                break
+            fields = line.split()
+            if len(fields) == 0 or not in_appendix:
+                continue
+            if fields[0].strip() in FIELD_NAMES:
+                cur_field = fields[0].strip()
+                if cur_field == FIRST_FIELD:
+                    if tv:
+                        testvecs.append(Testvec(tv))
+                    tv = {}
+                tv[cur_field] = b""
+                if len(fields) == 1:
+                    continue
+                possible_data = fields[1].strip()
+            elif not cur_field:
+                continue
+            else:
+                possible_data = fields[0].strip()
+            try:
+                data = bytes.fromhex(possible_data)
+                tv[cur_field] += data
+            except ValueError:
+                pass
+        testvecs.append(Testvec(tv))
+    return testvecs
+
+
+def print_bytes(prefix, value, bytes_per_line):
+    for i in range(0, len(value), bytes_per_line):
+        line = prefix + "".join(f"0x{b:02x}, " for b in value[i : i + bytes_per_line])
+        print(f"{line.rstrip()}")
+
+
+def print_c_struct_u8_array_field(name, value):
+    print(f"\t\t.{name} = {{")
+    print_bytes("\t\t\t", value, 8)
+    print("\t\t},")
+
+
+testvecs = load_testvecs(sys.argv[1])
+
+print(f"""/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by {SCRIPT_NAME} */
+
+static const struct xwing_testvec {{
+\tu8 seed[XWING_SEED_BYTES];
+\tu8 pk_hash[SHA3_256_DIGEST_SIZE];
+\tu8 sk_hash[SHA3_256_DIGEST_SIZE];
+\tu8 eseed[XWING_ESEED_BYTES];
+\tu8 ct_hash[SHA3_256_DIGEST_SIZE];
+\tu8 ss[XWING_SHARED_SECRET_BYTES];
+}} xwing_testvecs[] = {{""")
+for tv in testvecs:
+    print("\t{")
+    print_c_struct_u8_array_field("seed", tv.seed)
+    print_c_struct_u8_array_field("pk_hash", hashlib.sha3_256(tv.pk).digest())
+    print_c_struct_u8_array_field("sk_hash", hashlib.sha3_256(tv.sk).digest())
+    print_c_struct_u8_array_field("eseed", tv.eseed)
+    print_c_struct_u8_array_field("ct_hash", hashlib.sha3_256(tv.ct).digest())
+    print_c_struct_u8_array_field("ss", tv.ss)
+    print("\t},")
+print("};")
-- 
2.54.0

