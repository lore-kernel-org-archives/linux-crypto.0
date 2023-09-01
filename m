Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC84CA0FE2
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Sep 2023 02:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbjIAC2P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 22:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjIAC2O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 22:28:14 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D7E6F
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 19:28:10 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RcMNN12t5z1L9F0;
        Fri,  1 Sep 2023 10:26:28 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 1 Sep 2023 10:28:08 +0800
Message-ID: <c9b91a0c-5663-c351-3d4b-ad4ff74965f2@huawei.com>
Date:   Fri, 1 Sep 2023 10:28:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: Fix hungtask for PADATA_RESET
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lu Jialin <lujialin4@huawei.com>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <20230823073047.1515137-1-lujialin4@huawei.com>
 <ZOXRNntcDBuuJ2yg@gondor.apana.org.au>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <ZOXRNntcDBuuJ2yg@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/8/23 17:28, Herbert Xu wrote:
> On Wed, Aug 23, 2023 at 07:30:47AM +0000, Lu Jialin wrote:
>> We found a hungtask bug in test_aead_vec_cfg as follows:
>>
>> INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Call trace:
>>  __switch_to+0x98/0xe0
>>  __schedule+0x6c4/0xf40
>>  schedule+0xd8/0x1b4
>>  schedule_timeout+0x474/0x560
>>  wait_for_common+0x368/0x4e0
>>  wait_for_completion+0x20/0x30
>>  test_aead_vec_cfg+0xab4/0xd50
>>  test_aead+0x144/0x1f0
>>  alg_test_aead+0xd8/0x1e0
>>  alg_test+0x634/0x890
>>  cryptomgr_test+0x40/0x70
>>  kthread+0x1e0/0x220
>>  ret_from_fork+0x10/0x18
>>  Kernel panic - not syncing: hung_task: blocked tasks
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
>>         return err
>>
>> In order to resolve the problem, we retry at most 5 times when
>> padata_do_parallel return -EBUSY. For more than 5 times, we replace the
>> return err -EBUSY with -EAGAIN, which means parallel_data is changing, and
>> the caller should call it again.
> 
> Steffen, should we retry this at all? Or should it just fail as it
> did before?
> 
> Thanks,

It should be fine if we don't retry and just fail with -EAGAIN and let
caller handles it. It should not break the meaning of the error code.
-- 
Best
GUO Zihua

