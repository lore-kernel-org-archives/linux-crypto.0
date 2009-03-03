From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Date: Tue, 3 Mar 2009 11:02:20 +0800
Message-ID: <20090303030219.GA26480@gondor.apana.org.au>
References: <20090226095552.GB5811@n2100.arm.linux.org.uk> <20090226121043.GA13749@gondor.apana.org.au> <20090226232025.GE5811@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44496 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbZCCDCe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2009 22:02:34 -0500
Content-Disposition: inline
In-Reply-To: <20090226232025.GE5811@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 26, 2009 at 11:20:26PM +0000, Russell King - ARM Linux wrote:
>
> I don't think you can use chained scatterlists unless the architecture
> supports it.  It's not a case that you have to flatten the chaining
> before passing it over to the arch - it seems you're not allowed to
> create a chained scatterlist in the first place:
> 
> static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
>                             struct scatterlist *sgl)
> {
> #ifndef ARCH_HAS_SG_CHAIN
>         BUG();
> #endif

That's why we don't use sg_chain.  The chaining is completely
internal to the crypto API (or at least it's supposed to be).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
