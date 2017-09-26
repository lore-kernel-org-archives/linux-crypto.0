From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 09:16:46 +0530
Message-ID: <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
 <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170925155430.GB131920@otc-nc-03>
 <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Robin Murphy <robin.murphy@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
To: Casey Leedom <leedom@chelsio.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:43450 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967628AbdIZDrb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 23:47:31 -0400
In-Reply-To: <MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 26-09-2017 00:16, Casey Leedom wrote:
> | From: Raj, Ashok <ashok.raj@intel.com>
> | Sent: Monday, September 25, 2017 8:54 AM
> |
> | Not sure how the page->offset would end up being greater than page-size?
Refer below
> |
> | If you have additional traces, please send them by.
> |
> | Is this a new driver? wondering how we didn't run into this?
>
>   According to Herbert Xu and one of our own engineers, it's actually legal
> for Scatter/Gather Lists to have this.  This isn't my area of expertise
> though so I'm just passing that on.
>
>   I've asked our team to produce a detailed trace of the exact
> Scatter/Gather Lists they're seeing and what ends up coming out of the DMA
> Mappings, etc.  They're in India, so I expect that they'll have this for you
> by tomorrow morning.
Below mentioned log was already there in 1st mail. Copied here for easy reference. Let me know if you need
additional traces.

1) IN esp_output() "__skb_to_sgvec()" convert skb frags to scatter gather list. 
At that moment sg->offset was 4094.
2) From esp_output control reaches to "crypto_authenc_encrypt()". Here in 
"scatterwalk_ffwd()" sg->offset become 4110.
3) Same sg list received by chelsio crypto driver(chcr). When chcr try to do 
DMA mapping it starts giving DMA errors.

Following error observed. first two prints are added for debugging in chcr. 
Kernel version used to reproduce is 4.9.28 on x86_64 with Page size 4K.

Sep 15 12:40:52 heptagon kernel: process_cipher req src ffff8803cb41f0a8
Sep 15 12:40:52 heptagon kernel: ========= issue    hit offset:4110 ======= 
dma_addr f24b000e ==> DMA mapped address returned by dma_map_sg()

Sep 15 12:40:52 heptagon kernel: DMAR: DRHD: handling fault status reg 2
Sep 15 12:40:52 heptagon kernel: DMAR: [DMA Write] Request device [02:00.4] 
fault addr f24b0000 [fault reason 05] PTE Write access is not set

>
> Casey
