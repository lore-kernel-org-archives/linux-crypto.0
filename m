Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C93321420B;
	Mon, 20 Oct 2025 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921616; cv=none; b=D3dAUYxkqVVglpgMt4jFEM+GrJNCmdLWSIFFmIkcnxaBuZBbp4EEjFreMA3aWX1ap+VBGsNq2lrsqJEATXR6t3ZcgItOE+BkC8ExMM9shYve4umQeUq19LncfAC835j4vKmbK0WEvxqelQf0fyS/Ye1hSzPXr65ejOoAgyCAxB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921616; c=relaxed/simple;
	bh=3YHFqqatVYAdaji7NuRqfLy3KJyI82DMyXan+tUouMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g36MsHZ9je/G4EiKo+1dFPbDNrNU44DquE9wjNogR8kEGdCM4Myt4lHUCaVeeCtuIa6vmCwFW0R0JTzjVd92IfMNZGOUnZ6uXQoMmc59eWdhl4E5Lcp1XQZchgiLr8qeT1sonYSiDyes739PFYGwmMeMf5xonCbNDDCcx3XVSUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnQJfJFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnQJfJFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AE3C4CEE7;
	Mon, 20 Oct 2025 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921616;
	bh=3YHFqqatVYAdaji7NuRqfLy3KJyI82DMyXan+tUouMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnQJfJFPkl3b6tm6hDp/45/sno1hoDbgxW9aDdnf7oMWNkSgJmr2jsgMvGVmop59c
	 NrdPxaaW5RoltBBjF5Bz7crHZbjaaTJakuXJF5Y+1nMPy+Z0HO3K7FpEE5mrl01zu4
	 ylMaV3TWfnCDsrYUnZmByiXjVig5OqH5FEmSnax/9oSpnZ8elAWPGtpHVlMlLF3gdM
	 y4Rm/hVbUTU8kELs+EiSUyfOVuT8bdpqasiK7CW1vfojsJbbD3MriveBVm89i+cQoT
	 CdQtbJbcVVQBjBBzgCiazr/iCA+fl2s/svYCKNUGWvQpj1ItziYfpgwpdD0T7shZGP
	 sYqz0s5WLLqsQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/17] lib/crypto: sha3: Replace redundant ad-hoc test with FIPS test
Date: Sun, 19 Oct 2025 17:50:31 -0700
Message-ID: <20251020005038.661542-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SHA-3 is a FIPS-approved algorithm, add a FIPS cryptographic
algorithm self-test to it, following the example of SHA-1 and SHA-2.
Make it replace the existing ad-hoc test.  The actual correctness tests
are in the KUnit test suite; the boot-time testing is just for FIPS.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/sha3.rst       | 12 ++++--
 lib/crypto/fips.h                   |  7 ++++
 lib/crypto/sha3.c                   | 63 +++++++----------------------
 scripts/crypto/gen-fips-testvecs.py |  4 ++
 4 files changed, 33 insertions(+), 53 deletions(-)

diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
index 3255618ea2ec3..6d7a07e088e9a 100644
--- a/Documentation/crypto/sha3.rst
+++ b/Documentation/crypto/sha3.rst
@@ -9,11 +9,11 @@ SHA-3 Algorithm collection
   - Overview
   - Basic API
     - Extendable-Output Functions
   - Convenience API
   - Internal API
-    - Testing
+  - Testing
   - References
   - API Function Reference
 
 
 Overview
@@ -219,14 +219,18 @@ extracted/squeezed from the state and for the state to be cleared.  Note that
 there is no "final" function, per se, but that can be constructed by squeezing
 and clearing.
 
 
 Testing
--------
+=======
 
-The sha3 module does a basic sanity test on initialisation, but there is also a
-kunit test module available.
+To test the SHA-3 code, use sha3_kunit.
+
+Since the SHA-3 algorithms are FIPS-approved, when the kernel is booted in FIPS
+mode the SHA-3 library also performs a simple self-test.  This is purely to meet
+a FIPS requirement.  Normal testing done by kernel developers and integrators
+should use the much more comprehensive KUnit test suite instead.
 
 
 References
 ==========
 
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
index f8167037138c7..83fbfa1169cdb 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -15,10 +15,11 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <crypto/sha3.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
+#include "fips.h"
 
 /*
  * On some 32-bit architectures, such as h8300, GCC ends up using over 1 KB of
  * stack if the round calculation gets inlined into the loop in
  * sha3_keccakf_rounds_generic().  On the other hand, on 64-bit architectures
@@ -442,71 +443,35 @@ void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 	shake256_squeeze(&ctx, out, out_len);
 	shake256_clear(&ctx);
 }
 EXPORT_SYMBOL_GPL(shake256);
 
-/*
- * Do a quick test using SHAKE256 and a 200 byte digest.
- */
-static const u8 sha3_sample[] __initconst =
-	"The quick red fox jumped over the lazy brown dog!\n"
-	"The quick red fox jumped over the lazy brown dog!\n"
-	"The quick red fox jumped over the lazy brown dog!\n"
-	"The quick red fox jumped over the lazy brown dog!\n";
-
-static const u8 sha3_sample_shake256_200[] __initconst = {
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-before guard */
-	0xab, 0x06, 0xd4, 0xf9, 0x8b, 0xfd, 0xb2, 0xc4, 0xfe, 0xf1, 0xcc, 0xe2,
-	0x40, 0x45, 0xdd, 0x15, 0xcb, 0xdd, 0x02, 0x8d, 0xb7, 0x9f, 0x1e, 0x67,
-	0xd6, 0x7f, 0x98, 0x5e, 0x1b, 0x19, 0xf8, 0x01, 0x43, 0x82, 0xcb, 0xd8,
-	0x5d, 0x21, 0x64, 0xa8, 0x80, 0xc9, 0x22, 0xe5, 0x07, 0xaf, 0xe2, 0x5d,
-	0xcd, 0xc6, 0x23, 0x36, 0x2b, 0xc7, 0xc7, 0x7d, 0x09, 0x9d, 0x68, 0x05,
-	0xe4, 0x62, 0x63, 0x1b, 0x67, 0xbc, 0xf8, 0x95, 0x07, 0xd2, 0xe4, 0xd0,
-	0xba, 0xa2, 0x67, 0xf5, 0xe3, 0x15, 0xbc, 0x85, 0xa1, 0x50, 0xd6, 0x6f,
-	0x6f, 0xd4, 0x54, 0x4c, 0x3f, 0x4f, 0xe5, 0x1f, 0xb7, 0x00, 0x27, 0xfc,
-	0x15, 0x33, 0xc2, 0xf9, 0xb3, 0x4b, 0x9e, 0x81, 0xe5, 0x96, 0xbe, 0x05,
-	0x6c, 0xac, 0xf9, 0x9f, 0x65, 0x36, 0xbb, 0x11, 0x47, 0x6d, 0xf6, 0x8f,
-	0x9f, 0xa2, 0x77, 0x37, 0x3b, 0x18, 0x77, 0xcf, 0x65, 0xc5, 0xa1, 0x7e,
-	0x2c, 0x0e, 0x71, 0xf0, 0x4d, 0x18, 0x67, 0xb9, 0xc4, 0x8c, 0x64, 0x3b,
-	0x4b, 0x45, 0xea, 0x16, 0xb2, 0x4a, 0xc5, 0xf5, 0x85, 0xdc, 0xd2, 0xd9,
-	0x13, 0x77, 0xb3, 0x19, 0xd9, 0x8c, 0x9f, 0x28, 0xe7, 0x64, 0x91, 0x0f,
-	0x6f, 0x32, 0xbf, 0xa8, 0xa8, 0xa3, 0xff, 0x99, 0x0e, 0x0b, 0x62, 0x50,
-	0xf8, 0x3a, 0xc2, 0xf5, 0x98, 0x21, 0xeb, 0x9d, 0xe8, 0x45, 0xf4, 0x46,
-	0x1e, 0x8b, 0xbd, 0x10, 0x59, 0x2c, 0x87, 0xe2,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* Write-after guard */
-};
-
+#if defined(sha3_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha3_mod_init(void)
 {
-#define out_len 200
-	u8 out[8 + out_len + 8] = {};
-
 #ifdef sha3_mod_init_arch
 	sha3_mod_init_arch();
 #endif
-
-	BUILD_BUG_ON(sizeof(out) != sizeof(sha3_sample_shake256_200));
-
-	shake256(sha3_sample, sizeof(sha3_sample) - 1, out + 8, out_len);
-
-	if (memcmp(out, sha3_sample_shake256_200,
-		   sizeof(sha3_sample_shake256_200)) != 0) {
-		pr_err("SHAKE256(200) failed\n");
-		for (size_t i = 0; i < out_len;) {
-			size_t part = min(out_len - i, 32);
-
-			pr_err("%*phN\n", (int)part, out + i);
-			i += part;
-		}
-		return -EBADMSG;
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
 	}
 	return 0;
 }
 subsys_initcall(sha3_mod_init);
 
 static void __exit sha3_mod_exit(void)
 {
 }
 module_exit(sha3_mod_exit);
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-3 Secure Hash Algorithm");
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

