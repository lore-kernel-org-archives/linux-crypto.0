From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] api: Select cryptomgr where needed
Date: Mon, 16 Oct 2006 21:30:20 +1000
Message-ID: <20061016113020.GA19771@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Morris <jmorris@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56581 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751197AbWJPLaa
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Oct 2006 07:30:30 -0400
To: Andi Kleen <ak@suse.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andi:

I'll send this patch to Linus which should prevent the problem
that you were seeing.  James, this is probably what caused the
racoon problems for you too.

[CRYPTO] api: Select cryptomgr where needed

Since cryptomgr is the only way to construct algorithm instances
for now it makes sense to let the templates depend on it as
otherwise it may be left off inadvertently.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1e2f39c..cbae839 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -27,7 +27,6 @@ config CRYPTO_HASH
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_ALGAPI
-	default m
 	help
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
@@ -35,6 +34,7 @@ config CRYPTO_MANAGER
 config CRYPTO_HMAC
 	tristate "HMAC support"
 	select CRYPTO_HASH
+	select CRYPTO_MANAGER
 	help
 	  HMAC: Keyed-Hashing for Message Authentication (RFC2104).
 	  This is required for IPSec.
@@ -131,6 +131,7 @@ config CRYPTO_TGR192
 config CRYPTO_ECB
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
 	default m
 	help
 	  ECB: Electronic CodeBook mode
@@ -140,6 +141,7 @@ config CRYPTO_ECB
 config CRYPTO_CBC
 	tristate "CBC support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
 	default m
 	help
 	  CBC: Cipher Block Chaining mode
