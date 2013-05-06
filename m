From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/2] crypto: mv_cesa: remove unnecessary
 platform_set_drvdata()
Date: Mon, 6 May 2013 07:12:01 +0200
Message-ID: <20130506051201.GD2824@lunn.ch>
References: <002501ce4a0c$994cc010$cbe64030$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Herbert Xu' <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Phil Sutter' <phil.sutter@viprinet.com>,
	'Andrew Lunn' <andrew@lunn.ch>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:51699 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3EFFMQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 May 2013 01:12:16 -0400
Content-Disposition: inline
In-Reply-To: <002501ce4a0c$994cc010$cbe64030$@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 06, 2013 at 12:48:41PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/crypto/mv_cesa.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> index ce6290e..3374a3e 100644
> --- a/drivers/crypto/mv_cesa.c
> +++ b/drivers/crypto/mv_cesa.c
> @@ -1146,7 +1146,6 @@ err_unmap_reg:
>  err:
>  	kfree(cp);
>  	cpg = NULL;
> -	platform_set_drvdata(pdev, NULL);
>  	return ret;
>  }
>  

Acked-by: Andrew Lunn <andrew@lunn.ch>
