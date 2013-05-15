From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/39] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
Date: Wed, 15 May 2013 10:51:26 +0100
Message-ID: <1368611522-9984-4-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Rabin Vincent <rabin@rab.in>, linus.walleij@stericsson.com, arnd@arndb.de,
 srinidhi.kasagar@stericsson.com, Per Forlin <per.forlin@stericsson.com>,
 Dan Williams <djbw@fb.com>, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
 davem@davemloft.net, herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Using the dmaengine API, allocating and configuring a channel are two
separate actions. Here we're removing logical channel configuration from
the channel allocating routines.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b7fe46b..ba84df8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2040,6 +2040,9 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		d40c->dma_cfg = dma40_memcpy_conf_log;
 		d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
 
+		d40_log_cfg(&d40c->dma_cfg,
+			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
+
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
@@ -2508,9 +2511,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
-		d40_log_cfg(&d40c->dma_cfg,
-			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-
 		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
-- 
1.7.10.4
