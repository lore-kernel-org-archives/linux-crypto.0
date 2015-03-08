From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: tcrypt.ko module usage
Date: Sun, 8 Mar 2015 16:33:50 +0530
Message-ID: <CAHTT9VJ97mxEK=uZ8DUG3O0dFFpZvXikYmKaeipGa0fG9j5qyw@mail.gmail.com>
References: <CAHTT9VK5+AEGv1nbi5des3coux=6cW1Qukr4Zzep0QzYj0XJCQ@mail.gmail.com>
	<3784222.mDI2Uyy5JW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41285 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbCHLDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 07:03:51 -0400
Received: by pablj1 with SMTP id lj1so58708938pab.8
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2015 04:03:51 -0700 (PDT)
In-Reply-To: <3784222.mDI2Uyy5JW@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HI Stephan,

Thank you very much for the information provided.
It was a great help with quick response, I really appreciate your
efforts and the time.

If possible can you please help me to understand on how to handle
backlog messages from crypto kernel driver?

BR,
Srisowj

On Sun, Mar 8, 2015 at 3:54 PM, Stephan Mueller <smueller@chronox.de> w=
rote:
> Am Sonntag, 8. M=C3=A4rz 2015, 14:32:53 schrieb sri sowj:
>
> Hi sri,
>
>> HI All,
>>
>>
>> As I understand tcrypt.ko module purpose is to test different crypto
>> algorithm from the kenrel space. Please can some one help me with
>> below queries to understand tcrypt use cases.
>>
>> #1:If one need to test crypto algorithms with under laying crypto
>> Hardware engine  using tcrypto module ,is there any method or
>> procedure needs to be followed to hook crypto hardware engine with
>> tcrypt module?
>>
>> As per my understanding its very much straight forward,like if i nee=
d
>> to test aes algorithm then it will be some thing like  "insmod
>> tcrypt.ko mode =3D 10"
>
> That works if you ensured that your implementation has the highest pr=
iority of
> all implementations marked with the cipher names listed in case 10 (a=
s per
> your example):
>
>         case 10:
>                 ret +=3D tcrypt_test("ecb(aes)");
>                 ret +=3D tcrypt_test("cbc(aes)");
>                 ret +=3D tcrypt_test("lrw(aes)");
>                 ret +=3D tcrypt_test("xts(aes)");
>                 ret +=3D tcrypt_test("ctr(aes)");
>                 ret +=3D tcrypt_test("rfc3686(ctr(aes))");
>                 break;
>
>>
>> #2: Is there any way to test tcrypt module for some scenarios like
>>        2.a:concurrency scenario where multiple processes/threads try
>> to send a request for same algorithm
>
> This is not implemented with tcrypt. But you can either expand tcrypt=
,
> implement your own test, test it from user space with the speed test =
provided
> in [1] or use another implementation of the speed test that may easy =
be
> expanded [2].
>
> [1] http://www.chronox.de/libkcapi.html
> [2] https://www.eperm.de/cryptoperf.html
>
>>        2.b:multiple requests with a same tfm object
>
> dto
>
>>        2.c:back logged message scenarios like multiple methods will =
be
>> sent for processing while crypto engine is serving a request from sa=
me
>> tfm object
>
> dto
>>
>> #3:Is there any significance with
>> "CONFIG_CRYPTO_MANAGER_DISABLE_TESTS" Flag? ,Because when I disable
>> this flags I observed that tcrypt module
>> fails with a message like "Failed to load transform for cbc(aes): -2=
"
>
> This flag relates to the testmgr.c which implements known answer test=
s
> executed at the time a cipher implementation is registered.
>>
>>
>> BR,
>> Srisowj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cryp=
to" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ciao
> Stephan
