From: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 35/39] dmaengine: ste_dma40_ll: Replace meaningless
 register set with comment
Date: Thu, 16 May 2013 10:48:20 +0530
Message-ID: <20130516051820.GH27639@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	balbi-l0cyMroinI0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
	linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org, srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org,
	Dan Williams <djbw-b10kYP2dOMg@public.gmane.org>,
	Per Forlin <per.forlin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>,
	Rabin Vincent <rabin-66gdRtMMWGc@public.gmane.org>
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1368611522-9984-36-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 10:51:58AM +0100, Lee Jones wrote:
> Unsure of the author's intentions, rather than just removing the nop,
> we're replacing it with a comment containing the possible intention
> of the statement OR:ing with 0.
Would be worthwhile to check w/ Linus W on this (or check whom to blame)

--
~Vinod
> 
> Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Dan Williams <djbw-b10kYP2dOMg@public.gmane.org>
> Cc: Per Forlin <per.forlin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
> Cc: Rabin Vincent <rabin-66gdRtMMWGc@public.gmane.org>
> Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/dma/ste_dma40_ll.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
> index a035dfe..27b818d 100644
> --- a/drivers/dma/ste_dma40_ll.c
> +++ b/drivers/dma/ste_dma40_ll.c
> @@ -182,8 +182,10 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
>  	else
>  		lli->reg_cfg &= ~BIT(D40_SREG_CFG_TIM_POS);
>  
> -	/* Post link */
> -	lli->reg_lnk |= 0 << D40_SREG_LNK_PHY_PRE_POS;
> +	/*
> +	 * Post link - D40_SREG_LNK_PHY_PRE_POS = 0
> +	 * Relink happens after transfer completion.
> +	 */
>  
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
