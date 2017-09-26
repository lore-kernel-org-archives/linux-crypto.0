From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Tue, 26 Sep 2017 16:47:27 +0530
Message-ID: <c40b0173-2025-9255-3227-30f820e7079e@chelsio.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
 <1506365131.5294.37.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: joro@8bytes.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        leedom@chelsio.com
To: David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:15741 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754275AbdIZLSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 07:18:18 -0400
In-Reply-To: <1506365131.5294.37.camel@infradead.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 26-09-2017 00:15, David Woodhouse wrote:
> On Wed, 2017-09-20 at 16:01 +0800, Herbert Xu wrote:
>> Harsh Jain <Harsh@chelsio.com> wrote:
>>>  
>>> While debugging DMA mapping error in chelsio crypto driver we
>> observed that when scatter/gather list received by driver has some
>> entry with page->offset > 4096 (PAGE_SIZE). It starts giving DMA
>> error.  Without IOMMU it works fine.
>>
>> This is not a bug.  The network stack can and will feed us such
>> SG lists.
> Hm? Under what circumstances is the offset permitted to be >
> PAGE_SIZE? 
Its random, Kernel API's don't check offset value after arithmetic operations like in "__skb_to_sgvec()", "scatterwalk_ffwd()".
