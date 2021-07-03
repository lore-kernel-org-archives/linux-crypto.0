Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D1EC07E96
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jul 2021 01:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 303CA613CB
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jul 2021 01:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhGCBkP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jul 2021 21:40:15 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:51650 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhGCBkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jul 2021 21:40:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UeVvGqx_1625276258;
Received: from 30.25.251.73(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UeVvGqx_1625276258)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 03 Jul 2021 09:37:39 +0800
Subject: Re: [PATCH v3] pkcs7: make parser enable SM2 and SM3 algorithms
 combination
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        Elvira Khabirova <e.khabirova@omp.ru>
References: <20210624094705.48673-1-tianjia.zhang@linux.alibaba.com>
 <20210702143956.h3d55suhw5ekbag4@altlinux.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <3e1085a6-067b-c99e-dacf-05faf6bd4ce7@linux.alibaba.com>
Date:   Sat, 3 Jul 2021 09:37:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702143956.h3d55suhw5ekbag4@altlinux.org>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/2/21 10:39 PM, Vitaly Chikunov wrote:
> On Thu, Jun 24, 2021 at 05:47:05PM +0800, Tianjia Zhang wrote:
>> Support parsing the message signature of the SM2 and SM3 algorithm
>> combination. This group of algorithms has been well supported. One
>> of the main users is module signature verification.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> This will conflict with the patch of Elvira Khabirova adding the same
> for streebog/ecrdsa. Otherwise,
> 
> Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
> 
> Thanks,
> 

Thanks, I just saw it, I will contact Elvira Khabirova to consider 
whether it can be combined into a series of patches, and then resend.

Cheers,
Tianjia
