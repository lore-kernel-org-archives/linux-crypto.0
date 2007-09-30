From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Sun, 30 Sep 2007 14:23:04 +0200
Message-ID: <20070930122304.GA24811@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de> <20070902224226.GA22869@Chamillionaire.breakpoint.cc> <20070919122943.GD19866@gondor.apana.org.au> <20070919214652.GC20997@Chamillionaire.breakpoint.cc> <20070920002058.GA26848@gondor.apana.org.au> <20070920210947.GA27950@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36670 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbXI3MXM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Sep 2007 08:23:12 -0400
Content-Disposition: inline
In-Reply-To: <20070920210947.GA27950@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Sebastian Siewior | 2007-09-20 23:09:47 [+0200]:

>* Herbert Xu | 2007-09-20 08:20:58 [+0800]:
>
>>So that the generic C version can actually be tested on x86.
>>We don't want it to bit-rot which would make non-x86 2nd-class
>>citizens.
>
>Okey. I try to post something what you might like in the new few days.

This one should do it? Now you should not select both as module in order
to get the assembly version auto loaded by the kernel :)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -286,6 +286,9 @@ config CRYPTO_SERPENT
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
+	select CRYPTO_AES_586 if (X86 || UML_X86) && !64BIT
+	select CRYPTO_AES_X86_64 if (X86 || UML_X86) && 64BIT
+	select CRYPTO_AES_GENERIC if (!X86 && !UML_X86)
 	select CRYPTO_ALGAPI
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
@@ -304,47 +307,23 @@ config CRYPTO_AES
 
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
-
-config CRYPTO_AES_X86_64
-	tristate "AES cipher algorithms (x86_64)"
-	depends on (X86 || UML_X86) && 64BIT
+config CRYPTO_AES_GENERIC_ENFORCE
+	tristate "AES cipher algorithm (generic Version)"
+	depends on (X86 || UML_X86)
+	select CRYPTO_AES_GENERIC
 	select CRYPTO_ALGAPI
 	help
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
+	  This is the generic implementation of AES instead of the assembly
+	  optimized version.
 
-	  The AES specifies three key sizes: 128, 192 and 256 bits	  
+config CRYPTO_AES_586
+	tristate
 
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+config CRYPTO_AES_X86_64
+	tristate
 
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfis
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
-obj-$(CONFIG_CRYPTO_AES) += aes.o
+obj-$(CONFIG_CRYPTO_AES_GENERIC) += aes.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
