From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] DRBG: simplify ordering of linked list in drbg_ctr_df
Date: Wed, 25 Jun 2014 17:08:28 +0800
Message-ID: <20140625090828.GD8727@gondor.apana.org.au>
References: <5069712.neqH4zuI9U@myon.chronox.de>
 <280704396.67z02n3FAf@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Rafael Aquini <aquini@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <280704396.67z02n3FAf@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 23, 2014 at 09:11:29AM +0200, Stephan Mueller wrote:
> As reported by a static code analyzer, the code for the ordering of
> the linked list can be simplified.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index faaa2ce..99fa8f8 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -516,13 +516,13 @@ static int drbg_ctr_df(struct drbg_state *drbg,
>  	S2.next = addtl;
>  
>  	/*
> -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> -	 * input data chain
> +	 * Splice in addtl between S2 and S4 -- we place S4 at the end
> +	 * of the input data chain. As this code is only triggered when
> +	 * addtl is not NULL, no NULL checks are necessary.
>  	 */
>  	tempstr = addtl;
> -	for (; NULL != tempstr; tempstr = tempstr->next)
> -		if (NULL == tempstr->next)
> -			break;
> +	while (tempstr->next)
> +		tempstr = tempstr->next;
>  	tempstr->next = &S4;

This is still broken.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
