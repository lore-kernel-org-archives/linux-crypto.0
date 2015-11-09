From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 12/13] [media] omap3isp: Support for deferred probing when requesting DMA channel
Date: Mon, 09 Nov 2015 21:50:12 +0200
Message-ID: <11319647.puY9n5DpsR@avalon>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <1432646768-12532-13-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1432646768-12532-13-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Peter,

Thank you for the patch.

What happened to this patch series ? It looks like 
dma_request_slave_channel_compat_reason() isn't in mainline, so I can't apply 
this patch.

I'll mark this patch as deferred in patchwork, please resubmit it if you 
resubmit the series (and by the look of it the issue you're trying to fix 
still exists, so it would be nice if you could get it eventually fixed).

On Tuesday 26 May 2015 16:26:07 Peter Ujfalusi wrote:
> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
> channel. Only fall back to pio mode if the error code returned is not
> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/platform/omap3isp/isphist.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isphist.c
> b/drivers/media/platform/omap3isp/isphist.c index
> 7138b043a4aa..e690ca13af0e 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -499,14 +499,20 @@ int omap3isp_hist_init(struct isp_device *isp)
>  		if (res)
>  			sig = res->start;
> 
> -		hist->dma_ch = dma_request_slave_channel_compat(mask,
> +		hist->dma_ch = dma_request_slave_channel_compat_reason(mask,
>  				omap_dma_filter_fn, &sig, isp->dev, "hist");
> -		if (!hist->dma_ch)
> +		if (IS_ERR(hist->dma_ch)) {
> +			ret = PTR_ERR(hist->dma_ch);
> +			if (ret == -EPROBE_DEFER)
> +				return ret;
> +
> +			hist->dma_ch = NULL;
>  			dev_warn(isp->dev,
>  				 "hist: DMA channel request failed, using PIO\n");
> -		else
> +		} else {
>  			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
>  				dma_chan_name(hist->dma_ch));
> +		}
>  	}
> 
>  	hist->ops = &hist_ops;

-- 
Regards,

Laurent Pinchart

