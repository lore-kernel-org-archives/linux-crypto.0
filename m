Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671CCC432BE
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 03:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3970460F5B
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 03:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhH1DRk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:17:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18983 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhH1DRj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 23:17:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GxM8l49nzzbhfN
        for <linux-crypto@vger.kernel.org>; Sat, 28 Aug 2021 11:12:55 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 11:16:47 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 11:16:47 +0800
Subject: Re: [PATCH 2/5] crypto: hisilicon/sec - add ahash alg features for
 Kunpeng920
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>
References: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
 <1628847626-24383-3-git-send-email-yekai13@huawei.com>
 <20210821072557.GA31491@gondor.apana.org.au>
 <bac4d0b8-0dd1-ddeb-8d78-0c20a2d5ecdc@huawei.com>
 <20210827083652.GD21571@gondor.apana.org.au>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <337a3bac-86d4-c66e-9d6a-d4aa6685f83d@huawei.com>
Date:   Sat, 28 Aug 2021 11:16:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210827083652.GD21571@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/8/27 16:36, Herbert Xu wrote:
> On Sat, Aug 21, 2021 at 05:07:00PM +0800, yekai(A) wrote:
>>
>>
>> On 2021/8/21 15:25, Herbert Xu wrote:
>>> On Fri, Aug 13, 2021 at 05:40:23PM +0800, Kai Ye wrote:
>>>>
>>>> +static int sec_ahash_import(struct ahash_request *req, const void *in)
>>>> +{
>>>> +	/*
>>>> +	 * Import partial state of the transformation. This function loads the
>>>> +	 * entire state of the ongoing transformation from a provided block of
>>>> +	 * data so the transformation can continue from this point onward.
>>>> +	 */
>>>> +	struct sec_req *sreq = ahash_request_ctx(req);
>>>> +
>>>> +	memcpy(sreq, in, sizeof(struct sec_req));
>>>> +	return 0;
>>>> +}
>>>
>>> Please explain how this works given that you've got pointers in
>>> struct sec_req?
>>>
>>> Thanks,
>>>
>> We have set the sec_req size by use the "crypto_ahash_set_reqsize" in ahash
>> tfm init process. The crypto will allocate memory for the sec_req by
>> "__ctx[]". And we can got the pointers by use ahash_request. like
>>
>> void *temp = ahash_request_ctx(req);
>> struct sec_req *sreq = (struct sec_req)temp;
>>
>> The value of halg.statesize is sizeof(struct sec_req), so the user can get
>> the statesize.
>
> The data you get from the import could be random garbage.  Please
> explain how you avoid dereferencing random pointers in your code
> through the import path.
>
> Thanks,
>

I refered to other people's plans. Modify the value of halg.statesize
is sizeof(struct sec_req) + sizeof(u32), So user can allocate an extra 
sizeof(u32) memory. The driver will write a tag number to the addr in 
the export process, then the driver will check the pointers by the tag 
number through the import path.
I think this plan can avoid random pointers.

Thanks
Kai
