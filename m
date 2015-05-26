From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_aead - Disable AEAD user-space for now
Date: Tue, 26 May 2015 15:32:42 +0800
Message-ID: <20150526073242.GA6501@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32922 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbEZHcr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 03:32:47 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The newly added AEAD user-space isn't quite ready for prime time
just yet.  In particular it is conflicting with the AEAD single
SG list interface change so this patch disables it now.

Once the SG list stuff is completely done we can then renable
this interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8aaf298..362905e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1512,15 +1512,6 @@ config CRYPTO_USER_API_RNG
 	  This option enables the user-spaces interface for random
 	  number generator algorithms.
 
-config CRYPTO_USER_API_AEAD
-	tristate "User-space interface for AEAD cipher algorithms"
-	depends on NET
-	select CRYPTO_AEAD
-	select CRYPTO_USER_API
-	help
-	  This option enables the user-spaces interface for AEAD
-	  cipher algorithms.
-
 config CRYPTO_HASH_INFO
 	bool
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
