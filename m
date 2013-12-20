From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Fri, 20 Dec 2013 20:04:08 +0800
Message-ID: <20131220120408.GA31738@gondor.apana.org.au>
References: <1386703583-8386-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57896 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3LTMEj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Dec 2013 07:04:39 -0500
Content-Disposition: inline
In-Reply-To: <1386703583-8386-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 10, 2013 at 08:26:19PM +0100, Marek Vasut wrote:
> When finishing the ahash request, the ahash_op_unaligned_done() will
> call complete() on the request. Yet, this will not call the correct
> complete callback. The correct complete callback was previously stored
> in the requests' private data, as seen in ahash_op_unaligned(). This
> patch restores the correct complete callback and .data field of the
> request before calling complete() on it.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: linux-crypto@vger.kernel.org
> ---
>  crypto/ahash.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 793a27f..a92dc38 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -213,7 +213,10 @@ static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
>  
>  	ahash_op_unaligned_finish(areq, err);
>  
> -	complete(data, err);
> +	areq->base.complete = complete;
> +	areq->base.data = data;
> +
> +	complete(&areq->base, err);

This looks completely bogus.  While restoring areq isn't wrong per
se, calling complete with &areq->base makes no sense.  The original
completion data is in the variable "data".

Which driver relies on this behaviour?

Also, does your subsequent patches rely on this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
