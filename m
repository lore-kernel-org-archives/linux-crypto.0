From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] crypto: rng - Make DRBG the default RNG
Date: Wed, 03 Jun 2015 14:49:31 +0800
Message-ID: <E1Z02UV-0001Hc-9E@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56270 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbbFCGtf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch creates a new invisible Kconfig option CRYPTO_RNG_DEFAULT
that simply selects the DRBG.  This new option is then selected
by the IV generators.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c3b6a5b..19ca651 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -78,6 +78,10 @@ config CRYPTO_RNG2
 	tristate
 	select CRYPTO_ALGAPI2
 
+config CRYPTO_RNG_DEFAULT
+	tristate
+	select CRYPTO_DRBG_MENU
+
 config CRYPTO_PCOMP
 	tristate
 	select CRYPTO_PCOMP2
@@ -222,7 +226,7 @@ config CRYPTO_SEQIV
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_NULL
-	select CRYPTO_RNG
+	select CRYPTO_RNG_DEFAULT
 	help
 	  This IV generator generates an IV based on a sequence number by
 	  xoring it with a salt.  This algorithm is mainly useful for CTR
@@ -231,7 +235,7 @@ config CRYPTO_ECHAINIV
 	tristate "Encrypted Chain IV Generator"
 	select CRYPTO_AEAD
 	select CRYPTO_NULL
-	select CRYPTO_RNG
+	select CRYPTO_RNG_DEFAULT
 	default m
 	help
 	  This IV generator generates an IV based on the encryption of
@@ -1450,7 +1454,6 @@ comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
-	default m
 	select CRYPTO_AES
 	select CRYPTO_RNG
 	help
@@ -1468,11 +1471,9 @@ menuconfig CRYPTO_DRBG_MENU
 if CRYPTO_DRBG_MENU
 
 config CRYPTO_DRBG_HMAC
-	bool "Enable HMAC DRBG"
+	bool
 	default y
 	select CRYPTO_HMAC
-	help
-	  Enable the HMAC DRBG variant as defined in NIST SP800-90A.
 
 config CRYPTO_DRBG_HASH
 	bool "Enable Hash DRBG"
@@ -1488,7 +1489,7 @@ config CRYPTO_DRBG_CTR
 
 config CRYPTO_DRBG
 	tristate
-	default CRYPTO_DRBG_MENU if (CRYPTO_DRBG_HMAC || CRYPTO_DRBG_HASH || CRYPTO_DRBG_CTR)
+	default CRYPTO_DRBG_MENU
 	select CRYPTO_RNG
 	select CRYPTO_JITTERENTROPY
 
