From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: bcm: Constify *hash_alg_name[]
Date: Fri, 9 Mar 2018 22:29:55 +0800
Message-ID: <20180309142954.GA12852@gondor.apana.org.au>
References: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
 <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, steven.lin1@broadcom.com,
        arvind.yadav.cs@gmail.com, colin.king@canonical.com,
        raveendra.padasalagi@broadcom.com, ray.jui@broadcom.com,
        scott.branden@broadcom.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: =?iso-8859-1?Q?Hern=E1n?= Gonzalez <hernan@vanguardiasur.com.ar>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 27, 2018 at 07:01:27PM -0300, Hernán Gonzalez wrote:
> Note: This is compile only tested.
> No gain from this except some self-documenting.
> 
> Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
> ---
>  drivers/crypto/bcm/spu.c | 5 +++--
>  drivers/crypto/bcm/spu.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
> index efaf3cf..c7bb79e 100644
> --- a/drivers/crypto/bcm/spu.c
> +++ b/drivers/crypto/bcm/spu.c
> @@ -23,8 +23,9 @@
>  #include "cipher.h"
>  
>  /* This array is based on the hash algo type supported in spu.h */
> -char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
> -	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
> +char const * const hash_alg_name[] = { "None", "md5", "sha1", "sha224",

Please make that

	const char *const

Ditto with patch 4.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
