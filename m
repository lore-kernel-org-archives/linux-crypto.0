From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] Make crypto core API modular
Date: Sat, 1 Dec 2007 13:19:10 +0100
Message-ID: <20071201121910.GA8048@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42932 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbXLAMTL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Dec 2007 07:19:11 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes the whole crypto API is modular.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig         |    2 +-
 crypto/Makefile        |    3 ++-
 include/linux/crypto.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.orig/crypto/Kconfig	2007-12-01 13:02:48.000000000 +0100
+++ linux-2.6/crypto/Kconfig	2007-12-01 13:02:55.000000000 +0100
@@ -13,7 +13,7 @@
 # Cryptographic API Configuration
 #
 menuconfig CRYPTO
-	bool "Cryptographic API"
+	tristate "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
 
--- linux-2.6.orig/crypto/Makefile	2007-12-01 13:02:48.000000000 +0100
+++ linux-2.6/crypto/Makefile	2007-12-01 13:02:55.000000000 +0100
@@ -2,7 +2,8 @@
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO) += api.o cipher.o digest.o compress.o
+obj-$(CONFIG_CRYPTO) += crypto_core.o
+crypto_core-y := api.o cipher.o digest.o compress.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
--- linux-2.6.orig/include/linux/crypto.h	2007-12-01 13:02:48.000000000 +0100
+++ linux-2.6/include/linux/crypto.h	2007-12-01 13:02:55.000000000 +0100
@@ -299,7 +299,7 @@
 /*
  * Algorithm query interface.
  */
-#ifdef CONFIG_CRYPTO
+#if defined(CONFIG_CRYPTO) || defined(CONFIG_CRYPTO_MODULE)
 int crypto_has_alg(const char *name, u32 type, u32 mask);
 #else
 static inline int crypto_has_alg(const char *name, u32 type, u32 mask)
