Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F166EC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 07:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiGLHrW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiGLHrU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 03:47:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F69C254
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2022 00:47:18 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lht6H6sSBzVfkd;
        Tue, 12 Jul 2022 15:43:35 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 15:47:09 +0800
Message-ID: <b8546932-109f-a2d8-66cf-37512afd3927@huawei.com>
Date:   Tue, 12 Jul 2022 15:46:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] arm64/crypto: poly1305 fix a read out-of-bound
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>
References: <20220712033215.45960-1-guozihua@huawei.com>
 <Ys0d9KPadnltgwae@sol.localdomain> <Ys0ip6SdCfWmbA1V@sol.localdomain>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Ys0ip6SdCfWmbA1V@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/12 15:28, Eric Biggers wrote:
> On Tue, Jul 12, 2022 at 12:08:36AM -0700, Eric Biggers wrote:
>>
>> Is the special reproducer really needed?  I'd expect this to be reproduced by
>> the existing crypto self-tests just by booting a kernel built with both
>> CONFIG_KASAN=y and CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
>>
> 
> Ah, probably the self-tests don't find this because with poly1305 the key is
> actually read from the "data", and for the self-tests the data addresses happens
> to always be in the kernel direct map, so KASAN doesn't work for it (I think).
> Ideally the self-tests would test with kmalloc'ed data buffers too, or a buffer
> in vmalloc'ed memory that's directly followed by a guard page.
> 
> - Eric
> .

Hi Eric,

I just tried and it seems that the extra self-test won't find this bug 
so I will just keep the reproducer in place.

-- 
Best
GUO Zihua
