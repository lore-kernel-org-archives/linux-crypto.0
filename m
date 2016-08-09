From: Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 17:48:24 +0000
Message-ID: <20160809174824.GD2013@io.lakedaemon.net>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org
To: miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470726147-30095-2-git-send-email-miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 09, 2016 at 03:02:27PM +0800, miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> From: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW
> RNG, disable it by default. But we strongly recommand to enable
> it if the system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Until we get the hw_random/get_device_randomness question sorted...

Reviewed-by: Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>

thx,

Jason.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
