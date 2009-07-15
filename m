From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 27/35] crypto: cryptd - Switch to template create API
Date: Wed, 15 Jul 2009 10:47:23 +0200
Message-ID: <20090715084723.GK20288@secunet.com>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyiz-00051d-KJ@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43406 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZGOIoo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 04:44:44 -0400
Content-Disposition: inline
In-Reply-To: <E1MQyiz-00051d-KJ@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 03:16:21PM +0800, Herbert Xu wrote:
> crypto: cryptd - Switch to template create API
> 
> This patch changes cryptd to use the template->create function
> instead of alloc in anticipation for the switch to new style
> ahash algorithms.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/cryptd.c         |   53 ++++++++++++++++++++++++++----------------------
>  crypto/internal.h       |    3 --
>  include/crypto/algapi.h |    3 ++
>  3 files changed, 32 insertions(+), 27 deletions(-)
> 
> diff --git a/crypto/cryptd.c b/crypto/cryptd.c
> index 6e6722e..ad58f51 100644
> --- a/crypto/cryptd.c
> +++ b/crypto/cryptd.c
> @@ -287,8 +287,9 @@ out_free_inst:
>  	goto out;
>  }
>  
> -static struct crypto_instance *cryptd_alloc_blkcipher(
> -	struct rtattr **tb, struct cryptd_queue *queue)
> +static int cryptd_create_blkcipher(struct crypto_template *tmpl,
> +				   struct rtattr **tb,
> +				   struct cryptd_queue *queue)
>  {
>  	struct cryptd_instance_ctx *ctx;
>  	struct crypto_instance *inst;
> @@ -298,7 +299,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
>  	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
>  				  CRYPTO_ALG_TYPE_MASK);
>  	if (IS_ERR(alg))
> -		return ERR_CAST(alg);
> +		return PTR_ERR(alg);
>  
>  	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
>  	if (IS_ERR(inst))
> @@ -330,14 +331,16 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
>  	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
>  	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
>  
> +	err = crypto_register_instance(tmpl, inst);
> +	if (err) {
> +		crypto_drop_spawn(&ctx->spawn);
> +out_free_inst:
> +		kfree(inst);
> +	}
> +
>  out_put_alg:
>  	crypto_mod_put(alg);
> -	return inst;
> -
> -out_free_inst:
> -	kfree(inst);
> -	inst = ERR_PTR(err);
> -	goto out_put_alg;
> +	return err;

This introduces an uninitialized return value warning. err is not initialized
if cryptd_alloc_instance() fails.

>  }
>  
>  static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
> @@ -502,8 +505,8 @@ static int cryptd_hash_digest_enqueue(struct ahash_request *req)
>  	return cryptd_hash_enqueue(req, cryptd_hash_digest);
>  }
>  
> -static struct crypto_instance *cryptd_alloc_hash(
> -	struct rtattr **tb, struct cryptd_queue *queue)
> +static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
> +			      struct cryptd_queue *queue)
>  {
>  	struct hashd_instance_ctx *ctx;
>  	struct crypto_instance *inst;
> @@ -513,7 +516,7 @@ static struct crypto_instance *cryptd_alloc_hash(
>  
>  	salg = shash_attr_alg(tb[1], 0, 0);
>  	if (IS_ERR(salg))
> -		return ERR_CAST(salg);
> +		return PTR_ERR(salg);
>  
>  	alg = &salg->base;
>  	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
> @@ -542,34 +545,36 @@ static struct crypto_instance *cryptd_alloc_hash(
>  	inst->alg.cra_ahash.setkey = cryptd_hash_setkey;
>  	inst->alg.cra_ahash.digest = cryptd_hash_digest_enqueue;
>  
> +	err = crypto_register_instance(tmpl, inst);
> +	if (err) {
> +		crypto_drop_shash(&ctx->spawn);
> +out_free_inst:
> +		kfree(inst);
> +	}
> +
>  out_put_alg:
>  	crypto_mod_put(alg);
> -	return inst;
> -
> -out_free_inst:
> -	kfree(inst);
> -	inst = ERR_PTR(err);
> -	goto out_put_alg;
> +	return err;

Same here.
I'll send a patch to fix it.

