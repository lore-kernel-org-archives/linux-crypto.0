From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Thu, 26 Feb 2009 23:20:26 +0000
Message-ID: <20090226232025.GE5811@n2100.arm.linux.org.uk>
References: <20090226095552.GB5811@n2100.arm.linux.org.uk> <20090226121043.GA13749@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33987 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZBZXUu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 18:20:50 -0500
Content-Disposition: inline
In-Reply-To: <20090226121043.GA13749@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 26, 2009 at 08:10:43PM +0800, Herbert Xu wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >
> > We can't merge this until _all_ of ARM has been fixed for walking
> > scatterlist chains.
> 
> Right, this is definitely not the way to fix this bug.  Because
> even if ARM completely supported chaining, you still have to fix
> all the other architectures as well.

I don't think you can use chained scatterlists unless the architecture
supports it.  It's not a case that you have to flatten the chaining
before passing it over to the arch - it seems you're not allowed to
create a chained scatterlist in the first place:

static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
                            struct scatterlist *sgl)
{
#ifndef ARCH_HAS_SG_CHAIN
        BUG();
#endif
