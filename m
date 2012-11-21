From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/7] crypto: omap-aes: Remove cpu_is/omap_type check
 from driver
Date: Tue, 20 Nov 2012 17:03:43 -0800
Message-ID: <20121121010343.GS18567@atomide.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
 <1353351832-6685-5-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:55452 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752434Ab2KUBDu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2012 20:03:50 -0500
Content-Disposition: inline
In-Reply-To: <1353351832-6685-5-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Mark A. Greer <mgreer@animalcreek.com> [121119 11:06]:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> The omap-aes driver should not check the CPU class or the
> type of OMAP device its on.  The platform code should do
> that instead.

Similar patch for this one too should be queued already.

Regards,

Tony
 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-aes.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 093a8af..628c3cc 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -941,11 +941,6 @@ static int __init omap_aes_mod_init(void)
>  {
>  	pr_info("loading %s driver\n", "omap-aes");
>  
> -	if (!cpu_class_is_omap2() || omap_type() != OMAP2_DEVICE_TYPE_SEC) {
> -		pr_err("Unsupported cpu\n");
> -		return -ENODEV;
> -	}
> -
>  	return  platform_driver_register(&omap_aes_driver);
>  }
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
