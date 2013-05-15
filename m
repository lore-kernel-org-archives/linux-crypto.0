From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/39] ARM: ux500: Stop passing Cryp DMA channel config information though pdata
Date: Wed, 15 May 2013 10:51:40 +0100
Message-ID: <1368611522-9984-18-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

DMA channel configuration information should be setup in the driver.
The Ux500 Cryp driver now does this, so there's no need to send it
though here too.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index ec916ca..38e321c 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -426,20 +426,12 @@ static struct cryp_platform_data u8500_cryp1_platform_data = {
 		.mem_to_engine = {
 				.dir = STEDMA40_MEM_TO_PERIPH,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.src_info.data_width = STEDMA40_WORD_WIDTH,
-				.dst_info.data_width = STEDMA40_WORD_WIDTH,
 				.mode = STEDMA40_MODE_LOGICAL,
-				.src_info.psize = STEDMA40_PSIZE_LOG_4,
-				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
 		},
 		.engine_to_mem = {
 				.dir = STEDMA40_PERIPH_TO_MEM,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.src_info.data_width = STEDMA40_WORD_WIDTH,
-				.dst_info.data_width = STEDMA40_WORD_WIDTH,
 				.mode = STEDMA40_MODE_LOGICAL,
-				.src_info.psize = STEDMA40_PSIZE_LOG_4,
-				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
 		}
 };
 
-- 
1.7.10.4
