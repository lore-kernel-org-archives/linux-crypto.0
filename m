Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1EFC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiGZLdd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiGZLdd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:33:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D032471
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:33:31 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LsZTn1sNvzjXR9;
        Tue, 26 Jul 2022 19:30:37 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 19:33:28 +0800
Message-ID: <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com>
Date:   Tue, 26 Jul 2022 19:33:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Eric Biggers <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
        <luto@kernel.org>, <tytso@mit.edu>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
 <Yt/LPr0uJVheDuuW@zx2c4.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Yt/LPr0uJVheDuuW@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/26 19:08, Jason A. Donenfeld wrote:
> Hi,
> 
> On Tue, Jul 26, 2022 at 03:43:31PM +0800, Guozihua (Scott) wrote:
>> Thanks for all the comments on this inquiry. Does the community has any
>> channel to publishes changes like these? And will the man pages get
>> updated? If so, are there any time frame?
> 
> I was under the impression you were ultimately okay with the status quo.
> Have I misunderstood you?
> 
> Thanks,
> Jason
> .

Hi Jason.

To clarify, I does not have any issue with this change. I asked here 
only because I would like some background knowledge on this flag, to 
ensure I am on the same page as the community regarding this flag and 
the change. And it seems that I understands it correctly.

However I do think it's a good idea to update the document soon to avoid 
any misunderstanding in the future.

-- 
Best
GUO Zihua
