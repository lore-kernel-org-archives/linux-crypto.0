From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Fri, 6 Oct 2017 16:43:09 +0200
Message-ID: <20171006144309.GA30803@8bytes.org>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <1507035334.29211.105.camel@infradead.org>
 <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        leedom@chelsio.com, Harsh@chelsio.com, herbert@gondor.apana.org.au,
        iommu@lists.linux-foundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:39360 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdJFOnL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 10:43:11 -0400
Content-Disposition: inline
In-Reply-To: <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 03, 2017 at 07:05:17PM +0100, Robin Murphy wrote:
> Now, there are indeed plenty of drivers and subsystems which do work on
> lists of explicitly single pages - anything doing some variant of
> "addr = kmap_atomic(sg_page(sg)) + sg->offset;" is easy to spot - but I
> don't think DMA API implementations are in a position to make any kind
> of assumption; nearly all of them just shut up and handle sg->length
> bytes from sg_phys(sg) without questioning the caller, and I reckon
> that's exactly what they should be doing.

I agree with that, it is not explicitly forbidden to have an
sg->offset > PAGE_SIZE and most IOMMU drivers handle this case.

So this is a problem I'd like to see resolved in the VT-d driver too. If
nobody comes up with a correct fix soon I'll apply this one and rip out
the large-page support from __domain_mapping() to make it work.

Speaking of __domain_mapping(), this function is a big unmaintainable
mess which should be split and rewritten. A clean and maintainable
rewrite can alse re-add the large-page support.


Regards,

	Joerg
