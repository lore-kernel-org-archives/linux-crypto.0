Return-Path: <SRS0=kkja=VR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3839C76188
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 06:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5FCB21873
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 06:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563603038;
	bh=o6d88kRr9+zhq8rNuBJL5fcApYdN4EC5jEtF9QHnJcQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=11ybDvZz22Hu+EQd54wrXBDfUYmiQ0LgRkRmIYPnUGUpy52IIBZGu/Z+tAR6xu6hz
	 F5WgKShJvzTBLzd2x0pmxVRzZNoZPqoYHTY1R6rSL6XUpOsN0RkjkxJremZlgM2rii
	 O37aW3MsgOVKGpnTRapVTUaiY3lMppyfa09ox3uY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfGTGKh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Jul 2019 02:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfGTGKh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Jul 2019 02:10:37 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A64321872;
        Sat, 20 Jul 2019 06:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563603035;
        bh=o6d88kRr9+zhq8rNuBJL5fcApYdN4EC5jEtF9QHnJcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XopRPbIiuFP3l8zvgDLEsy5ciJ1udZICr+gwr2dNS9bPzH12pH+A6pgpa3Ni+B8QH
         +LlVAph7FZWXyDaseKsXcWWTOCUAO3qkqVj160dKtpYo2D/HNfGjpIMS8s36SpGsd2
         imaWL6xvXr42mI+Ww0nygxCxie4dskH6A3TWeHws=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: ghash - add comment and improve help text
Date:   Fri, 19 Jul 2019 23:09:18 -0700
Message-Id: <20190720060918.25880-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To help avoid confusion, add a comment to ghash-generic.c which explains
the convention that the kernel's implementation of GHASH uses.

Also update the Kconfig help text and module descriptions to call GHASH
a "hash function" rather than a "message digest", since the latter
normally means a real cryptographic hash function, which GHASH is not.

Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/ghash-ce-glue.c            |  2 +-
 arch/s390/crypto/ghash_s390.c              |  2 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  3 +--
 crypto/Kconfig                             | 11 ++++----
 crypto/ghash-generic.c                     | 31 +++++++++++++++++++---
 drivers/crypto/Kconfig                     |  6 ++---
 include/crypto/ghash.h                     |  2 +-
 7 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 52d472a050e6a..bfdc557dc031c 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -17,7 +17,7 @@
 #include <linux/crypto.h>
 #include <linux/module.h>
 
-MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("GHASH hash function using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("ghash");
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index eeeb6a7737a4a..a3e7400e031ca 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -153,4 +153,4 @@ module_exit(ghash_mod_exit);
 MODULE_ALIAS_CRYPTO("ghash");
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH Message Digest Algorithm, s390 implementation");
+MODULE_DESCRIPTION("GHASH hash function, s390 implementation");
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index ac76fe88ac4fd..04d72a5a8ce98 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -357,6 +357,5 @@ module_init(ghash_pclmulqdqni_mod_init);
 module_exit(ghash_pclmulqdqni_mod_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH Message Digest Algorithm, "
-		   "accelerated by PCLMULQDQ-NI");
+MODULE_DESCRIPTION("GHASH hash function, accelerated by PCLMULQDQ-NI");
 MODULE_ALIAS_CRYPTO("ghash");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e801450bcb1cf..f14c457183c55 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -728,11 +728,12 @@ config CRYPTO_VPMSUM_TESTER
 	  Unless you are testing these algorithms, you don't need this.
 
 config CRYPTO_GHASH
-	tristate "GHASH digest algorithm"
+	tristate "GHASH hash function"
 	select CRYPTO_GF128MUL
 	select CRYPTO_HASH
 	help
-	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
+	  GHASH is the hash function used in GCM (Galois/Counter Mode).
+	  It is not a general-purpose cryptographic hash function.
 
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
@@ -1057,12 +1058,12 @@ config CRYPTO_WP512
 	  <http://www.larc.usp.br/~pbarreto/WhirlpoolPage.html>
 
 config CRYPTO_GHASH_CLMUL_NI_INTEL
-	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
+	tristate "GHASH hash function (CLMUL-NI accelerated)"
 	depends on X86 && 64BIT
 	select CRYPTO_CRYPTD
 	help
-	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
-	  The implementation is accelerated by CLMUL-NI of Intel.
+	  This is the x86_64 CLMUL-NI accelerated implementation of
+	  GHASH, the hash function used in GCM (Galois/Counter mode).
 
 comment "Ciphers"
 
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index dad9e1f91a783..5027b3461c921 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -1,12 +1,37 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * GHASH: digest algorithm for GCM (Galois/Counter Mode).
+ * GHASH: hash function for GCM (Galois/Counter Mode).
  *
  * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
  * Copyright (c) 2009 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
+ */
+
+/*
+ * GHASH is a keyed hash function used in GCM authentication tag generation.
+ *
+ * The original GCM paper [1] presents GHASH as a function GHASH(H, A, C) which
+ * takes a 16-byte hash key H, additional authenticated data A, and a ciphertext
+ * C.  It formats A and C into a single byte string X, interprets X as a
+ * polynomial over GF(2^128), and evaluates this polynomial at the point H.
+ *
+ * However, the NIST standard for GCM [2] presents GHASH as GHASH(H, X) where X
+ * is the already-formatted byte string containing both A and C.
+ *
+ * "ghash" in the Linux crypto API uses the 'X' (pre-formatted) convention,
+ * since the API supports only a single data stream per hash.  Thus, the
+ * formatting of 'A' and 'C' is done in the "gcm" template, not in "ghash".
+ *
+ * The reason "ghash" is separate from "gcm" is to allow "gcm" to use an
+ * accelerated "ghash" when a standalone accelerated "gcm(aes)" is unavailable.
+ * It is generally inappropriate to use "ghash" for other purposes, since it is
+ * an "ε-almost-XOR-universal hash function", not a cryptographic hash function.
+ * It can only be used securely in crypto modes specially designed to use it.
  *
- * The algorithm implementation is copied from gcm.c.
+ * [1] The Galois/Counter Mode of Operation (GCM)
+ *     (http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.694.695&rep=rep1&type=pdf)
+ * [2] Recommendation for Block Cipher Modes of Operation: Galois/Counter Mode (GCM) and GMAC
+ *     (https://csrc.nist.gov/publications/detail/sp/800-38d/final)
  */
 
 #include <crypto/algapi.h>
@@ -156,6 +181,6 @@ subsys_initcall(ghash_mod_init);
 module_exit(ghash_mod_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH Message Digest Algorithm");
+MODULE_DESCRIPTION("GHASH hash function");
 MODULE_ALIAS_CRYPTO("ghash");
 MODULE_ALIAS_CRYPTO("ghash-generic");
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 603413f28fa35..43c36533322f1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -189,12 +189,12 @@ config S390_PRNG
 	  It is available as of z9.
 
 config CRYPTO_GHASH_S390
-	tristate "GHASH digest algorithm"
+	tristate "GHASH hash function"
 	depends on S390
 	select CRYPTO_HASH
 	help
-	  This is the s390 hardware accelerated implementation of the
-	  GHASH message digest algorithm for GCM (Galois/Counter Mode).
+	  This is the s390 hardware accelerated implementation of GHASH,
+	  the hash function used in GCM (Galois/Counter mode).
 
 	  It is available as of z196.
 
diff --git a/include/crypto/ghash.h b/include/crypto/ghash.h
index 9136301062a5c..f832c9f2aca30 100644
--- a/include/crypto/ghash.h
+++ b/include/crypto/ghash.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Common values for GHASH algorithms
+ * Common values for the GHASH hash function
  */
 
 #ifndef __CRYPTO_GHASH_H__
-- 
2.22.0

