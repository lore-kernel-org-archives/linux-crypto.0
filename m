Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF7EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 03:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4014D2177B
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 03:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGD60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 23:58:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43942 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbgHGD6Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 23:58:25 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DF065B935D0C3FADCEE4;
        Fri,  7 Aug 2020 11:58:23 +0800 (CST)
Received: from [10.63.139.185] (10.63.139.185) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 7 Aug 2020 11:58:22 +0800
Subject: Re: [BUG] crypto: hisilicon: accessing the data mapped to streaming
 DMA
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <361fa200-479c-e1ef-b7d6-e666a256660f@tsinghua.edu.cn>
 <5F276491.8060409@hisilicon.com>
 <c0001b9b-6529-27bc-2874-2a2674257507@tsinghua.edu.cn>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5F2CD15E.6060508@hisilicon.com>
Date:   Fri, 7 Aug 2020 11:58:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <c0001b9b-6529-27bc-2874-2a2674257507@tsinghua.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/8/3 9:29, Jia-Ju Bai wrote:
> 
> 
> On 2020/8/3 9:12, Zhou Wang wrote:
>> On 2020/8/2 22:52, Jia-Ju Bai wrote:
>>> In qm_qp_ctx_cfg(), "sqc" and "aeqc" are mapped to streaming DMA:
>>>    eqc_dma = dma_map_single(..., eqc, ...);
>>>    ......
>>>    aeqc_dma = dma_map_single(..., aeqc, ...);
>> Only sqc, cqc will be configured in qm_qp_ctx_cfg.
>>
>>> Then "sqc" and "aeqc" are accessed at many places, such as:
>>>    eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
>>>    eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
>>>    ......
>>>    aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
>>>    aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
>> There are sqc, cqc, eqc, aeqc, you seems misunderstand them.
>>
>>> These accesses may cause data inconsistency between CPU cache and hardware.
>>>
>>> I am not sure how to properly fix this problem, and thus I only report it.
>> In qm_qp_ctx_cfg, sqc/cqc memory will be allocated and related mailbox will be sent
>> to hardware. In qm_eq_ctx_cfg, eqc/aeqc related operations will be done.
>>
>> So there is no problem here :)
> 
> Ah, sorry, I misunderstood qm_eq_ctx_cfg() and qm_qp_ctx_cfg(), because their names are quite similar.
> Now, I re-organize this report as follows:
> 
> In qm_eq_ctx_cfg(), "eqc" and "aeqc" are mapped to streaming DMA:
>   eqc_dma = dma_map_single(..., eqc, ...);
>   ......
>   aeqc_dma = dma_map_single(..., aeqc, ...);
> 
> Then "sqc" and "aeqc" are accessed at some places in qm_eq_ctx_cfg(), such as:
>   eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
>   eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
>   ......
>   aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
>   aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
> 
> These accesses may cause data inconsistency between CPU cache and hardware.
> 
> Besides, in qm_qp_ctx_cfg(), "sqc" and "cqc" are mapped to streaming DMA:
>   sqc_dma = dma_map_single(..., sqc, ...);
>   ......
>   cqc_dma = dma_map_single(..., cqc, ...);
> 
> 
> Then "sqc" and "cqc" are at some places in qm_qp_ctx_cfg(), such as:
>   sqc->cq_num = cpu_to_le16(qp_id);
>   sqc->w13 = cpu_to_le16(QM_MK_SQC_W13(0, 1, qp->alg_type));
>   ......
>   cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(4));
>   cqc->w8 = 0;
> 
> These accesses may cause data inconsistency between CPU cache and hardware.
> 
> I think such problems (if they are real) can be fixed by finishing data assignment before DMA mapping.

Sorry for late. I got your idea, from the semantics of dma_map_single/dma_unmap_single,
we should not mix CPU and device DMA accessing here. The reason of working well is our
hardware is hardware CC.

Will fix this later.

Thanks,
Zhou

>  
> 
> Best wishes,
> Jia-Ju Bai
> 
> .
> 
