Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA12C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 11:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiGULaW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 07:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGULaR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 07:30:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EE7FD36
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 04:30:15 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LpVgf2q4XzmV8F;
        Thu, 21 Jul 2022 19:28:30 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 19:30:13 +0800
Message-ID: <4f21d499-9080-e911-f393-8559ab8eecc6@huawei.com>
Date:   Thu, 21 Jul 2022 19:30:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        <linux-crypto@vger.kernel.org>, <luto@kernel.org>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com> <Ytkz7DOfL6mFCxnI@mit.edu>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Ytkz7DOfL6mFCxnI@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/21 19:09, Theodore Ts'o wrote:
> On Thu, Jul 21, 2022 at 02:44:54PM +0800, Guozihua (Scott) wrote:
>   >
>> We have a userspace program that starts pretty early in the boot process and
>> it tries to fetch random bits from /dev/random with O_NONBLOCK, if that
>> returns -EAGAIN, it turns to /dev/urandom. Is this a correct handling of
>> -EAGAIN? Or this is not one of the intended use case of O_NONBLOCK?
> 
> In addition to the good points which Eric and Jason have raised, the
> other thing I would ask you is ***why*** is your userspace program
> trying to fetch random bits early in the boot process?  Is it, say,
> trying to generate a cryptographic key which is security critical.  If
> so, then DON'T DO THAT.
> 
> There have been plenty of really embarrassing security problems caused
> by consumer grade products who generate a public/private key pair
> within seconds of the customer taking the product out of the box, and
> plugging it into the wall for the first time.  At which point,
> hilarity ensues, unless the box is life- or mission- critical, in
> which case tragedy ensues....
> 
> Is it possible to move the userspace program so it's not being started
> early in the boot process?  What is it doing, and why does it need
> random data in the first place?
> 
> 						- Ted
> .

Hi Ted,

Thanks for the comment. The code is not written by me, but I think you 
made a good point here and I'll definitely bring this up to the author.

-- 
Best
GUO Zihua
