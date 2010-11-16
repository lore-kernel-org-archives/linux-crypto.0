From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/5] crypto: omap-aes: change in prevention of OCP bus
 error
Date: Tue, 16 Nov 2010 09:13:55 -0800
Message-ID: <20101116171355.GR9264@atomide.com>
References: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
 <78e86640037f10904b37250f0c578c6e0ca2c256.1289409924.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59337 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0KPRON (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Nov 2010 12:14:13 -0500
Content-Disposition: inline
In-Reply-To: <78e86640037f10904b37250f0c578c6e0ca2c256.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

* Dmitry Kasatkin <dmitry.kasatkin@nokia.com> [101110 09:18]:
> Suggested to use udelay() instead of nop as on the higher
> core frequencies it might not be enough time.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> ---
>  drivers/crypto/omap-aes.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 799ca51..9d65611 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -26,6 +26,7 @@
>  #include <linux/io.h>
>  #include <linux/crypto.h>
>  #include <linux/interrupt.h>
> +#include <linux/delay.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/aes.h>
>  
> @@ -187,11 +188,12 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
>  		omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_SOFTRESET,
>  					AES_REG_MASK_SOFTRESET);
>  		/*
> -		 * prevent OCP bus error (SRESP) in case an access to the module
> -		 * is performed while the module is coming out of soft reset
> +		 * prevent OCP bus error (SRESP) on OMAP3630 in case an access
> +		 * to the module is performed while the module is
> +		 * coming out of soft reset
>  		 */
> -		__asm__ __volatile__("nop");
> -		__asm__ __volatile__("nop");
> +		if (cpu_is_omap3630())
> +			udelay(1);
>  
>  		err = omap_aes_wait(dd, AES_REG_SYSSTATUS,
>  				AES_REG_SYSSTATUS_RESETDONE);

Please don't add more cpu_is_omapxxxx tests into drivers, those
will be limited to arch/arm/*omap*/ platform init code soonish.
The drivers should be generic.

Instead, check the crypto hardware version during init. If that
does not work, pass u32 flags in the platform data and define
OMAP_AES_SOFT_RESET_ERROR bit.

Regards,

Tony
