From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: cavium/nitrox - Remove default m setting from Kconfig
Date: Mon, 10 Jul 2017 18:15:32 +0800
Message-ID: <20170710101532.GA15004@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35390 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdGJKP7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 06:15:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Drivers should not enable themselves by default, unless they're
an integral part of the platform.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/cavium/nitrox/Kconfig b/drivers/crypto/cavium/nitrox/Kconfig
index 731e6a5..181a1df 100644
--- a/drivers/crypto/cavium/nitrox/Kconfig
+++ b/drivers/crypto/cavium/nitrox/Kconfig
@@ -12,7 +12,6 @@ config CRYPTO_DEV_NITROX_CNN55XX
 	tristate "Support for Cavium CNN55XX driver"
 	depends on PCI_MSI && 64BIT
 	select CRYPTO_DEV_NITROX
-	default m
 	help
 	  Support for Cavium NITROX family CNN55XX driver
 	  for accelerating crypto workloads.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
