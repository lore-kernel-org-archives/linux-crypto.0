Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF228C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jul 2022 09:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGTJ5f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 05:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGTJ5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 05:57:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E8612A84
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 02:57:33 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lnrcl192pzWf0x;
        Wed, 20 Jul 2022 17:53:43 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 17:57:31 +0800
Message-ID: <a29cb083-0305-3467-976c-e541daefc5e8@huawei.com>
Date:   Wed, 20 Jul 2022 17:57:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Content-Language: en-US
To:     Will Deacon <will@kernel.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <ebiggers@kernel.org>
References: <20220712075031.29061-1-guozihua@huawei.com>
 <20220720094116.GC15752@willie-the-truck>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <20220720094116.GC15752@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/20 17:41, Will Deacon wrote:
> On Tue, Jul 12, 2022 at 03:50:31PM +0800, GUO Zihua wrote:
>> A kasan error was reported during fuzzing:
> 
> [...]
> 
>> This patch fixes the issue by calling poly1305_init_arm64() instead of
>> poly1305_init_arch(). This is also the implementation for the same
>> algorithm on arm platform.
>>
>> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: GUO Zihua <guozihua@huawei.com>
>> ---
>>   arch/arm64/crypto/poly1305-glue.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I'm not a crypto guy by any stretch of the imagination, but Ard is out
> at the moment and this looks like an important fix so I had a crack at
> reviewing it.
> 
>> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
>> index 9c3d86e397bf..1fae18ba11ed 100644
>> --- a/arch/arm64/crypto/poly1305-glue.c
>> +++ b/arch/arm64/crypto/poly1305-glue.c
>> @@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
>>   {
>>   	if (unlikely(!dctx->sset)) {
>>   		if (!dctx->rset) {
>> -			poly1305_init_arch(dctx, src);
>> +			poly1305_init_arm64(&dctx->h, src);
>>   			src += POLY1305_BLOCK_SIZE;
>>   			len -= POLY1305_BLOCK_SIZE;
>>   			dctx->rset = 1;
> 
> With this change, we no longer initialise dctx->buflen to 0 as part of the
> initialisation. Looking at neon_poly1305_do_update(), I'm a bit worried
> that we could land in the 'if (likely(len >= POLY1305_BLOCK_SIZE))' block,
> end up with len == 0 and fail to set dctx->buflen. Is this a problem, or is
> my ignorance showing?
> 
> Will
> .

Thanks Will.

I noticed this as well, but I leaved it out so that the behavior is the 
same as the implementation for arm. The buflen here seems to be used for 
maintaining any excessive data after the last block, and is zeroed 
during init. I am not sure why it should be zeroed again during key 
initialization. Maybe the thought was that the very first block of the 
data is always used for initializing rset and that is also considered to 
be the "initialization" process for the algorithm, thus the zeroing of 
buflen. I could be completely wrong though.

-- 
Best
GUO Zihua
