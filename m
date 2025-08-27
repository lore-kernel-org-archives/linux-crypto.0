Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7A2D2384;
	Wed, 27 Aug 2025 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307702; cv=none; b=Cy0KX1CE7+W9n/AIq+mzcbpQpyG8WYOTMXj4cMDhud9HdVuNkoDy99LAuzG6WAcK972CG1GSf4u03GZ7GqpKJ6UkiUyKsfilWiqm7GYuX418Cm87wBsfQcZG4Bv5FUMd7vHe1+Fd/WICqHJEl2Xe2Q/gCRA0/euwiXKUMiIh0cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307702; c=relaxed/simple;
	bh=1qgaGsrCssucR1umbiIEhm9E7Chqg0rg24h/vOyJeL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXFFBs8T0XmgCbehraGG+lelg1Pf2xA3EoQ4Xj498BtbJJGo9aI898W+vx/lS5eNm18OfZDoY1KDoAkjlRs+DN+qU+36Vv0w4JpD46Mq1o3/MVB/SPH6Ddve6ofQUVndgv8Fddp2d6+Nf2nmx5+i0VCO60Lupq2ZtoBGl54WbrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnQf9eW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnQf9eW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB062C4CEF0;
	Wed, 27 Aug 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307702;
	bh=1qgaGsrCssucR1umbiIEhm9E7Chqg0rg24h/vOyJeL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnQf9eW6/q0WqMUAq3qefEoD22TolFa6J4vbJCvrOsqe5vfeBN4rgBTogvzaUu9Xc
	 K5pT08f0fM3QtdCxYh2prk75RcbPjcm+7/NnaY60tSl4nKAWDtyXGpJDbORZRY2O9L
	 CbpISfeYabjhtHkP0VRl5KsQi/y9YE3BdkOKMKmNMZVlN04AkpZC2UrNjlUCalIsgK
	 uywXCeDZ1B+ePxD1x3f1yebCHUenKQyfGpbw/Zr7UePDGhCg2ZdlyozJmm4VoZ1BkF
	 52eqCaFQqajyEg8DtyJD3Bz1mkBtb2anViaa2pXPxG4WXzh5aH0sTXeQfl11/FvVkI
	 Bs/air38RLOTw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/12] lib/crypto: tests: Add KUnit tests for BLAKE2s
Date: Wed, 27 Aug 2025 08:11:31 -0700
Message-ID: <20250827151131.27733-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test suite for BLAKE2s.  Most of the core test logic is in
the previously-added hash-test-template.h.  This commit just adds the
actual KUnit suite, commits the generated test vectors to the tree so
that gen-hash-testvecs.py won't have to be run at build time, and adds a
few BLAKE2s-specific test cases.

This is the replacement for blake2s-selftest, which an earlier commit
removed.  Improvements over blake2s-selftest include integration with
KUnit, more comprehensive test cases, and support for benchmarking.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig            |  10 ++
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/blake2s-testvecs.h | 238 ++++++++++++++++++++++++++++
 lib/crypto/tests/blake2s_kunit.c    | 134 ++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py |  27 +++-
 5 files changed, 407 insertions(+), 3 deletions(-)
 create mode 100644 lib/crypto/tests/blake2s-testvecs.h
 create mode 100644 lib/crypto/tests/blake2s_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index c21d53fd4b0ce..fd341aa12f157 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,7 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
+	tristate "KUnit tests for BLAKE2s" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# No need to select CRYPTO_LIB_BLAKE2S here, as that option doesn't
+	# exist; the BLAKE2s code is always built-in for the /dev/random driver.
+	help
+	  KUnit tests for the BLAKE2s cryptographic hash function.
+
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index f6f82c6f9cb5d..be7de929af2cc 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST) += md5_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST) += poly1305_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
diff --git a/lib/crypto/tests/blake2s-testvecs.h b/lib/crypto/tests/blake2s-testvecs.h
new file mode 100644
index 0000000000000..6f978b79a59b0
--- /dev/null
+++ b/lib/crypto/tests/blake2s-testvecs.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* This file was generated by: ./scripts/crypto/gen-hash-testvecs.py blake2s */
+
+static const struct {
+	size_t data_len;
+	u8 digest[BLAKE2S_HASH_SIZE];
+} hash_testvecs[] = {
+	{
+		.data_len = 0,
+		.digest = {
+			0x69, 0x21, 0x7a, 0x30, 0x79, 0x90, 0x80, 0x94,
+			0xe1, 0x11, 0x21, 0xd0, 0x42, 0x35, 0x4a, 0x7c,
+			0x1f, 0x55, 0xb6, 0x48, 0x2c, 0xa1, 0xa5, 0x1e,
+			0x1b, 0x25, 0x0d, 0xfd, 0x1e, 0xd0, 0xee, 0xf9,
+		},
+	},
+	{
+		.data_len = 1,
+		.digest = {
+			0x7c, 0xab, 0x53, 0xe2, 0x48, 0x87, 0xdf, 0x64,
+			0x98, 0x6a, 0xc1, 0x7e, 0xf0, 0x01, 0x4d, 0xc9,
+			0x07, 0x4f, 0xb8, 0x2f, 0x46, 0xd7, 0xee, 0xa9,
+			0xad, 0xe5, 0xf8, 0x21, 0xac, 0xfe, 0x17, 0x58,
+		},
+	},
+	{
+		.data_len = 2,
+		.digest = {
+			0x5e, 0x63, 0x2c, 0xd0, 0xf8, 0x7b, 0xf5, 0xae,
+			0x61, 0x97, 0x94, 0x57, 0xc8, 0x76, 0x22, 0xd9,
+			0x8b, 0x04, 0x5e, 0xf1, 0x5d, 0xd0, 0xfc, 0xd9,
+			0x0c, 0x19, 0x2e, 0xe2, 0xc5, 0xd9, 0x73, 0x51,
+		},
+	},
+	{
+		.data_len = 3,
+		.digest = {
+			0x33, 0x65, 0xa6, 0x37, 0xbf, 0xf8, 0x4f, 0x15,
+			0x4c, 0xac, 0x9e, 0xa4, 0x3b, 0x02, 0x07, 0x0c,
+			0x80, 0x86, 0x0d, 0x6c, 0xe4, 0xaf, 0x1c, 0xbc,
+			0x0b, 0x9c, 0x0a, 0x98, 0xc2, 0x99, 0x71, 0xcd,
+		},
+	},
+	{
+		.data_len = 16,
+		.digest = {
+			0x59, 0xd2, 0x10, 0xd3, 0x75, 0xac, 0x48, 0x32,
+			0xb1, 0xea, 0xee, 0xcf, 0x0a, 0xd2, 0x8b, 0x15,
+			0x5d, 0x72, 0x71, 0x4c, 0xa7, 0x29, 0xb0, 0x7a,
+			0x44, 0x48, 0x8a, 0x54, 0x54, 0x54, 0x41, 0xf5,
+		},
+	},
+	{
+		.data_len = 32,
+		.digest = {
+			0xdc, 0xfc, 0x46, 0x81, 0xc6, 0x1b, 0x2b, 0x47,
+			0x8b, 0xed, 0xe0, 0x73, 0x34, 0x38, 0x53, 0x92,
+			0x97, 0x2f, 0xfb, 0x51, 0xab, 0x4f, 0x2d, 0x9d,
+			0x69, 0x04, 0xa9, 0x5d, 0x33, 0xef, 0xcb, 0x1c,
+		},
+	},
+	{
+		.data_len = 48,
+		.digest = {
+			0xd6, 0x2a, 0x7f, 0x96, 0x04, 0x4d, 0x16, 0xc8,
+			0x49, 0xe0, 0x37, 0x33, 0xe3, 0x7b, 0x34, 0x56,
+			0x99, 0xc5, 0x78, 0x57, 0x06, 0x02, 0xb4, 0xea,
+			0x80, 0xc4, 0xf8, 0x8f, 0x8d, 0x2b, 0xe4, 0x05,
+		},
+	},
+	{
+		.data_len = 49,
+		.digest = {
+			0x8b, 0x58, 0x62, 0xb5, 0x85, 0xf6, 0x83, 0x36,
+			0xf5, 0x34, 0xb8, 0xd4, 0xbc, 0x5c, 0x8b, 0x38,
+			0xfd, 0x15, 0xcd, 0x44, 0x83, 0x25, 0x71, 0xe1,
+			0xd5, 0xe8, 0xa1, 0xa4, 0x36, 0x98, 0x7e, 0x68,
+		},
+	},
+	{
+		.data_len = 63,
+		.digest = {
+			0x7e, 0xeb, 0x06, 0x87, 0xdf, 0x1a, 0xdc, 0xe5,
+			0xfb, 0x64, 0xd4, 0xd1, 0x5d, 0x9e, 0x75, 0xc0,
+			0xb9, 0xad, 0x55, 0x6c, 0xe6, 0xba, 0x4d, 0x98,
+			0x2f, 0xbf, 0x72, 0xad, 0x61, 0x37, 0xf6, 0x11,
+		},
+	},
+	{
+		.data_len = 64,
+		.digest = {
+			0x72, 0xdb, 0x43, 0x16, 0x57, 0x8e, 0x3a, 0x96,
+			0xf3, 0x98, 0x19, 0x24, 0x17, 0x3b, 0xe8, 0xad,
+			0xa1, 0x9b, 0xa4, 0x1b, 0x74, 0x85, 0x2e, 0x24,
+			0x70, 0xea, 0x31, 0x5a, 0x1c, 0xbe, 0x43, 0xb5,
+		},
+	},
+	{
+		.data_len = 65,
+		.digest = {
+			0x32, 0x48, 0xb0, 0xf0, 0x3f, 0xbb, 0xd2, 0xa3,
+			0xfd, 0xf6, 0x28, 0x4a, 0x2a, 0xc5, 0xbe, 0x4b,
+			0x73, 0x50, 0x63, 0xd6, 0x16, 0x00, 0xef, 0xed,
+			0xfe, 0x97, 0x41, 0x29, 0xb2, 0x84, 0xc4, 0xa3,
+		},
+	},
+	{
+		.data_len = 127,
+		.digest = {
+			0x17, 0xda, 0x6b, 0x96, 0x6a, 0xa6, 0xa4, 0xa6,
+			0xa6, 0xf3, 0x9d, 0x18, 0x19, 0x8d, 0x98, 0x7c,
+			0x66, 0x38, 0xe8, 0x99, 0xe7, 0x0a, 0x50, 0x92,
+			0xaf, 0x11, 0x80, 0x05, 0x66, 0xed, 0xab, 0x74,
+		},
+	},
+	{
+		.data_len = 128,
+		.digest = {
+			0x13, 0xd5, 0x8b, 0x22, 0xae, 0x90, 0x7b, 0x67,
+			0x87, 0x4e, 0x3c, 0x35, 0x4e, 0x01, 0xf0, 0xb1,
+			0xd3, 0xd1, 0x67, 0xbb, 0x43, 0xdb, 0x7c, 0x75,
+			0xa4, 0xc7, 0x64, 0x83, 0x1e, 0x9b, 0x98, 0xad,
+		},
+	},
+	{
+		.data_len = 129,
+		.digest = {
+			0x6f, 0xe0, 0x5d, 0x9d, 0xd5, 0x78, 0x29, 0xfb,
+			0xd0, 0x77, 0xd1, 0x8a, 0xf0, 0x80, 0xcb, 0x81,
+			0x71, 0x9e, 0x4d, 0x49, 0xde, 0x74, 0x2a, 0x37,
+			0xc0, 0xd5, 0xf0, 0xfa, 0x50, 0xe6, 0x23, 0xfe,
+		},
+	},
+	{
+		.data_len = 256,
+		.digest = {
+			0x89, 0xac, 0xf6, 0xe7, 0x5e, 0xba, 0x53, 0xf4,
+			0x92, 0x32, 0xd5, 0x64, 0xfb, 0xc4, 0x08, 0xac,
+			0x2c, 0x19, 0x6e, 0x63, 0x13, 0x75, 0xd0, 0x60,
+			0x54, 0x35, 0x82, 0xc4, 0x6d, 0x03, 0x1a, 0x05,
+		},
+	},
+	{
+		.data_len = 511,
+		.digest = {
+			0x1c, 0xaf, 0x94, 0x7d, 0x9c, 0xce, 0x57, 0x64,
+			0xf8, 0xa8, 0x25, 0x45, 0x32, 0x86, 0x2b, 0x04,
+			0xb3, 0x2e, 0x67, 0xca, 0x73, 0x04, 0x2f, 0xab,
+			0xcc, 0xda, 0x9e, 0x42, 0xa1, 0xaf, 0x83, 0x5a,
+		},
+	},
+	{
+		.data_len = 513,
+		.digest = {
+			0x21, 0xdf, 0xdc, 0x29, 0xd9, 0xfc, 0x7b, 0xe7,
+			0x3a, 0xc4, 0xe1, 0x61, 0xc5, 0xb5, 0xe1, 0xee,
+			0x7a, 0x9d, 0x0c, 0x66, 0x36, 0x63, 0xe4, 0x12,
+			0x62, 0xe2, 0xf5, 0x68, 0x72, 0xfc, 0x1e, 0x18,
+		},
+	},
+	{
+		.data_len = 1000,
+		.digest = {
+			0x6e, 0xc7, 0x2e, 0xac, 0xd0, 0xbb, 0x22, 0xe0,
+			0xc2, 0x40, 0xb2, 0xfe, 0x8c, 0xaf, 0x9e, 0xcf,
+			0x32, 0x06, 0xc6, 0x45, 0x29, 0xbd, 0xe0, 0x7f,
+			0x53, 0x32, 0xc3, 0x2b, 0x2f, 0x68, 0x12, 0xcd,
+		},
+	},
+	{
+		.data_len = 3333,
+		.digest = {
+			0x76, 0xba, 0x52, 0xb5, 0x09, 0xf5, 0x19, 0x09,
+			0x70, 0x1c, 0x09, 0x28, 0xb4, 0xaa, 0x98, 0x6a,
+			0x79, 0xe7, 0x5e, 0xcd, 0xe8, 0xa4, 0x73, 0x69,
+			0x1f, 0xf8, 0x05, 0x0a, 0xb4, 0xfe, 0xf9, 0x63,
+		},
+	},
+	{
+		.data_len = 4096,
+		.digest = {
+			0xf7, 0xad, 0xf9, 0xc8, 0x0e, 0x04, 0x2f, 0xdf,
+			0xbe, 0x39, 0x79, 0x07, 0x0d, 0xd8, 0x1b, 0x06,
+			0x42, 0x3a, 0x43, 0x93, 0xf6, 0x7c, 0xc4, 0xe5,
+			0xc2, 0xd5, 0xd0, 0xa6, 0x35, 0x6c, 0xbd, 0x17,
+		},
+	},
+	{
+		.data_len = 4128,
+		.digest = {
+			0x38, 0xd7, 0xab, 0x7e, 0x08, 0xdc, 0x1e, 0xab,
+			0x55, 0xbb, 0x3b, 0x7b, 0x6a, 0x17, 0xcc, 0x79,
+			0xa7, 0x02, 0x62, 0x66, 0x9b, 0xca, 0xee, 0xc0,
+			0x3d, 0x75, 0x34, 0x2e, 0x55, 0x82, 0x26, 0x3c,
+		},
+	},
+	{
+		.data_len = 4160,
+		.digest = {
+			0xf7, 0xeb, 0x2f, 0x24, 0x98, 0x54, 0x04, 0x5a,
+			0x19, 0xe4, 0x12, 0x9d, 0x97, 0xbc, 0x87, 0xa5,
+			0x0b, 0x85, 0x29, 0xa1, 0x36, 0x89, 0xc9, 0xba,
+			0xa0, 0xe0, 0xac, 0x99, 0x7d, 0xa4, 0x51, 0x9f,
+		},
+	},
+	{
+		.data_len = 4224,
+		.digest = {
+			0x8f, 0xe8, 0xa7, 0x79, 0x02, 0xbb, 0x4a, 0x56,
+			0x66, 0x91, 0xef, 0x22, 0xd1, 0x09, 0x26, 0x6c,
+			0xa9, 0x13, 0xd7, 0x44, 0xc7, 0x19, 0x9c, 0x0b,
+			0xfb, 0x4f, 0xca, 0x72, 0x8f, 0x34, 0xf7, 0x82,
+		},
+	},
+	{
+		.data_len = 16384,
+		.digest = {
+			0xaa, 0x21, 0xbb, 0x25, 0x4b, 0x66, 0x6e, 0x29,
+			0x71, 0xc1, 0x44, 0x67, 0x19, 0xed, 0xe6, 0xe6,
+			0x61, 0x13, 0xf4, 0xb7, 0x02, 0x94, 0x81, 0x0f,
+			0xa7, 0x4d, 0xbb, 0x2c, 0xb8, 0xeb, 0x41, 0x0e,
+		},
+	},
+};
+
+static const u8 hash_testvec_consolidated[BLAKE2S_HASH_SIZE] = {
+	0x84, 0x21, 0xbb, 0x73, 0x64, 0x47, 0x45, 0xe0,
+	0xc1, 0x83, 0x78, 0xf1, 0xea, 0xe5, 0xfd, 0xdb,
+	0x01, 0xda, 0xb7, 0x86, 0x70, 0x3b, 0x83, 0xb3,
+	0xbc, 0xd9, 0xfd, 0x96, 0xbd, 0x50, 0x06, 0x67,
+};
+
+static const u8 blake2s_keyed_testvec_consolidated[BLAKE2S_HASH_SIZE] = {
+	0xa6, 0xad, 0xcd, 0xb8, 0xd9, 0xdd, 0xc7, 0x70,
+	0x07, 0x09, 0x7f, 0x9f, 0x41, 0xa9, 0x70, 0xa4,
+	0x1c, 0xca, 0x61, 0xbb, 0x58, 0xb5, 0xb2, 0x1d,
+	0xd1, 0x71, 0x16, 0xb0, 0x49, 0x4f, 0x9e, 0x1b,
+};
diff --git a/lib/crypto/tests/blake2s_kunit.c b/lib/crypto/tests/blake2s_kunit.c
new file mode 100644
index 0000000000000..057c40132246f
--- /dev/null
+++ b/lib/crypto/tests/blake2s_kunit.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/blake2s.h>
+#include "blake2s-testvecs.h"
+
+/*
+ * The following are compatibility functions that present BLAKE2s as an unkeyed
+ * hash function that produces hashes of fixed length BLAKE2S_HASH_SIZE, so that
+ * hash-test-template.h can be reused to test it.
+ */
+
+static void blake2s_default(const u8 *data, size_t len,
+			    u8 out[BLAKE2S_HASH_SIZE])
+{
+	blake2s(out, data, NULL, BLAKE2S_HASH_SIZE, len, 0);
+}
+
+static void blake2s_init_default(struct blake2s_state *state)
+{
+	blake2s_init(state, BLAKE2S_HASH_SIZE);
+}
+
+/*
+ * Generate the HASH_KUNIT_CASES using hash-test-template.h.  These test BLAKE2s
+ * with a key length of 0 and a hash length of BLAKE2S_HASH_SIZE.
+ */
+#define HASH blake2s_default
+#define HASH_CTX blake2s_state
+#define HASH_SIZE BLAKE2S_HASH_SIZE
+#define HASH_INIT blake2s_init_default
+#define HASH_UPDATE blake2s_update
+#define HASH_FINAL blake2s_final
+#include "hash-test-template.h"
+
+/*
+ * BLAKE2s specific test case which tests all possible combinations of key
+ * length and hash length.
+ */
+static void test_blake2s_all_key_and_hash_lens(struct kunit *test)
+{
+	const size_t data_len = 100;
+	u8 *data = &test_buf[0];
+	u8 *key = data + data_len;
+	u8 *hash = key + BLAKE2S_KEY_SIZE;
+	struct blake2s_state main_state;
+	u8 main_hash[BLAKE2S_HASH_SIZE];
+
+	rand_bytes_seeded_from_len(data, data_len);
+	blake2s_init(&main_state, BLAKE2S_HASH_SIZE);
+	for (int key_len = 0; key_len <= BLAKE2S_KEY_SIZE; key_len++) {
+		rand_bytes_seeded_from_len(key, key_len);
+		for (int out_len = 1; out_len <= BLAKE2S_HASH_SIZE; out_len++) {
+			blake2s(hash, data, key, out_len, data_len, key_len);
+			blake2s_update(&main_state, hash, out_len);
+		}
+	}
+	blake2s_final(&main_state, main_hash);
+	KUNIT_ASSERT_MEMEQ(test, main_hash, blake2s_keyed_testvec_consolidated,
+			   BLAKE2S_HASH_SIZE);
+}
+
+/*
+ * BLAKE2s specific test case which tests using a guarded buffer for all allowed
+ * key lengths.  Also tests both blake2s() and blake2s_init_key().
+ */
+static void test_blake2s_with_guarded_key_buf(struct kunit *test)
+{
+	const size_t data_len = 100;
+
+	rand_bytes(test_buf, data_len);
+	for (int key_len = 0; key_len <= BLAKE2S_KEY_SIZE; key_len++) {
+		u8 key[BLAKE2S_KEY_SIZE];
+		u8 *guarded_key = &test_buf[TEST_BUF_LEN - key_len];
+		u8 hash1[BLAKE2S_HASH_SIZE];
+		u8 hash2[BLAKE2S_HASH_SIZE];
+		struct blake2s_state state;
+
+		rand_bytes(key, key_len);
+		memcpy(guarded_key, key, key_len);
+
+		blake2s(hash1, test_buf, key,
+			BLAKE2S_HASH_SIZE, data_len, key_len);
+		blake2s(hash2, test_buf, guarded_key,
+			BLAKE2S_HASH_SIZE, data_len, key_len);
+		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2S_HASH_SIZE);
+
+		blake2s_init_key(&state, BLAKE2S_HASH_SIZE,
+				 guarded_key, key_len);
+		blake2s_update(&state, test_buf, data_len);
+		blake2s_final(&state, hash2);
+		KUNIT_ASSERT_MEMEQ(test, hash1, hash2, BLAKE2S_HASH_SIZE);
+	}
+}
+
+/*
+ * BLAKE2s specific test case which tests using a guarded output buffer for all
+ * allowed output lengths.
+ */
+static void test_blake2s_with_guarded_out_buf(struct kunit *test)
+{
+	const size_t data_len = 100;
+
+	rand_bytes(test_buf, data_len);
+	for (int out_len = 1; out_len <= BLAKE2S_HASH_SIZE; out_len++) {
+		u8 hash[BLAKE2S_HASH_SIZE];
+		u8 *guarded_hash = &test_buf[TEST_BUF_LEN - out_len];
+
+		blake2s(hash, test_buf, NULL, out_len, data_len, 0);
+		blake2s(guarded_hash, test_buf, NULL, out_len, data_len, 0);
+		KUNIT_ASSERT_MEMEQ(test, hash, guarded_hash, out_len);
+	}
+}
+
+static struct kunit_case blake2s_test_cases[] = {
+	HASH_KUNIT_CASES,
+	KUNIT_CASE(test_blake2s_all_key_and_hash_lens),
+	KUNIT_CASE(test_blake2s_with_guarded_key_buf),
+	KUNIT_CASE(test_blake2s_with_guarded_out_buf),
+	KUNIT_CASE(benchmark_hash),
+	{},
+};
+
+static struct kunit_suite blake2s_test_suite = {
+	.name = "blake2s",
+	.test_cases = blake2s_test_cases,
+	.suite_init = hash_suite_init,
+	.suite_exit = hash_suite_exit,
+};
+kunit_test_suite(blake2s_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for BLAKE2s");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-hash-testvecs.py b/scripts/crypto/gen-hash-testvecs.py
index 4ac927d40cf5c..fc063f2ee95f1 100755
--- a/scripts/crypto/gen-hash-testvecs.py
+++ b/scripts/crypto/gen-hash-testvecs.py
@@ -82,15 +82,20 @@ def print_static_u8_array_definition(name, value):
 def print_c_struct_u8_array_field(name, value):
     print(f'\t\t.{name} = {{')
     print_bytes('\t\t\t', value, 8)
     print('\t\t},')
 
+def alg_digest_size_const(alg):
+    if alg == 'blake2s':
+        return 'BLAKE2S_HASH_SIZE'
+    return f'{alg.upper()}_DIGEST_SIZE'
+
 def gen_unkeyed_testvecs(alg):
     print('')
     print('static const struct {')
     print('\tsize_t data_len;')
-    print(f'\tu8 digest[{alg.upper()}_DIGEST_SIZE];')
+    print(f'\tu8 digest[{alg_digest_size_const(alg)}];')
     print('} hash_testvecs[] = {')
     for data_len in DATA_LENS:
         data = rand_bytes(data_len)
         print('\t{')
         print(f'\t\t.data_len = {data_len},')
@@ -101,11 +106,11 @@ def gen_unkeyed_testvecs(alg):
     data = rand_bytes(4096)
     ctx = hash_init(alg)
     for data_len in range(len(data) + 1):
         hash_update(ctx, compute_hash(alg, data[:data_len]))
     print_static_u8_array_definition(
-            f'hash_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
+            f'hash_testvec_consolidated[{alg_digest_size_const(alg)}]',
             hash_final(ctx))
 
 def gen_hmac_testvecs(alg):
     ctx = hmac.new(rand_bytes(32), digestmod=alg)
     data = rand_bytes(4096)
@@ -117,10 +122,24 @@ def gen_hmac_testvecs(alg):
         ctx.update(mac)
     print_static_u8_array_definition(
             f'hmac_testvec_consolidated[{alg.upper()}_DIGEST_SIZE]',
             ctx.digest())
 
+BLAKE2S_KEY_SIZE = 32
+BLAKE2S_HASH_SIZE = 32
+
+def gen_additional_blake2s_testvecs():
+    hashes = b''
+    for key_len in range(BLAKE2S_KEY_SIZE + 1):
+        for out_len in range(1, BLAKE2S_HASH_SIZE + 1):
+            h = hashlib.blake2s(digest_size=out_len, key=rand_bytes(key_len))
+            h.update(rand_bytes(100))
+            hashes += h.digest()
+    print_static_u8_array_definition(
+            'blake2s_keyed_testvec_consolidated[BLAKE2S_HASH_SIZE]',
+            compute_hash('blake2s', hashes))
+
 def gen_additional_poly1305_testvecs():
     key = b'\xff' * POLY1305_KEY_SIZE
     data = b''
     ctx = Poly1305(key)
     for _ in range(32):
@@ -139,9 +158,11 @@ if len(sys.argv) != 2:
 
 alg = sys.argv[1]
 print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
 print(f'/* This file was generated by: {sys.argv[0]} {" ".join(sys.argv[1:])} */')
 gen_unkeyed_testvecs(alg)
-if alg == 'poly1305':
+if alg == 'blake2s':
+    gen_additional_blake2s_testvecs()
+elif alg == 'poly1305':
     gen_additional_poly1305_testvecs()
 else:
     gen_hmac_testvecs(alg)
-- 
2.50.1

