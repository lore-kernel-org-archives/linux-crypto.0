Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D34C433E3
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 16:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B6A21741
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 16:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgGSQuK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSQuK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 12:50:10 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B4C0619D2;
        Sun, 19 Jul 2020 09:50:09 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 36742BC064;
        Sun, 19 Jul 2020 16:50:06 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
        linux@armlinux.org.uk, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] crypto: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 18:49:59 +0200
Message-Id: <20200719164959.60308-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 Documentation/crypto/api-intro.txt    |  4 +--
 Documentation/crypto/userspace-if.rst |  4 +--
 arch/arm/crypto/crc32-ce-core.S       |  2 +-
 arch/arm/crypto/sha1-armv4-large.S    |  2 +-
 arch/arm/crypto/sha256-armv4.pl       |  2 +-
 arch/arm/crypto/sha256-core.S_shipped |  2 +-
 arch/arm/crypto/sha512-armv4.pl       |  4 +--
 arch/arm/crypto/sha512-core.S_shipped |  4 +--
 crypto/Kconfig                        | 46 +++++++++++++--------------
 crypto/blake2b_generic.c              |  2 +-
 crypto/camellia_generic.c             |  2 +-
 crypto/ecc.c                          |  2 +-
 crypto/jitterentropy.c                |  4 +--
 crypto/lrw.c                          |  2 +-
 crypto/salsa20_generic.c              |  4 +--
 crypto/sha3_generic.c                 |  2 +-
 16 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 45d943fcae5b..48ff83e8aec6 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -169,7 +169,7 @@ Portions of this API were derived from the following projects:
 
 and;
   
-  Nettle (http://www.lysator.liu.se/~nisse/nettle/)
+  Nettle (https://www.lysator.liu.se/~nisse/nettle/)
     Niels Möller
 
 Original developers of the crypto algorithms:
diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index ff86befa61e0..52019e905900 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -23,7 +23,7 @@ user space, however. This includes the difference between synchronous
 and asynchronous invocations. The user space API call is fully
 synchronous.
 
-[1] http://www.chronox.de/libkcapi.html
+[1] https://www.chronox.de/libkcapi.html
 
 User Space API General Remarks
 ------------------------------
@@ -384,4 +384,4 @@ Please see [1] for libkcapi which provides an easy-to-use wrapper around
 the aforementioned Netlink kernel interface. [1] also contains a test
 application that invokes all libkcapi API calls.
 
-[1] http://www.chronox.de/libkcapi.html
+[1] https://www.chronox.de/libkcapi.html
diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
index 5cbd4a6fedad..3f13a76b9066 100644
--- a/arch/arm/crypto/crc32-ce-core.S
+++ b/arch/arm/crypto/crc32-ce-core.S
@@ -39,7 +39,7 @@
  * CRC32 polynomial:0x04c11db7(BE)/0xEDB88320(LE)
  * PCLMULQDQ is a new instruction in Intel SSE4.2, the reference can be found
  * at:
- * http://www.intel.com/products/processor/manuals/
+ * https://www.intel.com/products/processor/manuals/
  * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
  * Volume 2B: Instruction Set Reference, N-Z
  *
diff --git a/arch/arm/crypto/sha1-armv4-large.S b/arch/arm/crypto/sha1-armv4-large.S
index f82cd8cf5a09..1c8b685149f2 100644
--- a/arch/arm/crypto/sha1-armv4-large.S
+++ b/arch/arm/crypto/sha1-armv4-large.S
@@ -13,7 +13,7 @@
 @ Written by Andy Polyakov <appro@fy.chalmers.se> for the OpenSSL
 @ project. The module is, however, dual licensed under OpenSSL and
 @ CRYPTOGAMS licenses depending on where you obtain it. For further
-@ details see http://www.openssl.org/~appro/cryptogams/.
+@ details see https://www.openssl.org/~appro/cryptogams/.
 @ ====================================================================
 
 @ sha1_block procedure for ARMv4.
diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
index a03cf4dfb781..9f96ff48e4a8 100644
--- a/arch/arm/crypto/sha256-armv4.pl
+++ b/arch/arm/crypto/sha256-armv4.pl
@@ -13,7 +13,7 @@
 # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 # project. The module is, however, dual licensed under OpenSSL and
 # CRYPTOGAMS licenses depending on where you obtain it. For further
-# details see http://www.openssl.org/~appro/cryptogams/.
+# details see https://www.openssl.org/~appro/cryptogams/.
 # ====================================================================
 
 # SHA256 block procedure for ARMv4. May 2007.
diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
index 054aae0edfce..ea04b2ab0c33 100644
--- a/arch/arm/crypto/sha256-core.S_shipped
+++ b/arch/arm/crypto/sha256-core.S_shipped
@@ -12,7 +12,7 @@
 @ Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 @ project. The module is, however, dual licensed under OpenSSL and
 @ CRYPTOGAMS licenses depending on where you obtain it. For further
-@ details see http://www.openssl.org/~appro/cryptogams/.
+@ details see https://www.openssl.org/~appro/cryptogams/.
 @ ====================================================================
 
 @ SHA256 block procedure for ARMv4. May 2007.
diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
index 788c17b56ecc..69df68981acd 100644
--- a/arch/arm/crypto/sha512-armv4.pl
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -13,7 +13,7 @@
 # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 # project. The module is, however, dual licensed under OpenSSL and
 # CRYPTOGAMS licenses depending on where you obtain it. For further
-# details see http://www.openssl.org/~appro/cryptogams/.
+# details see https://www.openssl.org/~appro/cryptogams/.
 # ====================================================================
 
 # SHA512 block procedure for ARMv4. September 2007.
@@ -43,7 +43,7 @@
 # terms it's 22.6 cycles per byte, which is disappointing result.
 # Technical writers asserted that 3-way S4 pipeline can sustain
 # multiple NEON instructions per cycle, but dual NEON issue could
-# not be observed, see http://www.openssl.org/~appro/Snapdragon-S4.html
+# not be observed, see https://www.openssl.org/~appro/Snapdragon-S4.html
 # for further details. On side note Cortex-A15 processes one byte in
 # 16 cycles.
 
diff --git a/arch/arm/crypto/sha512-core.S_shipped b/arch/arm/crypto/sha512-core.S_shipped
index 710ea309769e..cb147db5cbfe 100644
--- a/arch/arm/crypto/sha512-core.S_shipped
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -12,7 +12,7 @@
 @ Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 @ project. The module is, however, dual licensed under OpenSSL and
 @ CRYPTOGAMS licenses depending on where you obtain it. For further
-@ details see http://www.openssl.org/~appro/cryptogams/.
+@ details see https://www.openssl.org/~appro/cryptogams/.
 @ ====================================================================
 
 @ SHA512 block procedure for ARMv4. September 2007.
@@ -42,7 +42,7 @@
 @ terms it's 22.6 cycles per byte, which is disappointing result.
 @ Technical writers asserted that 3-way S4 pipeline can sustain
 @ multiple NEON instructions per cycle, but dual NEON issue could
-@ not be observed, see http://www.openssl.org/~appro/Snapdragon-S4.html
+@ not be observed, see https://www.openssl.org/~appro/Snapdragon-S4.html
 @ for further details. On side note Cortex-A15 processes one byte in
 @ 16 cycles.
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 091c0a0bbf26..1b57419fa2e7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -548,7 +548,7 @@ config CRYPTO_XCBC
 	select CRYPTO_MANAGER
 	help
 	  XCBC: Keyed-Hashing with encryption algorithm
-		http://www.ietf.org/rfc/rfc3566.txt
+		https://www.ietf.org/rfc/rfc3566.txt
 		http://csrc.nist.gov/encryption/modes/proposedmodes/
 		 xcbc-mac/xcbc-mac-spec.pdf
 
@@ -561,7 +561,7 @@ config CRYPTO_VMAC
 	  very high speed on 64-bit architectures.
 
 	  See also:
-	  <http://fastcrypto.org/vmac>
+	  <https://fastcrypto.org/vmac>
 
 comment "Digest"
 
@@ -816,7 +816,7 @@ config CRYPTO_RMD128
 	  RIPEMD-160 should be used.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD160
 	tristate "RIPEMD-160 digest algorithm"
@@ -833,7 +833,7 @@ config CRYPTO_RMD160
 	  against RIPEMD-160.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD256
 	tristate "RIPEMD-256 digest algorithm"
@@ -845,7 +845,7 @@ config CRYPTO_RMD256
 	  (than RIPEMD-128).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD320
 	tristate "RIPEMD-320 digest algorithm"
@@ -857,7 +857,7 @@ config CRYPTO_RMD320
 	  (than RIPEMD-160).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <https://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
@@ -1045,7 +1045,7 @@ config CRYPTO_TGR192
 	  Tiger was developed by Ross Anderson and Eli Biham.
 
 	  See also:
-	  <http://www.cs.technion.ac.il/~biham/Reports/Tiger/>.
+	  <https://www.cs.technion.ac.il/~biham/Reports/Tiger/>.
 
 config CRYPTO_WP512
 	tristate "Whirlpool digest algorithms"
@@ -1221,7 +1221,7 @@ config CRYPTO_BLOWFISH
 	  designed for use on "large microprocessors".
 
 	  See also:
-	  <http://www.schneier.com/blowfish.html>
+	  <https://www.schneier.com/blowfish.html>
 
 config CRYPTO_BLOWFISH_COMMON
 	tristate
@@ -1230,7 +1230,7 @@ config CRYPTO_BLOWFISH_COMMON
 	  generic c and the assembler implementations.
 
 	  See also:
-	  <http://www.schneier.com/blowfish.html>
+	  <https://www.schneier.com/blowfish.html>
 
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Blowfish cipher algorithm (x86_64)"
@@ -1245,7 +1245,7 @@ config CRYPTO_BLOWFISH_X86_64
 	  designed for use on "large microprocessors".
 
 	  See also:
-	  <http://www.schneier.com/blowfish.html>
+	  <https://www.schneier.com/blowfish.html>
 
 config CRYPTO_CAMELLIA
 	tristate "Camellia cipher algorithms"
@@ -1441,10 +1441,10 @@ config CRYPTO_SALSA20
 	  Salsa20 stream cipher algorithm.
 
 	  Salsa20 is a stream cipher submitted to eSTREAM, the ECRYPT
-	  Stream Cipher Project. See <http://www.ecrypt.eu.org/stream/>
+	  Stream Cipher Project. See <https://www.ecrypt.eu.org/stream/>
 
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
-	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
+	  Bernstein <djb@cr.yp.to>. See <https://cr.yp.to/snuffle.html>
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha stream cipher algorithms"
@@ -1456,7 +1456,7 @@ config CRYPTO_CHACHA20
 	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
 	  Bernstein and further specified in RFC7539 for use in IETF protocols.
 	  This is the portable C implementation of ChaCha20.  See also:
-	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
+	  <https://cr.yp.to/chacha/chacha-20080128.pdf>
 
 	  XChaCha20 is the application of the XSalsa20 construction to ChaCha20
 	  rather than to Salsa20.  XChaCha20 extends ChaCha20's nonce length
@@ -1509,7 +1509,7 @@ config CRYPTO_SERPENT
 	  variant of Serpent for compatibility with old kerneli.org code.
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SERPENT_SSE2_X86_64
 	tristate "Serpent cipher algorithm (x86_64/SSE2)"
@@ -1528,7 +1528,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	  blocks parallel using SSE2 instruction set.
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SERPENT_SSE2_586
 	tristate "Serpent cipher algorithm (i586/SSE2)"
@@ -1547,7 +1547,7 @@ config CRYPTO_SERPENT_SSE2_586
 	  blocks parallel using SSE2 instruction set.
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SERPENT_AVX_X86_64
 	tristate "Serpent cipher algorithm (x86_64/AVX)"
@@ -1567,7 +1567,7 @@ config CRYPTO_SERPENT_AVX_X86_64
 	  eight blocks parallel using the AVX instruction set.
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SERPENT_AVX2_X86_64
 	tristate "Serpent cipher algorithm (x86_64/AVX2)"
@@ -1583,7 +1583,7 @@ config CRYPTO_SERPENT_AVX2_X86_64
 	  blocks parallel using AVX2 instruction set.
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
 
 config CRYPTO_SM4
 	tristate "SM4 cipher algorithm"
@@ -1640,7 +1640,7 @@ config CRYPTO_TWOFISH
 	  bits.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <https://www.schneier.com/twofish.html>
 
 config CRYPTO_TWOFISH_COMMON
 	tristate
@@ -1662,7 +1662,7 @@ config CRYPTO_TWOFISH_586
 	  bits.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <https://www.schneier.com/twofish.html>
 
 config CRYPTO_TWOFISH_X86_64
 	tristate "Twofish cipher algorithm (x86_64)"
@@ -1678,7 +1678,7 @@ config CRYPTO_TWOFISH_X86_64
 	  bits.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <https://www.schneier.com/twofish.html>
 
 config CRYPTO_TWOFISH_X86_64_3WAY
 	tristate "Twofish cipher algorithm (x86_64, 3-way parallel)"
@@ -1699,7 +1699,7 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 	  blocks parallel, utilizing resources of out-of-order CPUs better.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <https://www.schneier.com/twofish.html>
 
 config CRYPTO_TWOFISH_AVX_X86_64
 	tristate "Twofish cipher algorithm (x86_64/AVX)"
@@ -1722,7 +1722,7 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	  eight blocks parallel using the AVX Instruction Set.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <https://www.schneier.com/twofish.html>
 
 comment "Compression"
 
diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 0ffd8d92e308..a2ffe60e06d3 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -8,7 +8,7 @@
  *
  * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
  * - OpenSSL license   : https://www.openssl.org/source/license.html
- * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
+ * - Apache 2.0        : https://www.apache.org/licenses/LICENSE-2.0
  *
  * More information about the BLAKE2 hash function can be found at
  * https://blake2.net.
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 9a5783e5196a..0b9f409f7370 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -6,7 +6,7 @@
 
 /*
  * Algorithm Specification
- *  http://info.isl.ntt.co.jp/crypt/eng/camellia/specifications.html
+ *  https://info.isl.ntt.co.jp/crypt/eng/camellia/specifications.html
  */
 
 /*
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 02d35be7702b..86c324936a2b 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -940,7 +940,7 @@ static bool ecc_point_is_zero(const struct ecc_point *point)
 }
 
 /* Point multiplication algorithm using Montgomery's ladder with co-Z
- * coordinates. From http://eprint.iacr.org/2011/338.pdf
+ * coordinates. From https://eprint.iacr.org/2011/338.pdf
  */
 
 /* Double in place */
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 57f4a1ac738b..6e147c43fc18 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -7,7 +7,7 @@
  * Design
  * ======
  *
- * See http://www.chronox.de/jent.html
+ * See https://www.chronox.de/jent.html
  *
  * License
  * =======
@@ -47,7 +47,7 @@
 
 /*
  * This Jitterentropy RNG is based on the jitterentropy library
- * version 2.2.0 provided at http://www.chronox.de/jent.html
+ * version 2.2.0 provided at https://www.chronox.de/jent.html
  */
 
 #ifdef __OPTIMIZE__
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 5b07a7c09296..b0ee65445aaf 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -9,7 +9,7 @@
  */
 /* This implementation is checked against the test vectors in the above
  * document and by a test vector provided by Ken Buchanan at
- * http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html
+ * https://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html
  *
  * The test vectors are included in the testing module tcrypt.[ch] */
 
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index c81a44404086..3418869dabef 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -9,8 +9,8 @@
  * Salsa20 is a stream cipher candidate in eSTREAM, the ECRYPT Stream
  * Cipher Project. It is designed by Daniel J. Bernstein <djb@cr.yp.to>.
  * More information about eSTREAM and Salsa20 can be found here:
- *   http://www.ecrypt.eu.org/stream/
- *   http://cr.yp.to/snuffle.html
+ *   https://www.ecrypt.eu.org/stream/
+ *   https://cr.yp.to/snuffle.html
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 44e263e25599..3e4069935b53 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -3,7 +3,7 @@
  * Cryptographic API.
  *
  * SHA-3, as specified in
- * http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
+ * https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
  *
  * SHA-3 code by Jeff Garzik <jeff@garzik.org>
  *               Ard Biesheuvel <ard.biesheuvel@linaro.org>
-- 
2.27.0

