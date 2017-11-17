From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Fri, 17 Nov 2017 07:48:34 -0800
Message-ID: <20171117154833.GA56337@otc-nc-03>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <1507035334.29211.105.camel@infradead.org>
 <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
 <20171006144309.GA30803@8bytes.org>
 <20171106104709.06b38f7c@jacob-builder>
 <20171115155456.141a6dc8@jacob-builder>
 <20171116143244.2583d044@t450s.home>
 <20171116210933.GA53016@otc-nc-03>
 <20171117091814.6673aecf@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, leedom@chelsio.com,
        herbert@gondor.apana.org.au, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, Harsh@chelsio.com
To: Alex Williamson <alex.williamson@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57047 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965345AbdKQQ0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Nov 2017 11:26:21 -0500
Content-Disposition: inline
In-Reply-To: <20171117091814.6673aecf@t450s.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Alex

On Fri, Nov 17, 2017 at 09:18:14AM -0700, Alex Williamson wrote:
> On Thu, 16 Nov 2017 13:09:33 -0800
> "Raj, Ashok" <ashok.raj@intel.com> wrote:
> 
> > > 
> > > What do we do about this?  I certainly can't rip out large page support
> > > and put a stable tag on the patch.  I'm not really spotting what's
> > > wrong with large page support here, other than the comment about it
> > > being a mess.  Suggestions?  Thanks,
> > >   
> > 
> > Largepage seems to work and i don't think we need to rip it out. When
> > Harsh tested it at one point we thought disabling super-page seemed to make
> > the problem go away. Jacob tested and we still saw the need for Robin's patch.
> > 
> > Yes, the function looks humongous but i don't think we should wait for that 
> > before this merge.
> 
> Ok.  Who wants to toss in review and testing sign-offs?  Clearly
> there's been a lot more eyes and effort on this patch than reflected in
> the original posting.  I'll add a stable cc.  Thanks,

Reported by: Harsh <harsh@chelsio.com>
Reviewed by: Ashok Raj <ashok.raj@intel.com>
Tested by: Jacob Pan <jacob.jun.pan@intel.com>
> 
> Alex
