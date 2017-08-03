From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3 2/6] crypto/nx: Create nx842_configure_crb function
Date: Thu, 3 Aug 2017 18:09:29 +0800
Message-ID: <20170803100929.GA13298@gondor.apana.org.au>
References: <1500699459.23205.3.camel@hbabu-laptop>
 <20170803055850.GA11987@gondor.apana.org.au>
 <87bmnxq8oj.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, suka@us.ibm.com,
        ddstreet@ieee.org, linuxram@us.ibm.com, npiggin@gmail.com,
        hbabu@us.ibm.com
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34644 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbdHCKJr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 06:09:47 -0400
Content-Disposition: inline
In-Reply-To: <87bmnxq8oj.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 07:53:16PM +1000, Michael Ellerman wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> 
> > On Fri, Jul 21, 2017 at 09:57:39PM -0700, Haren Myneni wrote:
> >> 
> >> Configure CRB is moved to nx842_configure_crb() so that it can
> >> be used for icswx and VAS exec functions. VAS function will be
> >> added later with P9 support.
> >> 
> >> Signed-off-by: Haren Myneni <haren@us.ibm.com>
> >
> > Your patch does not apply against cryptodev.  Please rebase.
> 
> It depends on another series that will go via my tree, so it might be
> better if this series goes via my tree too?

Sure, that's fine by me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
