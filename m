From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC] [crypto] AES shorten the Kconfig entry
Date: Fri, 28 Mar 2008 23:39:52 +0100
Message-ID: <20080328223952.GD24018@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57139 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbYC1Wjx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Mar 2008 18:39:53 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove copied / duplicate entry from the assemble version and add a
small hint that the assembly version performs better and is not
a relict.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig |   39 ++++++---------------------------------
 1 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 864456c..9be60a4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -320,47 +320,20 @@ config CRYPTO_AES
 
 config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
-	depends on (X86 || UML_X86) && !64BIT
+	depends on (X86 || UML_X86) && !64BIT && CRYPTO_AES
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
-	  algorithm.
+	  This is the assembly optimized version of AES. It should perform better
+	  than the generic implementation above.
 
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
 
 config CRYPTO_AES_X86_64
 	tristate "AES cipher algorithms (x86_64)"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on (X86 || UML_X86) && 64BIT && CRYPTO_AES
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES
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
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits
