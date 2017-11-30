From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Thu, 30 Nov 2017 15:30:51 +0100
Message-ID: <20171130143051.GK30391@kwain>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
 <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
 <20171128154236.19192-4-antoine.tenart@free-electrons.com>
 <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
 <20171130092927.GH30391@kwain>
 <6a920087-6cf2-6074-1f95-63ce56f0abee@partner.samsung.com>
 <20171130124106.GJ30391@kwain>
 <37f78e96-f7f7-2fde-25ac-7ae54a7a4217@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:34737 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdK3ObC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 09:31:02 -0500
Content-Disposition: inline
In-Reply-To: <37f78e96-f7f7-2fde-25ac-7ae54a7a4217@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kamil,

On Thu, Nov 30, 2017 at 03:10:28PM +0100, Kamil Konieczny wrote:
> On 30.11.2017 13:41, Antoine Tenart wrote:
> > 
> > No, if we do this we'll lose the ability to export the current state.
> 
> So maybe save it into request context:
> 
> 	result_sz = crypto_ahash_digestsize(ahash);
> 	ctx = ahash_request_ctx(areq);
> 
>   	if (sreq->finish)
>  		memcpy(sreq->state, areq->result, result_sz);
> 	else
> 		memcpy(sreq->state, ctx->state, result_sz);

Storing the digest into a driver own buffer could improve the export
ability in some *very rare* cases. If so I would suggest not to deal
with the kind of test you proposed, but to have your own buffer used
each time.

Anyway, this has nothing to do with the fix I'm proposing here, as it
would change the driver's logic, and would solve a complete different
(rare) issue.

The proposal here is to have a simple fix (which is similar to what can
be found in some other drivers), that can easily be backported to avoid
NULL pointer dereferences in older versions of the kernel.

Thanks,
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
