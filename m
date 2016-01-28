From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Thu, 28 Jan 2016 07:26:04 +0100
Message-ID: <76537095.pjn76bZGgL@positron.chronox.de>
References: <20160127221031.12534.13202.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160127221031.12534.13202.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 27. Januar 2016, 14:10:31 schrieb Tadeusz Struk:

Hi Tadeusz,

> Following the async change for algif_skcipher
> this patch adds similar async read to algif_aead.
> 
> changes in v2:
> - change internal data structures from fixed size arrays, limited to
>   RSGL_MAX_ENTRIES, to linked list model with no artificial limitation.

Thank you for the dynamic allocation support, but I do have a question.

> - use sock_kmalloc instead of kmalloc for memory allocation
> - use sock_hold instead of separate atomic ctr to wait for outstanding
> request
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  crypto/algif_aead.c |  278
> +++++++++++++++++++++++++++++++++++++++++++++------ 1 file changed, 248
> insertions(+), 30 deletions(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 147069c..3fa1a95 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -29,15 +29,24 @@ struct aead_sg_list {
>  	struct scatterlist sg[ALG_MAX_PAGES];
>  };
> 
> +struct aead_async_rsgl {
> +	struct af_alg_sgl sgl;
> +	struct list_head list;
> +};
> +
> +struct aead_async_req {
> +	struct scatterlist *tsgl;
> +	struct aead_async_rsgl first_rsgl;
> +	struct list_head list;
> +	struct kiocb *iocb;
> +	unsigned int tsgls;
> +	char iv[];
> +};
> +
>  struct aead_ctx {
>  	struct aead_sg_list tsgl;
> -	/*
> -	 * RSGL_MAX_ENTRIES is an artificial limit where user space at maximum
> -	 * can cause the kernel to allocate RSGL_MAX_ENTRIES * ALG_MAX_PAGES
> -	 * pages
> -	 */
> -#define RSGL_MAX_ENTRIES ALG_MAX_PAGES
> -	struct af_alg_sgl rsgl[RSGL_MAX_ENTRIES];
> +	struct aead_async_rsgl first_rsgl;
> +	struct list_head list;
> 
>  	void *iv;
> 
> @@ -75,6 +84,17 @@ static inline bool aead_sufficient_data(struct aead_ctx
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
> @@ -90,11 +110,6 @@ static void aead_put_sgl(struct sock *sk)
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
> @@ -240,6 +255,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size) if (!aead_writable(sk)) {
>  			/* user space sent too much data */
>  			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);
>  			err = -EMSGSIZE;
>  			goto unlock;
>  		}
> @@ -251,6 +267,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size)
> 
>  			if (sgl->cur >= ALG_MAX_PAGES) {
>  				aead_put_sgl(sk);
> +				aead_reset_ctx(ctx);
>  				err = -E2BIG;
>  				goto unlock;
>  			}
> @@ -287,6 +304,7 @@ static int aead_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size) ctx->more = msg->msg_flags & MSG_MORE;
>  	if (!ctx->more && !aead_sufficient_data(ctx)) {
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  	}
> 
> @@ -322,6 +340,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct
> page *page, if (!aead_writable(sk)) {
>  		/* user space sent too much data */
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  		goto unlock;
>  	}
> @@ -339,6 +358,7 @@ done:
>  	ctx->more = flags & MSG_MORE;
>  	if (!ctx->more && !aead_sufficient_data(ctx)) {
>  		aead_put_sgl(sk);
> +		aead_reset_ctx(ctx);
>  		err = -EMSGSIZE;
>  	}
> 
> @@ -349,23 +369,189 @@ unlock:
>  	return err ?: size;
>  }
> 
> -static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> ignored, int flags) +#define GET_ASYM_REQ(req, tfm) (struct aead_async_req
> *) \
> +		((char *)req + sizeof(struct aead_request) + \
> +		 crypto_aead_reqsize(tfm))
> +
> + #define GET_REQ_SIZE(tfm) sizeof(struct aead_async_req) + \
> +	crypto_aead_reqsize(tfm) + crypto_aead_ivsize(tfm) + \
> +	sizeof(struct aead_request)
> +
> +static void aead_async_cb(struct crypto_async_request *_req, int err)
> +{
> +	struct sock *sk = _req->data;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct aead_ctx *ctx = ask->private;
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
> +	struct aead_request *req = aead_request_cast(_req);
> +	struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
> +	struct scatterlist *sg = areq->tsgl;
> +	struct aead_async_rsgl *rsgl;
> +	struct kiocb *iocb = areq->iocb;
> +	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
> +
> +	list_for_each_entry(rsgl, &areq->list, list) {
> +		af_alg_free_sg(&rsgl->sgl);
> +		if (rsgl != &areq->first_rsgl)
> +			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
> +	}
> +
> +	for (i = 0; i < areq->tsgls; i++)
> +		put_page(sg_page(sg + i));

Shouldn't here be the same logic as in put_sgl? I.e.

        for (i = 0; i < sgl->cur; i++) {
                if (!sg_page(sg + i))
                        continue;

                put_page(sg_page(sg + i));
                sg_assign_page(sg + i, NULL);
        }

> +
> +	sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
> +	sock_kfree_s(sk, req, reqlen);
> +	__sock_put(sk);
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
> +	struct aead_async_rsgl *last_rsgl = NULL, *rsgl;
> +	unsigned int as = crypto_aead_authsize(tfm);
> +	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
> +	int err = -ENOMEM;
> +	unsigned long used;
> +	size_t outlen;
> +	size_t usedpages = 0;
> +
> +	lock_sock(sk);
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
> +	req = sock_kmalloc(sk, reqlen, GFP_KERNEL);
> +	if (unlikely(!req))
> +		goto unlock;
> +
> +	areq = GET_ASYM_REQ(req, tfm);
> +	memset(&areq->first_rsgl, '\0', sizeof(areq->first_rsgl));
> +	INIT_LIST_HEAD(&areq->list);
> +	areq->iocb = msg->msg_iocb;
> +	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
> +	aead_request_set_tfm(req, tfm);
> +	aead_request_set_ad(req, ctx->aead_assoclen);
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  aead_async_cb, sk);
> +	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
> +
> +	/* take over all tx sgls from ctx */
> +	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * sgl->cur,
> +				  GFP_KERNEL);
> +	if (unlikely(!areq->tsgl))
> +		goto free;
> +
> +	sg_init_table(areq->tsgl, sgl->cur);
> +	for (i = 0; i < sgl->cur; i++)
> +		sg_set_page(&areq->tsgl[i], sg_page(&sgl->sg[i]),
> +			    sgl->sg[i].length, sgl->sg[i].offset);
> +
> +	areq->tsgls = sgl->cur;
> +
> +	/* create rx sgls */
> +	while (iov_iter_count(&msg->msg_iter)) {
> +		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
> +				      (outlen - usedpages));
> +
> +		if (list_empty(&areq->list))
> +			rsgl = &areq->first_rsgl;
> +		else {
> +			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
> +			if (unlikely(!rsgl)) {
> +				err = -ENOMEM;
> +				goto free;
> +			}
> +		}
> +		rsgl->sgl.npages = 0;
> +		list_add_tail(&rsgl->list, &areq->list);
> +
> +		/* make one iovec available as scatterlist */
> +		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
> +		if (err < 0)
> +			goto free;
> +
> +		usedpages += err;
> +
> +		/* chain the new scatterlist with previous one */
> +		if (last_rsgl)
> +			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
> +
> +		last_rsgl = rsgl;
> +
> +		/* we do not need more iovecs as we have sufficient memory */
> +		if (outlen <= usedpages)
> +			break;
> +
> +		iov_iter_advance(&msg->msg_iter, err);
> +	}
> +	err = -EINVAL;
> +	/* ensure output buffer is sufficiently large */
> +	if (usedpages < outlen)
> +		goto free;
> +
> +	aead_request_set_crypt(req, areq->tsgl, areq->first_rsgl.sgl.sg, used,
> +			       areq->iv);
> +	err = ctx->enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
> +	if (err) {
> +		if (err == -EINPROGRESS) {
> +			sock_hold(sk);
> +			err = -EIOCBQUEUED;
> +			aead_reset_ctx(ctx);
> +			goto unlock;
> +		} else if (err == -EBADMSG) {
> +			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);
> +		}
> +		goto free;
> +	}
> +	aead_put_sgl(sk);
> +	aead_reset_ctx(ctx);
> +
> +free:
> +	list_for_each_entry(rsgl, &areq->list, list) {
> +		af_alg_free_sg(&rsgl->sgl);
> +		if (rsgl != &areq->first_rsgl)
> +			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
> +	}
> +	if (areq->tsgl)
> +		sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq-
>tsgls);
> +	if (req)
> +		sock_kfree_s(sk, req, reqlen);
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
>  	struct aead_ctx *ctx = ask->private;
>  	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx-
>aead_req));
>  	struct aead_sg_list *sgl = &ctx->tsgl;
> -	unsigned int i = 0;
> +	struct aead_async_rsgl *last_rsgl = NULL;
> +	struct aead_async_rsgl *rsgl, *tmp;
>  	int err = -EINVAL;
>  	unsigned long used = 0;
>  	size_t outlen = 0;
>  	size_t usedpages = 0;
> -	unsigned int cnt = 0;
> -
> -	/* Limit number of IOV blocks to be accessed below */
> -	if (msg->msg_iter.nr_segs > RSGL_MAX_ENTRIES)
> -		return -ENOMSG;
> 
>  	lock_sock(sk);
> 
> @@ -417,21 +603,33 @@ static int aead_recvmsg(struct socket *sock, struct
> msghdr *msg, size_t ignored, size_t seglen = min_t(size_t,
> iov_iter_count(&msg->msg_iter),
>  				      (outlen - usedpages));
> 
> +		if (list_empty(&ctx->list))
> +			rsgl = &ctx->first_rsgl;
> +		else {
> +			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
> +			if (unlikely(!rsgl)) {
> +				err = -ENOMEM;
> +				goto unlock;
> +			}
> +		}
> +		rsgl->sgl.npages = 0;
> +		list_add_tail(&rsgl->list, &ctx->list);
> +
>  		/* make one iovec available as scatterlist */
> -		err = af_alg_make_sg(&ctx->rsgl[cnt], &msg->msg_iter,
> -				     seglen);
> +		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
>  		if (err < 0)
>  			goto unlock;
>  		usedpages += err;
>  		/* chain the new scatterlist with previous one */
> -		if (cnt)
> -			af_alg_link_sg(&ctx->rsgl[cnt-1], &ctx->rsgl[cnt]);
> +		if (last_rsgl)
> +			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
> +
> +		last_rsgl = rsgl;
> 
>  		/* we do not need more iovecs as we have sufficient memory */
>  		if (outlen <= usedpages)
>  			break;
>  		iov_iter_advance(&msg->msg_iter, err);
> -		cnt++;
>  	}
> 
>  	err = -EINVAL;
> @@ -440,8 +638,7 @@ static int aead_recvmsg(struct socket *sock, struct
> msghdr *msg, size_t ignored, goto unlock;
> 
>  	sg_mark_end(sgl->sg + sgl->cur - 1);
> -
> -	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->rsgl[0].sg,
> +	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx-
>first_rsgl.sgl.sg,
>  			       used, ctx->iv);
>  	aead_request_set_ad(&ctx->aead_req, ctx->aead_assoclen);
> 
> @@ -452,25 +649,40 @@ static int aead_recvmsg(struct socket *sock, struct
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
>  unlock:
> -	for (i = 0; i < cnt; i++)
> -		af_alg_free_sg(&ctx->rsgl[i]);
> -
> +	list_for_each_entry_safe(rsgl, tmp, &ctx->list, list) {
> +		af_alg_free_sg(&rsgl->sgl);
> +		if (rsgl != &ctx->first_rsgl)
> +			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
> +		list_del(&rsgl->list);
> +	}
> +	INIT_LIST_HEAD(&ctx->list);
>  	aead_wmem_wakeup(sk);
>  	release_sock(sk);
> 
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
> +
>  static unsigned int aead_poll(struct file *file, struct socket *sock,
>  			      poll_table *wait)
>  {
> @@ -539,7 +751,12 @@ static void aead_sock_destruct(struct sock *sk)
>  	struct aead_ctx *ctx = ask->private;
>  	unsigned int ivlen = crypto_aead_ivsize(
>  				crypto_aead_reqtfm(&ctx->aead_req));
> +	int ctr = 0;
> +
> +	while (atomic_read(&sk->sk_refcnt) != 0 && ctr++ < 10)
> +		msleep(100);
> 
> +	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);
>  	aead_put_sgl(sk);
>  	sock_kzfree_s(sk, ctx->iv, ivlen);
>  	sock_kfree_s(sk, ctx, ctx->len);
> @@ -574,6 +791,7 @@ static int aead_accept_parent(void *private, struct sock
> *sk) ctx->aead_assoclen = 0;
>  	af_alg_init_completion(&ctx->completion);
>  	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
> +	INIT_LIST_HEAD(&ctx->list);
> 
>  	ask->private = ctx;


Ciao
Stephan
