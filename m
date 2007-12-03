From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC broken on s390
Date: Tue, 4 Dec 2007 09:09:00 +1100
Message-ID: <20071203220900.GA8573@gondor.apana.org.au>
References: <1196688700.4799.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Jens Axboe <axboe@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4635 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbXLCWJM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Dec 2007 17:09:12 -0500
Content-Disposition: inline
In-Reply-To: <1196688700.4799.5.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 03, 2007 at 02:31:40PM +0100, Jan Glauber wrote:
> Hi Herbert,
> 
> commit 788fefa33b0b50581585925c53c230a36af35d0e in cryptodev breaks hmac
> on s390 du to the usage of sg_chain():
> 
> static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
>                             struct scatterlist *sgl)
> {
> #ifndef ARCH_HAS_SG_CHAIN
>         BUG();
> #endif
> 
> ARCH_HAS_SG_CHAIN is false for s390 (and also for some other arch's).
> 
> What should we do with this?

Looks like we took a step backwards because the chaining I had
before worked on all architectures :)

I suppose either we'll have to do our own chaining again or implement
it for all architectures.  I'll look into this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
