Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9A1C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 17:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329BF64F60
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 17:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbhCDREU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 12:04:20 -0500
Received: from foss.arm.com ([217.140.110.172]:41714 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhCDRDv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 12:03:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2B9731B;
        Thu,  4 Mar 2021 09:03:05 -0800 (PST)
Received: from [10.57.48.219] (unknown [10.57.48.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 775E63F7D7;
        Thu,  4 Mar 2021 09:03:03 -0800 (PST)
Subject: Re: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230! (and
 dma-coherent query)
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Sascha Hauer <sha@pengutronix.de>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20210301152231.GC5549@pengutronix.de>
 <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
 <20210303145656.GL5549@pengutronix.de>
 <0103a43a-382d-0d71-a6ea-ead3d7ab7041@nxp.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <fe6faa24-d8f7-d18f-adfa-44fa0caa1598@arm.com>
Date:   Thu, 4 Mar 2021 17:02:57 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0103a43a-382d-0d71-a6ea-ead3d7ab7041@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021-03-03 16:40, Horia Geantă wrote:
> On 3/3/2021 4:57 PM, Sascha Hauer wrote:
>> On Wed, Mar 03, 2021 at 12:26:32PM +0200, Horia Geantă wrote:
>>> Adding some people in the loop, maybe they could help in understanding
>>> why lack of "dma-coherent" property for a HW-coherent device could lead to
>>> unexpected / strange side effects.
>>>
>>> On 3/1/2021 5:22 PM, Sascha Hauer wrote:
>>>> Hi All,
>>>>
>>>> I am on a Layerscape LS1046a using Linux-5.11. The CAAM driver sometimes
>>>> crashes during the run-time self tests with:
>>>>
>>>>> kernel BUG at drivers/crypto/caam/jr.c:247!
>>>>> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>>>>> Modules linked in:
>>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
>>>>> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
>>>>> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
>>>>> pc : caam_jr_dequeue+0x98/0x57c
>>>>> lr : caam_jr_dequeue+0x98/0x57c
>>>>> sp : ffff800010003d50
>>>>> x29: ffff800010003d50 x28: ffff8000118d4000
>>>>> x27: ffff8000118d4328 x26: 00000000000001f0
>>>>> x25: ffff0008022be480 x24: ffff0008022c6410
>>>>> x23: 00000000000001f1 x22: ffff8000118d4329
>>>>> x21: 0000000000004d80 x20: 00000000000001f1
>>>>> x19: 0000000000000001 x18: 0000000000000020
>>>>> x17: 0000000000000000 x16: 0000000000000015
>>>>> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
>>>>> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
>>>>> x11: ffff800011700a38 x10: 00000000fffff000
>>>>> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
>>>>> x7 : 0000000000000001 x6 : 0000000000000000
>>>>> x5 : 0000000000000000 x4 : 0000000000000000
>>>>> x3 : 00000000ffffffff x2 : 0000000000000000
>>>>> x1 : 0000000000000000 x0 : 0000000000001800
>>>>> Call trace:
>>>>>   caam_jr_dequeue+0x98/0x57c
>>>>>   tasklet_action_common.constprop.0+0x164/0x18c
>>>>>   tasklet_action+0x44/0x54
>>>>>   __do_softirq+0x160/0x454
>>>>>   __irq_exit_rcu+0x164/0x16c
>>>>>   irq_exit+0x1c/0x30
>>>>>   __handle_domain_irq+0xc0/0x13c
>>>>>   gic_handle_irq+0x5c/0xf0
>>>>>   el1_irq+0xb4/0x180
>>>>>   arch_cpu_idle+0x18/0x30
>>>>>   default_idle_call+0x3c/0x1c0
>>>>>   do_idle+0x23c/0x274
>>>>>   cpu_startup_entry+0x34/0x70
>>>>>   rest_init+0xdc/0xec
>>>>>   arch_call_rest_init+0x1c/0x28
>>>>>   start_kernel+0x4ac/0x4e4
>>>>> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)
>>>>
>>>> The driver iterates over the descriptors in the output ring and matches them
>>>> with the ones it has previously queued. If it doesn't find a matching
>>>> descriptor it complains with the BUG_ON() seen above. What I see sometimes is
>>>> that the address in the output ring is 0x0, the job status in this case is
>>>> 0x40000006 (meaning DECO Invalid KEY command). It seems that the CAAM doesn't
>>>> write the descriptor address to the output ring at least in some error cases.
>>>> When we don't have the descriptor address of the failed descriptor we have no
>>>> way to find it in the list of queued descriptors, thus we also can't find the
>>>> callback for that descriptor. This looks very unfortunate, anyone else seen
>>>> this or has an idea what to do about it?
>>>>
>>>> I haven't investigated yet which job actually fails and why. Of course that would
>>>> be my ultimate goal to find that out.
>>>>
>>> This looks very similar to an earlier report from Greg.
>>> He confirmed that adding "dma-coherent" property to the "crypto" DT node
>>> fixes the issue:
>>> https://lore.kernel.org/linux-crypto/74f664f5-5433-d322-4789-3c78bdb814d8@kernel.org
>>> Patch rebased on v5.11 is at the bottom. Does it work for you too?
>>
>> Indeed this seems to solve it for me as well, you can add my
>>
>> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
>>
> Thanks!
> I'll append the tag to the formally submitted patch.
> 
>> However, there seem to be two problems: First that "DECO Invalid KEY
>> command" actually occurs and second that the deqeueue code currently
>> can't handle a NULL pointer in the output ring.
> Currently the dequeue code BUGs not only for "NULL pointer", but for any
> IOVA in the output ring that is not matched with an entry in the "shadow"
> (SW) ring.
> Here the BUG_ON() should be replaced with WARN_ON since not finding a match
> means driver can't go to the "SW context" and eventually call complete()
> to wake up the crypto API user. In many cases the user relies on
> crypto_wait_req(), which does not time out and is not killable.
> 
>> Do you think that the occurence of a NULL pointer is also a coherency
>> issue?
>>
> I strongly believe there's a single problem because the issue goes away
> when the patch is applied, even though I haven't figured out what is
> the exact place / data structure that gets corrupted.
> 
> One theory is that corruption occurs in the input ring:
> -CPU sets up correctly the input ring entry
> -device doesn't see the "fresh" data, reading 0x0 for the descriptor address
> -device reads the descriptor commands from address 0x0 and issues
> "DECO invalid KEY command" (note that KEY command opcode is b'00000, so reading
> all zeros from address 0x0 would lead to this error)
> 
> But then the input & output rings are allocated using dma_alloc_coherent(),
> so I'll need to check if lack of "dma-coherent" DT property has the same
> effect on consistent DMA mappings as on streaming DMA mappings.

It certainly can, at least on arm64 where coherent buffers are remapped 
in vmalloc rather than changing the linear map attributes in-place. In 
that case the dma_alloc_coherent() flow looks like this:

1: clean and invalidate pages by (cacheable) linear map address
2: set up non-cacheable remap
3: write zeros via non-cacheable mapping
...
4: CPU writes descriptor via non-cacheable mapping
...
5: device reads descriptor

If the cacheable alias is prefetched back in between steps 1 and 4 (e.g. 
from another thread accessing an adjacent page by linear map address), 
the CPU writes will (usually) still bypass the caches and go straight to 
DRAM, so if the device read unexpectedly snoops it can return the older 
data from the cache. This will normally be the zeros from step 3, unless 
you're extremely unlucky and the prefetch happened even before that. As 
I mentioned, this is exactly what we were hitting with Panfrost where 
GPU coherency wasn't described.

Robin.
