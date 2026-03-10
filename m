Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0EE3E1D1E;
	Tue, 10 Mar 2026 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172633; cv=none; b=G3fO92zGJR8T2/o7rjj0Tlv1JYBJbllbXHqETXjRqa4Tu4+MNoFbXea8x+t6QYfcfS7qhu6ZJDtN30D/kNXNHj+AhSoj4rF9J3UFKkyTxCXdX0T/jctwobiTke3E8unGCEeQTA8938PRC9J98fjHJEM0pO0qFbR/pFuUBdkIYOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172633; c=relaxed/simple;
	bh=hlKoLX7zeBq1ARcS1dImjleE8ZzSFBuEd4CpwmCwe0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l+/FEfAmCibcAWcT10tSg3doexFLZ9iS4KdiBwryHQNCjB+eBlA3tTNEN7Gy1PlfjN5W9UVizC/6hUiXld24G9eFCQOdXAyC1FC7u4yopNopQ3UMl60X/AX6UNYLoNhz58lYbzQUvWrKOS+MAq8z1ZNSGjaEM1pMrUo5p3A0pI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk1WoA6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk1WoA6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6D2C19423;
	Tue, 10 Mar 2026 19:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172633;
	bh=hlKoLX7zeBq1ARcS1dImjleE8ZzSFBuEd4CpwmCwe0I=;
	h=From:To:Cc:Subject:Date:From;
	b=Xk1WoA6VsXWNjlO+7oQ16M3H28xU/xN8Y1YpJfjdd5sgdP6GP98vjc+tnxpczvnuT
	 kLkHh90TQ3g169UU1n5TKW3PFOUX9yr0CaoPZh4iotc5AXYstthsiTj/+qxtL+Uiok
	 AlP+KS5KeNhv7BfHn1B2wZu3yvQcLt8HFRkv5fqIjm3qk9qpVHidohBJggh8DrcAfS
	 Y7hyQJrekFod9xiNNdMsSWn38JVeTWCyBo28cyp2lOeznle7AS62p4S6lfWi1NcXZ0
	 gP2tpSysK+ypuJX6UfFEbXxOtjKSjMs+MPiShZqpv0nOKj4ib8SQxe/p7Z282FP00w
	 JX+oTbYhZKQGw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Gow <david@davidgow.net>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18] lib/crypto: tests: Depend on library options rather than selecting them
Date: Tue, 10 Mar 2026 12:56:46 -0700
Message-ID: <20260310195646.71713-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 4478e8eeb87120c11e90041864c2233238b2155a upstream.

The convention for KUnit tests is to have the test kconfig options
visible only when the code they depend on is already enabled.  This way
only the tests that are relevant to the particular kernel build can be
enabled, either manually or via KUNIT_ALL_TESTS.

Update lib/crypto/tests/Kconfig to follow that convention, i.e. depend
on the corresponding library options rather than selecting them.  This
fixes an issue where enabling KUNIT_ALL_TESTS enabled non-test code.

This does mean that it becomes a bit more difficult to enable *all* the
crypto library tests (which is what I do as a maintainer of the code),
since doing so will now require enabling other options that select the
libraries.  Regardless, we should follow the standard KUnit convention.
I'll also add a .kunitconfig file that does enable all these options.

Note: currently most of the crypto library options are selected by
visible options in crypto/Kconfig, which can be used to enable them
without too much trouble.  If in the future we end up with more cases
like CRYPTO_LIB_CURVE25519 which is selected only by WIREGUARD (thus
making CRYPTO_LIB_CURVE25519_KUNIT_TEST effectively depend on WIREGUARD
after this commit), we could consider adding a new kconfig option that
enables all the library code specifically for testing.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/r/CAMuHMdULzMdxuTVfg8_4jdgzbzjfx-PHkcgbGSthcUx_sHRNMg@mail.gmail.com
Fixes: 4dcf6caddaa0 ("lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256")
Fixes: 571eaeddb67d ("lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512")
Fixes: 6dd4d9f7919e ("lib/crypto: tests: Add KUnit tests for Poly1305")
Fixes: 66b130607908 ("lib/crypto: tests: Add KUnit tests for SHA-1 and HMAC-SHA1")
Fixes: d6b6aac0cdb4 ("lib/crypto: tests: Add KUnit tests for MD5 and HMAC-MD5")
Fixes: afc4e4a5f122 ("lib/crypto: tests: Migrate Curve25519 self-test to KUnit")
Fixes: 6401fd334ddf ("lib/crypto: tests: Add KUnit tests for BLAKE2b")
Fixes: 15c64c47e484 ("lib/crypto: tests: Add SHA3 kunit tests")
Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
Fixes: ed894faccb8d ("lib/crypto: tests: Add KUnit tests for ML-DSA verification")
Fixes: 7246fe6cd644 ("lib/crypto: tests: Add KUnit tests for NH")
Cc: stable@vger.kernel.org
Reviewed-by: David Gow <david@davidgow.net>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260226191749.39397-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 578af717e13a7..7f033f4c14918 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -3,73 +3,67 @@
 config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2s" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	# No need to select CRYPTO_LIB_BLAKE2S here, as that option doesn't
+	# No need to depend on CRYPTO_LIB_BLAKE2S here, as that option doesn't
 	# exist; the BLAKE2s code is always built-in for the /dev/random driver.
 	help
 	  KUnit tests for the BLAKE2s cryptographic hash function.
 
 config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_CURVE25519
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_CURVE25519
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
 
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_MD5
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_MD5
 	help
 	  KUnit tests for the MD5 cryptographic hash function and its
 	  corresponding HMAC.
 
 config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_POLY1305
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_POLY1305
 	help
 	  KUnit tests for the Poly1305 library functions.
 
 config CRYPTO_LIB_SHA1_KUNIT_TEST
 	tristate "KUnit tests for SHA-1" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA1
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA1
 	help
 	  KUnit tests for the SHA-1 cryptographic hash function and its
 	  corresponding HMAC.
 
 # Option is named *_SHA256_KUNIT_TEST, though both SHA-224 and SHA-256 tests are
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA256).
 config CRYPTO_LIB_SHA256_KUNIT_TEST
 	tristate "KUnit tests for SHA-224 and SHA-256" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA256
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA256
 	help
 	  KUnit tests for the SHA-224 and SHA-256 cryptographic hash functions
 	  and their corresponding HMACs.
 
 # Option is named *_SHA512_KUNIT_TEST, though both SHA-384 and SHA-512 tests are
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA512).
 config CRYPTO_LIB_SHA512_KUNIT_TEST
 	tristate "KUnit tests for SHA-384 and SHA-512" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA512
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA512
 	help
 	  KUnit tests for the SHA-384 and SHA-512 cryptographic hash functions
 	  and their corresponding HMACs.
 
 config CRYPTO_LIB_BENCHMARK_VISIBLE

base-commit: 6258e292d7463f96d0f06dff2a39093a54c9d16f
-- 
2.53.0

