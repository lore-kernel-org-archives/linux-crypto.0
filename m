Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1F2C38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 09:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBAJoB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 04:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBAJoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 04:44:00 -0500
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D7D62249
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 01:43:26 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VagOXnK_1675244581;
Received: from 30.240.102.229(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VagOXnK_1675244581)
          by smtp.aliyun-inc.com;
          Wed, 01 Feb 2023 17:43:01 +0800
Message-ID: <7fdf700c-6747-fa58-ee7a-2cca6397fa05@linux.alibaba.com>
Date:   Wed, 1 Feb 2023 17:43:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] crypto: arm64/aes-ccm - Rewrite skcipher walker loop
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
 <b83ca139-1e8c-60f3-939f-15f727710c36@linux.alibaba.com>
 <Y9opEyTFKXAVjk/D@gondor.apana.org.au>
 <477c73bd-b56e-3c63-1ad6-6a2a08af42af@linux.alibaba.com>
 <Y9ovNyYP03rUBPlq@gondor.apana.org.au>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y9ovNyYP03rUBPlq@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 2/1/23 5:21 PM, Herbert Xu wrote:
> On Wed, Feb 01, 2023 at 05:15:23PM +0800, Tianjia Zhang wrote:
>>
>> According to your previous reply, walker will ensure that the nbytes of
>> each iteration is at least the size of the chunk. If walk.nbytes == 0,
> 
> walk.nbytes == 0 is used to indicate error.  Of course you could
> check for an error return in addition to checking walk.nbytes but
> that's how this bug got created in the first place.
> 
> So always check for walk.nbytes == 0.
> 
> Cheers,

It seems that only need to fix the loop condition, so if change the
loop condition of the code just now to
while (walk.nbytes && walk.nbytes != walk.total), in this way, the
last chunk cryption is separated out of the loop, which will be clearer
logically. What is your opinion?

Thanks,
Tianjia
