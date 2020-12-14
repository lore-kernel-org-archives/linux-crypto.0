Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F90C4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 02:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834F7238A1
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 02:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438004AbgLNCaC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Dec 2020 21:30:02 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:27106 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgLNC3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Dec 2020 21:29:55 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 14 Dec
 2020 10:29:04 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 14 Dec
 2020 10:29:02 +0800
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <X9Ov3RWDpUik7gXo@sol.localdomain>
 <CAMj1kXEDjQG_my5FWVY+b7Q43-_waW74sZyBAPCkd7EEdku+Rw@mail.gmail.com>
 <CAMj1kXH=u7+_DSEsUmFbtgGdPqCUs=AfTqX0mgL+DYvW2hAc8g@mail.gmail.com>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <7b826cf5-7371-77a2-b4c1-a6533787031e@zhaoxin.com>
Date:   Mon, 14 Dec 2020 10:29:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXH=u7+_DSEsUmFbtgGdPqCUs=AfTqX0mgL+DYvW2hAc8g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 12/12/2020 18:54, Ard Biesheuvel wrote:
> On Sat, 12 Dec 2020 at 10:36, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>> On Fri, 11 Dec 2020 at 20:07, Eric Biggers <ebiggers@kernel.org> wrote:
>>>
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
>> This driver does not use CRC instructions, but carryless
>> multiplication and aggregation. So I suppose the pclmulqdq instruction
>> triggers some pathological performance limitation here.
>>
> 
> Just noticed it uses both crc instructions and pclmulqdq instructions.
> Sorry for the noise.
> 
>> That means the crct10dif driver probably needs the same treatment.
> 
> Tony, can you confirm that the problem is in the CRC instructions and
> not in the PCLMULQDQ code path that supersedes it when available?

CRC instructions.

sincerely
Tony
