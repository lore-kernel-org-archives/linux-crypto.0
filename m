From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 02/13] dmaengine: Introduce
	dma_request_slave_channel_compat_reason()
Date: Tue, 26 May 2015 16:25:57 +0300
Message-ID: <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org, dmaengine@vger.kernel.org,
 dan.j.williams@intel.com, linux-omap@vger.kernel.org,
 linux-media@vger.kernel.org
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

dma_request_slave_channel_compat() 'eats' up the returned error codes which
prevents drivers using the compat call to be able to do deferred probing.

The new wrapper is identical in functionality but it will return with error
code in case of failure and will pass the -EPROBE_DEFER to the caller in
case dma_request_slave_channel_reason() returned with it.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/dmaengine.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index abf63ceabef9..6c777394835c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1120,4 +1120,26 @@ static inline struct dma_chan
 
 	return __dma_request_channel(mask, fn, fn_param);
 }
+
+#define dma_request_slave_channel_compat_reason(mask, x, y, dev, name) \
+	__dma_request_slave_channel_compat_reason(&(mask), x, y, dev, name)
+
+static inline struct dma_chan
+*__dma_request_slave_channel_compat_reason(const dma_cap_mask_t *mask,
+				  dma_filter_fn fn, void *fn_param,
+				  struct device *dev, char *name)
+{
+	struct dma_chan *chan;
+
+	chan = dma_request_slave_channel_reason(dev, name);
+	/* Try via legacy API if not requesting for deferred probing */
+	if (IS_ERR(chan) && PTR_ERR(chan) != -EPROBE_DEFER)
+		chan = __dma_request_channel(mask, fn, fn_param);
+
+	if (!chan)
+		chan = ERR_PTR(-ENODEV);
+
+	return chan;
+}
+
 #endif /* DMAENGINE_H */
-- 
2.3.5
