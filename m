Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86EAC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 07:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiGZHoJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 03:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiGZHoH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 03:44:07 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E1D100A
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 00:44:05 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LsTP26SyJzjXQ1;
        Tue, 26 Jul 2022 15:41:10 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 15:43:31 +0800
Message-ID: <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
Date:   Tue, 26 Jul 2022 15:43:31 +0800
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
>>>
>>> Hi Eric
>>>
>>> We have a userspace program that starts pretty early in the boot process and
>>> it tries to fetch random bits from /dev/random with O_NONBLOCK, if that
>>> returns -EAGAIN, it turns to /dev/urandom. Is this a correct handling of
>>> -EAGAIN? Or this is not one of the intended use case of O_NONBLOCK?
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

Hi Jason, Eric and Theodore,

Thanks for all the comments on this inquiry. Does the community has any 
channel to publishes changes like these? And will the man pages get 
updated? If so, are there any time frame?

-- 
Best
GUO Zihua
