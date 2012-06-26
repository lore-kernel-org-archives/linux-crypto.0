From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Tue, 26 Jun 2012 18:13:46 +0200
Message-ID: <20120626161346.GB6509@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33024 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757866Ab2FZQNu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2012 12:13:50 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since commit ce6dd368 ("crypto: arc4 - improve performance by adding
ecb(arc4)) we need to pull in a blkcipher.

|ERROR: "crypto_blkcipher_type" [crypto/arc4.ko] undefined!
|ERROR: "blkcipher_walk_done" [crypto/arc4.ko] undefined!
|ERROR: "blkcipher_walk_virt" [crypto/arc4.ko] undefined!

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---

On a side note: do we pull in the blkcipher block mode for each cipher now to
gain some extra performance like the openssl project? I was under the
impression that is in general not worth it.

 crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2c1c2df..cefbe15 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -593,7 +593,7 @@ config CRYPTO_ANUBIS
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
 	  ARC4 cipher algorithm.
 
-- 
1.7.10
