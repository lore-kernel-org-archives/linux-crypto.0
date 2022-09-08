Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8C1C38145
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Sep 2022 03:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiIHDbf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 23:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIHDbf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 23:31:35 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3171EC7433
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 20:31:33 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MNPkR66QpzHnfS;
        Thu,  8 Sep 2022 11:29:35 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 11:31:31 +0800
Message-ID: <efb1e667-d63a-ddb1-d003-f8ba5d506c29@huawei.com>
Date:   Thu, 8 Sep 2022 11:31:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        zhongguohua <zhongguohua1@huawei.com>
References: <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
 <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com>
 <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
 <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
 <YxiWmiLP11UxyTzs@zx2c4.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <YxiWmiLP11UxyTzs@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/9/7 21:03, Jason A. Donenfeld wrote:
> On Tue, Sep 06, 2022 at 12:16:56PM +0200, Jason A. Donenfeld wrote:
>> On Thu, Jul 28, 2022 at 10:25 AM Guozihua (Scott) <guozihua@huawei.com> wrote:
>>>
>>> On 2022/7/26 19:33, Guozihua (Scott) wrote:
>>>> On 2022/7/26 19:08, Jason A. Donenfeld wrote:
>>>>> Hi,
>>>>>
>>>>> On Tue, Jul 26, 2022 at 03:43:31PM +0800, Guozihua (Scott) wrote:
>>>>>> Thanks for all the comments on this inquiry. Does the community has any
>>>>>> channel to publishes changes like these? And will the man pages get
>>>>>> updated? If so, are there any time frame?
>>>>>
>>>>> I was under the impression you were ultimately okay with the status quo.
>>>>> Have I misunderstood you?
>>>>>
>>>>> Thanks,
>>>>> Jason
>>>>> .
>>>>
>>>> Hi Jason.
>>>>
>>>> To clarify, I does not have any issue with this change. I asked here
>>>> only because I would like some background knowledge on this flag, to
>>>> ensure I am on the same page as the community regarding this flag and
>>>> the change. And it seems that I understands it correctly.
>>>>
>>>> However I do think it's a good idea to update the document soon to avoid
>>>> any misunderstanding in the future.
>>>>
>>>
>>> Our colleague suggests that we should inform users clearly about the
>>> change on the flag by returning -EINVAL when /dev/random gets this flag
>>> during boot process. Otherwise programs might silently block for a long
>>> time, causing other issues. Do you think this is a good way to prevent
>>> similar issues on this flag?
>>
>> I still don't really understand what you want. First you said this was
>> a problem and we should reintroduce the old behavior. Then you said no
>> big deal and the docs just needed to be updated. Now you're saying
>> this is a problem and we should reintroduce the old behavior?
>>
>> I'm just a bit lost on where we were in the conversation.
>>
>> Also, could you let me know whether this is affecting real things for
>> Huawei, or if this is just something you happened to notice but
>> doesn't have any practical impact?
> 
> Just following up on this again...
> .

Hi Jason,

Thank you for the timely respond and your patient. And sorry for the 
confusion.

First of all, what we think is that this change (removing O_NONBLOCK) is 
reasonable. However, this do cause issue during the test on one of our 
product which uses O_NONBLOCK flag the way I presented earlier in the 
Linux 4.4 era. Thus our colleague suggests that returning -EINVAL when 
this flag is received would be a good way to indicate this change.

For example:


-- 
Best
GUO Zihua

-- 
Best
GUO Zihua
