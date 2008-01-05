From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 2/2] [crypto] make the crypto subsystem fully modular
Date: Sat, 5 Jan 2008 13:36:37 +0100
Message-ID: <E1JB8IB-0003Pt-Kk@Chamillionaire.breakpoint.cc>
References: <20080105123637.GA12561@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34843 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYAEMiY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2008 07:38:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig         |    2 +-
 crypto/Makefile        |    3 ++-
 crypto/api.c           |    3 +++
 include/linux/crypto.h |    7 -------
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c3166a1..8c28a4b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -13,7 +13,7 @@ source "crypto/async_tx/Kconfig"
 # Cryptographic API Configuration
 #
 menuconfig CRYPTO
-	bool "Cryptographic API"
+	tristate "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 48c7583..fd24356 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -2,7 +2,8 @@
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO) += api.o cipher.o digest.o compress.o
+obj-$(CONFIG_CRYPTO) += crypto.o
+crypto-objs := api.o cipher.o digest.o compress.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
diff --git a/crypto/api.c b/crypto/api.c
index a2496d1..0a0f41e 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -445,3 +445,6 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
+
+MODULE_DESCRIPTION("Cryptographic core API");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0aba104..f1fb017 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -319,14 +319,7 @@ int crypto_unregister_alg(struct crypto_alg *alg);
 /*
  * Algorithm query interface.
  */
-#ifdef CONFIG_CRYPTO
 int crypto_has_alg(const char *name, u32 type, u32 mask);
-#else
-static inline int crypto_has_alg(const char *name, u32 type, u32 mask)
-{
-	return 0;
-}
-#endif
 
 /*
  * Transforms: user-instantiated objects which encapsulate algorithms
-- 
1.5.3.7
