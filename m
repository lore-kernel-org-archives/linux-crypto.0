From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 1 Dec 2017 11:55:45 +0100
Message-ID: <20171201105545.GC22648@kwain>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
 <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
 <20171128154236.19192-4-antoine.tenart@free-electrons.com>
 <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
 <20171201003109.GA26156@gondor.apana.org.au>
 <20171201081157.GA2535@kwain>
 <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
 <20171201102440.GA22648@kwain>
 <cdc62e93-a09d-af28-e279-3a6dd10066fd@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59565 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdLAKz5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 05:55:57 -0500
Content-Disposition: inline
In-Reply-To: <cdc62e93-a09d-af28-e279-3a6dd10066fd@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:43:18AM +0100, Kamil Konieczny wrote:
> On 01.12.2017 11:24, Antoine Tenart wrote:
> > 
> > Yes the last_req flag is set for the last request, so when
> > digest/finup/final are called. But no we can't copy the result into the
> > state based on this as an user might want to perform multiple updates,
> > then export the context, to import it again before sending more updates.
> 
> IMHO set them to false in hash update and init, set finish false and last_req true
> for hash final, and set both true for hash finup and digest.
> 
> As Herbert tells in https://www.spinics.net/lists/linux-crypto/msg28658.html
> you should support scenario export + update/finup, so basically export is reading
> state but it do not halt your hash driver.

Except if you import another state in the meantime.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
