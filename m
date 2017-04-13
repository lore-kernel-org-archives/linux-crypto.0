From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] crypto: chcr - Improve error checking
Date: Thu, 13 Apr 2017 17:03:05 +0300
Message-ID: <20170413140304.njbdwa3k5vhgxmw6@mwanda>
References: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
 <71c63ef360ba033c1321e9792228b1e7b728c88e.1492085165.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        harsh@chelsio.com, hariprasad@chelsio.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <71c63ef360ba033c1321e9792228b1e7b728c88e.1492085165.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 13, 2017 at 02:14:19PM +0200, Christophe JAILLET wrote:
> 'chcr_alloc_shash()' can return NULL. Here it is not possible because this
> code is reached only if 'get_alg_config()' a few lines above has succeeded.
> So we are garanteed that the value of 'max_authsize' is a correct
> parameter.
> Anyway, this is harmless to add a check for NULL.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 41bc7f4f58cd..f19590ac8775 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -2294,7 +2294,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
>  			    aeadctx->enckey_len << 3);
>  
>  	base_hash  = chcr_alloc_shash(max_authsize);
> -	if (IS_ERR(base_hash)) {
> +	if (IS_ERR_OR_NULL(base_hash)) {
>  		pr_err("chcr : Base driver cannot be loaded\n");
>  		goto out;

Ugh...  When you mix NULL and error pointers, it should be because NULL
is a valid return.  We should change chcr_alloc_shash() to return
ERR_PTR(-EINVAL) instead of NULL.

Also the "goto out;" is buggy, of course.  The problem with magical free
everything style error handling is that "base_hash" wasn't allocated so
this will oops for both NULL and error pointers.

regards,
dan carpenter
