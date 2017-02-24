From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] crypto: CRYPTO_DEV_MEDIATEK should depend on HAS_DMA
Date: Fri, 24 Feb 2017 11:27:39 +0100
Message-ID: <1487932059-31522-2-git-send-email-geert@linux-m68k.org>
References: <1487932059-31522-1-git-send-email-geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:50338 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdBXK2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 05:28:44 -0500
In-Reply-To: <1487932059-31522-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If NO_DMA=y:

    ERROR: "bad_dma_ops" [drivers/crypto/mediatek/mtk-crypto.ko] undefined!

Add a dependency on HAS_DMA to fix this.

Fixes: 7dee9f618790d0b7 ("crypto: mediatek - remove ARM dependencies")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 69f7fc0dc84dc3b9..a7ff6e5d0ba92cb7 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -571,6 +571,7 @@ config CRYPTO_DEV_ROCKCHIP
 
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
+	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
-- 
2.7.4
