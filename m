From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Tue, 20 Jun 2017 11:10:42 +0800
Message-ID: <20170620031042.GA17690@gondor.apana.org.au>
References: <1529895.BiIeBiIAIs@positron.chronox.de>
 <2834834.Sa5QGNeBMP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60832 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdFTDLi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:11:38 -0400
Content-Disposition: inline
In-Reply-To: <2834834.Sa5QGNeBMP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 10, 2017 at 07:59:25PM +0200, Stephan Müller wrote:
>
> -static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
> -				 int flags)
> +static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
> +			    size_t ignored, int flags)
>  {
>  	struct sock *sk = sock->sk;
> -	struct alg_sock *ask = alg_sk(sk);
> -	struct sock *psk = ask->parent;
> -	struct alg_sock *pask = alg_sk(psk);
> -	struct skcipher_ctx *ctx = ask->private;
> -	struct skcipher_tfm *skc = pask->private;
> -	struct crypto_skcipher *tfm = skc->skcipher;
> -	unsigned bs = crypto_skcipher_blocksize(tfm);
> -	struct skcipher_sg_list *sgl;
> -	struct scatterlist *sg;
> -	int err = -EAGAIN;
> -	int used;
> -	long copied = 0;
> +	int ret = 0;
>  
>  	lock_sock(sk);
>  	while (msg_data_left(msg)) {
> -		if (!ctx->used) {
> -			err = skcipher_wait_for_data(sk, flags);
> -			if (err)
> -				goto unlock;
> +		int err = _skcipher_recvmsg(sock, msg, ignored, flags);
> +
> +		/*
> +		 * This error covers -EIOCBQUEUED which implies that we can
> +		 * only handle one AIO request. If the caller wants to have
> +		 * multiple AIO requests in parallel, he must make multiple
> +		 * separate AIO calls.
> +		 */
> +		if (err < 0) {
> +			ret = err;
> +			goto out;

This looks like a semantic change.  The previous code would return
the number of bytes already successfully processed in case of a
subsequent error.  With your new code you will always return the
error.

> @@ -724,10 +737,9 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
>  	struct sock *sk = sock->sk;
>  	struct alg_sock *ask = alg_sk(sk);
>  	struct skcipher_ctx *ctx = ask->private;
> -	unsigned int mask;
> +	unsigned int mask = 0;
>  
>  	sock_poll_wait(file, sk_sleep(sk), wait);
> -	mask = 0;
>  
>  	if (ctx->used)
>  		mask |= POLLIN | POLLRDNORM;

Please remove this hunk as it has nothing to do with this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
