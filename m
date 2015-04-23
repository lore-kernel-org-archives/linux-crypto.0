From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] crypto: CRYPTO_DEV_IMGTEC_HASH should depend on HAS_DMA
Date: Thu, 23 Apr 2015 20:03:58 +0200
Message-ID: <1429812238-9306-1-git-send-email-geert@linux-m68k.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:40459 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030210AbbDWSEC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 14:04:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If NO_DMA=y:

    drivers/built-in.o: In function `img_hash_write_via_dma_stop':
    img-hash.c:(.text+0xa2b822): undefined reference to `dma_unmap_sg'
    drivers/built-in.o: In function `img_hash_xmit_dma':
    img-hash.c:(.text+0xa2b8d8): undefined reference to `dma_map_sg'
    img-hash.c:(.text+0xa2b948): undefined reference to `dma_unmap_sg'

Also move the "depends" section below the "tristate" line while we're at
it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 800bf41718e185e8..033c0c86f6ec051a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -446,8 +446,9 @@ config CRYPTO_DEV_VMX
 source "drivers/crypto/vmx/Kconfig"
 
 config CRYPTO_DEV_IMGTEC_HASH
-	depends on MIPS || COMPILE_TEST
 	tristate "Imagination Technologies hardware hash accelerator"
+	depends on MIPS || COMPILE_TEST
+	depends on HAS_DMA
 	select CRYPTO_ALGAPI
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-- 
1.9.1
