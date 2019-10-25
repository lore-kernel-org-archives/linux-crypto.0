Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F44CA9EAF
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 01:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E18D21D7B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 01:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbfJYBAc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:00:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52540 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388427AbfJYBAc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 21:00:32 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5E380D564F8B85ECFD54;
        Fri, 25 Oct 2019 09:00:28 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 09:00:26 +0800
Subject: Re: [PATCH 1/2] crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm
 Kconfig
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <1570792690-74597-1-git-send-email-wangzhou1@hisilicon.com>
 <CAKv+Gu-6BBC4KQ6Ld+=8XBSdxmyJkBu-3ur_=XAkhSOJnhRcwQ@mail.gmail.com>
 <20191024135629.vs43o3rz3xe2hg2c@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DB24928.5000307@hisilicon.com>
Date:   Fri, 25 Oct 2019 09:00:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191024135629.vs43o3rz3xe2hg2c@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/24 21:56, Herbert Xu wrote:
> On Thu, Oct 24, 2019 at 03:22:50PM +0200, Ard Biesheuvel wrote:
>>
>> If you are fixing a COMPILE_TEST failure, just add NEED_SG_DMA_LENGTH
>> as a dependency, or drop the COMPILE_TEST altogether (why was that
>> added in the first place?)
> 
> Because we want to maximise compiler coverage so that build failures
> can be caught at the earliest opportunity.
> 
> But a better fix would be to use
> 
> 	sg_dma_len(sg)

OK, will do by this. Thanks!

Best，
Zhou

> 
> instead of
> 
> 	sg->dma_length
> 
> Cheers,
> 

