From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: Intel SHA - add MODULE_ALIAS
Date: Fri, 13 May 2016 14:02 +0200
Message-ID: <2277976.2OBcIJC5tF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39268 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbcEMMBs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 08:01:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the MODULE_ALIAS for the cra_driver_name of the different ciphers to
allow an automated loading if a driver name is used.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/sha1_ssse3_glue.c   |  6 ++++++
 arch/x86/crypto/sha256_ssse3_glue.c | 10 ++++++++++
 arch/x86/crypto/sha512_ssse3_glue.c |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index dd14616..3dcd929 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -374,3 +374,9 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS_CRYPTO("sha1");
+MODULE_ALIAS_CRYPTO("sha1-ssse3");
+MODULE_ALIAS_CRYPTO("sha1-avx");
+MODULE_ALIAS_CRYPTO("sha1-avx2");
+#ifdef CONFIG_AS_SHA1_NI
+MODULE_ALIAS_CRYPTO("sha1-ni");
+#endif
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 5f4d608..0ac8d2f 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -427,4 +427,14 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS_CRYPTO("sha256");
+MODULE_ALIAS_CRYPTO("sha256-ssse3");
+MODULE_ALIAS_CRYPTO("sha256-avx");
+MODULE_ALIAS_CRYPTO("sha256-avx2");
 MODULE_ALIAS_CRYPTO("sha224");
+MODULE_ALIAS_CRYPTO("sha224-ssse3");
+MODULE_ALIAS_CRYPTO("sha224-avx");
+MODULE_ALIAS_CRYPTO("sha224-avx2");
+#ifdef CONFIG_AS_SHA256_NI
+MODULE_ALIAS_CRYPTO("sha256-ni");
+MODULE_ALIAS_CRYPTO("sha224-ni");
+#endif
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 34e5083..33058bc 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -346,4 +346,10 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA512 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS_CRYPTO("sha512");
+MODULE_ALIAS_CRYPTO("sha512-ssse3");
+MODULE_ALIAS_CRYPTO("sha512-avx");
+MODULE_ALIAS_CRYPTO("sha512-avx2");
 MODULE_ALIAS_CRYPTO("sha384");
+MODULE_ALIAS_CRYPTO("sha384-ssse3");
+MODULE_ALIAS_CRYPTO("sha384-avx");
+MODULE_ALIAS_CRYPTO("sha384-avx2");
-- 
2.5.5
