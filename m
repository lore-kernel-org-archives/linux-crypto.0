From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 18:34:54 +0530
Message-ID: <9412dba0-8e52-3361-f51d-0a8c70364d7f@chelsio.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4j3J41eY2eR07nTvo75F0yCbL9bNHM8GmXEFOHDQUuf8Q@mail.gmail.com>
 <MWHPR12MB1600948B2F57696189FC7C22C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Casey Leedom <leedom@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:38379 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965798AbdIZNFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 09:05:31 -0400
In-Reply-To: <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 26-09-2017 01:41, Dan Williams wrote:
> On Mon, Sep 25, 2017 at 1:05 PM, Casey Leedom <leedom@chelsio.com> wrote:
>> | From: Dan Williams <dan.j.williams@intel.com>
>> | Sent: Monday, September 25, 2017 12:31 PM
>> | ...
>> | IIUC it looks like this has been broken ever since commit e1605495c716
>> | "intel-iommu: Introduce domain_sg_mapping() to speed up
>> | intel_map_sg()". I.e. it looks like the calculation for pte_val should
>> | be:
>> |
>> |     pteval = (page_to_phys(sg_page(sg)) + sg->offset) | prot;
>>
>> Hhmmm, shouldn't that be:
>>
>>     pteval = (page_to_phys(sg_page(sg)) + (sg->offset>>PAGE_SHIFT)) | prot;
> Yes, I think you're right. We do want to mask off the page-unaligned
> portion of sg->offset.
Tried changing above line in "__domain_mapping" but didn't help.
