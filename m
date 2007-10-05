From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Fri, 5 Oct 2007 15:12:10 +0200
Message-ID: <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
 <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au>
 <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au>
 <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
 <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44614 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbXJEOAn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Oct 2007 10:00:43 -0400
In-Reply-To: <20071005135056.GA19693@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Loading the crypto algorithm by the alias instead of by module directly
has the advantage that all possible implementations of this algorithm
are loaded automatically and the crypto API can choose the best one
depending on its priority.
Additionally it ensures that the generic implementation as well as the
HW driver (if available) is loaded in case the HW driver needs the
generic version as fallback in corner cases.
Also remove the probe for sha1 in padlock's init code.
Quote from Herbert:
  The probe is actually pointless since we can always probe when
  the algorithm is actually used which does not lead to dead-locks
  like this.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/sha1_s390.c          |    2 +-
 arch/s390/crypto/sha256_s390.c        |    2 +-
 crypto/Makefile                       |    4 ++--
 crypto/{sha1.c => sha1_generic.c}     |    2 +-
 crypto/{sha256.c => sha256_generic.c} |    8 ++++----
 drivers/crypto/padlock-sha.c          |   19 ++-----------------
 6 files changed, 11 insertions(+), 26 deletions(-)
 rename crypto/{sha1.c => sha1_generic.c} (99%)
 rename crypto/{sha256.c => sha256_generic.c} (99%)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index af4460e..8ebd3cd 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -12,7 +12,7 @@
  *   Author(s): Thomas Spatzier
  *		Jan Glauber (jan.glauber@de.ibm.com)
  *
- * Derived from "crypto/sha1.c"
+ * Derived from "crypto/sha1_generic.c"
  *   Copyright (c) Alan Smithee.
  *   Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  *   Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
index 2ced333..c728bd0 100644
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -7,7 +7,7 @@
  *   Copyright IBM Corp. 2005,2007
  *   Author(s): Jan Glauber (jang@de.ibm.com)
  *
- * Derived from "crypto/sha256.c"
+ * Derived from "crypto/sha256_generic.c"
  * and "arch/s390/crypto/sha1_s390.c"
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/crypto/Makefile b/crypto/Makefile
index b6ef5e4..43c2a0d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -21,8 +21,8 @@ obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
-obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
-obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
+obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
+obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
diff --git a/crypto/sha1.c b/crypto/sha1_generic.c
similarity index 99%
rename from crypto/sha1.c
rename to crypto/sha1_generic.c
index 1bba551..70364dd 100644
--- a/crypto/sha1.c
+++ b/crypto/sha1_generic.c
@@ -139,4 +139,4 @@ module_exit(fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
 
-MODULE_ALIAS("sha1-generic");
+MODULE_ALIAS("sha1");
diff --git a/crypto/sha256.c b/crypto/sha256_generic.c
similarity index 99%
rename from crypto/sha256.c
rename to crypto/sha256_generic.c
index 716195b..c7097dd 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256_generic.c
@@ -339,4 +339,4 @@ module_exit(fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm");
 
-MODULE_ALIAS("sha256-generic");
+MODULE_ALIAS("sha256");
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a781fd2..bc1de34 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -253,19 +253,6 @@ static struct crypto_alg sha256_alg = {
 	}
 };
 
-static void __init padlock_sha_check_fallbacks(void)
-{
-	if (!crypto_has_hash("sha1", 0, CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK))
-		printk(KERN_WARNING PFX
-		       "Couldn't load fallback module for sha1.\n");
-
-	if (!crypto_has_hash("sha256", 0, CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK))
-		printk(KERN_WARNING PFX
-		       "Couldn't load fallback module for sha256.\n");
-}
-
 static int __init padlock_init(void)
 {
 	int rc = -ENODEV;
@@ -280,8 +267,6 @@ static int __init padlock_init(void)
 		return -ENODEV;
 	}
 
-	padlock_sha_check_fallbacks();
-
 	rc = crypto_register_alg(&sha1_alg);
 	if (rc)
 		goto out;
@@ -314,5 +299,5 @@ MODULE_DESCRIPTION("VIA PadLock SHA1/SHA256 algorithms support.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("sha1-padlock");
-MODULE_ALIAS("sha256-padlock");
+MODULE_ALIAS("sha1");
+MODULE_ALIAS("sha256");
-- 
1.5.3.2
