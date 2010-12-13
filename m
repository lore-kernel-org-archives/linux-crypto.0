From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG
Date: Mon, 13 Dec 2010 12:47:37 -0500
Message-ID: <20101213174737.GA12588@hmsreliant.think-freely.org>
References: <385134132.614111292260958484.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <1049191813.614221292261074998.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43629 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab0LMRrp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 12:47:45 -0500
Content-Disposition: inline
In-Reply-To: <1049191813.614221292261074998.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 13, 2010 at 12:24:34PM -0500, Miloslav Trmac wrote:
> ----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> > +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> > +			struct msghdr *msg, size_t len, int flags)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct rng_ctx *ctx = ask->private;
> > +	int rc, i;
> > +	u8 *data = kzalloc(len, GFP_KERNEL);
> There probably should be an upper limit on the allocation - perhaps just always allocate a single page.
> 
I'd rather allocate the explicit amount needed, just to avoid added memory
pressure allocating memory that we won't use, but yes, I can definately add an
upper limit to how much data can be requested in a single call.

> > +static void rng_release(void *private)
> > +{
> > +	struct rng_ctx *ctx = private;
> > +	crypto_free_rng(ctx->ctx);
> > +	kfree(ctx->seed);
> Is a seed secret enough that it should be zeroed before freeing?  (Same in setkey, accept_parent).
> 
I don't think that nececcecary, strictly speaking, but it couldn't hurt.
Actually looking at it, I don't really need to duplicate the seed at all in
accept_parent.  I can probaby shrink that down considerably. 

Thanks for the notes Mirek, I'll post an updated version shortly.
Neil

>      Mirek
> 
