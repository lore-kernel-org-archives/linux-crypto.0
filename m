Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:36887 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIT0N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:26:13 -0500
Received: by mail-it1-f196.google.com with SMTP id j79-v6so2339289itb.2
        for <linux-crypto@vger.kernel.org>; Fri, 09 Nov 2018 01:46:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181109094525.3shpcmj4uqxfx33z@gondor.apana.org.au>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
 <20181109094447.v4fqirpmx7owayr7@gondor.apana.org.au> <20181109094525.3shpcmj4uqxfx33z@gondor.apana.org.au>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 9 Nov 2018 10:46:25 +0100
Message-ID: <CAKv+Gu_iNsRCK31aGnb3F=y63WqKLXg=NskWkZ7VYGHEB0NRAg@mail.gmail.com>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Qian Cai <cai@gmx.us>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9 November 2018 at 10:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Nov 09, 2018 at 05:44:47PM +0800, Herbert Xu wrote:
>> On Fri, Nov 09, 2018 at 12:33:23AM +0100, Ard Biesheuvel wrote:
>> >
>> > This should be
>> >
>> > reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
>> >        crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
>> >
>> > since the cryptd path in simd still needs some space in the subreq for
>> > the completion.
>>
>> OK this is what I applied to the cryptodev tree, please double-check
>> to see if I did anything silly:
>
> I meant the crypto tree rather than cryptodev.
>

That looks fine. Thanks Herbert.
