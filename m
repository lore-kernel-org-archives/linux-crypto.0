Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620BAEE4996
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 08:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjHUIlp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjHUIlm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 04:41:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288DCB5
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 01:41:39 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RTm8347ntztSJW;
        Mon, 21 Aug 2023 16:37:55 +0800 (CST)
Received: from [10.67.109.150] (10.67.109.150) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 21 Aug 2023 16:41:37 +0800
Message-ID: <5814b562-78e7-c73b-aadc-205bd93dc981@huawei.com>
Date:   Mon, 21 Aug 2023 16:41:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto:padata: Fix return err for PADATA_RESET
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <steffen.klassert@secunet.com>, <daniel.m.jordan@oracle.com>,
        <linux-crypto@vger.kernel.org>
References: <ZN8JhAGuYlz3B+9j@gondor.apana.org.au>
From:   Lu Jialin <lujialin4@huawei.com>
In-Reply-To: <ZN8JhAGuYlz3B+9j@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.150]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for your suggestions. I will update my patch in v2

On 2023/8/18 14:02, Herbert Xu wrote:
> Lu Jialin <lujialin4@huawei.com> wrote:
>> We found a hungtask bug in test_aead_vec_cfg as follows:
>>
>> INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Call trace:
>> __switch_to+0x98/0xe0
>> __schedule+0x6c4/0xf40
>> schedule+0xd8/0x1b4
>> schedule_timeout+0x474/0x560
>> wait_for_common+0x368/0x4e0
>> wait_for_completion+0x20/0x30
>> test_aead_vec_cfg+0xab4/0xd50
>> test_aead+0x144/0x1f0
>> alg_test_aead+0xd8/0x1e0
>> alg_test+0x634/0x890
>> cryptomgr_test+0x40/0x70
>> kthread+0x1e0/0x220
>> ret_from_fork+0x10/0x18
>> Kernel panic - not syncing: hung_task: blocked tasks
>>
>> For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
>> wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
>> case, aead_request_complete() will be called in pcrypt_aead_serial and the
>> return err is 0 for padata_do_parallel. But, when pinst->flags is
>> PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
>> won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
>> hung at wait_for_completion(&wait->completion), which will cause
>> hungtask.
>>
>> The problem comes as following:
>> (padata_do_parallel)                 |
>>     rcu_read_lock_bh();              |
>>     err = -EINVAL;                   |   (padata_replace)
>>                                      |     pinst->flags |= PADATA_RESET;
>>     err = -EBUSY                     |
>>     if (pinst->flags & PADATA_RESET) |
>>         rcu_read_unlock_bh()         |
>>         return err                   |
>>
>> In order to resolve the problem, change the return err to -EINVAL when
>> pinst->flags is set PADATA_RESET.
>>
>> Signed-off-by: Lu Jialin <lujialin4@huawei.com>
>> ---
>> kernel/padata.c | 1 -
>> 1 file changed, 1 deletion(-)
> 
> Thanks for the patch.
> 
> So the issue here is that the Crypto API uses EBUSY for a specific
> purpose but padata uses it too and they're getting confused with
> each other.
> 
> I think what we should do is get pcrypt to check the error value from
> padata_do_parallel, and if it's EBUSY then change it to something
> else.
> 
> Thanks,
