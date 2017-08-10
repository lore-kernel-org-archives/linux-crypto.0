From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 1/4] crypto: AF_ALG -- add sign/verify API
Date: Thu, 10 Aug 2017 15:49:39 +0300
Message-ID: <45021398-1ff4-77af-2fea-92a02b4a33c4@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <1701667.ajpEH4uy8Y@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:10971 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdHJMui (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 08:50:38 -0400
In-Reply-To: <1701667.ajpEH4uy8Y@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

On 08/10/2017 09:39 AM, Stephan Müller wrote:
> Add the flags for handling signature generation and signature
> verification.
> 
> The af_alg helper code as well as the algif_skcipher and algif_aead code
> must be changed from a boolean indicating the cipher operation to an
> integer because there are now 4 different cipher operations that are
> defined. Yet, the algif_aead and algif_skcipher code still only allows
> encryption and decryption cipher operations.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>   crypto/af_alg.c             | 10 +++++-----
>   crypto/algif_aead.c         | 36 ++++++++++++++++++++++++------------
>   crypto/algif_skcipher.c     | 26 +++++++++++++++++---------
>   include/crypto/if_alg.h     |  4 ++--
>   include/uapi/linux/if_alg.h |  2 ++
>   5 files changed, 50 insertions(+), 28 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index d6936c0e08d9..a35a9f854a04 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -859,7 +859,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   	struct af_alg_tsgl *sgl;
>   	struct af_alg_control con = {};
>   	long copied = 0;
> -	bool enc = 0;
> +	int op = 0;
>   	bool init = 0;
>   	int err = 0;
>   
> @@ -870,11 +870,11 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   
>   		init = 1;
>   		switch (con.op) {
> +		case ALG_OP_VERIFY:
> +		case ALG_OP_SIGN:
>   		case ALG_OP_ENCRYPT:
> -			enc = 1;
> -			break;
>   		case ALG_OP_DECRYPT:
> -			enc = 0;
> +			op = con.op;
>   			break;
>   		default:
>   			return -EINVAL;
> @@ -891,7 +891,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   	}
>   
>   	if (init) {
> -		ctx->enc = enc;
> +		ctx->op = op;
>   		if (con.iv)
>   			memcpy(ctx->iv, con.iv->iv, ivsize);
>   
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 516b38c3a169..77abc04cf942 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -60,7 +60,7 @@ static inline bool aead_sufficient_data(struct sock *sk)
>   	 * The minimum amount of memory needed for an AEAD cipher is
>   	 * the AAD and in case of decryption the tag.
>   	 */
> -	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
> +	return ctx->used >= ctx->aead_assoclen + (ctx->op ? 0 : as);
>   }
>   
>   static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
> @@ -137,7 +137,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>   	 * buffer provides the tag which is consumed resulting in only the
>   	 * plaintext without a buffer for the tag returned to the caller.
>   	 */
> -	if (ctx->enc)
> +	if (ctx->op)
>   		outlen = used + as;
>   	else
>   		outlen = used - as;
> @@ -196,7 +196,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>   	/* Use the RX SGL as source (and destination) for crypto op. */
>   	src = areq->first_rsgl.sgl.sg;
>   
> -	if (ctx->enc) {
> +	if (ctx->op == ALG_OP_ENCRYPT) {
>   		/*
>   		 * Encryption operation - The in-place cipher operation is
>   		 * achieved by the following operation:
> @@ -212,7 +212,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>   		if (err)
>   			goto free;
>   		af_alg_pull_tsgl(sk, processed, NULL, 0);
> -	} else {
> +	} else if (ctx->op == ALG_OP_DECRYPT) {
>   		/*
>   		 * Decryption operation - To achieve an in-place cipher
>   		 * operation, the following  SGL structure is used:
> @@ -258,6 +258,9 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>   		} else
>   			/* no RX SGL present (e.g. authentication only) */
>   			src = areq->tsgl;
> +	} else {
> +		err = -EOPNOTSUPP;
> +		goto free;
>   	}
>   
>   	/* Initialize the crypto operation */
> @@ -272,19 +275,28 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>   		aead_request_set_callback(&areq->cra_u.aead_req,
>   					  CRYPTO_TFM_REQ_MAY_BACKLOG,
>   					  af_alg_async_cb, areq);
> -		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
> -				 crypto_aead_decrypt(&areq->cra_u.aead_req);
> -	} else {
> +	} else

Unbalanced braces around else statement.

>   		/* Synchronous operation */
>   		aead_request_set_callback(&areq->cra_u.aead_req,
>   					  CRYPTO_TFM_REQ_MAY_BACKLOG,
>   					  af_alg_complete, &ctx->completion);
> -		err = af_alg_wait_for_completion(ctx->enc ?
> -				crypto_aead_encrypt(&areq->cra_u.aead_req) :
> -				crypto_aead_decrypt(&areq->cra_u.aead_req),
> -						 &ctx->completion);
> +
> +	switch (ctx->op) {
> +	case ALG_OP_ENCRYPT:
> +		err = crypto_aead_encrypt(&areq->cra_u.aead_req);
> +		break;
> +	case ALG_OP_DECRYPT:
> +		err = crypto_aead_decrypt(&areq->cra_u.aead_req);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +		goto free;
>   	}
>   
> +	/* Wait for synchronous operation completion */
> +	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb))
> +		err = af_alg_wait_for_completion(err, &ctx->completion);
> +
>   	/* AIO operation in progress */
>   	if (err == -EINPROGRESS) {
>   		sock_hold(sk);
> @@ -552,7 +564,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
>   	ctx->rcvused = 0;
>   	ctx->more = 0;
>   	ctx->merge = 0;
> -	ctx->enc = 0;
> +	ctx->op = 0;

This implies decryption. Should we change the value of ALG_OP_DECRYPT?

>   	ctx->aead_assoclen = 0;
>   	af_alg_init_completion(&ctx->completion);
>   
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 8ae4170aaeb4..3bf761868689 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -121,22 +121,30 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>   		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
>   					      CRYPTO_TFM_REQ_MAY_SLEEP,
>   					      af_alg_async_cb, areq);
> -		err = ctx->enc ?
> -			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
> -			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
> -	} else {
> +	} else

Unbalanced braces around else statement.

Cheers,
ta

>   		/* Synchronous operation */
>   		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
>   					      CRYPTO_TFM_REQ_MAY_SLEEP |
>   					      CRYPTO_TFM_REQ_MAY_BACKLOG,
>   					      af_alg_complete,
>   					      &ctx->completion);
> -		err = af_alg_wait_for_completion(ctx->enc ?
> -			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
> -			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
> -						 &ctx->completion);
> +
> +	switch (ctx->op) {
> +	case ALG_OP_ENCRYPT:
> +		err = crypto_skcipher_encrypt(&areq->cra_u.skcipher_req);
> +		break;
> +	case ALG_OP_DECRYPT:
> +		err = crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +		goto free;
>   	}
>   
> +	/* Wait for synchronous operation completion */
> +	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb))
> +		err = af_alg_wait_for_completion(err, &ctx->completion);
> +
>   	/* AIO operation in progress */
>   	if (err == -EINPROGRESS) {
>   		sock_hold(sk);
> @@ -387,7 +395,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
>   	ctx->rcvused = 0;
>   	ctx->more = 0;
>   	ctx->merge = 0;
> -	ctx->enc = 0;
> +	ctx->op = 0;
>   	af_alg_init_completion(&ctx->completion);
>   
>   	ask->private = ctx;
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 75ec9c662268..50a21488f3ba 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -142,7 +142,7 @@ struct af_alg_async_req {
>    * @more:		More data to be expected from user space?
>    * @merge:		Shall new data from user space be merged into existing
>    *			SG?
> - * @enc:		Cryptographic operation to be performed when
> + * @op:			Cryptographic operation to be performed when
>    *			recvmsg is invoked.
>    * @len:		Length of memory allocated for this data structure.
>    */
> @@ -159,7 +159,7 @@ struct af_alg_ctx {
>   
>   	bool more;
>   	bool merge;
> -	bool enc;
> +	int op;
>   
>   	unsigned int len;
>   };
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index f2acd2fde1f3..d81dcca5bdd7 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -38,5 +38,7 @@ struct af_alg_iv {
>   /* Operations */
>   #define ALG_OP_DECRYPT			0
>   #define ALG_OP_ENCRYPT			1
> +#define ALG_OP_SIGN			2
> +#define ALG_OP_VERIFY			3
>   
>   #endif	/* _LINUX_IF_ALG_H */
> 
