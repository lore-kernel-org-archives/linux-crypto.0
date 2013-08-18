From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 05/14] crypto: omap-aes: Sync SG before DMA operation
Date: Sat, 17 Aug 2013 21:42:26 -0500
Message-ID: <1376793755-30478-6-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Greer <mgreer@animalcreek.com>,
	Tony Lindgren <tony@atomide.com>,
	Santosh Shilimkar <santosh.shilimkar@ti.com>,
	Rajendra Nayak <rnayak@ti.com>,
	Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Earlier functions that did a similar sync are replaced by the dma_sync_sg_*
which can operate on entire SG list.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 64dd5c1..5e034a1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -489,6 +489,8 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 	struct dma_slave_config cfg;
 	int ret;
 
+	dma_sync_sg_for_device(dd->dev, dd->in_sg, in_sg_len, DMA_TO_DEVICE);
+
 	memset(&cfg, 0, sizeof(cfg));
 
 	cfg.src_addr = dd->phys_base + AES_REG_DATA_N(dd, 0);
@@ -676,6 +678,8 @@ static void omap_aes_done_task(unsigned long data)
 
 	pr_debug("enter done_task\n");
 
+	dma_sync_sg_for_cpu(dd->dev, dd->in_sg, dd->in_sg_len, DMA_FROM_DEVICE);
+
 	omap_aes_crypt_dma_stop(dd);
 	omap_aes_finish_req(dd, 0);
 	omap_aes_handle_queue(dd, NULL);
-- 
1.7.9.5
