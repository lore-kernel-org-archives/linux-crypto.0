From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [v3 PATCH 1/3] crypto: algif_skcipher - Do not assume that req is
 unchanged
Date: Mon, 1 Feb 2016 13:03:57 -0800
Message-ID: <56AFC83D.2010005@intel.com>
References: <20160201130644.GA6904@gondor.apana.org.au>
 <E1aQED3-00022H-5o@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:18130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbcBAVHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 16:07:55 -0500
In-Reply-To: <E1aQED3-00022H-5o@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 02/01/2016 05:08 AM, Herbert Xu wrote:
> @@ -509,37 +498,42 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
>  {
>  	struct sock *sk = sock->sk;
>  	struct alg_sock *ask = alg_sk(sk);
> +	struct sock *psk = ask->parent;
> +	struct alg_sock *pask = alg_sk(psk);
>  	struct skcipher_ctx *ctx = ask->private;
> +	struct skcipher_tfm *skc = pask->private;
> +	struct crypto_skcipher *tfm = skc->skcipher;
>  	struct skcipher_sg_list *sgl;
>  	struct scatterlist *sg;
>  	struct skcipher_async_req *sreq;
>  	struct skcipher_request *req;
>  	struct skcipher_async_rsgl *last_rsgl = NULL;
>  	unsigned int txbufs = 0, len = 0, tx_nents = skcipher_all_sg_nents(ctx);
> -	unsigned int reqlen = sizeof(struct skcipher_async_req) +
> -				GET_REQ_SIZE(ctx) + GET_IV_SIZE(ctx);
> +	unsigned int reqsize = crypto_skcipher_reqsize(tfm);
> +	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
>  	int err = -ENOMEM;
>  	bool mark = false;
> +	char *iv;
>  
> -	lock_sock(sk);
> -	req = kmalloc(reqlen, GFP_KERNEL);
> -	if (unlikely(!req))
> -		goto unlock;
> +	sreq = kzalloc(sizeof(*req) + reqsize + ivsize, GFP_KERNEL);

I think this should be:
sreq = kzalloc(sizeof(*sreq) + reqsize + ivsize, GFP_KERNEL);

> +	if (unlikely(!sreq))
> +		goto out;
>  
> -	sreq = GET_SREQ(req, ctx);
> +	req = &sreq->req;
> +	iv = (char *)(req + 1) + reqsize;
>  	sreq->iocb = msg->msg_iocb;
> -	memset(&sreq->first_sgl, '\0', sizeof(struct skcipher_async_rsgl));
>  	INIT_LIST_HEAD(&sreq->list);
> +	sreq->inflight = &ctx->inflight;
> +
> +	lock_sock(sk);
>  	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
> -	if (unlikely(!sreq->tsg)) {
> -		kfree(req);
> +	if (unlikely(!sreq->tsg))
>  		goto unlock;
> -	}
>  	sg_init_table(sreq->tsg, tx_nents);
> -	memcpy(sreq->iv, ctx->iv, GET_IV_SIZE(ctx));
> -	skcipher_request_set_tfm(req, crypto_skcipher_reqtfm(&ctx->req));
> +	memcpy(iv, ctx->iv, ivsize);
> +	skcipher_request_set_tfm(req, tfm);
>  	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				      skcipher_async_cb, sk);
> +				      skcipher_async_cb, sreq);
>  
>  	while (iov_iter_count(&msg->msg_iter)) {
>  		struct skcipher_async_rsgl *rsgl;
> @@ -615,7 +609,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
>  		sg_mark_end(sreq->tsg + txbufs - 1);
>  
>  	skcipher_request_set_crypt(req, sreq->tsg, sreq->first_sgl.sgl.sg,
> -				   len, sreq->iv);
> +				   len, iv);
>  	err = ctx->enc ? crypto_skcipher_encrypt(req) :
>  			 crypto_skcipher_decrypt(req);
>  	if (err == -EINPROGRESS) {
> @@ -625,10 +619,11 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
>  	}
>  free:
>  	skcipher_free_async_sgls(sreq);
> -	kfree(req);
>  unlock:
>  	skcipher_wmem_wakeup(sk);
>  	release_sock(sk);
> +	kzfree(sreq);

we can't free sreq here because in case if (err == -EINPROGRESS)
we goto unlock and then we crash in the callback.

> +out:
>  	return err;
>  }

With the following changes on top, Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a692e06..322891a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -515,7 +515,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	bool mark = false;
 	char *iv;
 
-	sreq = kzalloc(sizeof(*req) + reqsize + ivsize, GFP_KERNEL);
+	sreq = kzalloc(sizeof(*sreq) + reqsize + ivsize, GFP_KERNEL);
 	if (unlikely(!sreq))
 		goto out;
 
@@ -528,7 +528,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	lock_sock(sk);
 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
 	if (unlikely(!sreq->tsg))
-		goto unlock;
+		goto free;
 	sg_init_table(sreq->tsg, tx_nents);
 	memcpy(iv, ctx->iv, ivsize);
 	skcipher_request_set_tfm(req, tfm);
@@ -619,10 +619,10 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	}
 free:
 	skcipher_free_async_sgls(sreq);
+	kzfree(sreq);
 unlock:
 	skcipher_wmem_wakeup(sk);
 	release_sock(sk);
-	kzfree(sreq);
 out:
 	return err;
 }

Thanks,

-- 
TS
