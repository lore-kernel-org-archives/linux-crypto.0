Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC082798F3;
	Sun, 26 Oct 2025 05:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457986; cv=none; b=DfqNheu/bQkWG1jgFtztjOfO85M0dTgSTSqCBW8rmpE0+yTi530cDMOO0dtCFIUNnwdXs+upotWsGnxJ+ew5Lr9Ax/YpWVqTYf5ElyhTjWww5ULIZ9oyYCqKKN4Lgv4HCHxXqw+3gAWcP6OdYTnCVDbRu6VJENnVg9pOVf79PVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457986; c=relaxed/simple;
	bh=emlkY+5nNYi2ijHBbHH5c1+/nTs6+mI5TfOU5NxkBH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5kdCKUBrHlHTBHmklqFJbeITbnPVxN8tMLRE2VhhjUqTT+qCYGL90dSMtPt8X2QVFNCv4op7OF5npLXRe2WQFcT53RVu8dCmo8vTQz2QodskJD45W6/cPKhui2TW6bfGmFcF0zgYSILxPT3H5uGLLMyHCXswFc7EFlBBsJ//OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/HDHsbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/HDHsbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA00C116C6;
	Sun, 26 Oct 2025 05:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457986;
	bh=emlkY+5nNYi2ijHBbHH5c1+/nTs6+mI5TfOU5NxkBH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/HDHsbI8X4Ka6VopNPe2FePuOltDSqHCT7iRjQTHzAntSOa3ktqhNOaVG4ORtJrN
	 JJinlHRql8sJ2ZUmE6kSRGdJ7X/k0wqgCasH10F4v1Te63aQVGpZnVtN0L/FiKd454
	 oNcpIkrSxJrBM9Q6uQJYwAiEpUxO5pHK2yBCG0yqpvvdzHDrSIXcIo0Q8n38hkEcoq
	 uv3U3ZgyGclFqOy5WWCwAfohpB2TRuCdJptorIZAuJqk0CwmIFtKC5goTttmNhNcBM
	 rz9DgLySiS15sGVFeJ2ILXK07YyjrxA7R6Gg6Ag2ZmrgG2mz7gnHJ08/GAfLU85yaJ
	 jZjPkbNjWt+5w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/15] lib/crypto: sha3: Add FIPS cryptographic algorithm self-test
Date: Sat, 25 Oct 2025 22:50:24 -0700
Message-ID: <20251026055032.1413733-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the SHA-3 algorithms are FIPS-approved, add the boot-time
self-test which is apparently required.  This closely follows the
corresponding SHA-1, SHA-256, and SHA-512 tests.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/sha3.rst       |  5 +++++
 lib/crypto/fips.h                   |  7 +++++++
 lib/crypto/sha3.c                   | 17 ++++++++++++++++-
 scripts/crypto/gen-fips-testvecs.py |  4 ++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
index f8c484feaa291..37640f295118b 100644
--- a/Documentation/crypto/sha3.rst
+++ b/Documentation/crypto/sha3.rst
@@ -110,10 +110,15 @@ Once all the desired output has been extracted, zeroize the context::
 Testing
 =======
 
 To test the SHA-3 code, use sha3_kunit (CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST).
 
+Since the SHA-3 algorithms are FIPS-approved, when the kernel is booted in FIPS
+mode the SHA-3 library also performs a simple self-test.  This is purely to meet
+a FIPS requirement.  Normal testing done by kernel developers and integrators
+should use the much more comprehensive KUnit test suite instead.
+
 
 References
 ==========
 
 .. [1] https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
diff --git a/lib/crypto/fips.h b/lib/crypto/fips.h
index 78a1bdd33a151..023410c2e0dbc 100644
--- a/lib/crypto/fips.h
+++ b/lib/crypto/fips.h
@@ -34,5 +34,12 @@ static const u8 fips_test_hmac_sha512_value[] __initconst __maybe_unused = {
 	0x92, 0x7e, 0x3c, 0xbd, 0xb1, 0x3c, 0x49, 0x98,
 	0x44, 0x9c, 0x8f, 0xee, 0x3f, 0x02, 0x71, 0x51,
 	0x57, 0x0b, 0x15, 0x38, 0x95, 0xd8, 0xa3, 0x81,
 	0xba, 0xb3, 0x15, 0x37, 0x5c, 0x6d, 0x57, 0x2b,
 };
+
+static const u8 fips_test_sha3_256_value[] __initconst __maybe_unused = {
+	0x77, 0xc4, 0x8b, 0x69, 0x70, 0x5f, 0x0a, 0xb1,
+	0xb1, 0xa5, 0x82, 0x0a, 0x22, 0x2b, 0x49, 0x31,
+	0xba, 0x9b, 0xb6, 0xaa, 0x32, 0xa7, 0x97, 0x00,
+	0x98, 0xdb, 0xff, 0xe7, 0xc6, 0xde, 0xb5, 0x82,
+};
diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index ee7a2ca92b2c5..6c94b4ebd0fd1 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -15,10 +15,11 @@
 #include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
+#include "fips.h"
 
 /*
  * On some 32-bit architectures, such as h8300, GCC ends up using over 1 KB of
  * stack if the round calculation gets inlined into the loop in
  * sha3_keccakf_generic().  On the other hand, on 64-bit architectures with
@@ -339,14 +340,28 @@ void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 	shake_squeeze(&ctx, out, out_len);
 	shake_zeroize_ctx(&ctx);
 }
 EXPORT_SYMBOL_GPL(shake256);
 
-#ifdef sha3_mod_init_arch
+#if defined(sha3_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha3_mod_init(void)
 {
+#ifdef sha3_mod_init_arch
 	sha3_mod_init_arch();
+#endif
+	if (fips_enabled) {
+		/*
+		 * FIPS cryptographic algorithm self-test.  As per the FIPS
+		 * Implementation Guidance, testing any SHA-3 algorithm
+		 * satisfies the test requirement for all of them.
+		 */
+		u8 hash[SHA3_256_DIGEST_SIZE];
+
+		sha3_256(fips_test_data, sizeof(fips_test_data), hash);
+		if (memcmp(fips_test_sha3_256_value, hash, sizeof(hash)) != 0)
+			panic("sha3: FIPS self-test failed\n");
+	}
 	return 0;
 }
 subsys_initcall(sha3_mod_init);
 
 static void __exit sha3_mod_exit(void)
diff --git a/scripts/crypto/gen-fips-testvecs.py b/scripts/crypto/gen-fips-testvecs.py
index 2956f88b764ae..db873f88619ac 100755
--- a/scripts/crypto/gen-fips-testvecs.py
+++ b/scripts/crypto/gen-fips-testvecs.py
@@ -3,10 +3,11 @@
 #
 # Script that generates lib/crypto/fips.h
 #
 # Copyright 2025 Google LLC
 
+import hashlib
 import hmac
 
 fips_test_data = b"fips test data\0\0"
 fips_test_key = b"fips test key\0\0\0"
 
@@ -28,5 +29,8 @@ print_static_u8_array_definition("fips_test_key", fips_test_key)
 
 for alg in 'sha1', 'sha256', 'sha512':
     ctx = hmac.new(fips_test_key, digestmod=alg)
     ctx.update(fips_test_data)
     print_static_u8_array_definition(f'fips_test_hmac_{alg}_value', ctx.digest())
+
+print_static_u8_array_definition(f'fips_test_sha3_256_value',
+                                 hashlib.sha3_256(fips_test_data).digest())
-- 
2.51.1.dirty

