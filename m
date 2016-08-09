From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Tue, 9 Aug 2016 18:06:33 +0800
Message-ID: <20160809100633.GA6751@gondor.apana.org.au>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, tony@atomide.com,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58626 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbcHIKGw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 06:06:52 -0400
Content-Disposition: inline
In-Reply-To: <1470306526-27219-4-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 04, 2016 at 01:28:38PM +0300, Tero Kristo wrote:
> Context export/import are now required for ahash algorithms due to
> required support in algif_hash. Implement these for OMAP SHA driver,
> saving and restoring the internal state of the driver.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  drivers/crypto/omap-sham.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 6e53944..aa71e61 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1379,6 +1379,27 @@ exit_unlock:
>  	return ret;
>  }
>  
> +static int omap_sham_export(struct ahash_request *req, void *out)
> +{
> +	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
> +
> +	while (omap_sham_flush(req) == -EINPROGRESS)
> +		msleep(10);

Do we really need this? You must not call export until the previous
operation has completed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
