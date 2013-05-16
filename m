From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 03/39] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
Date: Thu, 16 May 2013 12:06:40 +0530
Message-ID: <20130516063640.GE14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-4-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.hengli.com.au, arnd@arndb.de,
	linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
	Dan Williams <djbw@fb.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Rabin Vincent <rabin@rab.in>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab3EPHMF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 03:12:05 -0400
Content-Disposition: inline
In-Reply-To: <1368611522-9984-4-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 10:51:26AM +0100, Lee Jones wrote:
> Using the dmaengine API, allocating and configuring a channel are two
> separate actions. Here we're removing logical channel configuration from
> the channel allocating routines.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
>  drivers/dma/ste_dma40.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index b7fe46b..ba84df8 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2040,6 +2040,9 @@ static int d40_config_memcpy(struct d40_chan *d40c)
>  		d40c->dma_cfg = dma40_memcpy_conf_log;
>  		d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
>  
> +		d40_log_cfg(&d40c->dma_cfg,
> +			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> +
>  	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
>  		   dma_has_cap(DMA_SLAVE, cap)) {
>  		d40c->dma_cfg = dma40_memcpy_conf_phy;
> @@ -2508,9 +2511,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>  	d40_set_prio_realtime(d40c);
>  
>  	if (chan_is_logical(d40c)) {
> -		d40_log_cfg(&d40c->dma_cfg,
> -			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> -
>  		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
>  			d40c->lcpa = d40c->base->lcpa_base +
>  				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
> -- 
> 1.7.10.4
> 
