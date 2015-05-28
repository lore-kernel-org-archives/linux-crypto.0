From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Revert "crypto: algif_aead - Disable AEAD user-space for now"
Date: Thu, 28 May 2015 11:30:35 +0800
Message-ID: <20150528033034.GA3792@gondor.apana.org.au>
References: <20150526073242.GA6501@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35466 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbE1Dak (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 23:30:40 -0400
Content-Disposition: inline
In-Reply-To: <20150526073242.GA6501@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit f858c7bcca8c20761a20593439fe998b4b67e86b as
the algif_aead interface has been switched over to the new AEAD
interface.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0ff4cd4..af011a9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1532,6 +1532,15 @@ config CRYPTO_USER_API_RNG
 	  This option enables the user-spaces interface for random
 	  number generator algorithms.
 
+config CRYPTO_USER_API_AEAD
+	tristate "User-space interface for AEAD cipher algorithms"
+	depends on NET
+	select CRYPTO_AEAD
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for AEAD
+	  cipher algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
