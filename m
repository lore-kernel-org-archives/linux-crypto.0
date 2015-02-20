From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: Intermediate Hash states
Date: Sat, 21 Feb 2015 01:39:23 +0530
Message-ID: <CAHTT9VLchccUkWBSjKGFyAAU51xpkJj4LWi6AieXMK+iig3JJw@mail.gmail.com>
References: <CAHTT9VLHi6m8-NNS_MJ2cabNm2Eng18zs8iGqJudP1ANb-99Ww@mail.gmail.com>
	<3307166.8E51TTmzB6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40370 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBTUJY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 15:09:24 -0500
Received: by pdev10 with SMTP id v10so9902190pde.7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 12:09:23 -0800 (PST)
In-Reply-To: <3307166.8E51TTmzB6@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Muller ,

Thanks for the information provided.

I am little confused between current scenario (multiple threads will
send multiple requests to crypto H/W) and export/import.

Please can you let me know when export/imports can be used in real time?

I Have seen many references of these method(export/import) in open
source , but not really sure when its being used in real time.

BR,
Srisowj

On Sat, Feb 21, 2015 at 1:07 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 19. Februar 2015, 21:48:30 schrieb sri sowj:
>
> Hi sri,
>
>> Hi ,
>>
>> I am trying to understand Hashing Algorithms implementation in linux kernel
>> .
>>
>> I am really not sure on how to deal with following scenario.
>>
>> assume when App1 is in middle of
>> execution(crypto_ahash_init/update/update...) ,App2 sends a request
>> may be from another cpu in multi-core system to underlying crypto
>> driver .
>> Then essentially input1 has to save its  state(intermediate Hash) and
>> serves App2 request.
>>
>> App1 ---------> Linux kernel crypto driver
>>
>>        crypto_ahash_init(input1);
>>         crypto_ahash_update(input1);
>>        ..................
>>        ..................
>>         crypto_ahash_update(input1); // multple Hash requests
>>        ..................
>>        ..................
>>     crypto_ahash_final()
>>
>>
>>
>> App2 ---------> Linux kernel crypto driver
>>
>>         crypto_ahash_init(input2);
>>         crypto_ahash_update(input2);
>>
>>
>> Here in this scenario how to track,save and restore the Hash state for App1
>> ?
>
> The ahash (ablkcipher too) uses kernel threads. Those are scheduled like
> normal processes, including the context switching.
>>
>> BR,
>> Srisowj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ciao
> Stephan
