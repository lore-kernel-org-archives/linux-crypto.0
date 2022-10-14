Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23084C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 01:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJNBnp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 21:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJNBno (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 21:43:44 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD22B1A2093;
        Thu, 13 Oct 2022 18:43:42 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MpTZH5s3fzmVFq;
        Fri, 14 Oct 2022 09:39:03 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 09:43:40 +0800
Received: from [10.67.103.232] (10.67.103.232) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 09:43:40 +0800
Message-ID: <09d0686b-1955-c63d-c02d-fb0d2db42672@huawei.com>
Date:   Fri, 14 Oct 2022 09:43:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 0/6] crypto: benchmark - add the crypto benchmark
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <gregkh@linuxfoundation.org>
References: <20220919120537.39258-1-shenyang39@huawei.com>
 <Yyl5yKQCAgPBbFd7@gondor.apana.org.au>
 <3dd984c1-d17f-0a6a-c52e-87e161f867fc@huawei.com>
 <YzZ12Y/kEF4DrQV6@gondor.apana.org.au>
From:   Yang Shen <shenyang39@huawei.com>
In-Reply-To: <YzZ12Y/kEF4DrQV6@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.232]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2022/9/30 12:51, Herbert Xu 写道:
> On Wed, Sep 21, 2022 at 04:19:18PM +0800, Yang Shen wrote:
>> I know the tcrypt.ko has the speed test cases. But the tcrypt.ko test case
>> is fixed.
>> If I understand correctly, the design model of tcrypt.ko is test the
>> algorithms with
>> determined case conditions. It can provide some standardized testing to
>> ensure
>> that the implementation of the algorithm meets the requirements. This is a
>> reasonable developer test tool, but it is not flexible enough for testers
>> and users.
> How about improving tcrypt then? We're not going to have two things
> in the kernel that do the same thing unless you provide a clear path
> of eliminating one of them.
>
> Cheers,

Got it. I'll try to support this on the tcrypt.

Thanks,

Yang

