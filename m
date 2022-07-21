Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD5DC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 06:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiGUGpA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 02:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiGUGo7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 02:44:59 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86854550C7
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 23:44:57 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LpNKF3WWDz1M83Y;
        Thu, 21 Jul 2022 14:42:09 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 14:44:54 +0800
Message-ID: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
Date:   Thu, 21 Jul 2022 14:44:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        <linux-crypto@vger.kernel.org>, <luto@kernel.org>, <tytso@mit.edu>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <YtjREZMzuppTJHeR@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/21 12:07, Eric Biggers wrote:
> On Thu, Jul 21, 2022 at 11:50:27AM +0800, Guozihua (Scott) wrote:
>> On 2022/7/19 19:01, Jason A. Donenfeld wrote:
>>> Hi,
>>>
>>> On Thu, Jul 14, 2022 at 03:33:47PM +0800, Guozihua (Scott) wrote:
>>>> Recently we noticed the removal of flag O_NONBLOCK on /dev/random by
>>>> commit 30c08efec888 ("random: make /dev/random be almost like
>>>> /dev/urandom"), it seems that some of the open_source packages e.g.
>>>> random_get_fd() of util-linux and __getrandom() of glibc. The man page
>>>> for random() is not updated either.
>>>>
>>>> Would anyone please kindly provide some background knowledge of this
>>>> flag and it's removal? Thanks!
>>>
>>> I didn't write that code, but I assume it was done this way because it
>>> doesn't really matter that much now, as /dev/random never blocks after
>>> the RNG is seeded. And now a days, the RNG gets seeded with jitter
>>> fairly quickly as a last resort, so almost nobody waits a long time.
>>>
>>> Looking at the two examples you mentioned, the one in util-linux does
>>> that if /dev/urandom fails, which means it's mostly unused code, and the
>>> one in glibc is for GNU Hurd, not Linux. I did a global code search and
>>> found a bunch of other instances pretty similar to the util-linux case,
>>> where /dev/random in O_NONBLOCK mode is used as a fallback to
>>> /dev/urandom, which means it's basically never used. (Amusingly one such
>>> user of this pattern is Ted's pwgen code from way back at the turn of
>>> the millennium.)
>>>
>>> All together, I couldn't really find anywhere that the removal of
>>> O_NONBLOCK semantics would actually pose a problem for, especially since
>>> /dev/random doesn't block at all after being initialized. So I'm
>>> slightly leaning toward the "doesn't matter, do nothing" course of
>>> action.
>>>
>>> But on the other hand, you did somehow notice this, so that's important
>>> perhaps. How did you run into it? *Does* it actually pose a problem? Or
>>> was this a mostly theoretical finding from perusing source code?
>>> Something like the below diff would probably work and isn't too
>>> invasive, but I think I'd prefer to leave it be unless this really did
>>> break some userspace of yours. So please let me know.
>>>
>>> Regards,
>>> Jason
>>>
>>> diff --git a/drivers/char/random.c b/drivers/char/random.c
>>> index 70d8d1d7e2d7..6f232ac258bf 100644
>>> --- a/drivers/char/random.c
>>> +++ b/drivers/char/random.c
>>> @@ -1347,6 +1347,10 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
>>>    {
>>>    	int ret;
>>> +	if (!crng_ready() &&
>>> +	    ((kiocb->ki_flags & IOCB_NOWAIT) || (kiocb->ki_filp->f_flags & O_NONBLOCK)))
>>> +		return -EAGAIN;
>>> +
>>>    	ret = wait_for_random_bytes();
>>>    	if (ret != 0)
>>>    		return ret;
>>>
>>> .
>>
>> Hi Jason, Thanks for the respond.
>>
>> The reason this comes to me is that we have an environment that is super
>> clean with very limited random events and with very limited random hardware
>> access. It would take up to 80 minutes before /dev/random is fully
>> initialized. I think it would be great if we can restore the O_NONBLOCK
>> flag.
>>
>> Would you mind merge this change into mainstream or may I have the honor?
>>
> 
> Can you elaborate on how this change would actually solve a problem for you?  Do
> you actually have a program that is using /dev/random with O_NONBLOCK, and that
> handles the EAGAIN error correctly?  Just because you're seeing a program wait
> for the RNG to be initialized doesn't necessarily mean that this change would
> make a difference, as the program could just be reading from /dev/random without
> O_NONBLOCK or calling getrandom() without GRND_NONBLOCK.  The behavior of those
> (more common) cases would be unchanged by Jason's proposed change.
> 
> - Eric
> .

Hi Eric

We have a userspace program that starts pretty early in the boot process 
and it tries to fetch random bits from /dev/random with O_NONBLOCK, if 
that returns -EAGAIN, it turns to /dev/urandom. Is this a correct 
handling of -EAGAIN? Or this is not one of the intended use case of 
O_NONBLOCK?

-- 
Best
GUO Zihua
