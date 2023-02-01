Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2157CC38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 09:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjBAJzE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 04:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjBAJzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 04:55:04 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A27528D03
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 01:55:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VagQs26_1675245299;
Received: from 30.240.102.229(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VagQs26_1675245299)
          by smtp.aliyun-inc.com;
          Wed, 01 Feb 2023 17:55:00 +0800
Message-ID: <4ce7be59-64ad-3d39-3949-0d729a0c8ccf@linux.alibaba.com>
Date:   Wed, 1 Feb 2023 17:54:58 +0800
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
 <7fdf700c-6747-fa58-ee7a-2cca6397fa05@linux.alibaba.com>
 <Y9o1zy10V4Yyoi+/@gondor.apana.org.au>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y9o1zy10V4Yyoi+/@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2/1/23 5:50 PM, Herbert Xu wrote:
> On Wed, Feb 01, 2023 at 05:43:00PM +0800, Tianjia Zhang wrote:
>>
>> It seems that only need to fix the loop condition, so if change the
>> loop condition of the code just now to
>> while (walk.nbytes && walk.nbytes != walk.total), in this way, the
>> last chunk cryption is separated out of the loop, which will be clearer
>> logically. What is your opinion?
> 
> Yes that should work.
> 
> Cheers,

Thanks, I will rewrite the loop in this form.

Best regards,
Tianjia
