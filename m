Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BA4968EC;
	Fri,  2 Oct 2026 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980703; cv=none; b=OF/4utcJsSFRUsH5ZoZDq9D4ko1O6G4GkA9YVum1WJkJt75Y/kDQKKGvMmtFhCeR7bGvKG/fVyEd9T3lAzmxcFfTbRfFNtuQQX4AiDRGM/ijf9o8MGQoik7To2cX5PcPUR/xUT2vfj2L+IBHfe72I9FBd3J7iI7x9V0lTnUF8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980703; c=relaxed/simple;
	bh=Bva8BNciURWl8yUW82jFE/8yEgOo6fOKPbDmsbRuR1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVIjQJ+ATT16p76MMr9hM+R52ODwTNuU6Lk0LIremY7LFfOKshfsnv5qDHNtf6pe9TNwz592U5znA+aNskfrf1APnqsr/8q2W0JBeWF4KJf+Xq6gSmEIDoz/BNX4hT0Mf47BxVFMc/wosAbkQPSewI7W+tc/RYfCYpTMXp5++Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWcALDbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWcALDbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7251F00893;
	Fri,  2 Oct 2026 22:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980701;
	bh=yVXvSTZV+wOW3rU7laW2CvI+tv/5A+XeBSRiNm1iWuc=;
	h=From:To:Cc:Subject:Date;
	b=RWcALDbZ2i8JByAnu183ZoyxJYn+VWb+mrwdFdtKsmVegJfQDBOe//zEJLT1+ii+f
	 3sZb1wSpV8fsn7QeaNCEB6Lh/C/4z6cuOyGaxLagM6Vmkyx2/4MCsa38OUmz1iijFp
	 vwY9MgZzzsrHxOskwIQzGghosKSZ271NjDGpLL8wJh7S7R3Hg8TI+89Y8AK3PyNTcF
	 2mziqllAO3m1taB67qR+1SGYXnNUf7omg2A83nhkHSWo2bsAQy7Hp0ysWAl69uR4Sp
	 SzY//k2B1kOqrG43Sw+j+srx0WPo+Layn3nR/ij9Gi19LTQCDCQCcEG3ioXZJW5o5J
	 Nlw/Zmu/zPiyA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib: Move SipHash into lib/crypto/
Date: Fri,  2 Oct 2026 15:37:08 -0700
Message-ID: <20261002223708.39183-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The addition of SipHash to lib/ predated the existence of the
lib/crypto/ directory.  Since it's a cryptographic algorithm, move it
from the top-level lib/ directory to lib/crypto/.

Specifically:

- Move both siphash.c and siphash_kunit.c.  Keep the header
  <linux/siphash.h> as-is for now.

- Keep the dedicated MAINTAINERS entry for SipHash.  Just update the
  file paths it references.

- Move the kconfig option that controls the KUnit test.  Put
  "CRYPTO_LIB" in its name and update the prompt to make it consistent
  with the other crypto library test options.

- Enable the KUnit test in lib/crypto/.kunitconfig.

- Link to siphash.rst from the appropriate place in libcrypto-hash.rst.

- Use obj-y instead of lib-y, for consistency with the fact that
  currently lib/crypto/ doesn't use kbuild's support for library file
  goals.  We could keep it as lib-y, but virtually every kernel needs
  SipHash support anyway (with vsprintf, printk, IPv4, IPv6, etc.
  depending on it) so there is no practical difference in this case.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 Documentation/crypto/libcrypto-hash.rst          |  5 +++++
 MAINTAINERS                                      |  4 ++--
 lib/Kconfig.debug                                | 11 -----------
 lib/Makefile                                     |  2 +-
 lib/crypto/.kunitconfig                          |  1 +
 lib/crypto/Makefile                              |  2 ++
 lib/{ => crypto}/siphash.c                       |  0
 lib/crypto/tests/Kconfig                         | 11 +++++++++++
 lib/crypto/tests/Makefile                        |  1 +
 lib/{ => crypto}/tests/siphash_kunit.c           |  0
 lib/tests/Makefile                               |  1 -
 tools/testing/selftests/bpf/progs/test_siphash.h |  2 +-
 12 files changed, 24 insertions(+), 16 deletions(-)
 rename lib/{ => crypto}/siphash.c (100%)
 rename lib/{ => crypto}/tests/siphash_kunit.c (100%)

diff --git a/Documentation/crypto/libcrypto-hash.rst b/Documentation/crypto/libcrypto-hash.rst
index fa4c54236af6..d1e2d2ff06f4 100644
--- a/Documentation/crypto/libcrypto-hash.rst
+++ b/Documentation/crypto/libcrypto-hash.rst
@@ -80,6 +80,11 @@ SHA-3
 
 The SHA-3 API is documented in :ref:`sha3`.
 
+SipHash
+-------
+
+The SipHash API is documented in Documentation/security/siphash.rst.
+
 SM3
 ---
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 9dc69113f47a..21ab5d531557 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25117,8 +25117,8 @@ SIPHASH PRF ROUTINES
 M:	Jason A. Donenfeld <Jason@zx2c4.com>
 S:	Maintained
 F:	include/linux/siphash.h
-F:	lib/siphash.c
-F:	lib/tests/siphash_kunit.c
+F:	lib/crypto/siphash.c
+F:	lib/crypto/tests/siphash_kunit.c
 
 SIS 190 ETHERNET DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..0f37a552318d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3075,17 +3075,6 @@ config HW_BREAKPOINT_KUNIT_TEST
 
 source "lib/crypto/tests/Kconfig"
 
-config SIPHASH_KUNIT_TEST
-	tristate "Perform selftest on siphash functions" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	default KUNIT_ALL_TESTS
-	help
-	  Enable this option to test the kernel's siphash (<linux/siphash.h>) hash
-	  functions on boot (or module load).
-
-	  This is intended to help people writing architecture-specific
-	  optimized versions.  If unsure, say N.
-
 config USERCOPY_KUNIT_TEST
 	tristate "KUnit Test for user/kernel boundary protections"
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index dfab958327c5..e1eb91d62a30 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -38,7 +38,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 maple_tree.o idr.o extable.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
+	 earlycpio.o seq_buf.o dec_and_lock.o \
 	 nmi_backtrace.o win_minmax.o memcat_p.o \
 	 buildid.o objpool.o iomem_copy.o sys_info.o
 
diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 60e0a77f9889..6f218cd2d0c3 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -19,4 +19,5 @@ CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SIPHASH_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_SM3_KUNIT_TEST=y
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index d683b8520f55..7697a361625c 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -12,6 +12,8 @@ ppc64-perlasm-flavour-y := linux-ppc64
 ppc64-perlasm-flavour-$(CONFIG_PPC64_ELF_ABI_V2) := linux-ppc64-elfv2
 ppc64-perlasm-flavour-$(CONFIG_CPU_LITTLE_ENDIAN) := linux-ppc64le
 
+obj-y += siphash.o
+
 obj-$(CONFIG_KUNIT)				+= tests/
 
 obj-$(CONFIG_CRYPTO_HASH_INFO)			+= hash_info.o
diff --git a/lib/siphash.c b/lib/crypto/siphash.c
similarity index 100%
rename from lib/siphash.c
rename to lib/crypto/siphash.c
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index e121114624da..2971ec1f08b3 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -151,6 +151,17 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.
 
+config CRYPTO_LIB_SIPHASH_KUNIT_TEST
+	tristate "KUnit tests for SipHash" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test the kernel's siphash (<linux/siphash.h>)
+	  hash functions on boot (or module load).
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
+
 config CRYPTO_LIB_SM3_KUNIT_TEST
 	tristate "KUnit tests for SM3" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SM3
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index c97c1d78784a..f639d76a8fb7 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -17,4 +17,5 @@ obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SM3_KUNIT_TEST) += sm3_kunit.o
diff --git a/lib/tests/siphash_kunit.c b/lib/crypto/tests/siphash_kunit.c
similarity index 100%
rename from lib/tests/siphash_kunit.c
rename to lib/crypto/tests/siphash_kunit.c
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 3cac3b63a752..1a3d39db268f 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_PRINTF_KUNIT_TEST) += printf_kunit.o
 obj-$(CONFIG_RANDSTRUCT_KUNIT_TEST) += randstruct_kunit.o
 obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
 obj-$(CONFIG_SEQ_BUF_KUNIT_TEST) += seq_buf_kunit.o
-obj-$(CONFIG_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
diff --git a/tools/testing/selftests/bpf/progs/test_siphash.h b/tools/testing/selftests/bpf/progs/test_siphash.h
index 5d3a7ec36780..9a85670a9dea 100644
--- a/tools/testing/selftests/bpf/progs/test_siphash.h
+++ b/tools/testing/selftests/bpf/progs/test_siphash.h
@@ -22,7 +22,7 @@ static inline u64 rol64(u64 word, unsigned int shift)
 #define SIPHASH_CONST_2 0x6c7967656e657261ULL
 #define SIPHASH_CONST_3 0x7465646279746573ULL
 
-/* lib/siphash.c */
+/* lib/crypto/siphash.c */
 #define SIPROUND SIPHASH_PERMUTATION(v0, v1, v2, v3)
 
 #define PREAMBLE(len) \

base-commit: 9ca77aa621027149c43551308112eba06b1de3af
-- 
2.56.0

