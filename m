From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] don't make CTR default M
Date: Sun, 28 Oct 2007 16:49:02 +0100
Message-ID: <20071028154902.GA26247@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41984 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXJ1PtF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Oct 2007 11:49:05 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

NO other block mode is M by default.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---

Herbert, please squash this one into the CTR patch and if you set
apply.whitespace strip
than the white space damage shoud be fixed by itself on your next 
rebase :)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a375d4d..8cb6450 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -199,7 +199,6 @@ config CRYPTO_CTR
 	tristate "CTR support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  CTR: Counter mode
 	  This block cipher algorithm is required for IPSec.
-- 
1.5.3.4
