Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0829EC05027
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 09:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBAJQA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 04:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjBAJPn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 04:15:43 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ADF62256
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 01:15:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VagKKZ._1675242924;
Received: from 30.240.102.229(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VagKKZ._1675242924)
          by smtp.aliyun-inc.com;
          Wed, 01 Feb 2023 17:15:25 +0800
Message-ID: <477c73bd-b56e-3c63-1ad6-6a2a08af42af@linux.alibaba.com>
Date:   Wed, 1 Feb 2023 17:15:23 +0800
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
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y9opEyTFKXAVjk/D@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 2/1/23 4:55 PM, Herbert Xu wrote:
> On Wed, Feb 01, 2023 at 10:53:37AM +0800, Tianjia Zhang wrote:
>>
>> 	while (walk.nbytes != walk.total) {
> 
> This is still buggy, because we can have walk.nbytes == 0 and
> walk.nbytes != walk.total.  You will enter the loop and call
> skcipher_walk_done which is not allowed.
> 
> That is why you should follow the standard calling convention
> for skcipher walks, always check for walk.nbytes != 0 and not
> whether the walk returns an error.
> 
> Cheers,

According to your previous reply, walker will ensure that the nbytes of
each iteration is at least the size of the chunk. If walk.nbytes == 0,
it must be the last chunk. If this is the case,
walk.nbytes == 0 && walk.nbytes != walk.total will not appear, sorry I
am not very clear about the details of walker, I don’t know if I
understand correctly.

Cheers,
Tianjia
