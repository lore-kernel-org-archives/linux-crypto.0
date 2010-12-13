From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG
Date: Mon, 13 Dec 2010 12:24:34 -0500 (EST)
Message-ID: <1049191813.614221292261074998.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <385134132.614111292260958484.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:34900 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab0LMRYq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 12:24:46 -0500
In-Reply-To: <385134132.614111292260958484.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> +			struct msghdr *msg, size_t len, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct rng_ctx *ctx = ask->private;
> +	int rc, i;
> +	u8 *data = kzalloc(len, GFP_KERNEL);
There probably should be an upper limit on the allocation - perhaps just always allocate a single page.

> +static void rng_release(void *private)
> +{
> +	struct rng_ctx *ctx = private;
> +	crypto_free_rng(ctx->ctx);
> +	kfree(ctx->seed);
Is a seed secret enough that it should be zeroed before freeing?  (Same in setkey, accept_parent).

     Mirek
