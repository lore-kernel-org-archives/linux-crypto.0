Return-Path: <SRS0=/mkk=BM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3F0C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 14:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4E12072A
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 14:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgHBOxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 10:53:00 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:39368
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1725861AbgHBOxA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 10:53:00 -0400
Received: from [101.5.209.60] (unknown [101.5.209.60])
        by app-3 (Coremail) with SMTP id EQQGZQA3PiJB0yZfgSzdAw--.56560S2;
        Sun, 02 Aug 2020 22:52:51 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [BUG] crypto: hisilicon: accessing the data mapped to streaming DMA
To:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <361fa200-479c-e1ef-b7d6-e666a256660f@tsinghua.edu.cn>
Date:   Sun, 2 Aug 2020 22:52:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: EQQGZQA3PiJB0yZfgSzdAw--.56560S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw18Gw1rKr1Duw1xWF47XFb_yoWxZrX_A3
        y3Gw1rGFWq9an7twn7Ja15A3yaqFZrtr4qyr9ayFW8Zw17Aa1kGwn5Za18tw1Fy3Z0yFn5
        tw13u393WF1FvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkI
        ecxEwVAFwVW5XwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07jorWrUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In qm_qp_ctx_cfg(), "sqc" and "aeqc" are mapped to streaming DMA:
   eqc_dma = dma_map_single(..., eqc, ...);
   ......
   aeqc_dma = dma_map_single(..., aeqc, ...);

Then "sqc" and "aeqc" are accessed at many places, such as:
   eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
   eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
   ......
   aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
   aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));

These accesses may cause data inconsistency between CPU cache and hardware.

I am not sure how to properly fix this problem, and thus I only report it.


Best wishes,
Jia-Ju Bai

