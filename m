From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: ccree: limit build to plausible archs
Date: Mon, 23 Apr 2018 12:48:17 +0100
Message-ID: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Limit option to compile ccree to plausible architectures.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d1ea1a0..7302785 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -726,6 +726,7 @@ config CRYPTO_DEV_ARTPEC6
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell family of security processors"
 	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
+	depends on (XTENSA || X86 || UNICORE32 || SUPERH || RISCV || PPC32 || OPENRISC || NIOS2 || NDS32 || MIPS || MICROBLAZE || HEXAGON || H8300 || ARM || ARM64 || ARC || COMPILE_TEST)
 	default n
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
-- 
2.7.4
