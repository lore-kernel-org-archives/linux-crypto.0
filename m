From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 02/19] crypto: khazad - Fix checkpatch errors
Date: Wed, 10 Mar 2010 18:27:23 +0800
Message-ID: <20100310102723.GB23298@gondor.apana.org.au>
References: <1266538903-3145-1-git-send-email-richih.mailinglist@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1266538903-3145-1-git-send-email-richih.mailinglist@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 19, 2010 at 01:21:41AM +0100, Richard Hartmann wrote:
> 
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
> ---
>  crypto/khazad.c |   71 +++++++++++++++++++++++++++----------------------------
>  1 files changed, 35 insertions(+), 36 deletions(-)
>
> @@ -810,25 +810,25 @@ static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
>  	state = be64_to_cpu(*src) ^ roundKey[0];
>  
>  	for (r = 1; r < KHAZAD_ROUNDS; r++) {
> -		state = T0[(int)(state >> 56)       ] ^
> -			T1[(int)(state >> 48) & 0xff] ^
> -			T2[(int)(state >> 40) & 0xff] ^
> -			T3[(int)(state >> 32) & 0xff] ^
> -			T4[(int)(state >> 24) & 0xff] ^
> -			T5[(int)(state >> 16) & 0xff] ^
> -			T6[(int)(state >>  8) & 0xff] ^
> -			T7[(int)(state      ) & 0xff] ^
> +		state = T0[(int)(state >> 56)] ^
> +			T1[(int)(state >> 48)&0xff] ^
> +			T2[(int)(state >> 40)&0xff] ^
> +			T3[(int)(state >> 32)&0xff] ^
> +			T4[(int)(state >> 24)&0xff] ^
> +			T5[(int)(state >> 16)&0xff] ^
> +			T6[(int)(state >>  8)&0xff] ^
> +			T7[(int)(state      )&0xff] ^
>  			roundKey[r];
> -    	}
> +		}

This indentation change is bogus.

> @@ -865,7 +865,6 @@ static struct crypto_alg khazad_alg = {
>  static int __init khazad_mod_init(void)
>  {
>  	int ret = 0;
> -	
>  	ret = crypto_register_alg(&khazad_alg);
>  	return ret;
>  }

What's this for?

Please review the all the rest of the patches for similar errors
and resubmit.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
