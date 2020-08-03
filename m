Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2341C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 01:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D612076B
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 01:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgHCB3f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 21:29:35 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:42522
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1725820AbgHCB3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 21:29:35 -0400
X-Greylist: delayed 39131 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 21:29:31 EDT
Received: from [166.111.139.118] (unknown [166.111.139.118])
        by app-1 (Coremail) with SMTP id DwQGZQA3P6toaCdf_pLwAw--.11242S2;
        Mon, 03 Aug 2020 09:29:14 +0800 (CST)
Subject: Re: [BUG] crypto: hisilicon: accessing the data mapped to streaming
 DMA
To:     Zhou Wang <wangzhou1@hisilicon.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <361fa200-479c-e1ef-b7d6-e666a256660f@tsinghua.edu.cn>
 <5F276491.8060409@hisilicon.com>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <c0001b9b-6529-27bc-2874-2a2674257507@tsinghua.edu.cn>
Date:   Mon, 3 Aug 2020 09:29:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5F276491.8060409@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: DwQGZQA3P6toaCdf_pLwAw--.11242S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJryrKr1DJF4fWw4fJr17trb_yoW8Kw43pF
        48ZFWUWr43tFWv9w4qyw17XFyfZa43tw18t3WY93Z3GryDAF1kGF4DWF97Kayqgw12vF1U
        Ww45ZFZ5ur9rJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvab7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG
        8wCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
        026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
        JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
        vEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280
        aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyT
        uYvjxU41CJDUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/8/3 9:12, Zhou Wang wrote:
> On 2020/8/2 22:52, Jia-Ju Bai wrote:
>> In qm_qp_ctx_cfg(), "sqc" and "aeqc" are mapped to streaming DMA:
>>    eqc_dma = dma_map_single(..., eqc, ...);
>>    ......
>>    aeqc_dma = dma_map_single(..., aeqc, ...);
> Only sqc, cqc will be configured in qm_qp_ctx_cfg.
>
>> Then "sqc" and "aeqc" are accessed at many places, such as:
>>    eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
>>    eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
>>    ......
>>    aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
>>    aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
> There are sqc, cqc, eqc, aeqc, you seems misunderstand them.
>
>> These accesses may cause data inconsistency between CPU cache and hardware.
>>
>> I am not sure how to properly fix this problem, and thus I only report it.
> In qm_qp_ctx_cfg, sqc/cqc memory will be allocated and related mailbox will be sent
> to hardware. In qm_eq_ctx_cfg, eqc/aeqc related operations will be done.
>
> So there is no problem here :)

Ah, sorry, I misunderstood qm_eq_ctx_cfg() and qm_qp_ctx_cfg(), because their names are quite similar.
Now, I re-organize this report as follows:

In qm_eq_ctx_cfg(), "eqc" and "aeqc" are mapped to streaming DMA:
   eqc_dma = dma_map_single(..., eqc, ...);
   ......
   aeqc_dma = dma_map_single(..., aeqc, ...);

Then "sqc" and "aeqc" are accessed at some places in qm_eq_ctx_cfg(), such as:
   eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
   eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
   ......
   aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
   aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));

These accesses may cause data inconsistency between CPU cache and hardware.

Besides, in qm_qp_ctx_cfg(), "sqc" and "cqc" are mapped to streaming DMA:
   sqc_dma = dma_map_single(..., sqc, ...);
   ......
   cqc_dma = dma_map_single(..., cqc, ...);


Then "sqc" and "cqc" are at some places in qm_qp_ctx_cfg(), such as:
   sqc->cq_num = cpu_to_le16(qp_id);
   sqc->w13 = cpu_to_le16(QM_MK_SQC_W13(0, 1, qp->alg_type));
   ......
   cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(4));
   cqc->w8 = 0;

These accesses may cause data inconsistency between CPU cache and hardware.

I think such problems (if they are real) can be fixed by finishing data assignment before DMA mapping.
  

Best wishes,
Jia-Ju Bai

