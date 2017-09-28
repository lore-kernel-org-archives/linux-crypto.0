From: "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 28 Sep 2017 06:29:43 -0700
Message-ID: <20170928132942.GA99552@otc-nc-03>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robin Murphy <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Harsh Jain <Harsh@chelsio.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
To: Casey Leedom <leedom@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44123 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdI1QYp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 12:24:45 -0400
Content-Disposition: inline
In-Reply-To: <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Casey

On Thu, Sep 28, 2017 at 04:17:59PM +0000, Casey Leedom wrote:
>   Thanks Robin.  Harsh can certainly test your latest patch as soon as he's
> back in the office tomorrow morning India time.  If your patch works and is
> accepted, it sounds like the commit would be important enough to consider
> backporting into various Long-Term Support releases and the affected
> distributions.  What's the procedure for nominating a commit for LTS inclusion?

its documented in Documentation/process/submitting-patches

I didn't see a new patch fly by.. Robin, could you send that over?

Cheers,
Ashok
