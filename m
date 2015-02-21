From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: communicating from the user space
Date: Sat, 21 Feb 2015 08:39:05 +0530
Message-ID: <CAHTT9VJhyHRMCsOZ+Unq7zTXNq7+iQpNvKCktPhDbZ_JA6vmsg@mail.gmail.com>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	<1522393.KEIVXizgKy@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45144 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbbBUDJH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 22:09:07 -0500
Received: by pablf10 with SMTP id lf10so12532734pab.12
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 19:09:05 -0800 (PST)
In-Reply-To: <1522393.KEIVXizgKy@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephen,

Thank you very much for the information provided.

I will try to explore more on AF_ALG , in between please can you also
provide information regarding below ?
#1: how openssl communicates to crypto h/w using PF_ALG
#2: How man algorithms are supported?
#3: are there any samples to get start with.

but if you can provide some info regarding cryptodev-linux from the
openssl prospect it will be more helpful.


BR,
Srisowj

On Sat, Feb 21, 2015 at 2:28 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Samstag, 21. Februar 2015, 01:27:04 schrieb sri sowj:
>
> Hi sri,
>
>> Hi ,
>>
>> I want to interact with Crypto Hardware from user space using openssl
>> like libraries based applications through cryptodev-linux interface.
>>
>> it looks like openssl comes with cryptodev-linux support(through
>> eng_cryptodev.c) .
>> When I downloaded openssl,eng_cryptodev.c file is available by default.
>>
>> below link refers about eng_cryptodev.c for openssl support :
>>
>> http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f928f4ee
>> e59755d1f0afc53
>>
>> Note:looks like there are some additional changes done on
>> eng_cryptodev.c file available in updated openssl source code.
>>
>> There seems to be some changes/patches  also available recently for
>> cryptodev-linux,below contains reference information.
>>
>> http://rt.openssl.org/Ticket/Display.html?id=2770&user=guest&pass=guest
>>
>>
>> Please let me know if my understanding is incorrect .
>
> See AF_ALG and a generic user space library around it:
>
> http://www.chronox.de/libkcapi.html
>>
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
