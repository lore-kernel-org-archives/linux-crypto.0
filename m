From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Date: Fri, 27 Feb 2009 08:50:33 +0800
Message-ID: <20090227005033.GA20046@gondor.apana.org.au>
References: <20090226232025.GE5811@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52402 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbZB0Aus (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 19:50:48 -0500
Content-Disposition: inline
In-Reply-To: <20090226232025.GE5811@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
> I don't think you can use chained scatterlists unless the architecture
> supports it.  It's not a case that you have to flatten the chaining
> before passing it over to the arch - it seems you're not allowed to
> create a chained scatterlist in the first place:
> 
> static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
>                            struct scatterlist *sgl)
> {
> #ifndef ARCH_HAS_SG_CHAIN
>        BUG();
> #endif

The crypto layer does its own chaining.  However, this chaining
is not meant to be exposed to any external entities until generic
chaining has been ported everywhere.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
