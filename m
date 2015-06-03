From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: echainiv - Set Kconfig default to m
Date: Wed, 03 Jun 2015 14:49:29 +0800
Message-ID: <E1Z02UT-0001HJ-VF@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46946 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbbFCGtd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As this is required by many IPsec algorithms, let's set the default
to m.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index af011a9..c3b6a5b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -232,6 +232,7 @@ config CRYPTO_ECHAINIV
 	select CRYPTO_AEAD
 	select CRYPTO_NULL
 	select CRYPTO_RNG
+	default m
 	help
 	  This IV generator generates an IV based on the encryption of
 	  a sequence number xored with a salt.  This is the default
