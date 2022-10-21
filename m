Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CACC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 02:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJUCrY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Oct 2022 22:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJUCrX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2022 22:47:23 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4262C1A0F86;
        Thu, 20 Oct 2022 19:47:22 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VShO7aQ_1666320435;
Received: from 30.240.99.116(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VShO7aQ_1666320435)
          by smtp.aliyun-inc.com;
          Fri, 21 Oct 2022 10:47:18 +0800
Message-ID: <6d2a98f4-c50d-d05b-4a24-08fdd3ee20fa@linux.alibaba.com>
Date:   Fri, 21 Oct 2022 10:47:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 12/15] crypto: arm64/sm4 - add CE implementation for
 ESSIV mode
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <20221018071006.5717-1-tianjia.zhang@linux.alibaba.com>
 <20221018071006.5717-13-tianjia.zhang@linux.alibaba.com>
 <Y1DHb66VYPzFlTwh@sol.localdomain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y1DHb66VYPzFlTwh@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 10/20/22 11:58 AM, Eric Biggers wrote:
> On Tue, Oct 18, 2022 at 03:10:03PM +0800, Tianjia Zhang wrote:
>> This patch is a CE-optimized assembly implementation for ESSIV mode.
>> The assembly part is realized by reusing the CBC mode.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Is there still a use case for CBC-ESSIV mode these days, now that everyone is
> using XTS instead?
> 
> - Eric

The mainstream is already using XTS, but CBC-ESSIV is still an optional
backup algorithm, especially in block crypto and fscrypto, I'm currently
working on supporting the SM4 algorithm for these subsystems.

Cheers,
Tianjia
