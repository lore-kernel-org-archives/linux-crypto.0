From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 05/27] crypto: omap-sham: avoid executing tasklet where
 not needed
Date: Fri, 24 Jun 2016 18:30:42 +0800
Message-ID: <20160624103042.GA19571@gondor.apana.org.au>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-6-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	tony@atomide.com, davem@davemloft.net, lokeshvutla@ti.com,
	linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57194 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcFXKav (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 06:30:51 -0400
Content-Disposition: inline
In-Reply-To: <1466601840-18486-6-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:23:38PM +0300, Tero Kristo wrote:
> Some of the call paths of OMAP SHA driver can avoid executing the next
> step of the crypto queue under tasklet; instead, execute the next step
> directly via function call. This avoids a costly round-trip via the
> scheduler giving a slight performance boost.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  drivers/crypto/omap-sham.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 6247887..84a0027 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -242,6 +242,8 @@ static struct omap_sham_drv sham = {
>  	.lock = __SPIN_LOCK_UNLOCKED(sham.lock),
>  };
>  
> +static void omap_sham_done_task(unsigned long data);
> +
>  static inline u32 omap_sham_read(struct omap_sham_dev *dd, u32 offset)
>  {
>  	return __raw_readl(dd->io_base + offset);
> @@ -1007,7 +1009,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
>  		req->base.complete(&req->base, err);
>  
>  	/* handle new request */
> -	tasklet_schedule(&dd->done_task);
> +	omap_sham_done_task((unsigned long)dd);
>  }

Hmm, what guarnatees that you won't run out of stack doing this?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
