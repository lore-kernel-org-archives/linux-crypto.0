Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD9FC433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 09:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9466B2399A
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 09:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbhAUJzu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:55:50 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:24680 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbhAUJzo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 04:55:44 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLyRS5HVVz9v6L3;
        Thu, 21 Jan 2021 10:54:44 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ldGUfcVV3v_f; Thu, 21 Jan 2021 10:54:44 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLyRS4Qzdz9v6Kv;
        Thu, 21 Jan 2021 10:54:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C069B8B7FB;
        Thu, 21 Jan 2021 10:54:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id TDQ7okhBwX9c; Thu, 21 Jan 2021 10:54:45 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 350708B7F9;
        Thu, 21 Jan 2021 10:54:45 +0100 (CET)
Subject: Re: [PATCH 1/2] crypto: talitos - Work around SEC6 ERRATA (AES-CTR
 mode data size error)
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
References: <4b7a870573f485b9fea496b13c9b02d86dd97314.1611169001.git.christophe.leroy@csgroup.eu>
 <CAMj1kXE7B05eAnR7KoDCym09Cw5qnzrV8KfNT2zJrko+mFic+w@mail.gmail.com>
 <6b804eff-bc9f-5e05-d479-f398de4e2b30@csgroup.eu>
 <CAMj1kXHz8LdDgfOcifcB-MBMM9-TbymOU_psT3JBFQfyvQ=EjQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <ecdd07b3-afca-7e26-b6b6-3a3a985bc5a1@csgroup.eu>
Date:   Thu, 21 Jan 2021 10:54:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHz8LdDgfOcifcB-MBMM9-TbymOU_psT3JBFQfyvQ=EjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 21/01/2021 à 08:31, Ard Biesheuvel a écrit :
> On Thu, 21 Jan 2021 at 06:35, Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>>
>>
>>
>> Le 20/01/2021 à 23:23, Ard Biesheuvel a écrit :
>>> On Wed, 20 Jan 2021 at 19:59, Christophe Leroy
>>> <christophe.leroy@csgroup.eu> wrote:
>>>>
>>>> Talitos Security Engine AESU considers any input
>>>> data size that is not a multiple of 16 bytes to be an error.
>>>> This is not a problem in general, except for Counter mode
>>>> that is a stream cipher and can have an input of any size.
>>>>
>>>> Test Manager for ctr(aes) fails on 4th test vector which has
>>>> a length of 499 while all previous vectors which have a 16 bytes
>>>> multiple length succeed.
>>>>
>>>> As suggested by Freescale, round up the input data length to the
>>>> nearest 16 bytes.
>>>>
>>>> Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>>>
>>> Doesn't this cause the hardware to write outside the given buffer?
>>
>>
>> Only the input length is modified. Not the output length.
>>
>> The ERRATA says:
>>
>> The input data length (in the descriptor) can be rounded up to the nearest 16B. Set the
>> data-in length (in the descriptor) to include X bytes of data beyond the payload. Set the
>> data-out length to only output the relevant payload (don't need to output the padding).
>> SEC reads from memory are not destructive, so the extra bytes included in the AES-CTR
>> operation can be whatever bytes are contiguously trailing the payload.
> 
> So what happens if the input is not 16 byte aligned, and rounding it
> up causes it to extend across a page boundary into a page that is not
> mapped by the IOMMU/SMMU?
> 

What is the IOMMU/SMMU ?

The mpc8xx, mpc82xx and mpc83xx which embed the Talitos Security Engine don't have such thing, the 
security engine uses DMA and has direct access to the memory bus for reading and writing.

Christophe
