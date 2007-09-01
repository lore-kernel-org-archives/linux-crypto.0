From: Satyam Sharma <satyam@infradead.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Sun, 2 Sep 2007 02:39:15 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709020157580.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070901155353.8a09db69.kamezawa.hiroyu@jp.fujitsu.com>
 <20070831235815.a09c7865.akpm@linux-foundation.org>
 <20070901085429.GA7213@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbXIAU4S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Sep 2007 16:56:18 -0400
In-Reply-To: <20070901085429.GA7213@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Sat, 1 Sep 2007, Herbert Xu wrote:

> On Fri, Aug 31, 2007 at 11:58:15PM -0700, Andrew Morton wrote:
> > 
> > > crypto/built-in.o: In function `update2':
> > > digest.c:(.text+0x94a): undefined reference to `crypto_km_types'
> > > digest.c:(.text+0x9bf): undefined reference to `crypto_km_types'
> > > 
> > > digest.c (CONFIG_CRYPTO) uses crypto/scatterwalk.c's object (CONFIG_CRYPTO_ALGAPI)
> > > I meet this when CONFIG_CRYPTO_ALGAPI=m. I need to make CONFIG_CRYPTO_ALGAPI=y.

Tangential, but I've often wondered what are the upsides of keeping
CONFIG_CRYPTO_ALGAPI as a separate config option in the first place? Every
single item in crypto/ ends up "select"ing it (directly or transitively)
so it makes all sense to just do away with it and keep it == CONFIG_CRYPTO
in the Makefile, thusly:


[PATCH] crypto: Remove CONFIG_CRYPTO_ALGAPI config option

Because all other options in crypto/ end up selecting it anyway. So let's
make it a default part of the rest of "core" crypto stuff, that gets built
whenever CONFIG_CRYPTO == y.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/s390/crypto/Kconfig |    4 ----
 crypto/Kconfig           |   37 -------------------------------------
 crypto/Makefile          |    7 ++-----
 drivers/crypto/Kconfig   |    2 --
 4 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index d1defbb..d35f901 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -1,7 +1,6 @@
 config CRYPTO_SHA1_S390
 	tristate "SHA1 digest algorithm"
 	depends on S390
-	select CRYPTO_ALGAPI
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
@@ -9,7 +8,6 @@ config CRYPTO_SHA1_S390
 config CRYPTO_SHA256_S390
 	tristate "SHA256 digest algorithm"
 	depends on S390
-	select CRYPTO_ALGAPI
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  SHA256 secure hash standard (DFIPS 180-2).
@@ -20,7 +18,6 @@ config CRYPTO_SHA256_S390
 config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms"
 	depends on S390
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This us the s390 hardware accelerated implementation of the
@@ -29,7 +26,6 @@ config CRYPTO_DES_S390
 config CRYPTO_AES_S390
 	tristate "AES cipher algorithms"
 	depends on S390
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This is the s390 hardware accelerated implementation of the
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3d1a1e2..0a52118 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -19,26 +19,18 @@ menuconfig CRYPTO
 
 if CRYPTO
 
-config CRYPTO_ALGAPI
-	tristate
-	help
-	  This option provides the API for cryptographic algorithms.
-
 config CRYPTO_ABLKCIPHER
 	tristate
 	select CRYPTO_BLKCIPHER
 
 config CRYPTO_BLKCIPHER
 	tristate
-	select CRYPTO_ALGAPI
 
 config CRYPTO_HASH
 	tristate
-	select CRYPTO_ALGAPI
 
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
-	select CRYPTO_ALGAPI
 	help
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
@@ -64,31 +56,26 @@ config CRYPTO_XCBC
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  MD4 message digest algorithm (RFC1320).
 
 config CRYPTO_MD5
 	tristate "MD5 digest algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  MD5 message digest algorithm (RFC1321).
 
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
 config CRYPTO_SHA256
 	tristate "SHA256 digest algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  SHA256 secure hash standard (DFIPS 180-2).
 	  
@@ -97,7 +84,6 @@ config CRYPTO_SHA256
 
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  SHA512 secure hash standard (DFIPS 180-2).
 	  
@@ -109,7 +95,6 @@ config CRYPTO_SHA512
 
 config CRYPTO_WP512
 	tristate "Whirlpool digest algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  Whirlpool hash algorithm 512, 384 and 256-bit hashes
 
@@ -121,7 +106,6 @@ config CRYPTO_WP512
 
 config CRYPTO_TGR192
 	tristate "Tiger digest algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  Tiger hash algorithm 192, 160 and 128-bit hashes
 
@@ -194,20 +178,17 @@ config CRYPTO_CRYPTD
 
 config CRYPTO_DES
 	tristate "DES and Triple DES EDE cipher algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
 config CRYPTO_FCRYPT
 	tristate "FCrypt cipher algorithm"
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  FCrypt algorithm used by RxRPC.
 
 config CRYPTO_BLOWFISH
 	tristate "Blowfish cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  Blowfish cipher algorithm, by Bruce Schneier.
 	  
@@ -220,7 +201,6 @@ config CRYPTO_BLOWFISH
 
 config CRYPTO_TWOFISH
 	tristate "Twofish cipher algorithm"
-	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
 	help
 	  Twofish cipher algorithm.
@@ -242,7 +222,6 @@ config CRYPTO_TWOFISH_COMMON
 config CRYPTO_TWOFISH_586
 	tristate "Twofish cipher algorithms (i586)"
 	depends on (X86 || UML_X86) && !64BIT
-	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
 	help
 	  Twofish cipher algorithm.
@@ -258,7 +237,6 @@ config CRYPTO_TWOFISH_586
 config CRYPTO_TWOFISH_X86_64
 	tristate "Twofish cipher algorithm (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
-	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
 	help
 	  Twofish cipher algorithm (x86_64).
@@ -273,7 +251,6 @@ config CRYPTO_TWOFISH_X86_64
 
 config CRYPTO_SERPENT
 	tristate "Serpent cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
 
@@ -286,7 +263,6 @@ config CRYPTO_SERPENT
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
@@ -307,7 +283,6 @@ config CRYPTO_AES
 config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
 	depends on (X86 || UML_X86) && !64BIT
-	select CRYPTO_ALGAPI
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
@@ -328,7 +303,6 @@ config CRYPTO_AES_586
 config CRYPTO_AES_X86_64
 	tristate "AES cipher algorithms (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
-	select CRYPTO_ALGAPI
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
@@ -348,21 +322,18 @@ config CRYPTO_AES_X86_64
 
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  The CAST5 encryption algorithm (synonymous with CAST-128) is
 	  described in RFC2144.
 
 config CRYPTO_CAST6
 	tristate "CAST6 (CAST-256) cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  The CAST6 encryption algorithm (synonymous with CAST-256) is
 	  described in RFC2612.
 
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
-	select CRYPTO_ALGAPI
 	help
 	  TEA cipher algorithm.
 
@@ -379,7 +350,6 @@ config CRYPTO_TEA
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  ARC4 cipher algorithm.
 
@@ -390,7 +360,6 @@ config CRYPTO_ARC4
 
 config CRYPTO_KHAZAD
 	tristate "Khazad cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  Khazad cipher algorithm.
 
@@ -403,7 +372,6 @@ config CRYPTO_KHAZAD
 
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  Anubis cipher algorithm.
 
@@ -418,7 +386,6 @@ config CRYPTO_ANUBIS
 
 config CRYPTO_DEFLATE
 	tristate "Deflate compression algorithm"
-	select CRYPTO_ALGAPI
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	help
@@ -429,7 +396,6 @@ config CRYPTO_DEFLATE
 
 config CRYPTO_MICHAEL_MIC
 	tristate "Michael MIC keyed digest algorithm"
-	select CRYPTO_ALGAPI
 	help
 	  Michael MIC is used for message integrity protection in TKIP
 	  (IEEE 802.11i). This algorithm is required for TKIP, but it
@@ -438,7 +404,6 @@ config CRYPTO_MICHAEL_MIC
 
 config CRYPTO_CRC32C
 	tristate "CRC32c CRC algorithm"
-	select CRYPTO_ALGAPI
 	select LIBCRC32C
 	help
 	  Castagnoli, et al Cyclic Redundancy-Check Algorithm.  Used
@@ -449,7 +414,6 @@ config CRYPTO_CRC32C
 config CRYPTO_CAMELLIA
 	tristate "Camellia cipher algorithms"
 	depends on CRYPTO
-	select CRYPTO_ALGAPI
 	help
 	  Camellia cipher algorithms module.
 
@@ -464,7 +428,6 @@ config CRYPTO_CAMELLIA
 config CRYPTO_TEST
 	tristate "Testing module"
 	depends on m
-	select CRYPTO_ALGAPI
 	help
 	  Quick & dirty crypto test module.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 0cf17f1..a8ea4f6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -2,11 +2,8 @@
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO) += api.o scatterwalk.o cipher.o digest.o compress.o
-
-crypto_algapi-$(CONFIG_PROC_FS) += proc.o
-crypto_algapi-objs := algapi.o $(crypto_algapi-y)
-obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
+obj-$(CONFIG_CRYPTO) += api.o scatterwalk.o cipher.o digest.o compress.o algapi.o
+obj-$(CONFIG_PROC_FS) += proc.o
 
 obj-$(CONFIG_CRYPTO_ABLKCIPHER) += ablkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += blkcipher.o
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c0fc4ae..90f6c6d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -13,7 +13,6 @@ if CRYPTO_HW
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
 	depends on X86_32
-	select CRYPTO_ALGAPI
 	default m
 	help
 	  Some VIA processors come with an integrated crypto engine
@@ -56,7 +55,6 @@ source "arch/s390/crypto/Kconfig"
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
 	depends on X86_32 && PCI
-	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	default m
 	help
