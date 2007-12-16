From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] tcrypt depends on AEAD
Date: Sun, 16 Dec 2007 21:29:25 +0100
Message-ID: <20071216202925.GC29507@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37233 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbXLPU30 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Dec 2007 15:29:26 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 ERROR: "crypto_aead_setauthsize" [crypto/tcrypt.ko] undefined!
 ERROR: "crypto_alloc_aead" [crypto/tcrypt.ko] undefined!

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b0481f7..93ad53a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -568,6 +568,7 @@ config CRYPTO_TEST
 	tristate "Testing module"
 	depends on m
 	select CRYPTO_ALGAPI
+	select CRYPTO_AEAD
 	help
 	  Quick & dirty crypto test module.
 
-- 
1.5.3.4
