From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Mon, 30 Mar 2009 13:54:15 +0200
Message-ID: <20090330115415.GC6791@secunet.com>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com> <20090327083615.GB27903@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:38219 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbZC3LwY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2009 07:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20090327083615.GB27903@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 27, 2009 at 04:36:15PM +0800, Herbert Xu wrote:
> On Mon, Mar 16, 2009 at 12:52:51PM +0100, Steffen Klassert wrote:
> > If the crypro requests of a crypto transformation are processed in
> > parallel, the usual chain IV generator would serialize the crypto
> > requests again. The percpu IV chain genarator allocates the IV as
> > percpu data and generates percpu IV chains, so a crypro request
> > does not need to wait for the completition of the IV generation
> > from a previous request that runs on a different cpu.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> I actually thought about this one when I first wrote chainiv,
> I chose to avoid this because it has some security consequences.
> In particular, an attacker would now be able to infer whether two
> packets belong to two differnt flows from the fact that they came
> from two different IV streams.
> 
> In any case, I don't think this is central to your work, right?
> 

Well, to do efficient parallel processing we need a percpu IV chain
genarator. pcrypt sends the crypto requests round robin to the cpus
independent of the flow they are belong to, so the flows and the IV
streams are mixing. As long as we use the percpu IV chain genarator just
for parallel algorithms we don't have this security issues. 

