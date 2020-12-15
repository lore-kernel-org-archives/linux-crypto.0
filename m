Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C60C4361B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 02:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08000206CB
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 02:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgLOCQh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:16:37 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:46345 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgLOCQb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:31 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 15 Dec
 2020 10:15:42 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 15 Dec
 2020 10:15:39 +0800
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <TimGuo-oc@zhaoxin.com>,
        <CooperYan@zhaoxin.com>, <QiyuanWang@zhaoxin.com>,
        <HerryYang@zhaoxin.com>, <CobeChen@zhaoxin.com>,
        <SilviaZhao@zhaoxin.com>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <X9Ov3RWDpUik7gXo@sol.localdomain>
 <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com>
 <X9fN7mOMdn1Dxn63@sol.localdomain>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <a95984ea-7451-78fe-88c5-b81f633fecdf@zhaoxin.com>
Date:   Tue, 15 Dec 2020 10:15:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <X9fN7mOMdn1Dxn63@sol.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 15/12/2020 04:41, Eric Biggers wrote:
> On Mon, Dec 14, 2020 at 10:28:19AM +0800, Tony W Wang-oc wrote:
>> On 12/12/2020 01:43, Eric Biggers wrote:
>>> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
>>>> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
>>>> On platforms with Zhaoxin CPUs supporting this X86 feature, When
>>>> crc32c-intel and crc32c-generic are both registered, system will
>>>> use crc32c-intel because its .cra_priority is greater than
>>>> crc32c-generic. This case expect to use crc32c-generic driver for
>>>> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
>>>> CPUs support from crc32c-intel.
>>>>
>>>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
>>>
>>> Does this mean that the performance of the crc32c instruction on those CPUs is
>>> actually slower than a regular C implementation?  That's very weird.
>>>
>>
>> From the lmbench3 Create and Delete file test on those chips, I think yes.
>>
> 
> Did you try measuring the performance of the hashing itself, and not some
> higher-level filesystem operations?
> 

Yes. Was testing on these Zhaoxin CPUs, the result is that with the same
input value the generic C implementation takes fewer time than the
crc32c instruction implementation.

Sincerely
Tony
