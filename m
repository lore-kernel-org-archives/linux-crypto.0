From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: If two strings are exact match, they must
 have same length.
Date: Wed, 22 Mar 2017 11:00:40 +0800
Message-ID: <20170322030040.GB29214@gondor.apana.org.au>
References: <1490132440-112761-1-git-send-email-mingma@micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Ming Ma <mingma@micron.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46403 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751192AbdCVDBA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 23:01:00 -0400
Content-Disposition: inline
In-Reply-To: <1490132440-112761-1-git-send-email-mingma@micron.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 04:40:40PM -0500, Ming Ma wrote:
> When both "crct10dif-pclmul" algorithm and "crct10dif-generic" algorithm
> exist in crypto_alg_list, "crct10dif-pclmul" should be selected, since it
> has higher priority than "crct10dif-generic". However, both algorithms
> have the same cra_name "crct10dif". If we use "crct10dif" to find a
> matched algorithm in crypto_alg_list, it's possible "crct10dif-generic" is
> selected, because the code calls strcmp to decide if two string are exact
> match, but doesn't check if two strings have the same length.
> 
> exact = !strcmp(q->cra_driver_name, name);
> 
> So ,if "crct10dif-generic" is in front of "crct10dif-pclmul" in
> crypto_alg_list, it will be picked as the matched algorithm, even if it has
> lower priority than "crct10dif-pclmul".
> Signed-off-by: Ming Ma <mingma@micron.com>
> ---
>  crypto/api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index b16ce16..5b3d45a 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -76,7 +76,8 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
>  		    ((struct crypto_larval *)q)->mask != mask)
>  			continue;
>  
> -		exact = !strcmp(q->cra_driver_name, name);
> +		exact = (strlen(name) == strlen(q->cra_driver_name)) &&
> +				!strcmp(q->cra_driver_name, name);
>  		fuzzy = !strcmp(q->cra_name, name);
>  		if (!exact && !(fuzzy && q->cra_priority > best))
>  			continue;

This is bogus.  Please describe how you reproduced the problem.

The priority matching should work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
