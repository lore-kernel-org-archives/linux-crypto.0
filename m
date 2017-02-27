From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: cbc - Propagate NEED_FALLBACK bit
Date: Mon, 27 Feb 2017 17:51:36 +0800
Message-ID: <20170227095136.GA31553@gondor.apana.org.au>
References: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
 <1488157399-3587-2-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488157399-3587-2-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Feb 26, 2017 at 10:03:18PM -0300, Marcelo Henrique Cerri wrote:
> When requesting a fallback algorithm, we should propagate the
> NEED_FALLBACK bit when search for the underlying algorithm.
> 
> This will prevents drivers from allocating unnecessary fallbacks that
> are never called. For instance, currently the vmx-crypto driver will use
> the following chain of calls when calling the fallback implementation:
> 
> p8_aes_cbc -> cbc(p8_aes) -> aes-generic
> 
> However p8_aes will always delegate its calls to aes-generic. With this
> patch, p8_aes_cbc will be able to use cbc(aes-generic) directly as its
> fallback. The same applies to aes_s390.
> 
> Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> ---
>  crypto/cbc.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/cbc.c b/crypto/cbc.c
> index bc160a3..7147842 100644
> --- a/crypto/cbc.c
> +++ b/crypto/cbc.c
> @@ -108,24 +108,32 @@ static void crypto_cbc_free(struct skcipher_instance *inst)
>  static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
>  {
>  	struct skcipher_instance *inst;
> +	struct crypto_attr_type *algt;
>  	struct crypto_spawn *spawn;
>  	struct crypto_alg *alg;
> +	u32 mask;
>  	int err;
>  
>  	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER);
>  	if (err)
>  		return err;
>  
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return PTR_ERR(algt);
> +
> +	mask = CRYPTO_ALG_TYPE_MASK |
> +		crypto_requires_off(algt->type, algt->mask,
> +				    CRYPTO_ALG_NEED_FALLBACK);
> +
> +	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
> +	if (IS_ERR(alg))
> +		return PTR_ERR(alg);
> +
>  	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
>  	if (!inst)
>  		return -ENOMEM;

You're leaking alg if the kzalloc of inst fails.  Easiest fix
would be to do crypto_get_attr_alg after the kzalloc as is the
status quo.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
