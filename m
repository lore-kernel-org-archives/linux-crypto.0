From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: ssi_hash: remove unnecessary parentheses
Date: Mon, 8 Jan 2018 16:07:53 +0100
Message-ID: <20180108150753.GA22928@kroah.com>
References: <20171228102417.GA10407@ewexler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Elad Wexler <elad.wexler@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbeAHPHv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 10:07:51 -0500
Content-Disposition: inline
In-Reply-To: <20171228102417.GA10407@ewexler>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 28, 2017 at 12:24:17PM +0200, Elad Wexler wrote:
> Fixed a coding style issue
> 
> Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
> ---
>  drivers/staging/ccree/ssi_hash.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Why did you send this twice?

> diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
> index 2035835..8d56fa7 100644
> --- a/drivers/staging/ccree/ssi_hash.c
> +++ b/drivers/staging/ccree/ssi_hash.c
> @@ -2280,8 +2280,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
>  				      &hash_handle->hash_list);
>  		}
>  
> -		if ((hw_mode == DRV_CIPHER_XCBC_MAC) ||
> -		    (hw_mode == DRV_CIPHER_CMAC))
> +		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
> +		    hw_mode == DRV_CIPHER_CMAC)

No, now I have to go look up if == or || comes in which order.  Ick,
just leave it as-is please.

thanks,

greg k-h
