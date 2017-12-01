From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 1 Dec 2017 21:36:49 +1100
Message-ID: <20171201103648.GB320@gondor.apana.org.au>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
 <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
 <20171128154236.19192-4-antoine.tenart@free-electrons.com>
 <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
 <20171201003109.GA26156@gondor.apana.org.au>
 <20171201081157.GA2535@kwain>
 <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41656 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdLAKhr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 05:37:47 -0500
Content-Disposition: inline
In-Reply-To: <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:18:30AM +0100, Kamil Konieczny wrote:
>
> Herbert, is it possible for every init/update that areq->result can be NULL,
> and only for final/update/digit user set it to actual memory ?
> testmgr.c can check if hash update writes into areq->result and if yes, 
> then test fails ?

Yes we should modify testmgr to check that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
