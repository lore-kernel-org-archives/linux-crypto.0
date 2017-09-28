From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 28 Sep 2017 17:59:11 +0100
Message-ID: <a135090f-27e2-cf69-b3a7-c9d0e101bf07@arm.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170928132942.GA99552@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Harsh Jain <Harsh@chelsio.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
To: "Raj, Ashok" <ashok.raj@intel.com>,
        Casey Leedom <leedom@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60206 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdI1Q7P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 12:59:15 -0400
In-Reply-To: <20170928132942.GA99552@otc-nc-03>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28/09/17 14:29, Raj, Ashok wrote:
> Hi Casey
> 
> On Thu, Sep 28, 2017 at 04:17:59PM +0000, Casey Leedom wrote:
>>   Thanks Robin.  Harsh can certainly test your latest patch as soon as he's
>> back in the office tomorrow morning India time.  If your patch works and is
>> accepted, it sounds like the commit would be important enough to consider
>> backporting into various Long-Term Support releases and the affected
>> distributions.  What's the procedure for nominating a commit for LTS inclusion?

I tend to leave stable decisions up to Joerg as the subsystem
maintainer, particularly when it's code outside my usual areas of
familiarity. FWIW, from a real dig through the history, the fragile
logic seems to date from the 2.6 days, having snuck in with b536d24d212c
("intel-iommu: Clean up intel_map_sg(), remove domain_page_mapping()")

> its documented in Documentation/process/submitting-patches
> 
> I didn't see a new patch fly by.. Robin, could you send that over?

I hope our email server hasn't got blacklisted again... Said patch is
the top of this very thread we're replying on[1] - you were definitely
on cc :(

Robin.

[1]:https://lists.linuxfoundation.org/pipermail/iommu/2017-September/024371.html
