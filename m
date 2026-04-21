Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E373DE442;
	Tue, 21 Apr 2026 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805598; cv=none; b=JlkqE0OUTp8sGFI4TBJ6WVLVz/digCKKIeeiBeserN5aYRfvCiu/H+XQLbzW9HNTDgiake2pqwTLouQE4ZKnrE6H/fMAYtV7//DimofasXe0X5arfQ8sea+kjtcTRrAagN2T3y1EM2015rXJe09uMS89Lgpg4Fjzv4vzXz3/WEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805598; c=relaxed/simple;
	bh=35LDYpViL2Z6AX7jBOzJkwpedKVCP8iYwHVo3Dy53RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sou+LQfQKW+10BMOh30Z0YHWSN5fkRVe425j2Au6eJlZ7SNq3k5/P51qYK9zgDkM484WzuEqHCwPtR11vu3jWtUq1iqDdF7Un+PvGscWA7kcK55MrWumYZRWCh3+p9kVbgnestQaVK4xYnwmHEziXxB1+HZTcfFolh8AdpvgN3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pn6CEO1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pn6CEO1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10C4C2BCB0;
	Tue, 21 Apr 2026 21:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805598;
	bh=35LDYpViL2Z6AX7jBOzJkwpedKVCP8iYwHVo3Dy53RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn6CEO1uC04II4/TloxEqfBiUjpZyUQ0rngExqakIZvZM5+wboNuXXYstWpEOBi6L
	 tQxN0SHUc6NIOH6Z8P6Tfg9aUPiTO8rMsEN3oe3Jtp7pKsdj1Vya94SSNLRyjAdgZn
	 cxgAUA1PRzn1X5v6G0FXcUhlCO/BQgrb91fTGrsbcHCizOJfDFXQRe3lTn+zGlCjiX
	 maq/b6eyj4I6ZsRKfwqE22Rs1Et+60/RhOvEN3N5JbI3W4pQly/6e+EAew9QpRMWMv
	 c/FQU1QacY8wbEBO0PHSJ+YRRhKu7+JmSWP8F0+8ZhvvZVbmFCKY9ODiR6ZKXvBxGz
	 hcyXM6RCWNp6Q==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 8/8] lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS
Date: Tue, 21 Apr 2026 14:05:54 -0700
Message-ID: <20260421210554.36096-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421210554.36096-1-ebiggers@kernel.org>
References: <20260421210554.36096-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 6d80749becf8fc5ffa004194e578f79b558235ef upstream.

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

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260317040626.5697-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 73200134916e8..a91815ec9b3ad 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,68 +1,68 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
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
 
 config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_POLY1305
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Poly1305 library functions.
 
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
 
-- 
2.53.0

