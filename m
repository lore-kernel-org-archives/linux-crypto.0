From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Fri, 3 Nov 2017 20:41:57 +0800
Message-ID: <20171103124157.GA8330@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Robert Baronescu <robert.baronescu@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37870 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755590AbdKCMm0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 08:42:26 -0400
Content-Disposition: inline
In-Reply-To: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 10, 2017 at 01:21:59PM +0300, Robert Baronescu wrote:
> In case buffer length is a multiple of PAGE_SIZE,
> the S/G table is incorrectly generated.
> Fix this by handling buflen = k * PAGE_SIZE separately.
> 
> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>
> ---
>  crypto/tcrypt.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 0022a18..bd9b66c 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -221,11 +221,13 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
>  	}
>  
>  	sg_init_table(sg, np + 1);
> -	np--;
> +	if (rem)
> +		np--;
>  	for (k = 0; k < np; k++)
>  		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
>  
> -	sg_set_buf(&sg[k + 1], xbuf[k], rem);
> +	if (rem)
> +		sg_set_buf(&sg[k + 1], xbuf[k], rem);

Sorry but I think this is still buggy because you have not moved the
end-of-table marking in the rem == 0 case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
