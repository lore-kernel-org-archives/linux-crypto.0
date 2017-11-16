From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 16 Nov 2017 14:32:44 -0700
Message-ID: <20171116143244.2583d044@t450s.home>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
        <1507035334.29211.105.camel@infradead.org>
        <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
        <20171006144309.GA30803@8bytes.org>
        <20171106104709.06b38f7c@jacob-builder>
        <20171115155456.141a6dc8@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>, leedom@chelsio.com,
        herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-crypto@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Harsh@chelsio.com
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933833AbdKPVcr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Nov 2017 16:32:47 -0500
In-Reply-To: <20171115155456.141a6dc8@jacob-builder>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 15 Nov 2017 15:54:56 -0800
Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:

> Hi Alex and all,
> 
> Just wondering if you could merge Robin's patch for the next rc. From
> all our testing, this seems to be a solid fix and should be included in
> the stable releases as well.

Hi Jacob,

Sorry, this wasn't on my radar, I only scanned for patches back through
about when Joerg refreshed his next branch (others on the list speak up
if I didn't pickup your patches for the v4.15 merge window).

This patch makes sense to me and I'm glad you were able to work through
the anomaly Harsh saw in testing as an unrelated issue, but...

> On Mon, 6 Nov 2017 10:47:09 -0800
> Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
> 
> > On Fri, 6 Oct 2017 16:43:09 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> >   
> > > On Tue, Oct 03, 2017 at 07:05:17PM +0100, Robin Murphy wrote:    
> > > > Now, there are indeed plenty of drivers and subsystems which do
> > > > work on lists of explicitly single pages - anything doing some
> > > > variant of "addr = kmap_atomic(sg_page(sg)) + sg->offset;" is easy
> > > > to spot - but I don't think DMA API implementations are in a
> > > > position to make any kind of assumption; nearly all of them just
> > > > shut up and handle sg->length bytes from sg_phys(sg) without
> > > > questioning the caller, and I reckon that's exactly what they
> > > > should be doing.      
> > > 
> > > I agree with that, it is not explicitly forbidden to have an
> > > sg->offset > PAGE_SIZE and most IOMMU drivers handle this case.
> > > 
> > > So this is a problem I'd like to see resolved in the VT-d driver
> > > too. If nobody comes up with a correct fix soon I'll apply this one
> > > and rip out the large-page support from __domain_mapping() to make
> > > it work.

What do we do about this?  I certainly can't rip out large page support
and put a stable tag on the patch.  I'm not really spotting what's
wrong with large page support here, other than the comment about it
being a mess.  Suggestions?  Thanks,

Alex
