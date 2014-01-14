From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/3] crypto: Fix the pointer voodoo in unaligned ahash
Date: Tue, 14 Jan 2014 13:35:50 -0600
Message-ID: <1755989.ess5rJDo4G@tlendack-t1>
References: <1389720829-5963-1-git-send-email-marex@denx.de> <1389720829-5963-2-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: <linux-arm-kernel@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:17963
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbaANTgH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 14:36:07 -0500
In-Reply-To: <1389720829-5963-2-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Tuesday, January 14, 2014 06:33:47 PM Marek Vasut wrote:
> Add documentation for the pointer voodoo that is happening in crypto/ahash.c
> in ahash_op_unaligned(). This code is quite confusing, so add a beefy chunk
> of documentation.
> 
> Moreover, make sure the mangled request is completely restored after finishing
> this unaligned operation. This means restoring all of .result, .priv, .base.data
> and .base.complete .
> 
> Also, remove the crypto_completion_t complete = ... line present in the
> ahash_op_unaligned_done() function. This type actually declares a function
> pointer, which is very confusing.
> 
> Finally, yet very important nonetheless, make sure the req->priv is free()'d
> only after the original request is restored in ahash_op_unaligned_done().
> The req->priv data must not be free()'d before that in ahash_op_unaligned_finish(),
> since we would be accessing previously free()'d data in ahash_op_unaligned_done()
> and cause corruption.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  crypto/ahash.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 54 insertions(+), 11 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a92dc38..5ca8ede 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -29,6 +29,7 @@
>  struct ahash_request_priv {
>  	crypto_completion_t complete;
>  	void *data;
> +	void *priv;
>  	u8 *result;
>  	void *ubuf[] CRYPTO_MINALIGN_ATTR;
>  };
> @@ -200,23 +201,38 @@ static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
>  	if (!err)
>  		memcpy(priv->result, req->result,
>  		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
> -
> -	kzfree(priv);

You can't move/remove this kzfree since a synchronous operation will not take
the ahash_op_unaligned_done path.  A synchronous operation will never return
-EINPROGRESS and the effect will be to never free the priv structure.

>  }
>  
> -static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
> +static void ahash_op_unaligned_done(struct crypto_async_request *areq, int err)
>  {
> -	struct ahash_request *areq = req->data;
> -	struct ahash_request_priv *priv = areq->priv;
> -	crypto_completion_t complete = priv->complete;
> -	void *data = priv->data;
> +	struct ahash_request *req = areq->data;
> +	struct ahash_request_priv *priv = req->priv;
> +	struct crypto_async_request *data;
> +
> +	/*
> +	 * Restore the original request, see ahash_op_unaligned() for what
> +	 * goes where.
> +	 *
> +	 * The "struct ahash_request *req" here is in fact the "req.base"
> +	 * from the ADJUSTED request from ahash_op_unaligned(), thus as it
> +	 * is a pointer to self, it is also the ADJUSTED "req" .
> +	 */
> +
> +	/* First copy req->result into req->priv.result */
> +	ahash_op_unaligned_finish(req, err);

Given the above comment on the kzfree, you'll need to save all the priv
values as was done previously.

Thanks,
Tom

>  
> -	ahash_op_unaligned_finish(areq, err);
> +	/* Restore the original crypto request. */
> +	req->result = priv->result;
> +	req->base.complete = priv->complete;
> +	req->base.data = priv->data;
> +	req->priv = priv->priv;
>  
> -	areq->base.complete = complete;
> -	areq->base.data = data;
> +	/* Free the req->priv.priv from the ADJUSTED request. */
> +	kzfree(priv);
>  
> -	complete(&areq->base, err);
> +	/* Complete the ORIGINAL request. */
> +	data = req->base.data;
> +	req->base.complete(data, err);
>  }
>  
>  static int ahash_op_unaligned(struct ahash_request *req,
> @@ -234,9 +250,36 @@ static int ahash_op_unaligned(struct ahash_request *req,
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	/*
> +	 * WARNING: Voodoo programming below!
> +	 *
> +	 * The code below is obscure and hard to understand, thus explanation
> +	 * is necessary. See include/crypto/hash.h and include/linux/crypto.h
> +	 * to understand the layout of structures used here!
> +	 *
> +	 * The code here will replace portions of the ORIGINAL request with
> +	 * pointers to new code and buffers so the hashing operation can store
> +	 * the result in aligned buffer. We will call the modified request
> +	 * an ADJUSTED request.
> +	 *
> +	 * The newly mangled request will look as such:
> +	 *
> +	 * req {
> +	 *   .result        = ADJUSTED[new aligned buffer]
> +	 *   .base.complete = ADJUSTED[pointer to completion function]
> +	 *   .base.data     = ADJUSTED[*req (pointer to self)]
> +	 *   .priv          = ADJUSTED[new priv] {
> +	 *           .result   = ORIGINAL(result)
> +	 *           .complete = ORIGINAL(base.complete)
> +	 *           .data     = ORIGINAL(base.data)
> +	 *           .priv     = ORIGINAL(priv)
> +	 *   }
> +	 */
> +
>  	priv->result = req->result;
>  	priv->complete = req->base.complete;
>  	priv->data = req->base.data;
> +	priv->priv = req->priv;
>  
>  	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
>  	req->base.complete = ahash_op_unaligned_done;
> -- 
> 1.8.5.2
> 
> 
