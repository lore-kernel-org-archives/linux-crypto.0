From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 linux-next] hwrng: update Freescale i.MX RNGA Random Number Generator
Date: Tue, 16 Aug 2016 21:49:45 +0200
Message-ID: <1471376985-7791-1-git-send-email-fabf@skynet.be>
Cc: linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, fabf@skynet.be
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We can directly depend on SOC_IMX31 since commit c9ee94965dce
("ARM: imx: deconstruct mxc_rnga initialization")

Since that commit, CONFIG_HW_RANDOM_MXC_RNGA could not be switched on
with unknown symbol ARCH_HAS_RNGA and mxc-rnga.o can't be generated with
ARCH=arm make M=drivers/char/hw_random
Previously, HW_RANDOM_MXC_RNGA required ARCH_HAS_RNGA
which was based on IMX_HAVE_PLATFORM_MXC_RNGA  && ARCH_MXC.
IMX_HAVE_PLATFORM_MXC_RNGA  was based on SOC_IMX31.

Fixes: c9ee94965dce ("ARM: imx: deconstruct mxc_rnga initialization")
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
-Cc to linux-crypto (suggested by Herbert Xu)
-Adding "Fixes:" (suggested by Arnd Bergmann)
-This patch appeared in 4.8-rc1 (not in stable yet)
-Improving patch description

 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 56ad5a59..8c0770b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -244,7 +244,7 @@ config HW_RANDOM_TX4939
 
 config HW_RANDOM_MXC_RNGA
 	tristate "Freescale i.MX RNGA Random Number Generator"
-	depends on ARCH_HAS_RNGA
+	depends on SOC_IMX31
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-- 
2.8.1
