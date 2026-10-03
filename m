Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5D7485515;
	Sat,  3 Oct 2026 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791044964; cv=none; b=f0c7A9kAJHbU6/0+tipCedmr8ciA60cdYhUZJ2mdEuJtGytP++AR6gF2FJ08/zU5kN5zGWh+mm5aD+ZDuf4chvglcDA9YHTK1DYknbtLsD+jAoff6QGCZJCgz2f5SPMctE+m0X2wymrrHxxBQMBBlZFCaAYA6zOkNzUebUmlD7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791044964; c=relaxed/simple;
	bh=NwM74oRXrPpti1G7Y2pyZK/qCEPbjPiylIVFE0vYADU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l27ERYxHaX2H+gtjT8WLx5YOQ9Wq0UZ4XBMD7Wy8eLQGuvFeiuvj+Dv7foQMVoJo4ac0BkoXHuK+wooGOCavOE7W+SGhe8SyWtKlfqGcRORlivJ47P2zksJ7oO3LKSdjLVIB0boamxRkegkOPOK+s1CI1+RrF8I5QSyuoKvbjdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoPe6oe0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoPe6oe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC32A1F0089B;
	Sat,  3 Oct 2026 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791044962;
	bh=8G2+e0Us6mjX1OgDT9B9dMGeP6uvZKD2lijXaK951XE=;
	h=From:To:Cc:Subject:Date;
	b=YoPe6oe0KQ3fBRDP0mieDIEASTPFtgUJlLrFOfRboBzJgZ+uRAk9Y3T0Je6SJagzN
	 HSCxBiAe2WV3/1LulmqVYpvM/eKnvmNfSW9lb30x4K/SyQheahp9Yy/GdsjQUgkLVm
	 IAWZYG4Ayi7cyjHpiUVA+CtOqKL2YQkqBCj3fKqXwxf+/N13ZOfY1ZLYVLBk9WgyNv
	 xTYQP81rvsBOft2zVqBBCIeTxctVVCRp11PZRNgJUbmN1eetd9JBny5HzPqvqiD8ZJ
	 7hIQDQghlY52ndkML96Ak6cnPxiU4eVd4El0Ot0Ell5cN488UnHKpmk5PASLU7oAH1
	 LkRID6HtEWztw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib: Move SipHash into lib/crypto/
Date: Sat,  3 Oct 2026 18:28:27 +0200
Message-ID: <20261003162827.155527-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The addition of SipHash to lib/ predated the existence of the
lib/crypto/ directory.  Since SipHash is a cryptographic algorithm, move
it from the top-level lib/ directory to lib/crypto/.

(This does mean HalfSipHash comes with it too, as it's in the same
files.  But lib/crypto/ still seems like the proper place for both.)

Specifically:

- Move both siphash.c and siphash_kunit.c.  Keep the header
  <linux/siphash.h> as-is for now.

- Drop the dedicated MAINTAINERS entry for SipHash, as per the
  suggestion from Jason
  (https://lore.kernel.org/r/asB7QVFMlgKgbje2@zx2c4.com/).  The C files
  now just fold up to the "CRYPTO LIBRARY" entry.  Add the header
  explicitly, as it otherwise would be left unmaintained.

- Move the kconfig option that controls the KUnit test.  Put
  "CRYPTO_LIB" in its name and update the prompt and help text to make
  it consistent with the other crypto library test options.

- Enable the KUnit test in lib/crypto/.kunitconfig.

- Link to siphash.rst from the appropriate place in libcrypto-hash.rst.

- Use obj-y instead of lib-y, for consistency with the fact that
  currently lib/crypto/ doesn't use kbuild's support for library file
  goals.  We could keep it as lib-y, but virtually every kernel needs
  SipHash support anyway (with vsprintf, printk, IPv4, IPv6, etc.
  depending on it) so there is no practical difference in this case.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

v2: 
   - Dropped the MAINTAINERS entry entirely
   - Noted the consideration of HalfSipHash in the commit message
   - Added Acked-by's
   - Moved siphash.o line to proper alphabetic order and added a comment
     similar to the blake2s.o one
   - Tweaked the actual help text for the test kconfig entry as well, to
     be consistent with the other options in the same menu

 Documentation/crypto/libcrypto-hash.rst          |  5 +++++
 MAINTAINERS                                      |  8 +-------
 lib/Kconfig.debug                                | 11 -----------
 lib/Makefile                                     |  2 +-
 lib/crypto/.kunitconfig                          |  1 +
 lib/crypto/Makefile                              |  6 ++++++
 lib/{ => crypto}/siphash.c                       |  0
 lib/crypto/tests/Kconfig                         |  9 +++++++++
 lib/crypto/tests/Makefile                        |  1 +
 lib/{ => crypto}/tests/siphash_kunit.c           |  0
 lib/tests/Makefile                               |  1 -
 tools/testing/selftests/bpf/progs/test_siphash.h |  2 +-
 12 files changed, 25 insertions(+), 21 deletions(-)
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
index 9dc69113f47a..f4d49df0774b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6980,6 +6980,7 @@ S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
 F:	Documentation/crypto/libcrypto*
+F:	include/linux/siphash.h
 F:	lib/crypto/
 F:	scripts/crypto/
 
@@ -25113,13 +25114,6 @@ F:	drivers/gpio/gpio-siox.c
 F:	drivers/siox/*
 F:	include/trace/events/siox.h
 
-SIPHASH PRF ROUTINES
-M:	Jason A. Donenfeld <Jason@zx2c4.com>
-S:	Maintained
-F:	include/linux/siphash.h
-F:	lib/siphash.c
-F:	lib/tests/siphash_kunit.c
-
 SIS 190 ETHERNET DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
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
index d683b8520f55..832d170cab94 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -376,6 +376,12 @@ endif # CONFIG_CRYPTO_LIB_SHA3_ARCH
 
 ################################################################################
 
+# SipHash support is always built-in because it's used by core components such
+# as printk (for pointer hashing) and networking.
+obj-y += siphash.o
+
+################################################################################
+
 obj-$(CONFIG_CRYPTO_LIB_SM3) += libsm3.o
 libsm3-y := sm3.o
 ifeq ($(CONFIG_CRYPTO_LIB_SM3_ARCH),y)
diff --git a/lib/siphash.c b/lib/crypto/siphash.c
similarity index 100%
rename from lib/siphash.c
rename to lib/crypto/siphash.c
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index e121114624da..67026ef1e8f6 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -151,6 +151,15 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.
 
+config CRYPTO_LIB_SIPHASH_KUNIT_TEST
+	tristate "KUnit tests for SipHash" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	# SipHash support is always built-in, so there's no kconfig option for
+	# it that needs to be depended on here.
+	help
+	  KUnit tests for the SipHash cryptographically secure PRF.
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

base-commit: da4d5933e30340766925480f9dd9f250c4355e24
-- 
2.56.0

