From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] crypto/omap aes: select BLKCIPHER2
Date: Wed, 31 Oct 2012 20:08:37 +0100
Message-ID: <1351710517-9516-1-git-send-email-bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:59300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2JaTIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Oct 2012 15:08:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

without it:
|drivers/built-in.o:(.data+0x14588): undefined reference to `crypto_ablkcipher_type'
|drivers/built-in.o:(.data+0x14668): undefined reference to `crypto_ablkcipher_type'

Not sure when this broke.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 308c7fb..ac7235a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -254,6 +254,7 @@ config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER2
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
-- 
1.7.10.4
