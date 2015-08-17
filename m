From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto/Konfig
Date: Mon, 17 Aug 2015 20:39:40 +0800
Message-ID: <20150817123939.GA30538@gondor.apana.org.au>
References: <11252787.PiQGprMvJX@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39221 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbHQMjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 08:39:44 -0400
Content-Disposition: inline
In-Reply-To: <11252787.PiQGprMvJX@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 17, 2015 at 02:34:05PM +0200, Stephan Mueller wrote:
> Hi Herbert,
> 
> something seems to be missing in the latest Kconfig file.
> 
> Shall there be a tristate added?

You're quite Stephan.

Thanks,

---8<---
Subject: crypto: null - Add missing Kconfig tristate for NULL2

This patch adds a missing tristate statement to Kconfig for the
new CRYPTO_NULL2 option.

Fixes: 149a39717dcc ("crypto: aead - Add type-safe geniv init/exit helpers")
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0e35889..b582ea7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -157,6 +157,7 @@ config CRYPTO_NULL
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
 config CRYPTO_NULL2
+	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_HASH2

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
