From: "Ming Ma (mingma)" <mingma@micron.com>
Subject: RE: [PATCH 1/1] crypto: If two strings are exact match, they must
 have same length.
Date: Mon, 27 Mar 2017 23:04:30 +0000
Message-ID: <f44f9db26fbc4310bc233374d1d459d0@bowex17b.micron.com>
References: <1490132440-112761-1-git-send-email-mingma@micron.com>
 <20170322030040.GB29214@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170322030040.GB29214@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Please ignore this patch, we have seen some issues in older verison of linux kernel. But it doesn't seem to be an issue in the latest kernel.

thanks

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Tuesday, March 21, 2017 8:01 PM
To: Ming Ma (mingma) <mingma@micron.com>
Cc: davem@davemloft.net; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: If two strings are exact match, they must have same length.

On Tue, Mar 21, 2017 at 04:40:40PM -0500, Ming Ma wrote:
> When both "crct10dif-pclmul" algorithm and "crct10dif-generic" 
> algorithm exist in crypto_alg_list, "crct10dif-pclmul" should be 
> selected, since it has higher priority than "crct10dif-generic". 
> However, both algorithms have the same cra_name "crct10dif". If we use 
> "crct10dif" to find a matched algorithm in crypto_alg_list, it's 
> possible "crct10dif-generic" is selected, because the code calls 
> strcmp to decide if two string are exact match, but doesn't check if two strings have the same length.
> 
> exact = !strcmp(q->cra_driver_name, name);
> 
> So ,if "crct10dif-generic" is in front of "crct10dif-pclmul" in 
> crypto_alg_list, it will be picked as the matched algorithm, even if 
> it has lower priority than "crct10dif-pclmul".
> Signed-off-by: Ming Ma <mingma@micron.com>
> ---
>  crypto/api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c index b16ce16..5b3d45a 100644
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
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
