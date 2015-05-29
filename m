From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Fri, 29 May 2015 15:03:17 +0530
Message-ID: <20150529093317.GF3140@localhost>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbE2JcL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 05:32:11 -0400
Content-Disposition: inline
In-Reply-To: <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
> dma_request_slave_channel_compat() 'eats' up the returned error codes which
> prevents drivers using the compat call to be able to do deferred probing.
> 
> The new wrapper is identical in functionality but it will return with error
> code in case of failure and will pass the -EPROBE_DEFER to the caller in
> case dma_request_slave_channel_reason() returned with it.
This is okay but am worried about one more warpper, how about fixing
dma_request_slave_channel_compat()


-- 
~Vinod
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  include/linux/dmaengine.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index abf63ceabef9..6c777394835c 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -1120,4 +1120,26 @@ static inline struct dma_chan
>  
>  	return __dma_request_channel(mask, fn, fn_param);
>  }
> +
> +#define dma_request_slave_channel_compat_reason(mask, x, y, dev, name) \
> +	__dma_request_slave_channel_compat_reason(&(mask), x, y, dev, name)
> +
> +static inline struct dma_chan
> +*__dma_request_slave_channel_compat_reason(const dma_cap_mask_t *mask,
> +				  dma_filter_fn fn, void *fn_param,
> +				  struct device *dev, char *name)
> +{
> +	struct dma_chan *chan;
> +
> +	chan = dma_request_slave_channel_reason(dev, name);
> +	/* Try via legacy API if not requesting for deferred probing */
> +	if (IS_ERR(chan) && PTR_ERR(chan) != -EPROBE_DEFER)
> +		chan = __dma_request_channel(mask, fn, fn_param);
> +
> +	if (!chan)
> +		chan = ERR_PTR(-ENODEV);
> +
> +	return chan;
> +}
> +
>  #endif /* DMAENGINE_H */
> -- 
> 2.3.5
> 

-- 
