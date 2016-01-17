From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Sun, 17 Jan 2016 16:07:04 +0100
Message-ID: <1641011.7xuR0fALWB@myon.chronox.de>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42094 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbcAQPHJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2016 10:07:09 -0500
In-Reply-To: <20160115192112.3065.45755.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 15. Januar 2016, 11:21:12 schrieb Tadeusz Struk:

Hi Tadeusz,

> Following the async change for algif_skcipher
> this patch adds similar async read to algif_aead.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  crypto/algif_aead.c |  196
> +++++++++++++++++++++++++++++++++++++++++++++++++-- 1 file changed, 189
> insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index f70bcf8..6130759 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -44,6 +44,7 @@ struct aead_ctx {
>  	struct af_alg_completion completion;
> 
>  	unsigned long used;
> +	atomic_t inflight;
> 
>  	unsigned int len;
>  	bool more;
> @@ -54,6 +55,15 @@ struct aead_ctx {
>  	struct aead_request aead_req;
>  };
> 
> +struct aead_async_req {
> +	struct kiocb *iocb;
> +	struct af_alg_sgl rsgl[RSGL_MAX_ENTRIES];
> +	struct scatterlist tsgl[ALG_MAX_PAGES];
> +	unsigned int rsgls;
> +	unsigned int tsgls;
> +	char iv[];
> +};
> +
>  static inline int aead_sndbuf(struct sock *sk)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
> @@ -75,6 +85,17 @@ static inline bool aead_sufficient_data(struct aead_ctx
> *ctx) return ctx->used >= ctx->aead_assoclen + as;
>  }
> 
> +static void aead_reset_ctx(struct aead_ctx *ctx)
> +{
> +	struct aead_sg_list *sgl = &ctx->tsgl;
> +
> +	sg_init_table(sgl->sg, ALG_MAX_PAGES);
> +	sgl->cur = 0;
> +	ctx->used = 0;
> +	ctx->more = 0;
> +	ctx->merge = 0;
> +}
> +
>  static void aead_put_sgl(struct sock *sk)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
> @@ -90,11 +111,6 @@ static void aead_put_sgl(struct sock *sk)
>  		put_page(sg_page(sg + i));
>  		sg_assign_page(sg + i, NULL);
>  	}
> -	sg_init_table(sg, ALG_MAX_PAGES);
> -	sgl->cur = 0;
> -	ctx->used = 0;
> -	ctx->more = 0;
> -	ctx->merge = 0;
>  }
> 
>  static void aead_wmem_wakeup(struct sock *sk)
> @@ -240,6 +256,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size) if (!aead_writable(sk)) {
>  			/* user space sent too much data */
>  			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);
>  			err = -EMSGSIZE;
>  			goto unlock;
>  		}
> @@ -251,6 +268,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size)
> 
>  			if (sgl->cur >= ALG_MAX_PAGES) {
>  				aead_put_sgl(sk);
> +				aead_reset_ctx(ctx);
>  				err = -E2BIG;
>  				goto unlock;
>  			}
> @@ -287,6 +305,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size) ctx->more = msg->msg_flags & MSG_MORE;
>  	if (!ctx->more && !aead_sufficient_data(ctx)) {
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  	}
> 
> @@ -322,6 +341,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct
> page *page, if (!aead_writable(sk)) {
>  		/* user space sent too much data */
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  		goto unlock;
>  	}
> @@ -339,6 +359,7 @@ done:
>  	ctx->more = flags & MSG_MORE;
>  	if (!ctx->more && !aead_sufficient_data(ctx)) {
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  	}
> 
> @@ -349,7 +370,144 @@ unlock:
>  	return err ?: size;
>  }
> 
> -static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> ignored, int flags) +#define GET_ASYM_REQ(req, tfm) (struct aead_async_req
> *) \
> +		((char *)req + crypto_aead_reqsize(tfm))
> +
> +static void aead_async_cb(struct crypto_async_request *req, int err)
> +{
> +	struct sock *sk = req->data;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct aead_ctx *ctx = ask->private;
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
> +	struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
> +	struct scatterlist *sg = areq->tsgl;
> +	struct kiocb *iocb = areq->iocb;
> +	int i;
> +
> +	atomic_dec(&ctx->inflight);
> +	for (i = 0; i < areq->tsgls; i++)
> +		put_page(sg_page(sg + i));
> +
> +	for (i = 0; i < areq->rsgls; i++)
> +		af_alg_free_sg(&areq->rsgl[i]);
> +
> +	kfree(req);
> +	iocb->ki_complete(iocb, err, err);
> +}
> +
> +static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
> +			      int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct aead_ctx *ctx = ask->private;
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
> +	struct aead_async_req *areq;
> +	struct aead_request *req = NULL;
> +	struct aead_sg_list *sgl = &ctx->tsgl;
> +	unsigned int as = crypto_aead_authsize(tfm);
> +	unsigned int reqlen = sizeof(*areq) + crypto_aead_reqsize(tfm) +
> +				crypto_aead_ivsize(tfm);
> +	int err = -ENOMEM, i;
> +	unsigned long used;
> +	size_t outlen;
> +	size_t usedpages = 0;
> +	unsigned int cnt = 0;
> +
> +	/* Limit number of IOV blocks to be accessed below */
> +	if (msg->msg_iter.nr_segs > RSGL_MAX_ENTRIES)
> +		return -ENOMSG;
> +
> +	lock_sock(sk);
> +
> +	if (ctx->more) {
> +		err = aead_wait_for_data(sk, flags);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +	used = ctx->used;
> +	outlen = used;
> +
> +	if (!aead_sufficient_data(ctx))
> +		goto unlock;
> +
> +	req = kmalloc(reqlen, GFP_KERNEL);

Shouldn't that be sock_kmalloc? If yes, we also need to use sock_kfree_s 
above.

> +	if (unlikely(!req))
> +		goto unlock;
> +
> +	areq = GET_ASYM_REQ(req, tfm);
> +	areq->iocb = msg->msg_iocb;
> +	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
> +	aead_request_set_tfm(req, tfm);
> +	aead_request_set_ad(req, ctx->aead_assoclen);
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  aead_async_cb, sk);
> +	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
> +
> +	/* take over all tx sgls from ctx */
> +	for (i = 0; i < sgl->cur; i++)
> +		areq->tsgl[i] = sgl->sg[i];
> +
> +	sg_mark_end(areq->tsgl + sgl->cur - 1);
> +	areq->tsgls = sgl->cur;
> +
> +	/* create rx sgls */
> +	while (iov_iter_count(&msg->msg_iter)) {
> +		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
> +				      (outlen - usedpages));
> +
> +		/* make one iovec available as scatterlist */
> +		err = af_alg_make_sg(&areq->rsgl[cnt], &msg->msg_iter, 
seglen);
> +		if (err < 0)
> +			goto free;
> +		usedpages += err;
> +		/* chain the new scatterlist with previous one */
> +		if (cnt)
> +			af_alg_link_sg(&areq->rsgl[cnt - 1], &areq-
>rsgl[cnt]);
> +
> +		/* we do not need more iovecs as we have sufficient memory */
> +		if (outlen <= usedpages)
> +			break;
> +		iov_iter_advance(&msg->msg_iter, err);
> +		cnt++;
> +	}
> +	areq->rsgls = cnt;
> +	err = -EINVAL;
> +	/* ensure output buffer is sufficiently large */
> +	if (usedpages < outlen)
> +		goto free;
> +
> +	aead_request_set_crypt(req, areq->tsgl, areq->rsgl[0].sg, used,
> +			       areq->iv);
> +	err = ctx->enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
> +	if (err) {
> +		if (err == -EINPROGRESS) {
> +			atomic_inc(&ctx->inflight);
> +			err = -EIOCBQUEUED;
> +			aead_reset_ctx(ctx);
> +			goto unlock;
> +		} else if (err == -EBADMSG) {
> +			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);
> +			goto free;
> +		}
> +		goto free;
> +	}
> +	aead_put_sgl(sk);
> +	aead_reset_ctx(ctx);
> +free:
> +	for (i = 0; i < cnt; i++)
> +		af_alg_free_sg(&areq->rsgl[i]);
> +
> +	kfree(req);
> +unlock:
> +	aead_wmem_wakeup(sk);
> +	release_sock(sk);
> +	return err ? err : outlen;
> +}
> +
> +static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int
> flags) {
>  	struct sock *sk = sock->sk;
>  	struct alg_sock *ask = alg_sk(sk);
> @@ -452,12 +610,15 @@ static int aead_recvmsg(struct socket *sock, struct
> msghdr *msg, size_t ignored,
> 
>  	if (err) {
>  		/* EBADMSG implies a valid cipher operation took place */
> -		if (err == -EBADMSG)
> +		if (err == -EBADMSG) {
>  			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);
> +		}
>  		goto unlock;
>  	}
> 
>  	aead_put_sgl(sk);
> +	aead_reset_ctx(ctx);
> 
>  	err = 0;
> 
> @@ -471,6 +632,14 @@ unlock:
>  	return err ? err : outlen;
>  }
> 
> +static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> ignored, +			int flags)
> +{
> +	return (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) ?
> +		aead_recvmsg_async(sock, msg, flags) :
> +		aead_recvmsg_sync(sock, msg, flags);
> +}

The code in the aead_recvmsg_sync and _async is very very similar with the 
exception of the areq handling.

What I am wondering, is it possible to consolidate both into one, considering 
that the real difference according to my understanding is the 
af_alg_wait_for_completion usage (in _sync) vs. the use of a self-written 
callback (_async)?

> +
>  static unsigned int aead_poll(struct file *file, struct socket *sock,
>  			      poll_table *wait)
>  {
> @@ -533,6 +702,16 @@ static int aead_setkey(void *private, const u8 *key,
> unsigned int keylen) return crypto_aead_setkey(private, key, keylen);
>  }
> 
> +static void aead_wait(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct aead_ctx *ctx = ask->private;
> +	int ctr = 0;
> +
> +	while (atomic_read(&ctx->inflight) && ctr++ < 100)
> +		msleep(100);

I know that same logic is applied to algif_skcipher. But isn't that a kind of 
uninterruptible sleep? Do you see the potential that a process cannot 
terminate the socket? For example, if a process makes the error of sending 
asynchronously data to the kernel, but "forgets" all necessary recvmsg calls 
and we do not decrease the inflight any more. In this case, wouldn't a kill -9 
of that hanging process leave a zombie or not work at all?

> +}
> +
>  static void aead_sock_destruct(struct sock *sk)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
> @@ -540,6 +719,9 @@ static void aead_sock_destruct(struct sock *sk)
>  	unsigned int ivlen = crypto_aead_ivsize(
>  				crypto_aead_reqtfm(&ctx->aead_req));
> 
> +	if (atomic_read(&ctx->inflight))
> +		aead_wait(sk);
> +
>  	aead_put_sgl(sk);
>  	sock_kzfree_s(sk, ctx->iv, ivlen);
>  	sock_kfree_s(sk, ctx, ctx->len);


-- 
Ciao
Stephan
