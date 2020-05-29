Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C5AC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 11:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFC92075A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 11:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgE2LEz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 07:04:55 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42789 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgE2LEy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 07:04:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Tzz9qwA_1590750289;
Received: from 30.27.118.64(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tzz9qwA_1590750289)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 May 2020 19:04:50 +0800
Subject: Re: [PATCH v2 0/7] crpyto: introduce OSCCA certificate and SM2
 asymmetric algorithm
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, ebiggers@kernel.org, ebiggers@google.com,
        pvanleeuwen@rambus.com, zohar@linux.ibm.com, gilad@benyossef.com,
        jarkko.sakkinen@linux.intel.com, dmitry.kasatkin@intel.com,
        nicstange@gmail.com, tadeusz.struk@intel.com, jmorris@namei.org,
        serge@hallyn.com, zhang.jia@linux.alibaba.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200402123504.84628-1-tianjia.zhang@linux.alibaba.com>
 <20200416060136.GA19149@gondor.apana.org.au>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <fba669ef-b784-bdd9-d34e-a7726df7342c@linux.alibaba.com>
Date:   Fri, 29 May 2020 19:04:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200416060136.GA19149@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/4/16 14:01, Herbert Xu wrote:
> On Thu, Apr 02, 2020 at 08:34:57PM +0800, Tianjia Zhang wrote:
>> Hello all,
>>
>> This new module implement the OSCCA certificate and SM2 public key
>> algorithm. It was published by State Encryption Management Bureau, China.
>> List of specifications for OSCCA certificate and SM2 elliptic curve
>> public key cryptography:
>>
>> * GM/T 0003.1-2012
>> * GM/T 0003.2-2012
>> * GM/T 0003.3-2012
>> * GM/T 0003.4-2012
>> * GM/T 0003.5-2012
>> * GM/T 0015-2012
>> * GM/T 0009-2012
>>
>> IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
>> oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
>> scctc: http://www.gmbz.org.cn/main/bzlb.html
>>
>> These patchs add the OID object identifier defined by OSCCA. The
>> x509 certificate supports sm2-with-sm3 type certificate parsing
>> and verification.
> 
> I don't have any objections to the crypto API bits, but obviously
> this is contingent on the x509 bits getting accepted since that's
> the only in-kernel user.  So can I see some acks on that please?
> 
> Thanks,
> 

Hi Herbert,

Any opinion on this series patches? Do I need to provide additional 
information ?

Thanks and best,
Tianjia
