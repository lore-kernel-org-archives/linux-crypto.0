Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A60C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 11:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiGULaQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGULaP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 07:30:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D92FD36
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 04:30:12 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LpVfN3dtVz1M8JK;
        Thu, 21 Jul 2022 19:27:24 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 19:30:09 +0800
Message-ID: <cb2da51e-8935-2787-28de-caba41d6ec14@huawei.com>
Date:   Thu, 21 Jul 2022 19:30:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <luto@kernel.org>, <tytso@mit.edu>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <YtksefZvcFiugeC1@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/21 18:37, Jason A. Donenfeld wrote:
> Hi Guozihua,
> 
> On Wed, Jul 20, 2022 at 11:50:46PM -0700, Eric Biggers wrote:
>> On Thu, Jul 21, 2022 at 02:44:54PM +0800, Guozihua (Scott) wrote:
>>
>> That doesn't make any sense; you should just use /dev/urandom unconditionally.
> 
> What Eric said: this flow doesn't really make sense. Why not use
> /dev/urandom unconditionally or getrandom(GRND_INSECURE)?
> 
> But also I have to wonder: you wrote '-EAGAIN' but usually userspace
> checks errno==EAGAIN, a positive value. That makes me wonder whether you
> wrote your email with your code is open. So I just wanted to triple
> check that what you've described is actually what the code is doing,
> just in case there's some ambiguity.
> 
> I'm just trying to find out what this code is and where it is to assess
> whether we change the userspace behavior again, given that this has been
> sitting for several years now.
> 
> Jason
> .

Hi Jason and Eric.

To clarify, the code in question is not written by me and I did not see 
the code myself, the code is from another team. We discovered this 
change during the test when we try to run our userspace program on a 
newer version kernel, and it blocks for a long time during the boot 
process. It seems that the author use the -EAGAIN error code as an 
indication that /dev/random is not ready and they implemented a "best 
effort" mechanism in terms of getting random data.

Honestly speaking I don't know what they are using those random data 
for, and I am trying to get some background knowledge for this flag and 
the change, maybe figure out whether that team is using the flag as 
intended, and bring this up with them.

-- 
Best
GUO Zihua
