From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
Date: Wed, 15 May 2013 10:51:33 +0100
Message-ID: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
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

'struct stedma40_half_channel_info's header comment says that it's
called 'struct stedma40_chan_cfg'. Let's straighten that out.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/platform_data/dma-ste-dma40.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index af0064e..288dc24 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -86,7 +86,7 @@ enum stedma40_xfer_dir {
 
 
 /**
- * struct stedma40_chan_cfg - dst/src channel configuration
+ * struct stedma40_half_channel_info - dst/src channel configuration
  *
  * @big_endian: true if the src/dst should be read as big endian
  * @data_width: Data width of the src/dst hardware
-- 
1.7.10.4
