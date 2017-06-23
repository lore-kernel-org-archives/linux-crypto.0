From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Fri, 23 Jun 2017 15:43:59 +0800
Message-ID: <20170623074359.GA29582@gondor.apana.org.au>
References: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
 <20170622024051.GA24529@gondor.apana.org.au>
 <DB6PR04MB317607AE27DD1AC235D0103C8BDB0@DB6PR04MB3176.eurprd04.prod.outlook.com>
 <20170622075338.GA25314@gondor.apana.org.au>
 <1498139799.26231.10.camel@nxp.com>
 <20170623063154.GA29002@gondor.apana.org.au>
 <1498203199.26231.21.camel@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
To: Radu Solea <radu.solea@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35952 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753849AbdFWHyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 03:54:15 -0400
Content-Disposition: inline
In-Reply-To: <1498203199.26231.21.camel@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 07:33:20AM +0000, Radu Solea wrote:
>
> Normally I would agree with you, if it's a weird requirement coming
> from hardware or driver. In this case I think it's different. This is
> not a limitation coming from one driver or one particular hardware
> variety. It applies to all platforms that do not have hw cache
> coherence and a large enough cacheline.
>  
> A couple of lines below the allocation hash is linked into a
> scatterlist, a data structure with remarkably high chances of ending up
> in a DMA endpoint, yet we choose to ignore all other DMA requirements?

What I'm saying is that you cannot rely on crypto API users to do
this for you.  Sure we can fix this one spot in gcm.c.  But any
other user of caam anywhere in the kernel can do exactly the same
thing.

You cannot expect them to know to allocate IVs at cacheline boundaries.
So if you have this requirement (which the generic C version certainly
does not), then you'll need to deal with it in the driver.

Of course if every DMA driver needed to do the same thing, then it's
something the crypto API should take care of, e.g., like we do for
alignmask.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
