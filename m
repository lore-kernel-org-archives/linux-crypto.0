Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872B7C43332
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6550864F4B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhCDAHQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:16 -0500
Received: from foss.arm.com ([217.140.110.172]:46548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhCCMJY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 07:09:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A47AF31B;
        Wed,  3 Mar 2021 04:07:36 -0800 (PST)
Received: from [10.57.48.219] (unknown [10.57.48.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 605103F766;
        Wed,  3 Mar 2021 04:07:34 -0800 (PST)
Subject: Re: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230! (and
 dma-coherent query)
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Sascha Hauer <sha@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20210301152231.GC5549@pengutronix.de>
 <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <a5d6cc26-cd23-7c31-f56e-f6d535ea39b0@arm.com>
Date:   Wed, 3 Mar 2021 12:07:29 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a52e0a0f-a784-2430-4b37-fb9fdcf3692b@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021-03-03 10:26, Horia Geantă wrote:
> Adding some people in the loop, maybe they could help in understanding
> why lack of "dma-coherent" property for a HW-coherent device could lead to
> unexpected / strange side effects.
> 
> On 3/1/2021 5:22 PM, Sascha Hauer wrote:
>> Hi All,
>>
>> I am on a Layerscape LS1046a using Linux-5.11. The CAAM driver sometimes
>> crashes during the run-time self tests with:
>>
>>> kernel BUG at drivers/crypto/caam/jr.c:247!
>>> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>>> Modules linked in:
>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
>>> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
>>> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
>>> pc : caam_jr_dequeue+0x98/0x57c
>>> lr : caam_jr_dequeue+0x98/0x57c
>>> sp : ffff800010003d50
>>> x29: ffff800010003d50 x28: ffff8000118d4000
>>> x27: ffff8000118d4328 x26: 00000000000001f0
>>> x25: ffff0008022be480 x24: ffff0008022c6410
>>> x23: 00000000000001f1 x22: ffff8000118d4329
>>> x21: 0000000000004d80 x20: 00000000000001f1
>>> x19: 0000000000000001 x18: 0000000000000020
>>> x17: 0000000000000000 x16: 0000000000000015
>>> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
>>> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
>>> x11: ffff800011700a38 x10: 00000000fffff000
>>> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
>>> x7 : 0000000000000001 x6 : 0000000000000000
>>> x5 : 0000000000000000 x4 : 0000000000000000
>>> x3 : 00000000ffffffff x2 : 0000000000000000
>>> x1 : 0000000000000000 x0 : 0000000000001800
>>> Call trace:
>>>   caam_jr_dequeue+0x98/0x57c
>>>   tasklet_action_common.constprop.0+0x164/0x18c
>>>   tasklet_action+0x44/0x54
>>>   __do_softirq+0x160/0x454
>>>   __irq_exit_rcu+0x164/0x16c
>>>   irq_exit+0x1c/0x30
>>>   __handle_domain_irq+0xc0/0x13c
>>>   gic_handle_irq+0x5c/0xf0
>>>   el1_irq+0xb4/0x180
>>>   arch_cpu_idle+0x18/0x30
>>>   default_idle_call+0x3c/0x1c0
>>>   do_idle+0x23c/0x274
>>>   cpu_startup_entry+0x34/0x70
>>>   rest_init+0xdc/0xec
>>>   arch_call_rest_init+0x1c/0x28
>>>   start_kernel+0x4ac/0x4e4
>>> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)
>>
>> The driver iterates over the descriptors in the output ring and matches them
>> with the ones it has previously queued. If it doesn't find a matching
>> descriptor it complains with the BUG_ON() seen above. What I see sometimes is
>> that the address in the output ring is 0x0, the job status in this case is
>> 0x40000006 (meaning DECO Invalid KEY command). It seems that the CAAM doesn't
>> write the descriptor address to the output ring at least in some error cases.
>> When we don't have the descriptor address of the failed descriptor we have no
>> way to find it in the list of queued descriptors, thus we also can't find the
>> callback for that descriptor. This looks very unfortunate, anyone else seen
>> this or has an idea what to do about it?
>>
>> I haven't investigated yet which job actually fails and why. Of course that would
>> be my ultimate goal to find that out.
>>
> This looks very similar to an earlier report from Greg.
> He confirmed that adding "dma-coherent" property to the "crypto" DT node
> fixes the issue:
> https://lore.kernel.org/linux-crypto/74f664f5-5433-d322-4789-3c78bdb814d8@kernel.org
> Patch rebased on v5.11 is at the bottom. Does it work for you too?
> 
> What I don't understand (and the reason I've postponed upstreaming it) is
> _why_ exactly this patch is working.
> I would have expected that a HW-coherent device to work fine even without
> the "dma-coherent" DT property in the corresponding node.
> I've found what seems related discussions involving eSDHC, but still I am trying
> to figure out what's happening. I'd really appreciate a clarification on what
> could go wrong (e.g. interactions with SW-based cache management etc.):
> https://lore.kernel.org/linux-mmc/20190916171509.GG25745@shell.armlinux.org.uk
> https://lore.kernel.org/lkml/20191010083503.250941866@linuxfoundation.org
> https://lore.kernel.org/linux-mmc/AM7PR04MB688507B5B4D84EB266738891F8320@AM7PR04MB6885.eurprd04.prod.outlook.com

Consider the flow for a non-coherent DMA_FROM_DEVICE transfer:

1: dma_map_page() - cleans and invalidates caches to prevent any dirty 
lines being written back during the transfer
2: CPU cache may prefetch the buffer back in at any time from now on 
(e.g. if other threads access nearby memory), but that's OK since the 
CPU must not actually access it until after step 4, and clean lines 
don't get written back
3: device writes to buffer - non-coherent so goes straight to DRAM
4: dma_unmap_page() - invalidates caches to discard any clean lines 
speculatively fetched since step 1
5: CPU reads from buffer - fetches new data into cache, all is well

Now consider what can happen if the device is secretly coherent, but the 
DMA API still uses the same non-coherent flow:

1: dma_map_page() - cleans and invalidates caches to prevent any dirty 
lines being written back during the transfer
2: CPU cache *does* happen to prefetch the buffer back in
3: device writes to buffer - write snoop hits in cache so data goes 
there instead of DRAM
4: dma_unmap_page() - invalidates caches, unknowingly destroying new data
5: CPU reads from page - fetches whatever old data was cleaned to DRAM 
in step 1, hilarity ensues.

Note that it still *can* work out OK in the (likely) case that the 
prefetch at step 2 doesn't happen, so in step 3 the snoop doesn't hit 
and the data does end up going to DRAM, or (less likely) the updated 
dirty lines are naturally evicted and written back between steps 3 and 4.

Similarly, if a buffer is mmap'ed to userspace (or remapped for coherent 
DMA) with non-cacheable attributes on the assumption that the device is 
non-coherent - the cacheable alias from the kernel linear map can still 
be present in caches, so coherent device accesses can unexpectedly hit 
that and fail to observe CPU reads and writes going straight to/from 
DRAM via the non-cacheable alias. We hit this case with Panfrost on some 
Amlogic platforms not too long ago.

Hope that helps clarify things.

Robin.

> 
> Thanks,
> Horia
> 
> -- >8 --
> 
> Subject: [PATCH] arm64: dts: ls1046a: mark crypto engine dma coherent
> 
> Crypto engine (CAAM) on LS1046A platform has support for HW coherency,
> mark accordingly the DT node.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>   arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> index 025e1f587662..6d4db3e021e8 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> @@ -325,6 +325,7 @@
>                          ranges = <0x0 0x00 0x1700000 0x100000>;
>                          reg = <0x00 0x1700000 0x0 0x100000>;
>                          interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
> +                       dma-coherent;
> 
>                          sec_jr0: jr@10000 {
>                                  compatible = "fsl,sec-v5.4-job-ring",
> 
