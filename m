Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B2BC433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 01:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32A3E64E60
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 01:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBTBwU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Feb 2021 20:52:20 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13364 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBTBwT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Feb 2021 20:52:19 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DjBGM3m24z7kG9;
        Sat, 20 Feb 2021 09:50:03 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Sat, 20 Feb 2021
 09:51:28 +0800
Subject: Re: [PATCH 0/4] Fix the parameter of dma_map_sg()
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        <prime.zeng@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <54b73ba3-54f9-bb73-e398-4f12bc359b26@hisilicon.com>
Date:   Sat, 20 Feb 2021 09:51:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ping...

ÔÚ 2021/2/9 14:59, chenxiang Ð´µÀ:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> According to Documentation/core-api/dma-api-howto.rst, the parameters
> of dma_unmap_sg() must be the same as those which are passed in to the
> scatter/gather mapping API.
> But for some drivers under crypto, the <nents> parameter of dma_unmap_sg()
> is number of elements after mapping. So fix them.
>
> Part of the document is as follows:
>
> To unmap a scatterlist, just call::
>
>          dma_unmap_sg(dev, sglist, nents, direction);
> 	
> Again, make sure DMA activity has already finished.
> 	
> 	.. note::
> 	
> 	        The 'nents' argument to the dma_unmap_sg call must be
> 		the _same_ one you passed into the dma_map_sg call,
> 		it should _NOT_ be the 'count' value _returned_ from the
> 		dma_map_sg call.
>
> chenxiang (4):
>    crypto: amlogic - Fix the parameter of dma_unmap_sg()
>    crypto: cavium - Fix the parameter of dma_unmap_sg()
>    crypto: ux500 - Fix the parameter of dma_unmap_sg()
>    crypto: allwinner - Fix the parameter of dma_unmap_sg()
>
>   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 ++++++---
>   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 ++-
>   drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 ++++++---
>   drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 ++-
>   drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 6 +++---
>   drivers/crypto/cavium/nitrox/nitrox_reqmgr.c        | 8 ++++----
>   drivers/crypto/ux500/cryp/cryp_core.c               | 4 ++--
>   drivers/crypto/ux500/hash/hash_core.c               | 2 +-
>   8 files changed, 26 insertions(+), 18 deletions(-)
>


