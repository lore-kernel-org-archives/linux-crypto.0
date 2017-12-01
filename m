From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 1 Dec 2017 11:52:25 +0100
Message-ID: <20171201105225.GB22648@kwain>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
 <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
 <20171128154236.19192-4-antoine.tenart@free-electrons.com>
 <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
 <20171201003109.GA26156@gondor.apana.org.au>
 <20171201081157.GA2535@kwain>
 <20171201103552.GA320@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59530 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbdLAKwh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 05:52:37 -0500
Content-Disposition: inline
In-Reply-To: <20171201103552.GA320@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Fri, Dec 01, 2017 at 09:35:52PM +1100, Herbert Xu wrote:
> On Fri, Dec 01, 2017 at 09:11:57AM +0100, Antoine Tenart wrote:
> >
> > I agree this should not be the case.
> > 
> > But:
> > - Other drivers are doing this check (grep "if (!req->result)" or
> >   "if (req->result)" to see some of them).
> > - I see at least one commit fixing the exact same issue I'm facing here,
> >   393897c5156a415533ff85aa381458840417b032:
> > 
> >     crypto: ccp - Check for caller result area before using it
> > 
> >     For a hash operation, the caller doesn't have to supply a result
> >     area on every call so don't use it / update it if it hasn't
> >     been supplied.
> > 
> > I'm not entirely sure what was the code path that leads to this, I'll
> > reproduce the issue and try to understand what is going on (I clearly
> > recall having this crash though).
> 
> That's different.  In that case an unconditional copy is made
> regardless of whether the operation is final or update.  That's
> why a check is required.
> 
> If the operation is finup/final/digest then req->result must be
> set and you don't need to check it.

Ah, I didn't understand your point then. Of course ->result should be
allocated for finup/final/digest. The function where I fix this is
called regardless of the operation that was performed, so it can be an
update() as well.

Thanks,
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
