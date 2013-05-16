From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
Date: Thu, 16 May 2013 12:12:17 +0530
Message-ID: <20130516064217.GH14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.hengli.com.au, arnd@arndb.de,
	linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 10:51:33AM +0100, Lee Jones wrote:
> 'struct stedma40_half_channel_info's header comment says that it's
> called 'struct stedma40_chan_cfg'. Let's straighten that out.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
>  include/linux/platform_data/dma-ste-dma40.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
> index af0064e..288dc24 100644
> --- a/include/linux/platform_data/dma-ste-dma40.h
> +++ b/include/linux/platform_data/dma-ste-dma40.h
> @@ -86,7 +86,7 @@ enum stedma40_xfer_dir {
>  
>  
>  /**
> - * struct stedma40_chan_cfg - dst/src channel configuration
> + * struct stedma40_half_channel_info - dst/src channel configuration
>   *
>   * @big_endian: true if the src/dst should be read as big endian
>   * @data_width: Data width of the src/dst hardware
> -- 
> 1.7.10.4
> 
