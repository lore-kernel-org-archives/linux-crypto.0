From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC] [crypto] tiny Kconfig cleanup
Date: Fri, 28 Mar 2008 23:36:21 +0100
Message-ID: <20080328223621.GC24018@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33650 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757156AbYC1WgX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Mar 2008 18:36:23 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ciphers, block modes, name it, are grouped together and sorted.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig |  645 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 329 insertions(+), 316 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index edd00c5..864456c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -19,6 +19,8 @@ menuconfig CRYPTO
 
 if CRYPTO
 
+comment "Crypto core or helper"
+
 config CRYPTO_ALGAPI
 	tristate
 	help
@@ -32,15 +34,6 @@ config CRYPTO_BLKCIPHER
 	tristate
 	select CRYPTO_ALGAPI
 
-config CRYPTO_SEQIV
-	tristate "Sequence Number IV Generator"
-	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
-	help
-	  This IV generator generates an IV based on a sequence number by
-	  xoring it with a salt.  This algorithm is mainly useful for CTR
-	  and similar modes.
-
 config CRYPTO_HASH
 	tristate
 	select CRYPTO_ALGAPI
@@ -52,24 +45,15 @@ config CRYPTO_MANAGER
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
 
-config CRYPTO_HMAC
-	tristate "HMAC support"
-	select CRYPTO_HASH
-	select CRYPTO_MANAGER
-	help
-	  HMAC: Keyed-Hashing for Message Authentication (RFC2104).
-	  This is required for IPSec.
-
-config CRYPTO_XCBC
-	tristate "XCBC support"
+config CRYPTO_GF128MUL
+	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	select CRYPTO_HASH
-	select CRYPTO_MANAGER
 	help
-	  XCBC: Keyed-Hashing with encryption algorithm
-		http://www.ietf.org/rfc/rfc3566.txt
-		http://csrc.nist.gov/encryption/modes/proposedmodes/
-		 xcbc-mac/xcbc-mac-spec.pdf
+	  Efficient table driven implementation of multiplications in the
+	  field GF(2^128).  This is needed by some cypher modes. This
+	  option will be selected automatically if you select such a
+	  cipher mode.  Only select this option by hand if you expect to load
+	  an external module that requires these functions.
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
@@ -78,107 +62,98 @@ config CRYPTO_NULL
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
-config CRYPTO_MD4
-	tristate "MD4 digest algorithm"
-	select CRYPTO_ALGAPI
+config CRYPTO_CRYPTD
+	tristate "Software async crypto daemon"
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
 	help
-	  MD4 message digest algorithm (RFC1320).
+	  This is a generic software asynchronous crypto daemon that
+	  converts an arbitrary synchronous software crypto algorithm
+	  into an asynchronous algorithm that executes in a kernel thread.
 
-config CRYPTO_MD5
-	tristate "MD5 digest algorithm"
-	select CRYPTO_ALGAPI
+config CRYPTO_AUTHENC
+	tristate "Authenc support"
+	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
+	select CRYPTO_HASH
 	help
-	  MD5 message digest algorithm (RFC1321).
+	  Authenc: Combined mode wrapper for IPsec.
+	  This is required for IPSec.
 
-config CRYPTO_SHA1
-	tristate "SHA1 digest algorithm"
+config CRYPTO_TEST
+	tristate "Testing module"
+	depends on m
 	select CRYPTO_ALGAPI
+	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
 	help
-	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
+	  Quick & dirty crypto test module.
 
-config CRYPTO_SHA256
-	tristate "SHA224 and SHA256 digest algorithm"
-	select CRYPTO_ALGAPI
-	help
-	  SHA256 secure hash standard (DFIPS 180-2).
-	  
-	  This version of SHA implements a 256 bit hash with 128 bits of
-	  security against collision attacks.
+comment "Authenticated Encryption with Associated Data"
 
-          This code also includes SHA-224, a 224 bit hash with 112 bits
-          of security against collision attacks.
-
-config CRYPTO_SHA512
-	tristate "SHA384 and SHA512 digest algorithms"
-	select CRYPTO_ALGAPI
+config CRYPTO_CCM
+	tristate "CCM support"
+	select CRYPTO_CTR
+	select CRYPTO_AEAD
 	help
-	  SHA512 secure hash standard (DFIPS 180-2).
-	  
-	  This version of SHA implements a 512 bit hash with 256 bits of
-	  security against collision attacks.
-
-	  This code also includes SHA-384, a 384 bit hash with 192 bits
-	  of security against collision attacks.
+	  Support for Counter with CBC MAC. Required for IPsec.
 
-config CRYPTO_WP512
-	tristate "Whirlpool digest algorithms"
-	select CRYPTO_ALGAPI
+config CRYPTO_GCM
+	tristate "GCM/GMAC support"
+	select CRYPTO_CTR
+	select CRYPTO_AEAD
+	select CRYPTO_GF128MUL
 	help
-	  Whirlpool hash algorithm 512, 384 and 256-bit hashes
-
-	  Whirlpool-512 is part of the NESSIE cryptographic primitives.
-	  Whirlpool will be part of the ISO/IEC 10118-3:2003(E) standard
-
-	  See also:
-	  <http://planeta.terra.com.br/informatica/paulobarreto/WhirlpoolPage.html>
+	  Support for Galois/Counter Mode (GCM) and Galois Message
+	  Authentication Code (GMAC). Required for IPSec.
 
-config CRYPTO_TGR192
-	tristate "Tiger digest algorithms"
-	select CRYPTO_ALGAPI
+config CRYPTO_SEQIV
+	tristate "Sequence Number IV Generator"
+	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
 	help
-	  Tiger hash algorithm 192, 160 and 128-bit hashes
-
-	  Tiger is a hash function optimized for 64-bit processors while
-	  still having decent performance on 32-bit processors.
-	  Tiger was developed by Ross Anderson and Eli Biham.
+	  This IV generator generates an IV based on a sequence number by
+	  xoring it with a salt.  This algorithm is mainly useful for CTR
 
-	  See also:
-	  <http://www.cs.technion.ac.il/~biham/Reports/Tiger/>.
+comment "Block modes"
 
-config CRYPTO_GF128MUL
-	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  Efficient table driven implementation of multiplications in the
-	  field GF(2^128).  This is needed by some cypher modes. This
-	  option will be selected automatically if you select such a
-	  cipher mode.  Only select this option by hand if you expect to load
-	  an external module that requires these functions.
-
-config CRYPTO_ECB
-	tristate "ECB support"
+config CRYPTO_CBC
+	tristate "CBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	help
-	  ECB: Electronic CodeBook mode
-	  This is the simplest block cipher algorithm.  It simply encrypts
-	  the input block by block.
+	  CBC: Cipher Block Chaining mode
+	  This block cipher algorithm is required for IPSec.
 
-config CRYPTO_CBC
-	tristate "CBC support"
+config CRYPTO_CTR
+	tristate "CTR support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_SEQIV
 	select CRYPTO_MANAGER
 	help
-	  CBC: Cipher Block Chaining mode
+	  CTR: Counter mode
 	  This block cipher algorithm is required for IPSec.
 
-config CRYPTO_PCBC
-	tristate "PCBC support"
+config CRYPTO_CTS
+	tristate "CTS support"
+	select CRYPTO_BLKCIPHER
+	help
+	  CTS: Cipher Text Stealing
+	  This is the Cipher Text Stealing mode as described by
+	  Section 8 of rfc2040 and referenced by rfc3962.
+	  (rfc3962 includes errata information in its Appendix A)
+	  This mode is required for Kerberos gss mechanism support
+	  for AES encryption.
+
+config CRYPTO_ECB
+	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	help
-	  PCBC: Propagating Cipher Block Chaining mode
-	  This block cipher algorithm is required for RxRPC.
+	  ECB: Electronic CodeBook mode
+	  This is the simplest block cipher algorithm.  It simply encrypts
+	  the input block by block.
 
 config CRYPTO_LRW
 	tristate "LRW support (EXPERIMENTAL)"
@@ -193,6 +168,14 @@ config CRYPTO_LRW
 	  The first 128, 192 or 256 bits in the key are used for AES and the
 	  rest is used to tie each cipher block to its logical position.
 
+config CRYPTO_PCBC
+	tristate "PCBC support"
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
+	help
+	  PCBC: Propagating Cipher Block Chaining mode
+	  This block cipher algorithm is required for RxRPC.
+
 config CRYPTO_XTS
 	tristate "XTS support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -204,160 +187,134 @@ config CRYPTO_XTS
 	  key size 256, 384 or 512 bits. This implementation currently
 	  can't handle a sectorsize which is not a multiple of 16 bytes.
 
-config CRYPTO_CTR
-	tristate "CTR support"
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_SEQIV
+comment "Hash modes"
+
+config CRYPTO_HMAC
+	tristate "HMAC support"
+	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
-	  CTR: Counter mode
-	  This block cipher algorithm is required for IPSec.
+	  HMAC: Keyed-Hashing for Message Authentication (RFC2104).
+	  This is required for IPSec.
 
-config CRYPTO_CTS
-	tristate "CTS support"
-	select CRYPTO_BLKCIPHER
+config CRYPTO_XCBC
+	tristate "XCBC support"
+	depends on EXPERIMENTAL
+	select CRYPTO_HASH
+	select CRYPTO_MANAGER
 	help
-	  CTS: Cipher Text Stealing
-	  This is the Cipher Text Stealing mode as described by
-	  Section 8 of rfc2040 and referenced by rfc3962.
-	  (rfc3962 includes errata information in its Appendix A)
-	  This mode is required for Kerberos gss mechanism support
-	  for AES encryption.
+	  XCBC: Keyed-Hashing with encryption algorithm
+		http://www.ietf.org/rfc/rfc3566.txt
+		http://csrc.nist.gov/encryption/modes/proposedmodes/
+		 xcbc-mac/xcbc-mac-spec.pdf
 
-config CRYPTO_GCM
-	tristate "GCM/GMAC support"
-	select CRYPTO_CTR
-	select CRYPTO_AEAD
-	select CRYPTO_GF128MUL
-	help
-	  Support for Galois/Counter Mode (GCM) and Galois Message
-	  Authentication Code (GMAC). Required for IPSec.
+comment "Digest"
 
-config CRYPTO_CCM
-	tristate "CCM support"
-	select CRYPTO_CTR
-	select CRYPTO_AEAD
+config CRYPTO_CRC32C
+	tristate "CRC32c CRC algorithm"
+	select CRYPTO_ALGAPI
+	select LIBCRC32C
 	help
-	  Support for Counter with CBC MAC. Required for IPsec.
+	  Castagnoli, et al Cyclic Redundancy-Check Algorithm.  Used
+	  by iSCSI for header and data digests and by others.
+	  See Castagnoli93.  This implementation uses lib/libcrc32c.
+          Module will be crc32c.
 
-config CRYPTO_CRYPTD
-	tristate "Software async crypto daemon"
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_MANAGER
+config CRYPTO_MD4
+	tristate "MD4 digest algorithm"
+	select CRYPTO_ALGAPI
 	help
-	  This is a generic software asynchronous crypto daemon that
-	  converts an arbitrary synchronous software crypto algorithm
-	  into an asynchronous algorithm that executes in a kernel thread.
+	  MD4 message digest algorithm (RFC1320).
 
-config CRYPTO_DES
-	tristate "DES and Triple DES EDE cipher algorithms"
+config CRYPTO_MD5
+	tristate "MD5 digest algorithm"
 	select CRYPTO_ALGAPI
 	help
-	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
+	  MD5 message digest algorithm (RFC1321).
 
-config CRYPTO_FCRYPT
-	tristate "FCrypt cipher algorithm"
+config CRYPTO_MICHAEL_MIC
+	tristate "Michael MIC keyed digest algorithm"
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
 	help
-	  FCrypt algorithm used by RxRPC.
+	  Michael MIC is used for message integrity protection in TKIP
+	  (IEEE 802.11i). This algorithm is required for TKIP, but it
+	  should not be used for other purposes because of the weakness
+	  of the algorithm.
 
-config CRYPTO_BLOWFISH
-	tristate "Blowfish cipher algorithm"
+config CRYPTO_SHA1
+	tristate "SHA1 digest algorithm"
 	select CRYPTO_ALGAPI
 	help
-	  Blowfish cipher algorithm, by Bruce Schneier.
-	  
-	  This is a variable key length cipher which can use keys from 32
-	  bits to 448 bits in length.  It's fast, simple and specifically
-	  designed for use on "large microprocessors".
-	  
-	  See also:
-	  <http://www.schneier.com/blowfish.html>
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
-config CRYPTO_TWOFISH
-	tristate "Twofish cipher algorithm"
+config CRYPTO_SHA256
+	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_ALGAPI
-	select CRYPTO_TWOFISH_COMMON
 	help
-	  Twofish cipher algorithm.
-	  
-	  Twofish was submitted as an AES (Advanced Encryption Standard)
-	  candidate cipher by researchers at CounterPane Systems.  It is a
-	  16 round block cipher supporting key sizes of 128, 192, and 256
-	  bits.
-	  
-	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  SHA256 secure hash standard (DFIPS 180-2).
 
-config CRYPTO_TWOFISH_COMMON
-	tristate
-	help
-	  Common parts of the Twofish cipher algorithm shared by the
-	  generic c and the assembler implementations.
+	  This version of SHA implements a 256 bit hash with 128 bits of
+	  security against collision attacks.
 
-config CRYPTO_TWOFISH_586
-	tristate "Twofish cipher algorithms (i586)"
-	depends on (X86 || UML_X86) && !64BIT
+          This code also includes SHA-224, a 224 bit hash with 112 bits
+          of security against collision attacks.
+
+config CRYPTO_SHA512
+	tristate "SHA384 and SHA512 digest algorithms"
 	select CRYPTO_ALGAPI
-	select CRYPTO_TWOFISH_COMMON
 	help
-	  Twofish cipher algorithm.
+	  SHA512 secure hash standard (DFIPS 180-2).
 
-	  Twofish was submitted as an AES (Advanced Encryption Standard)
-	  candidate cipher by researchers at CounterPane Systems.  It is a
-	  16 round block cipher supporting key sizes of 128, 192, and 256
-	  bits.
+	  This version of SHA implements a 512 bit hash with 256 bits of
+	  security against collision attacks.
 
-	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  This code also includes SHA-384, a 384 bit hash with 192 bits
+	  of security against collision attacks.
 
-config CRYPTO_TWOFISH_X86_64
-	tristate "Twofish cipher algorithm (x86_64)"
-	depends on (X86 || UML_X86) && 64BIT
+config CRYPTO_TGR192
+	tristate "Tiger digest algorithms"
 	select CRYPTO_ALGAPI
-	select CRYPTO_TWOFISH_COMMON
 	help
-	  Twofish cipher algorithm (x86_64).
+	  Tiger hash algorithm 192, 160 and 128-bit hashes
 
-	  Twofish was submitted as an AES (Advanced Encryption Standard)
-	  candidate cipher by researchers at CounterPane Systems.  It is a
-	  16 round block cipher supporting key sizes of 128, 192, and 256
-	  bits.
+	  Tiger is a hash function optimized for 64-bit processors while
+	  still having decent performance on 32-bit processors.
+	  Tiger was developed by Ross Anderson and Eli Biham.
 
 	  See also:
-	  <http://www.schneier.com/twofish.html>
+	  <http://www.cs.technion.ac.il/~biham/Reports/Tiger/>.
 
-config CRYPTO_SERPENT
-	tristate "Serpent cipher algorithm"
+config CRYPTO_WP512
+	tristate "Whirlpool digest algorithms"
 	select CRYPTO_ALGAPI
 	help
-	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
+	  Whirlpool hash algorithm 512, 384 and 256-bit hashes
 
-	  Keys are allowed to be from 0 to 256 bits in length, in steps
-	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli.org code.
+	  Whirlpool-512 is part of the NESSIE cryptographic primitives.
+	  Whirlpool will be part of the ISO/IEC 10118-3:2003(E) standard
 
 	  See also:
-	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+	  <http://planeta.terra.com.br/informatica/paulobarreto/WhirlpoolPage.html>
+
+comment "Ciphers"
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
 
 	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing 
-	  environments regardless of its use in feedback or non-feedback 
-	  modes. Its key setup time is excellent, and its key agility is 
-	  good. Rijndael's very low memory requirements make it very well 
-	  suited for restricted-space environments, in which it also 
-	  demonstrates excellent performance. Rijndael's operations are 
-	  among the easiest to defend against power and timing attacks.	
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
 
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
+	  The AES specifies three key sizes: 128, 192 and 256 bits
 
 	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
 
@@ -367,19 +324,19 @@ config CRYPTO_AES_586
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
 
 	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing 
-	  environments regardless of its use in feedback or non-feedback 
-	  modes. Its key setup time is excellent, and its key agility is 
-	  good. Rijndael's very low memory requirements make it very well 
-	  suited for restricted-space environments, in which it also 
-	  demonstrates excellent performance. Rijndael's operations are 
-	  among the easiest to defend against power and timing attacks.	
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
 
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
+	  The AES specifies three key sizes: 128, 192 and 256 bits
 
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 
@@ -389,22 +346,75 @@ config CRYPTO_AES_X86_64
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
 
 	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing 
-	  environments regardless of its use in feedback or non-feedback 
-	  modes. Its key setup time is excellent, and its key agility is 
-	  good. Rijndael's very low memory requirements make it very well 
-	  suited for restricted-space environments, in which it also 
-	  demonstrates excellent performance. Rijndael's operations are 
-	  among the easiest to defend against power and timing attacks.	
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
 
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
+	  The AES specifies three key sizes: 128, 192 and 256 bits
 
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 
+config CRYPTO_ANUBIS
+	tristate "Anubis cipher algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  Anubis cipher algorithm.
+
+	  Anubis is a variable key length cipher which can use keys from
+	  128 bits to 320 bits in length.  It was evaluated as a entrant
+	  in the NESSIE competition.
+
+	  See also:
+	  <https://www.cosic.esat.kuleuven.ac.be/nessie/reports/>
+	  <http://planeta.terra.com.br/informatica/paulobarreto/AnubisPage.html>
+
+config CRYPTO_ARC4
+	tristate "ARC4 cipher algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  ARC4 cipher algorithm.
+
+	  ARC4 is a stream cipher using keys ranging from 8 bits to 2048
+	  bits in length.  This algorithm is required for driver-based
+	  WEP, but it should not be for other purposes because of the
+	  weakness of the algorithm.
+
+config CRYPTO_BLOWFISH
+	tristate "Blowfish cipher algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  Blowfish cipher algorithm, by Bruce Schneier.
+
+	  This is a variable key length cipher which can use keys from 32
+	  bits to 448 bits in length.  It's fast, simple and specifically
+	  designed for use on "large microprocessors".
+
+	  See also:
+	  <http://www.schneier.com/blowfish.html>
+
+config CRYPTO_CAMELLIA
+	tristate "Camellia cipher algorithms"
+	depends on CRYPTO
+	select CRYPTO_ALGAPI
+	help
+	  Camellia cipher algorithms module.
+
+	  Camellia is a symmetric key block cipher developed jointly
+	  at NTT and Mitsubishi Electric Corporation.
+
+	  The Camellia specifies three key sizes: 128, 192 and 256 bits.
+
+	  See also:
+	  <https://info.isl.ntt.co.jp/crypt/eng/camellia/index_s.html>
+
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
 	select CRYPTO_ALGAPI
@@ -419,33 +429,18 @@ config CRYPTO_CAST6
 	  The CAST6 encryption algorithm (synonymous with CAST-256) is
 	  described in RFC2612.
 
-config CRYPTO_TEA
-	tristate "TEA, XTEA and XETA cipher algorithms"
+config CRYPTO_DES
+	tristate "DES and Triple DES EDE cipher algorithms"
 	select CRYPTO_ALGAPI
 	help
-	  TEA cipher algorithm.
-
-	  Tiny Encryption Algorithm is a simple cipher that uses
-	  many rounds for security.  It is very fast and uses
-	  little memory.
-
-	  Xtendend Tiny Encryption Algorithm is a modification to
-	  the TEA algorithm to address a potential key weakness
-	  in the TEA algorithm.
-
-	  Xtendend Encryption Tiny Algorithm is a mis-implementation 
-	  of the XTEA algorithm for compatibility purposes.
+	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
-config CRYPTO_ARC4
-	tristate "ARC4 cipher algorithm"
+config CRYPTO_FCRYPT
+	tristate "FCrypt cipher algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
-	  ARC4 cipher algorithm.
-
-	  ARC4 is a stream cipher using keys ranging from 8 bits to 2048
-	  bits in length.  This algorithm is required for driver-based 
-	  WEP, but it should not be for other purposes because of the
-	  weakness of the algorithm.
+	  FCrypt algorithm used by RxRPC.
 
 config CRYPTO_KHAZAD
 	tristate "Khazad cipher algorithm"
@@ -460,34 +455,6 @@ config CRYPTO_KHAZAD
 	  See also:
 	  <http://planeta.terra.com.br/informatica/paulobarreto/KhazadPage.html>
 
-config CRYPTO_ANUBIS
-	tristate "Anubis cipher algorithm"
-	select CRYPTO_ALGAPI
-	help
-	  Anubis cipher algorithm.
-
-	  Anubis is a variable key length cipher which can use keys from 
-	  128 bits to 320 bits in length.  It was evaluated as a entrant
-	  in the NESSIE competition.
-	  
-	  See also:
-	  <https://www.cosic.esat.kuleuven.ac.be/nessie/reports/>
-	  <http://planeta.terra.com.br/informatica/paulobarreto/AnubisPage.html>
-
-config CRYPTO_SEED
-	tristate "SEED cipher algorithm"
-	select CRYPTO_ALGAPI
-	help
-	  SEED cipher algorithm (RFC4269).
-
-	  SEED is a 128-bit symmetric key block cipher that has been
-	  developed by KISA (Korea Information Security Agency) as a
-	  national standard encryption algorithm of the Republic of Korea.
-	  It is a 16 round block cipher with the key size of 128 bit.
-
-	  See also:
-	  <http://www.kisa.or.kr/kisa/seed/jsp/seed_eng.jsp>
-
 config CRYPTO_SALSA20
 	tristate "Salsa20 stream cipher algorithm (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -529,69 +496,115 @@ config CRYPTO_SALSA20_X86_64
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
-config CRYPTO_DEFLATE
-	tristate "Deflate compression algorithm"
+config CRYPTO_SEED
+	tristate "SEED cipher algorithm"
 	select CRYPTO_ALGAPI
-	select ZLIB_INFLATE
-	select ZLIB_DEFLATE
 	help
-	  This is the Deflate algorithm (RFC1951), specified for use in
-	  IPSec with the IPCOMP protocol (RFC3173, RFC2394).
-	  
-	  You will most probably want this if using IPSec.
+	  SEED cipher algorithm (RFC4269).
 
-config CRYPTO_MICHAEL_MIC
-	tristate "Michael MIC keyed digest algorithm"
+	  SEED is a 128-bit symmetric key block cipher that has been
+	  developed by KISA (Korea Information Security Agency) as a
+	  national standard encryption algorithm of the Republic of Korea.
+	  It is a 16 round block cipher with the key size of 128 bit.
+
+	  See also:
+	  <http://www.kisa.or.kr/kisa/seed/jsp/seed_eng.jsp>
+
+config CRYPTO_SERPENT
+	tristate "Serpent cipher algorithm"
 	select CRYPTO_ALGAPI
 	help
-	  Michael MIC is used for message integrity protection in TKIP
-	  (IEEE 802.11i). This algorithm is required for TKIP, but it
-	  should not be used for other purposes because of the weakness
-	  of the algorithm.
+	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
 
-config CRYPTO_CRC32C
-	tristate "CRC32c CRC algorithm"
+	  Keys are allowed to be from 0 to 256 bits in length, in steps
+	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
+	  variant of Serpent for compatibility with old kerneli.org code.
+
+	  See also:
+	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+
+config CRYPTO_TEA
+	tristate "TEA, XTEA and XETA cipher algorithms"
 	select CRYPTO_ALGAPI
-	select LIBCRC32C
 	help
-	  Castagnoli, et al Cyclic Redundancy-Check Algorithm.  Used
-	  by iSCSI for header and data digests and by others.
-	  See Castagnoli93.  This implementation uses lib/libcrc32c.
-          Module will be crc32c.
+	  TEA cipher algorithm.
 
-config CRYPTO_CAMELLIA
-	tristate "Camellia cipher algorithms"
-	depends on CRYPTO
+	  Tiny Encryption Algorithm is a simple cipher that uses
+	  many rounds for security.  It is very fast and uses
+	  little memory.
+
+	  Xtendend Tiny Encryption Algorithm is a modification to
+	  the TEA algorithm to address a potential key weakness
+	  in the TEA algorithm.
+
+	  Xtendend Encryption Tiny Algorithm is a mis-implementation
+	  of the XTEA algorithm for compatibility purposes.
+
+config CRYPTO_TWOFISH
+	tristate "Twofish cipher algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_TWOFISH_COMMON
 	help
-	  Camellia cipher algorithms module.
+	  Twofish cipher algorithm.
 
-	  Camellia is a symmetric key block cipher developed jointly
-	  at NTT and Mitsubishi Electric Corporation.
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
 
-	  The Camellia specifies three key sizes: 128, 192 and 256 bits.
+	  See also:
+	  <http://www.schneier.com/twofish.html>
+
+config CRYPTO_TWOFISH_COMMON
+	tristate
+	help
+	  Common parts of the Twofish cipher algorithm shared by the
+	  generic c and the assembler implementations.
+
+config CRYPTO_TWOFISH_586
+	tristate "Twofish cipher algorithms (i586)"
+	depends on (X86 || UML_X86) && !64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_TWOFISH_COMMON
+	help
+	  Twofish cipher algorithm.
+
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
 
 	  See also:
-	  <https://info.isl.ntt.co.jp/crypt/eng/camellia/index_s.html>
+	  <http://www.schneier.com/twofish.html>
 
-config CRYPTO_TEST
-	tristate "Testing module"
-	depends on m
+config CRYPTO_TWOFISH_X86_64
+	tristate "Twofish cipher algorithm (x86_64)"
+	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
-	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_TWOFISH_COMMON
 	help
-	  Quick & dirty crypto test module.
+	  Twofish cipher algorithm (x86_64).
 
-config CRYPTO_AUTHENC
-	tristate "Authenc support"
-	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_MANAGER
-	select CRYPTO_HASH
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
+
+	  See also:
+	  <http://www.schneier.com/twofish.html>
+
+comment "Compression"
+
+config CRYPTO_DEFLATE
+	tristate "Deflate compression algorithm"
+	select CRYPTO_ALGAPI
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
 	help
-	  Authenc: Combined mode wrapper for IPsec.
-	  This is required for IPSec.
+	  This is the Deflate algorithm (RFC1951), specified for use in
+	  IPSec with the IPCOMP protocol (RFC3173, RFC2394).
+
+	  You will most probably want this if using IPSec.
 
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
-- 
1.5.4.3

