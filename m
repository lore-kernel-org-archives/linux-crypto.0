From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 13/13] ASoC: omap-pcm: Switch to use dma_request_slave_channel_compat_reason()
Date: Tue, 26 May 2015 16:26:08 +0300
Message-ID: <1432646768-12532-14-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Jarkko Nikula <jarkko.nikula-FVTvWyuFUl3QT0dZR+AlfA@public.gmane.org>,
	Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

dmaengine provides a wrapper function to handle DT and non DT boots when
requesting DMA channel. Use that instead of checking for of_node in the
platform driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
CC: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Jarkko Nikula <jarkko.nikula-FVTvWyuFUl3QT0dZR+AlfA@public.gmane.org>
CC: Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 sound/soc/omap/omap-pcm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 52fd7cbbd1f4..ae04834f4697 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -132,6 +132,7 @@ static int omap_pcm_open(struct snd_pcm_substream *substream)
 	struct snd_dmaengine_dai_dma_data *dma_data;
 	struct dma_slave_caps dma_caps;
 	struct dma_chan *chan;
+	dma_cap_mask_t mask;
 	u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
 			  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
 			  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
@@ -139,12 +140,15 @@ static int omap_pcm_open(struct snd_pcm_substream *substream)
 
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
-	if (rtd->cpu_dai->dev->of_node)
-		chan = dma_request_slave_channel(rtd->cpu_dai->dev,
-						 dma_data->filter_data);
-	else
-		chan = snd_dmaengine_pcm_request_channel(omap_dma_filter_fn,
-							 dma_data->filter_data);
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_CYCLIC, mask);
+	chan = dma_request_slave_channel_compat_reason(mask, omap_dma_filter_fn,
+				dma_data->filter_data, rtd->cpu_dai->dev,
+				dma_data->filter_data);
+
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
 
 	if (!dma_get_slave_caps(chan, &dma_caps)) {
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-- 
2.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
