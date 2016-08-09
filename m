From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 09:14:30 +0200
Message-ID: <4627645.oz3l49ICL3@tauon.atsec.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org
To: miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470726147-30095-2-git-send-email-miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 9. August 2016, 15:02:27 CEST schrieb miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org:

Hi Miaoqing,

> From: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW
> RNG, disable it by default. But we strongly recommand to enable
> it if the system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

As a short term solution:

Acked-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>

But as Jason outlined, there should be nothing that prevents using this code 
with the HW Random framework. This framework also has logic to limit the rate 
of injection and allows the setting of the entropy threshold at runtime.

> ---
>  drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
> b/drivers/net/wireless/ath/ath9k/Kconfig index f68cb00..8f231c6 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -180,7 +180,7 @@ config ATH9K_HTC_DEBUGFS
>  config ATH9K_HWRNG
>  	bool "Random number generator support"
>  	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
> -	default y
> +	default n
>  	---help---
>  	  This option incorporates the ADC register output as a source of
>  	  randomness into Linux entropy pool (/dev/urandom and /dev/random)



Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
