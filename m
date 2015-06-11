From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: drbg - Add select on sha256
Date: Thu, 11 Jun 2015 08:55:10 +0800
Message-ID: <20150611005510.GA9267@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36028 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbFKAzP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 20:55:15 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The hash-based DRBG variants all use sha256 so we need to add a
select on it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cb7806f..f6fc054 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1508,10 +1508,11 @@ config CRYPTO_DRBG_HMAC
 	bool
 	default y
 	select CRYPTO_HMAC
+	select CRYPTO_SHA256
 
 config CRYPTO_DRBG_HASH
 	bool "Enable Hash DRBG"
-	select CRYPTO_HASH
+	select CRYPTO_SHA256
 	help
 	  Enable the Hash DRBG variant as defined in NIST SP800-90A.
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
