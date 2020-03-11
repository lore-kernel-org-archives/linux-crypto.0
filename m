Return-Path: <SRS0=jZ+Q=44=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76435C10F25
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 04:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435F32146E
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 04:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583902074;
	bh=ouooP6nnMDZ8LhjZt/FqEUiqiWWvvzgQhvB7qIvxDEc=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=u07KVNvxFG/qSfpr2DJg5TjnTWlEUBzYG71Kbk+KPrHa3eJ6mT1F4pp8bxBnHe1I6
	 NG/Fc14YpFvTEbmriOewk4GAlE0vd3qFlG78NQQGDO39Yjyx/cUreUgUQV4aowXi6/
	 N41adxeyyA68/hYGW4c/3h0NOiYANQztVQZniNZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgCKErx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Mar 2020 00:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgCKErx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Mar 2020 00:47:53 -0400
Received: from [10.44.0.22] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1CC420866;
        Wed, 11 Mar 2020 04:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583902072;
        bh=ouooP6nnMDZ8LhjZt/FqEUiqiWWvvzgQhvB7qIvxDEc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LujIv8LL/4AmwHEHsasDxmELkX0wKjUl/8alvZsZGteNFx7t0aDwz62qi3IMHPkYO
         lP4sews7/sC8Km4N/nacRDfC98xx1DaDMvuYY81+G4S4E8qlmh9erc8F39c12GqH0U
         ZPAM6D59YiAMsUemDOywnTZMcuI2EONj2cLqjL8Q=
Subject: Re: [PATCH] crypto: caam - select DMA address size at runtime
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <e19cec7b-0721-391f-f43e-437062a7eab3@kernel.org>
 <fafc165f-2bc7-73d6-b8e0-d40ed5786af3@nxp.com>
From:   Greg Ungerer <gerg@kernel.org>
Message-ID: <74f664f5-5433-d322-4789-3c78bdb814d8@kernel.org>
Date:   Wed, 11 Mar 2020 14:47:47 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fafc165f-2bc7-73d6-b8e0-d40ed5786af3@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On 10/3/20 10:00 pm, Horia Geantă wrote:
> On 3/10/2020 8:43 AM, Greg Ungerer wrote:
>> Hi Andrey,
>>
>> I am tracking down a caam driver problem, where it is dumping on startup
>> on a Layerscape 1046 based hardware platform. The dump typically looks
>> something like this:
>>
>> ------------[ cut here ]------------
>> kernel BUG at drivers/crypto/caam/jr.c:218!
>> Internal error: Oops - BUG: 0 [#1] SMP
>> Modules linked in:
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-ac0 #1
>> Hardware name: Digi AnywhereUSB-8 (DT)
>> pstate: 40000005 (nZcv daif -PAN -UAO)
>> pc : caam_jr_dequeue+0x3f8/0x420
>> lr : tasklet_action_common.isra.17+0x144/0x180
>> sp : ffffffc010003df0
>> x29: ffffffc010003df0 x28: 0000000000000001
>> x27: 0000000000000000 x26: 0000000000000000
>> x25: ffffff8020aeba80 x24: 0000000000000000
>> x23: 0000000000000000 x22: ffffffc010ab4e51
>> x21: 0000000000000001 x20: ffffffc010ab4000
>> x19: ffffff8020a2ec10 x18: 0000000000000004
>> x17: 0000000000000001 x16: 6800f1f100000000
>> x15: ffffffc010de5000 x14: 0000000000000000
>> x13: ffffffc010de5000 x12: ffffffc010de5000
>> x11: 0000000000000000 x10: ffffff8073018080
>> x9 : 0000000000000028 x8 : 0000000000000000
>> x7 : 0000000000000000 x6 : ffffffc010a11140
>> x5 : ffffffc06b070000 x4 : 0000000000000008
>> x3 : ffffff8073018080 x2 : 0000000000000000
>> x1 : 0000000000000001 x0 : 0000000000000000
>>
>> Call trace:
>>    caam_jr_dequeue+0x3f8/0x420
>>    tasklet_action_common.isra.17+0x144/0x180
>>    tasklet_action+0x24/0x30
>>    _stext+0x114/0x228
>>    irq_exit+0x64/0x70
>>    __handle_domain_irq+0x64/0xb8
>>    gic_handle_irq+0x50/0xa0
>>    el1_irq+0xb8/0x140
>>    arch_cpu_idle+0x10/0x18
>>    do_idle+0xf0/0x118
>>    cpu_startup_entry+0x24/0x60
>>    rest_init+0xb0/0xbc
>>    arch_call_rest_init+0xc/0x14
>>    start_kernel+0x3d0/0x3fc
>> Code: d3607c21 2a020002 aa010041 17ffff4d (d4210000)
>> ---[ end trace ce2c4c37d2c89a99 ]---
>>
>>
>> Git bisecting this lead me to commit a1cf573ee95d ("crypto: caam -
>> select DMA address size at runtime") as the culprit.
>>
>> I came across commit by Iuliana, 7278fa25aa0e ("crypto: caam -
>> do not reset pointer size from MCFGR register"). However that
>> doesn't fix this dumping problem for me (it does seem to occur
>> less often though). [NOTE: dump above generated with this
>> change applied].
>>
>> I initially hit this dump on a linux-5.4, and it also occurs on
>> linux-5.5 for me.
>>
>> Any thoughts?
>>
> Could you try the following patch?
> It worked on my side.
> 
> Unfortunately I don't think it fixes the root cause,
> the device should work fine (though slower) without the property.
> DMA API violations (e.g. cacheline sharing) are a good candidate.

Yep, that definitely fixes it for me. Thanks!

Regards
Greg


> --- >8 ---
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
> index d4c1da3d4bde..9e8147ef1748 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> @@ -244,6 +244,7 @@
>                          ranges = <0x0 0x00 0x1700000 0x100000>;
>                          reg = <0x00 0x1700000 0x0 0x100000>;
>                          interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
> +                       dma-coherent;
> 
>                          sec_jr0: jr@10000 {
>                                  compatible = "fsl,sec-v5.4-job-ring",
> --
> 2.17.1
> 
