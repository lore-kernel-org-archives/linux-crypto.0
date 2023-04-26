Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB91C77B60
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 09:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbjDZJsq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbjDZJsp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 05:48:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A32726
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2023 02:48:43 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q5vBW3zdKzLnl5;
        Wed, 26 Apr 2023 17:45:55 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 17:48:39 +0800
Subject: Re: [PATCH -next] crypto: jitter - change module_init(jent_mod_init)
 to subsys_initcall(jent_mod_init)
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <20230425125709.39470-1-cuigaosheng1@huawei.com>
 <ZEjkmOPvk7Iz213G@gondor.apana.org.au>
 <d3198a93-3811-69d3-9a19-602bf8b849aa@huawei.com>
 <ZEjuUg9GQGB+4WO/@gondor.apana.org.au>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <be567820-a2b5-8496-0d8a-e44fdd8fdc3b@huawei.com>
Date:   Wed, 26 Apr 2023 17:48:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ZEjuUg9GQGB+4WO/@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Submitting patches directly to stable branches will not be accepted.

Maybe it doesn't need fixing，we can also compile ecdh into modules
to get around this problem.

Thanks for your time.

On 2023/4/26 17:26, Herbert Xu wrote:
> On Wed, Apr 26, 2023 at 05:18:11PM +0800, cuigaosheng wrote:
>> Thanks for taking time to review this patch.
>>
>> We have not used subsystem initialisation ordering to guarantee the
>> order of registration since commit adad556efcdd ("crypto: api - Fix
>> built-in testing dependency failures"),but this patch is not a bugfix,
>> it's not merged into the earlier stable branch.
> You're going about this backwards.  We don't apply patches to
> the mainline kernel to fix problems that only exist in an older
> version.
>
> If you have a problem with an older kernel then you should fix
> it there.
>
> Cheers,
