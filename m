Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C443624B3;
	Tue, 17 Mar 2026 04:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773720496; cv=none; b=FppcPB1dqQrHiDy8RjUPjMl8Lr5aajXJSkXXWuX+hbBu7FieIlB0To89O1QCsd4lvoh7xSnGTaEw3T1O57rJQo64AHc1OutnbCelcV3EVX8uoelqs/0zqJtDn/H8ROa/LZpWzm536wbBxGvJui1dw+3ni0gUF9C3qnNIivLekus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773720496; c=relaxed/simple;
	bh=fagMUb9NepIotkIBKwsYh9ObQp2uTwtsi/Ou/4zYDWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FqJ20H8nPkm1Pz8xKV0Y2ugafsh+V5Ov8uda4VcOB6vma/MNNoap2V8xfCa7JjIX7HD91iQ68ioIX0y+NhmzzCzVDmgB0lr4bfq+Jj71WZ0BiNVjWNNyqoyE/vPXQFEd9lXN3fQWun8LK84aJDVNB9VDv6GKQs1OD0q/dn5gUiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3dJ/qO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3dJ/qO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9165C4CEF7;
	Tue, 17 Mar 2026 04:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773720496;
	bh=fagMUb9NepIotkIBKwsYh9ObQp2uTwtsi/Ou/4zYDWA=;
	h=From:To:Cc:Subject:Date:From;
	b=S3dJ/qO5NcZrB5zH5mBQ8jFKITtF4rnMi0R1iuOf+FRoMbU5q77yChiRDQ78LVJLI
	 7/DjNXRRGdMTrYVPNCfk4O3HKvIVdxghd5k2IWYzvk+8ZlMvCf2Ex52kNOgWSMkzZK
	 TdS68wX+lcwEKtuZvUdsN28jup62uDbCv4+3f12qyoKHbqhg3gRCeKo3g/TFUnK9j9
	 YIHkB0CRhkHnQ7XNdcfgdqrNNeaJu/SjE0ev8JPjVg4VbU5gim2IOey88qlgTwt8na
	 rsdrnDQSIdpVfEgSSB4nXR6j1QOwXpeuj77hEPiReeOjYGIuXsccGiAAEOU29crg+e
	 vjaQi/eLcMYUA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS
Date: Mon, 16 Mar 2026 21:06:26 -0700
Message-ID: <20260317040626.5697-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Defaulting the crypto KUnit tests to KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
instead of simply KUNIT_ALL_TESTS was originally intended to make it
easy to enable all the crypto KUnit tests.  This additional default is
nonstandard for KUnit tests, though, and it can cause all the KUnit
tests to be built-in unexpectedly if CRYPTO_SELFTESTS is set.  It also
constitutes a back-reference to crypto/ from lib/crypto/, which is
something that we should be avoiding in order to get clean layering.

Now that we provide a lib/crypto/.kunitconfig file that enables all
crypto KUnit tests, let's consider that to be the supported way to
enable all these tests, and drop the default of CRYPTO_SELFTESTS.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/tests/Kconfig | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 0d71de3da15d..144b98fcbb50 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,117 +1,117 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 config CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST
 	tristate "KUnit tests for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_CBC_MACS
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC message
 	  authentication codes.
 
 config CRYPTO_LIB_BLAKE2B_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2b" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_BLAKE2B
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the BLAKE2b cryptographic hash function.
 
 config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2s" if !KUNIT_ALL_TESTS
 	depends on KUNIT
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	# No need to depend on CRYPTO_LIB_BLAKE2S here, as that option doesn't
 	# exist; the BLAKE2s code is always built-in for the /dev/random driver.
 	help
 	  KUnit tests for the BLAKE2s cryptographic hash function.
 
 config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_CURVE25519
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
 
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_MD5
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the MD5 cryptographic hash function and its
 	  corresponding HMAC.
 
 config CRYPTO_LIB_MLDSA_KUNIT_TEST
 	tristate "KUnit tests for ML-DSA" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_MLDSA
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the ML-DSA digital signature algorithm.
 
 config CRYPTO_LIB_NH_KUNIT_TEST
 	tristate "KUnit tests for NH" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_NH
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	help
 	  KUnit tests for the NH almost-universal hash function.
 
 config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_POLY1305
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Poly1305 library functions.
 
 config CRYPTO_LIB_POLYVAL_KUNIT_TEST
 	tristate "KUnit tests for POLYVAL" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_POLYVAL
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the POLYVAL library functions.
 
 config CRYPTO_LIB_SHA1_KUNIT_TEST
 	tristate "KUnit tests for SHA-1" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA1
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-1 cryptographic hash function and its
 	  corresponding HMAC.
 
 # Option is named *_SHA256_KUNIT_TEST, though both SHA-224 and SHA-256 tests are
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA256).
 config CRYPTO_LIB_SHA256_KUNIT_TEST
 	tristate "KUnit tests for SHA-224 and SHA-256" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA256
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-224 and SHA-256 cryptographic hash functions
 	  and their corresponding HMACs.
 
 # Option is named *_SHA512_KUNIT_TEST, though both SHA-384 and SHA-512 tests are
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA512).
 config CRYPTO_LIB_SHA512_KUNIT_TEST
 	tristate "KUnit tests for SHA-384 and SHA-512" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA512
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-384 and SHA-512 cryptographic hash functions
 	  and their corresponding HMACs.
 
 config CRYPTO_LIB_SHA3_KUNIT_TEST
 	tristate "KUnit tests for SHA-3" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA3
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA3 cryptographic hash and XOF functions,
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.

base-commit: 44a3873df8114546a76ead737f64b57ae7676cc2
-- 
2.53.0

