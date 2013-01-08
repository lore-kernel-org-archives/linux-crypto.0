From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 08/10] crypto: omap-aes - Convert to dma_request_slave_channel_compat()
Date: Tue,  8 Jan 2013 11:57:45 -0700
Message-ID: <1357671467-32363-9-git-send-email-mgreer@animalcreek.com>
References: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, russ.dill@gmail.com,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Use the dma_request_slave_channel_compat() call instead of
the dma_request_channel() call to request a DMA channel.
This allows the omap-aes driver use different DMA engines.

CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index dfebd40..d34aa5d 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -296,15 +296,19 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dd->dma_lch_in = dma_request_channel(mask, omap_dma_filter_fn,
-					     &dd->dma_in);
+	dd->dma_lch_in = dma_request_slave_channel_compat(mask,
+							  omap_dma_filter_fn,
+							  &dd->dma_in,
+							  dd->dev, "rx");
 	if (!dd->dma_lch_in) {
 		dev_err(dd->dev, "Unable to request in DMA channel\n");
 		goto err_dma_in;
 	}
 
-	dd->dma_lch_out = dma_request_channel(mask, omap_dma_filter_fn,
-					     &dd->dma_out);
+	dd->dma_lch_out = dma_request_slave_channel_compat(mask,
+							   omap_dma_filter_fn,
+							   &dd->dma_out,
+							   dd->dev, "tx");
 	if (!dd->dma_lch_out) {
 		dev_err(dd->dev, "Unable to request out DMA channel\n");
 		goto err_dma_out;
-- 
1.7.12

