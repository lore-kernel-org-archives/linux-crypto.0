From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Wed, 14 Feb 2018 11:13:53 +0530
Message-ID: <617281e5-543c-0d8c-1fa6-56c4a65cc515@chelsio.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
 <1842104.0gXuQuQB9D@positron.chronox.de>
 <2808558.OTeCt0oKkL@positron.chronox.de>
 <4507333.JelVKMRNjF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:63619 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754322AbeBNFoO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 00:44:14 -0500
In-Reply-To: <4507333.JelVKMRNjF@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10-02-2018 03:33, Stephan Müller wrote:
> The kernel crypto API requires the caller to set an IV in the request data
> structure. That request data structure shall define one particular cipher
> operation. During the cipher operation, the IV is read by the cipher
> implementation and eventually the potentially updated IV (e.g. in case of
> CBC) is written back to the memory location the request data structure
> points to.
>
> AF_ALG allows setting the IV with a sendmsg request, where the IV is stored
> in the AF_ALG context that is unique to one particular AF_ALG socket. Note
> the analogy: an AF_ALG socket is like a TFM where one recvmsg operation
> uses one request with the TFM from the socket.
>
> AF_ALG these days supports AIO operations with multiple IOCBs. I.e. with
> one recvmsg call, multiple IOVECs can be specified. Each individual IOCB
> (derived from one IOVEC) implies that one request data structure is
> created with the data to be processed by the cipher implementation. The
> IV that was set with the sendmsg call is registered with the request data
> structure before the cipher operation.
>
> In case of an AIO operation, the cipher operation invocation returns
> immediately, queuing the request to the hardware. While the AIO request is
> processed by the hardware, recvmsg processes the next IOVEC for which
> another request is created. Again, the IV buffer from the AF_ALG socket
> context is registered with the new request and the cipher operation is
> invoked.
>
> You may now see that there is a potential race condition regarding the IV
> handling, because there is *no* separate IV buffer for the different
> requests. This is nicely demonstrated with libkcapi using the following
> command which creates an AIO request with two IOCBs each encrypting one
> AES block in CBC mode:
>
> kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k
> 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
> 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
>
> When the first AIO request finishes before the 2nd AIO request is
> processed, the returned value is:
>
> 8b19050f66582cb7f7e4b6c873819b7108afa0eaa7de29bac7d903576b674c32
>
> I.e. two blocks where the IV output from the first request is the IV input
> to the 2nd block.
>
> In case the first AIO request is not completed before the 2nd request
> commences, the result is two identical AES blocks (i.e. both use the same
> IV):
>
> 8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71
>
> This inconsistent result may even lead to the conclusion that there can be
> a memory corruption in the IV buffer if both AIO requests write to the IV
> buffer at the same time.
>
> As the AF_ALG interface is used by user space, a mutex provides the
> serialization which puts the caller to sleep in case a previous IOCB
> processing is not yet finished.
>
> If multiple IOCBs arrive that all are blocked, the mutex' FIFO operation
> of processing arriving requests ensures that the blocked IOCBs are
> unblocked in the right order.
Hi Stephen,

Patch set is working fine with chelsio Driver.
Do we really need IV locking mechanism for AEAD algo because AEAD algo's don't support Partial mode operation and Driver are not updating(atleast Chelsio) IV's on AEAD request completions.
>
> CC: <stable@vger.kernel.org> #4.14
> Fixes: e870456d8e7c8 ("crypto: algif_skcipher - overhaul memory management")
> Fixes: d887c52d6ae43 ("crypto: algif_aead - overhaul memory management")
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/af_alg.c         | 31 +++++++++++++++++++++++++++++++
>  crypto/algif_aead.c     | 20 +++++++++++++-------
>  crypto/algif_skcipher.c | 12 +++++++++---
>  include/crypto/if_alg.h |  5 +++++
>  4 files changed, 58 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 5231f421ad00..e7887621aa44 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1051,6 +1051,8 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
>  	struct kiocb *iocb = areq->iocb;
>  	unsigned int resultlen;
>  
> +	af_alg_put_iv(sk);
> +
>  	/* Buffer size written by crypto operation. */
>  	resultlen = areq->outlen;
>  
> @@ -1175,6 +1177,35 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
>  }
>  EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
>  
> +/**
> + * af_alg_get_iv
> + *
> + * @sk [in] AF_ALG socket
> + * @return 0 on success, < 0 on error
> + */
> +int af_alg_get_iv(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct af_alg_ctx *ctx = ask->private;
> +
> +	return mutex_lock_interruptible(&ctx->ivlock);
> +}
> +EXPORT_SYMBOL_GPL(af_alg_get_iv);
> +
> +/**
> + * af_alg_put_iv - release lock on IV in case CTX IV is used
> + *
> + * @sk [in] AF_ALG socket
> + */
> +void af_alg_put_iv(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct af_alg_ctx *ctx = ask->private;
> +
> +	mutex_unlock(&ctx->ivlock);
> +}
> +EXPORT_SYMBOL_GPL(af_alg_put_iv);
> +
>  static int __init af_alg_init(void)
>  {
>  	int err = proto_register(&alg_proto, 0);
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 4b07edd5a9ff..402de50d4a58 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -159,10 +159,14 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	if (IS_ERR(areq))
>  		return PTR_ERR(areq);
>  
> +	err = af_alg_get_iv(sk);
> +	if (err)
> +		goto free;
> +
>  	/* convert iovecs of output buffers into RX SGL */
>  	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
>  	if (err)
> -		goto free;
> +		goto unlock;
>  
>  	/*
>  	 * Ensure output buffer is sufficiently large. If the caller provides
> @@ -176,7 +180,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  
>  		if (used < less) {
>  			err = -EINVAL;
> -			goto free;
> +			goto unlock;
>  		}
>  		used -= less;
>  		outlen -= less;
> @@ -197,7 +201,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	}
>  	if (processed && !tsgl_src) {
>  		err = -EFAULT;
> -		goto free;
> +		goto unlock;
>  	}
>  
>  	/*
> @@ -230,7 +234,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
>  					   areq->first_rsgl.sgl.sg, processed);
>  		if (err)
> -			goto free;
> +			goto unlock;
>  		af_alg_pull_tsgl(sk, processed, NULL, 0);
>  	} else {
>  		/*
> @@ -248,7 +252,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
>  					   areq->first_rsgl.sgl.sg, outlen);
>  		if (err)
> -			goto free;
> +			goto unlock;
>  
>  		/* Create TX SGL for tag and chain it to RX SGL. */
>  		areq->tsgl_entries = af_alg_count_tsgl(sk, processed,
> @@ -260,7 +264,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  					  GFP_KERNEL);
>  		if (!areq->tsgl) {
>  			err = -ENOMEM;
> -			goto free;
> +			goto unlock;
>  		}
>  		sg_init_table(areq->tsgl, areq->tsgl_entries);
>  
> @@ -316,7 +320,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  				&ctx->wait);
>  	}
>  
> -
> +unlock:
> +	af_alg_put_iv(sk);
>  free:
>  	af_alg_free_resources(areq);
>  
> @@ -562,6 +567,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
>  		return -ENOMEM;
>  	}
>  	memset(ctx->iv, 0, ivlen);
> +	mutex_init(&ctx->ivlock);
>  
>  	INIT_LIST_HEAD(&ctx->tsgl_list);
>  	ctx->len = len;
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index c88e5e4cd6a6..b65b9a89d6bb 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -77,10 +77,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  	if (IS_ERR(areq))
>  		return PTR_ERR(areq);
>  
> +	err = af_alg_get_iv(sk);
> +	if (err)
> +		goto free;
> +
>  	/* convert iovecs of output buffers into RX SGL */
>  	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
>  	if (err)
> -		goto free;
> +		goto unlock;
>  
>  	/* Process only as much RX buffers for which we have TX data */
>  	if (len > ctx->used)
> @@ -104,7 +108,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  				  GFP_KERNEL);
>  	if (!areq->tsgl) {
>  		err = -ENOMEM;
> -		goto free;
> +		goto unlock;
>  	}
>  	sg_init_table(areq->tsgl, areq->tsgl_entries);
>  	af_alg_pull_tsgl(sk, len, areq->tsgl, 0);
> @@ -146,7 +150,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  						 &ctx->wait);
>  	}
>  
> -
> +unlock:
> +	af_alg_put_iv(sk);
>  free:
>  	af_alg_free_resources(areq);
>  
> @@ -353,6 +358,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
>  	}
>  
>  	memset(ctx->iv, 0, crypto_skcipher_ivsize(tfm));
> +	mutex_init(&ctx->ivlock);
>  
>  	INIT_LIST_HEAD(&ctx->tsgl_list);
>  	ctx->len = len;
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index f38227a78eae..c48eff27e5a9 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -19,6 +19,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/types.h>
>  #include <linux/atomic.h>
> +#include <linux/mutex.h>
>  #include <net/sock.h>
>  
>  #include <crypto/aead.h>
> @@ -127,6 +128,7 @@ struct af_alg_async_req {
>   *
>   * @tsgl_list:		Link to TX SGL
>   * @iv:			IV for cipher operation
> + * @ivlock:		Mutex to serialize access to the IV
>   * @aead_assoclen:	Length of AAD for AEAD cipher operations
>   * @completion:		Work queue for synchronous operation
>   * @used:		TX bytes sent to kernel. This variable is used to
> @@ -146,6 +148,7 @@ struct af_alg_ctx {
>  	struct list_head tsgl_list;
>  
>  	void *iv;
> +	struct mutex ivlock;
>  	size_t aead_assoclen;
>  
>  	struct crypto_wait wait;
> @@ -252,5 +255,7 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
>  int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
>  		    struct af_alg_async_req *areq, size_t maxsize,
>  		    size_t *outlen);
> +int af_alg_get_iv(struct sock *sk);
> +void af_alg_put_iv(struct sock *sk);
>  
>  #endif	/* _CRYPTO_IF_ALG_H */
