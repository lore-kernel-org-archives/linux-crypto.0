From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] load the AES module by an alias
Date: Thu, 4 Oct 2007 09:37:27 +0200
Message-ID: <E1IdMSO-0004KM-8Y@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
 <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au>
 <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au>
 <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60903 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbXJDIxW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 04:53:22 -0400
In-Reply-To: <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Loading the crypto algorithm by the alias instead of by module directly
has the advantage that all possible implementations of this algorithm
are loaded automatically and the crypto API can choose the best one
depending on its priority.
Additionally it ensures that the generic implementation as well as the
HW driver (if available) is loaded in case the HW driver needs the
generic version as fallback in corner cases.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/aes_s390.c     |    2 +-
 crypto/Makefile                 |    2 +-
 crypto/{aes.c => aes_generic.c} |    2 +-
 drivers/crypto/geode-aes.c      |    1 +
 drivers/crypto/padlock-aes.c    |    4 ++--
 5 files changed, 6 insertions(+), 5 deletions(-)
 rename crypto/{aes.c => aes_generic.c} (99%)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 3660ca6..5126696 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -7,7 +7,7 @@
  *   Copyright IBM Corp. 2005,2007
  *   Author(s): Jan Glauber (jang@de.ibm.com)
  *
- * Derived from "crypto/aes.c"
+ * Derived from "crypto/aes_generic.c"
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/crypto/Makefile b/crypto/Makefile
index e96a07e..7025bd5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
-obj-$(CONFIG_CRYPTO_AES) += aes.o
+obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
diff --git a/crypto/aes.c b/crypto/aes_generic.c
similarity index 99%
rename from crypto/aes.c
rename to crypto/aes_generic.c
index e244077..9401dca 100644
--- a/crypto/aes.c
+++ b/crypto/aes_generic.c
@@ -453,4 +453,4 @@ module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("Dual BSD/GPL");
-
+MODULE_ALIAS("aes");
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6a86958..f9a34ab 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -473,6 +473,7 @@ geode_aes_exit(void)
 MODULE_AUTHOR("Advanced Micro Devices, Inc.");
 MODULE_DESCRIPTION("Geode LX Hardware AES driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("aes");
 
 module_init(geode_aes_init);
 module_exit(geode_aes_exit);
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index d4501dc..abbcff0 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -5,7 +5,7 @@
  *
  * Copyright (c) 2004  Michal Ludvig <michal@logix.cz>
  *
- * Key expansion routine taken from crypto/aes.c
+ * Key expansion routine taken from crypto/aes_generic.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -660,4 +660,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algorithm support");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("aes-padlock");
+MODULE_ALIAS("aes");
-- 
1.5.3.2
