From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/39] ARM: ux500: Remove recently unused stedma40_xfer_dir enums
Date: Wed, 15 May 2013 10:51:55 +0100
Message-ID: <1368611522-9984-33-git-send-email-lee.jones@linaro.org>
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

We're now using the transfer direction definitions provided by the DMA
sub-system, so the home-brew ones have become obsolete.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/platform_data/dma-ste-dma40.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 288dc24..54ddca6 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -77,14 +77,6 @@ enum stedma40_periph_data_width {
 	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
 };
 
-enum stedma40_xfer_dir {
-	STEDMA40_MEM_TO_MEM = 1,
-	STEDMA40_MEM_TO_PERIPH,
-	STEDMA40_PERIPH_TO_MEM,
-	STEDMA40_PERIPH_TO_PERIPH
-};
-
-
 /**
  * struct stedma40_half_channel_info - dst/src channel configuration
  *
@@ -120,7 +112,7 @@ struct stedma40_half_channel_info {
  *
  */
 struct stedma40_chan_cfg {
-	enum stedma40_xfer_dir			 dir;
+	enum dma_transfer_direction		 dir;
 	bool					 high_priority;
 	bool					 realtime;
 	enum stedma40_mode			 mode;
-- 
1.7.10.4
