From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: reorder paes test lexicographically
Date: Tue, 15 May 2018 19:23:04 +0530
Message-ID: <1526392384.19317.3.camel@abdul>
References: <1526025847-13134-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org,
        linux-next <linux-next@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526025847-13134-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-05-11 at 09:04 +0100, Gilad Ben-Yossef wrote:
> Due to a snafu "paes" testmgr tests were not ordered
> lexicographically, which led to boot time warnings.
> Reorder the tests as needed.
> 
> Fixes: a794d8d ("crypto: ccree - enable support for hardware keys")
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  crypto/testmgr.c | 44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index c31da0f..b1b8ebb 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3012,13 +3012,6 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> -		/* Same as ecb(aes) except the key is stored in
> -		 * hardware secure memory which we reference by index
> -		 */
> -		.alg = "ecb(paes)",
> -		.test = alg_test_null,
> -		.fips_allowed = 1,
> -	}, {
>  		.alg = "ecb(khazad)",
>  		.test = alg_test_skcipher,
>  		.suite = {
> @@ -3028,6 +3021,13 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> +		/* Same as ecb(aes) except the key is stored in
> +		 * hardware secure memory which we reference by index
> +		 */
> +		.alg = "ecb(paes)",
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "ecb(seed)",
>  		.test = alg_test_skcipher,
>  		.suite = {
> @@ -3610,21 +3610,6 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> -		/* Same as xts(aes) except the key is stored in
> -		 * hardware secure memory which we reference by index
> -		 */
> -		.alg = "xts(paes)",
> -		.test = alg_test_null,
> -		.fips_allowed = 1,
> -	}, {
> -		.alg = "xts4096(paes)",
> -		.test = alg_test_null,
> -		.fips_allowed = 1,
> -	}, {
> -		.alg = "xts512(paes)",
> -		.test = alg_test_null,
> -		.fips_allowed = 1,
> -	}, {
>  		.alg = "xts(camellia)",
>  		.test = alg_test_skcipher,
>  		.suite = {
> @@ -3643,6 +3628,13 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> +		/* Same as xts(aes) except the key is stored in
> +		 * hardware secure memory which we reference by index
> +		 */
> +		.alg = "xts(paes)",
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "xts(serpent)",
>  		.test = alg_test_skcipher,
>  		.suite = {
> @@ -3679,6 +3671,14 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> +		.alg = "xts4096(paes)",
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
> +		.alg = "xts512(paes)",
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "zlib-deflate",
>  		.test = alg_test_comp,
>  		.fips_allowed = 1,


Gilad, 

The given patch fixes the boot warnings.

Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>

Thanks for the fix.

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
