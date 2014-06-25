From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Date: Wed, 25 Jun 2014 17:06:46 +0800
Message-ID: <20140625090646.GB8727@gondor.apana.org.au>
References: <20140620202418.GZ5015@mwanda>
 <4892293.kf6KiPx6BS@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4892293.kf6KiPx6BS@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> The handling of additional input data / personalization string data may
> be subject to a NULL pointer deference for the CTR DRBG. The
> caller-provided data may be NULL which must be caught by the DRBG.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index faaa2ce..8e7c302 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -513,17 +513,20 @@ static int drbg_ctr_df(struct drbg_state *drbg,
>  	drbg_string_fill(&S2, L_N, sizeof(L_N));
>  	drbg_string_fill(&S4, pad, padlen);
>  	S1.next = &S2;
> -	S2.next = addtl;
>  
> -	/*
> -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> -	 * input data chain
> -	 */
> -	tempstr = addtl;
> -	for (; NULL != tempstr; tempstr = tempstr->next)
> -		if (NULL == tempstr->next)
> -			break;
> -	tempstr->next = &S4;
> +	if (NULL == addtl) {
> +		S2.next = &S4;
> +	} else {
> +		/*
> +		 * splice in addtl between S2 and S4 -- we place S4 at the end
> +		 * of the input data chain
> +		 */
> +		S2.next = addtl;
> +		tempstr = addtl;
> +		while (tempstr->next)
> +			tempstr = tempstr->next;
> +		tempstr->next = &S4;

You've still got exactly the same NULL dereference.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
