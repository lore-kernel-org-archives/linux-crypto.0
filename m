From: jang@linux.vnet.ibm.com
Subject: [PATCH 6/8] s390: cleanup s390 Kconfig options
Date: Tue, 19 Apr 2011 21:29:19 +0200
Message-ID: <20110419193249.501699502@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:34592 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab1DSTeB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:01 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJY0M6020566
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:34:00 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYt4Q1445938
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:55 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXxrd028605
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:59 -0600
Content-Disposition: inline; filename=crypto-Kconfig.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jan Glauber <jang@linux.vnet.ibm.com>

Cleanup the remaining s390 crypto options by mentioning the earliest machine
type that supports an accelerated algorithm.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 drivers/crypto/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -91,6 +91,8 @@ config CRYPTO_SHA1_S390
 	  This is the s390 hardware accelerated implementation of the
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
+	  It is available as of z990.
+
 config CRYPTO_SHA256_S390
 	tristate "SHA256 digest algorithm"
 	depends on S390
@@ -99,8 +101,7 @@ config CRYPTO_SHA256_S390
 	  This is the s390 hardware accelerated implementation of the
 	  SHA256 secure hash standard (DFIPS 180-2).
 
-	  This version of SHA implements a 256 bit hash with 128 bits of
-	  security against collision attacks.
+	  It is available as of z9.
 
 config CRYPTO_SHA512_S390
 	tristate "SHA384 and SHA512 digest algorithm"
@@ -110,10 +111,7 @@ config CRYPTO_SHA512_S390
 	  This is the s390 hardware accelerated implementation of the
 	  SHA512 secure hash standard.
 
-	  This version of SHA implements a 512 bit hash with 256 bits of
-	  security against collision attacks. The code also includes SHA-384,
-	  a 384 bit hash with 192 bits of security against collision attacks.
-
+	  It is available as of z10.
 
 config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms"
@@ -151,8 +149,10 @@ config S390_PRNG
 	  Select this option if you want to use the s390 pseudo random number
 	  generator. The PRNG is part of the cryptographic processor functions
 	  and uses triple-DES to generate secure random numbers like the
-	  ANSI X9.17 standard. The PRNG is usable via the char device
-	  /dev/prandom.
+	  ANSI X9.17 standard. User-space programs access the
+	  pseudo-random-number device through the char device /dev/prandom.
+
+	  It is available as of z9.
 
 config CRYPTO_GHASH_S390
 	tristate "GHASH digest algorithm"

-- 
