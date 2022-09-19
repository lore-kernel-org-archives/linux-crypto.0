Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69ACBC54EE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 10:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiISKvO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiISKuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 06:50:51 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EF712A8B
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 03:45:24 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MWLql0JkxzHnx5;
        Mon, 19 Sep 2022 18:43:15 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 18:45:22 +0800
Message-ID: <5a375c35-66f6-b377-8ffb-58006b151d60@huawei.com>
Date:   Mon, 19 Sep 2022 18:45:22 +0800
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
References: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
 <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com>
 <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
 <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
 <YxiWmiLP11UxyTzs@zx2c4.com>
 <efb1e667-d63a-ddb1-d003-f8ba5d506c29@huawei.com>
 <Yxm7OKZxT7tXsTgx@zx2c4.com>
 <ca31cb51-30b8-e970-c33c-7b848ae5ed45@huawei.com>
 <CAHmME9qWQxkDRY+TG=QL_mSZqd+vNTn186L4kbZfKEbimQcD0Q@mail.gmail.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <CAHmME9qWQxkDRY+TG=QL_mSZqd+vNTn186L4kbZfKEbimQcD0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/9/19 18:40, Jason A. Donenfeld wrote:
> Hi,
> 
> On Mon, Sep 19, 2022 at 11:27 AM Guozihua (Scott) <guozihua@huawei.com> wrote:
>>
>> On 2022/9/8 17:51, Jason A. Donenfeld wrote:
>>> Hi,
>>>
>>> On Thu, Sep 08, 2022 at 11:31:31AM +0800, Guozihua (Scott) wrote:
>>>> For example:
>>>>
>>>>
>>>> --
>>>> Best
>>>> GUO Zihua
>>>>
>>>> --
>>>> Best
>>>> GUO Zihua
>>>
>>> Looks like you forgot to paste the example...
>>>
>>>> Thank you for the timely respond and your patient. And sorry for the
>>>> confusion.
>>>>
>>>> First of all, what we think is that this change (removing O_NONBLOCK) is
>>>> reasonable. However, this do cause issue during the test on one of our
>>>> product which uses O_NONBLOCK flag the way I presented earlier in the
>>>> Linux 4.4 era. Thus our colleague suggests that returning -EINVAL when
>>>> this flag is received would be a good way to indicate this change.
>>>
>>> No, I don't think it's wise to introduce yet *new* behavior (your
>>> proposed -EINVAL). That would just exacerbate the (mostly) invisible
>>> breakage from the 5.6-era change.
>>>
>>> The question now before us is whether to bring back the behavior that
>>> was there pre-5.6, or to keep the behavior that has existed since 5.6.
>>> Accidental regressions like this (I assume it was accidental, at least)
>>> that are unnoticed for so long tend to ossify and become the new
>>> expected behavior. It's been around 2.5 years since 5.6, and this is the
>>> first report of breakage. But the fact that it does break things for you
>>> *is* still significant.
>>>
>>> If this was just something you noticed during idle curiosity but doesn't
>>> have a real impact on anything, then I'm inclined to think we shouldn't
>>> go changing the behavior /again/ after 2.5 years. But it sounds like
>>> actually you have a real user space in a product that stopped working
>>> when you tried to upgrade the kernel from 4.4 to one >5.6. If this is
>>> the case, then this sounds truly like a userspace-breaking regression,
>>> which we should fix by restoring the old behavior. Can you confirm this
>>> is the case? And in the meantime, I'll prepare a patch for restoring
>>> that old behavior.
>>>
>>> Jason
>>> .
>>
>> Hi Jason
>>
>> Thank for your patience.
>>
>> To answer your question, yes, we do have a userspace program reading
>> /dev/random during early boot which relies on O_NONBLOCK. And this
>> change do breaks it. The userspace program comes from 4.4 era, and as
>> 4.4 is going EOL, we are switching to 5.10 and the breakage is reported.
>>
>> It would be great if the kernel is able to restore this flag for
>> backward compatibility.
> 
> Alright then. Sounds like a clear case of userspace being broken. I'll
> include https://git.zx2c4.com/linux-rng/commit/?id=b931eaf6ef5cef474a1171542a872a5e270e3491
> or similar in my pull for 6.1, if that's okay with you. For 6.0, we're
> already at rc6, so maybe better to let this one stew for a bit longer,
> given the change, unless you feel strongly about having it earlier, I
> guess.
> 
> Jason
> .

Hi Jason

That's OK with us. Thanks.

-- 
Best
GUO Zihua
