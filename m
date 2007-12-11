From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/19] [CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module
Date: Tue, 11 Dec 2007 12:02:52 +0800
Message-ID: <E1J1wKa-0002jI-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1902 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbXLKECz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:02:55 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKa-00061z-II
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:02:52 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module

With the impending addition of the givcipher type, both blkcipher and
ablkcipher algorithms will use it to create givcipher objects.  As such
it no longer makes sense to split the system between ablkcipher and
blkcipher.  In particular, both ablkcipher.c and blkcipher.c would need
to use the givcipher type which has to reside in ablkcipher.c since it
shares much code with it.

This patch merges the two Kconfig options as well as the modules into one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig         |    6 +-----
 crypto/Makefile        |    6 ++++--
 drivers/crypto/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ec272c0..a31864c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -24,10 +24,6 @@ config CRYPTO_ALGAPI
 	help
 	  This option provides the API for cryptographic algorithms.
 
-config CRYPTO_ABLKCIPHER
-	tristate
-	select CRYPTO_BLKCIPHER
-
 config CRYPTO_AEAD
 	tristate
 	select CRYPTO_ALGAPI
@@ -217,7 +213,7 @@ config CRYPTO_GCM
 
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
-	select CRYPTO_ABLKCIPHER
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  This is a generic software asynchronous crypto daemon that
diff --git a/crypto/Makefile b/crypto/Makefile
index 83532ac..2a1883f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -8,9 +8,11 @@ crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
 
-obj-$(CONFIG_CRYPTO_ABLKCIPHER) += ablkcipher.o
 obj-$(CONFIG_CRYPTO_AEAD) += aead.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += blkcipher.o
+
+crypto_blkcipher-objs := ablkcipher.o
+crypto_blkcipher-objs += blkcipher.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
 
 crypto_hash-objs := hash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d848e1b..d8c7040 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -87,7 +87,7 @@ config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_DES
 	select CRYPTO_ALGAPI
-	select CRYPTO_ABLKCIPHER
+	select CRYPTO_BLKCIPHER
 	depends on PCI
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
