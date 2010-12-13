From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG
Date: Mon, 13 Dec 2010 12:50:21 -0500 (EST)
Message-ID: <1453219646.616071292262621577.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20101213174737.GA12588@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38565 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab0LMRub (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 12:50:31 -0500
In-Reply-To: <20101213174737.GA12588@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@tuxdriver.com> wrote:

> On Mon, Dec 13, 2010 at 12:24:34PM -0500, Miloslav Trmac wrote:
> > ----- "Neil Horman" <nhorman@tuxdriver.com> wrote:
> > > +static int rng_recvmsg(struct kiocb *unused, struct socket
> *sock,
> > > +			struct msghdr *msg, size_t len, int flags)
> > > +{
> > > +	struct sock *sk = sock->sk;
> > > +	struct alg_sock *ask = alg_sk(sk);
> > > +	struct rng_ctx *ctx = ask->private;
> > > +	int rc, i;
> > > +	u8 *data = kzalloc(len, GFP_KERNEL);
> > There probably should be an upper limit on the allocation - perhaps
> just always allocate a single page.
> > 
> I'd rather allocate the explicit amount needed, just to avoid added memory
> pressure allocating memory that we won't use, but yes, I can definately add an
> upper limit to how much data can be requested in a single call.
Please allow arbitrarily large requests.  rng_recvmsg can easily use a smaller buffer by filling the user-space destination one buffer-size at a time, on the other hand handling an arbitrary upper limit in user-space would be unnecessarily complex.
    Mirek
