Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACCEC04A94
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 03:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjHKDZb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 23:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjHKDZa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 23:25:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBAE2D66
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 20:25:29 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RMTcq4L4FzqSdR;
        Fri, 11 Aug 2023 11:22:35 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 11:25:27 +0800
Message-ID: <1bcf580b-3a19-c0aa-b3cb-1f9f183b61e4@huawei.com>
Date:   Fri, 11 Aug 2023 11:25:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 3/3] crypto: Introduce SM9 key exchange algorithm
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <20230625014958.32631-1-guozihua@huawei.com>
 <20230625014958.32631-4-guozihua@huawei.com>
 <ZLD+9pRFQdSpfMog@gondor.apana.org.au>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <ZLD+9pRFQdSpfMog@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/7/14 15:53, Herbert Xu wrote:
> On Sun, Jun 25, 2023 at 09:49:58AM +0800, GUO Zihua wrote:
>> This patch introduces a generic implementation of SM9 (ShangMi 9) key
>> exchange algorithm.
>>
>> SM9 is an ID-based cryptography algorithm within the ShangMi family whose
>> key exchange algorithm was accepted in ISO/IEC 11770-3 as an
>> international standard.
> 
> For each new algorithm we require an in-kernel user.  Where is the
> in-kernel user for this?
> 
> Thanks,
Hi Herbert,

Unfortunately we don't have such usage right now and we are researching
into it.

Just while we are here, do you think it's a good idea to also introduce
a new crypto algorithm type for IBCs to better support their
functionality if there are usage within kernel and we are to port this
algorithm in?

-- 
Best
GUO Zihua

