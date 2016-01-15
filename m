From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] crypto: CRYPTO_DEV_ATMEL_AES should depend on HAS_DMA
Date: Fri, 15 Jan 2016 14:48:06 +0100
Message-ID: <1452865686-687-1-git-send-email-geert@linux-m68k.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:58289 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbcAONsL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 08:48:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If NO_DMA=y:

    ERROR: "dma_unmap_sg" [drivers/crypto/atmel-aes.ko] undefined!
    ERROR: "dma_map_sg" [drivers/crypto/atmel-aes.ko] undefined!

Add a dependency on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3dd69df9c970fa0e..07d494276aad0419 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -381,6 +381,7 @@ config CRYPTO_DEV_BFIN_CRC
 
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
+	depends on HAS_DMA
 	depends on AT_XDMAC || AT_HDMAC || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
-- 
1.9.1
