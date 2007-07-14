From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] crypto/Kconfig: remove "default m"s
Date: Sat, 14 Jul 2007 06:53:50 +0200
Message-ID: <20070714045349.GF3565@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60729 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbXGNEyQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Jul 2007 00:54:16 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Other options requiring specific block cipher algorithms already have 
the appropriate select's.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 crypto/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.22-rc6-mm1/crypto/Kconfig.old	2007-07-14 06:24:23.000000000 +0200
+++ linux-2.6.22-rc6-mm1/crypto/Kconfig	2007-07-14 06:24:30.000000000 +0200
@@ -146,7 +146,6 @@
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  ECB: Electronic CodeBook mode
 	  This is the simplest block cipher algorithm.  It simply encrypts
@@ -156,7 +155,6 @@
 	tristate "CBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  CBC: Cipher Block Chaining mode
 	  This block cipher algorithm is required for IPSec.
@@ -165,7 +163,6 @@
 	tristate "PCBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  PCBC: Propagating Cipher Block Chaining mode
 	  This block cipher algorithm is required for RxRPC.
