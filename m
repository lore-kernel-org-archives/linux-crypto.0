From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 3 Sep 2007 00:42:27 +0200
Message-ID: <20070902224226.GA22869@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55489 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbXIBWma (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Sep 2007 18:42:30 -0400
Content-Disposition: inline
In-Reply-To: <20070820130639.GN16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Andi Kleen | 2007-08-20 15:06:39 [+0200]:

>> That would be the best.  However, it's not hard to do a
>> simple probing in the kernel until modprobe(8) gets this
>> feature.
>
>Sounds like a big hack, and at least for aes / aes-x86_64 and
>twofish it's not needed.  Just disable aes on x86.
>
>The only problem is the select issue with wireless.
>
>Unfortunately 
>
>select CRYPTO_AES_X86_64 if X86_64
>select CRYPTO_AES_I586 if X86_32
>select CRYPTO_AES if !X86
>
>produces warnings for unreferenced symbols :/
>Perhaps it can be just removed for now.

What about:

[crypto] do not use generic AES on i386 and x86_64

This patch automatically selects the assembly optimized version
of AES (if selected) and the generic version can no longer be
selected. The module will be called aes.ko

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/i386/crypto/Makefile               |    4 +-
 arch/i386/crypto/{aes.c => aes_key.c}   |    0 
 arch/x86_64/crypto/Makefile             |    5 +--
 arch/x86_64/crypto/{aes.c => aes_key.c} |    0 
 crypto/Kconfig                          |   46 +++++-------------------------
 crypto/Makefile                         |    2 +-
 6 files changed, 13 insertions(+), 44 deletions(-)
 rename arch/i386/crypto/{aes.c => aes_key.c} (100%)
 rename arch/x86_64/crypto/{aes.c => aes_key.c} (100%)

diff --git a/arch/i386/crypto/Makefile b/arch/i386/crypto/Makefile
index 3fd19af..e725951 100644
--- a/arch/i386/crypto/Makefile
+++ b/arch/i386/crypto/Makefile
@@ -4,9 +4,9 @@
 # Arch-specific CryptoAPI modules.
 # 
 
-obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
+obj-$(CONFIG_CRYPTO_AES_586) += aes.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 
-aes-i586-y := aes-i586-asm.o aes.o
+aes-y := aes-i586-asm.o aes_key.o
 twofish-i586-y := twofish-i586-asm.o twofish.o
 
diff --git a/arch/i386/crypto/aes.c b/arch/i386/crypto/aes_key.c
similarity index 100%
rename from arch/i386/crypto/aes.c
rename to arch/i386/crypto/aes_key.c
diff --git a/arch/x86_64/crypto/Makefile b/arch/x86_64/crypto/Makefile
index 15b538a..e34e716 100644
--- a/arch/x86_64/crypto/Makefile
+++ b/arch/x86_64/crypto/Makefile
@@ -4,9 +4,8 @@
 # Arch-specific CryptoAPI modules.
 # 
 
-obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
+obj-$(CONFIG_CRYPTO_AES_X86_64) += aes.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 
-aes-x86_64-y := aes-x86_64-asm.o aes.o
+aes-y := aes-x86_64-asm.o aes_key.o
 twofish-x86_64-y := twofish-x86_64-asm.o twofish.o
-
diff --git a/arch/x86_64/crypto/aes.c b/arch/x86_64/crypto/aes_key.c
similarity index 100%
rename from arch/x86_64/crypto/aes.c
rename to arch/x86_64/crypto/aes_key.c
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3d1a1e2..87d7bce 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -286,6 +286,9 @@ config CRYPTO_SERPENT
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
+	select CRYPTO_AES_586 if (X86 || UML_X86) && !64BIT
+	select CRYPTO_AES_X86_64 if (X86 || UML_X86) && 64BIT
+	select CRYPTO_AES_GENERIC if !X86
 	select CRYPTO_ALGAPI
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
@@ -304,47 +307,14 @@ config CRYPTO_AES
 
 	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
 
-config CRYPTO_AES_586
-	tristate "AES cipher algorithms (i586)"
-	depends on (X86 || UML_X86) && !64BIT
-	select CRYPTO_ALGAPI
-	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
-	  algorithm.
-
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing 
-	  environments regardless of its use in feedback or non-feedback 
-	  modes. Its key setup time is excellent, and its key agility is 
-	  good. Rijndael's very low memory requirements make it very well 
-	  suited for restricted-space environments, in which it also 
-	  demonstrates excellent performance. Rijndael's operations are 
-	  among the easiest to defend against power and timing attacks.	
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
+config CRYPTO_AES_GENERIC
+	tristate
 
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+config CRYPTO_AES_586
+	tristate
 
 config CRYPTO_AES_X86_64
-	tristate "AES cipher algorithms (x86_64)"
-	depends on (X86 || UML_X86) && 64BIT
-	select CRYPTO_ALGAPI
-	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
-	  algorithm.
-
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing 
-	  environments regardless of its use in feedback or non-feedback 
-	  modes. Its key setup time is excellent, and its key agility is 
-	  good. Rijndael's very low memory requirements make it very well 
-	  suited for restricted-space environments, in which it also 
-	  demonstrates excellent performance. Rijndael's operations are 
-	  among the easiest to defend against power and timing attacks.	
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
-
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+	tristate
 
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
diff --git a/crypto/Makefile b/crypto/Makefile
index 0cf17f1..af44fd5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
-obj-$(CONFIG_CRYPTO_AES) += aes.o
+obj-$(CONFIG_CRYPTO_AES_GENERIC) += aes.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
-- 
1.5.3.rc7
