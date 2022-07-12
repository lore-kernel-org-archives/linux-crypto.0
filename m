Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47418C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 01:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGLB6I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jul 2022 21:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGLB6G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jul 2022 21:58:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B923A4A8
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 18:58:05 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LhkMK1jdhzVfd4;
        Tue, 12 Jul 2022 09:54:21 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 09:58:01 +0800
Message-ID: <107b496c-8106-b262-2731-444bd5e6e6d6@huawei.com>
Date:   Tue, 12 Jul 2022 09:57:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: An inquire about a read out-of-bound found in poly1305-neon
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <zengxianjun3@huawei.com>, <yunjia.wang@huawei.com>
References: <65952163-6b78-a02a-ba14-933807d3cfec@huawei.com>
 <YsxksSnCsk3TQVD+@gmail.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <YsxksSnCsk3TQVD+@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/12 1:58, Eric Biggers wrote:
> On Mon, Jul 11, 2022 at 09:34:49PM +0800, Guozihua (Scott) wrote:
>> Directly calling poly1305_init_arm64 instead of poly1305_init_arch() is also
>> tried but it would fail the self-test as well.
> 
> I think that's the correct fix.  Are you sure it fails the self-test?  It should
> look like:
> 
> 	poly1305_init_arm64(&dctx->h, src);
> 
> Just like the arm32 version in arch/arm/crypto/poly1305-glue.c.  Note that
> &dctx->h must be used rather than just dctx.
> 
> - Eric
> .

Thanks Eric, I'll have a try!

-- 
Best
GUO Zihua
