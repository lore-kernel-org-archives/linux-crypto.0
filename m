Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FCAC77B60
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 09:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbjDZJkh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 05:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbjDZJke (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 05:40:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C303E2121
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2023 02:40:32 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q5tV26P97zpTFp;
        Wed, 26 Apr 2023 17:14:18 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 17:18:11 +0800
Subject: Re: [PATCH -next] crypto: jitter - change module_init(jent_mod_init)
 to subsys_initcall(jent_mod_init)
To:     Herbert Xu <herbert@gondor.apana.org.au>, <cuigaosheng1@huawei.com>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <20230425125709.39470-1-cuigaosheng1@huawei.com>
 <ZEjkmOPvk7Iz213G@gondor.apana.org.au>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <d3198a93-3811-69d3-9a19-602bf8b849aa@huawei.com>
Date:   Wed, 26 Apr 2023 17:18:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ZEjkmOPvk7Iz213G@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for taking time to review this patch.

We have not used subsystem initialisation ordering to guarantee the
order of registration since commit adad556efcdd ("crypto: api - Fix
built-in testing dependency failures"),but this patch is not a bugfix,
it's not merged into the earlier stable branch.

For example,on linux-5.10-y, when they are built into the kernel,
ecdh will test failed on earlier kernel, we can enable fips=1,
the calltrace like below:

alg: ecdh: test failed on vector 2, err=-14
Kernel panic - not syncing: alg: self-tests for ecdh-generic (ecdh)
failed in fips mode!
Call Trace:
  dump_stack+0x57/0x6e
  panic+0x109/0x2ca
  alg_test+0x414/0x420
  ? __switch_to_asm+0x3a/0x60
  ? __switch_to_asm+0x34/0x60
  ? __schedule+0x263/0x640
  ? crypto_acomp_scomp_free_ctx+0x30/0x30
  cryptomgr_test+0x22/0x40
  kthread+0xf9/0x130
  ? kthread_park+0x90/0x90
  ret_from_fork+0x22/0x30

Merging the commit adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
into linux-5.10-y can fix it, but we have to merge more patch before it,
such as: https://www.spinics.net/lists/linux-crypto/msg57562.html
Otherwise this patch will introduce new problems.

It might make sense to keep the timing, on the other hand, we can use
it to fix the dependency problem of earlier kernel.

Thanks.

Gaosheng.

On 2023/4/26 16:45, Herbert Xu wrote:
> On Tue, Apr 25, 2023 at 08:57:09PM +0800, Gaosheng Cui wrote:
>> The ecdh-nist-p256 algorithm will depend on jitterentropy_rng,
>> and when they are built into kernel, the order of registration
>> should be done such that the underlying algorithms are ready
>> before the ones on top are registered.
>>
>> Now ecdh is initialized with subsys_initcall but jitterentropy_rng
>> is initialized with module_init.
>>
>> This patch will change module_init(jent_mod_init) to
>> subsys_initcall(jent_mod_init), so jitterentropy_rng will be
>> registered before ecdh-nist-p256 when they are built into kernel.
>>
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>> ---
>>   crypto/jitterentropy-kcapi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
>> index b9edfaa51b27..563c1ea8c8fe 100644
>> --- a/crypto/jitterentropy-kcapi.c
>> +++ b/crypto/jitterentropy-kcapi.c
>> @@ -205,7 +205,7 @@ static void __exit jent_mod_exit(void)
>>   	crypto_unregister_rng(&jent_alg);
>>   }
>>   
>> -module_init(jent_mod_init);
>> +subsys_initcall(jent_mod_init);
> This is unnecessary because we now postpone the testing of all
> algorithms until their first use.  So unless something in the
> kernel makes use of this before/during module_init, then we don't
> need to move jent.
>
> Cheers,
