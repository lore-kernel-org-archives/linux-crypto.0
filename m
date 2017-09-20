From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Wed, 20 Sep 2017 16:01:52 +0800
Message-ID: <20170920080151.GA3348@gondor.apana.org.au>
References: <be3bb850-a9f2-61fa-e378-eb44489256e0@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: dwmw2@infradead.org, joro@8bytes.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        leedom@chelsio.com
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <be3bb850-a9f2-61fa-e378-eb44489256e0@chelsio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Harsh Jain <Harsh@chelsio.com> wrote:
> 
> While debugging DMA mapping error in chelsio crypto driver we observed that when scatter/gather list received by driver has some entry with page->offset > 4096 (PAGE_SIZE). It starts giving DMA error.  Without IOMMU it works fine.

This is not a bug.  The network stack can and will feed us such
SG lists.

> 2) It cannot be driver's responsibilty to update received sg entries to adjust offset and page 
> because we are not the only one who directly uses received sg list.

No the driver must deal with this.  Having said that, if we can
improve our driver helper interface to make this easier then we
should do that too.  What we certainly shouldn't do is to take a
whack-a-mole approach like this patch does.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
