Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:51439 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbeKETj2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 14:39:28 -0500
Received: by mail-it1-f193.google.com with SMTP id h13so11907888itl.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 02:20:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOtvUMeRth4zrTZbEy6Co=+CR4==5oSDbaf760Yh4fj8UAf8bQ@mail.gmail.com>
References: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
 <2578248.XAorIH2ink@tauon.chronox.de> <CAOtvUMeRth4zrTZbEy6Co=+CR4==5oSDbaf760Yh4fj8UAf8bQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 5 Nov 2018 11:20:28 +0100
Message-ID: <CAKv+Gu8x1LRKq4xJTrWfu7vQDPSzxYwEYGXG_o3Xv+Zsch9S-g@mail.gmail.com>
Subject: Re: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5 November 2018 at 10:18, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Hi Stephan,
>
> On Mon, Nov 5, 2018 at 10:50 AM Stephan Mueller <smueller@chronox.de> wrote:
>>
>> Am Sonntag, 4. November 2018, 11:05:24 CET schrieb Gilad Ben-Yossef:
>>
>> Hi Gilad,
>>
>> > As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
>> > allowed as a FIPS mode algorithm. Mark it as such.
>> >
>> > [1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
>>
>> There are several types of CTS approaches. Only three of those are listed in
>> the SP800-38A addendum. The source code only refers to some RFCs.
>>
>> Did you check whether the CTS implementation matches one or more of the types
>> listed in the addendum? If yes, may I suggest to add a small statement in the
>> code noting this fact?
>
> Yes, AFAIK the software implements CBC-CS3 as described in the document.
> You have a very good point about this not document anywhere. I will
> send a patch.
>

I agree that it makes sense to document this.

> While we're at it, does someone find it useful if I implemented the
> other two modes?
> They are part of the standard as well, although I am not sure that in
> itself is sufficient cause.
>

Nope. The linux crypto API is not a general purpose cryptography
toolkit, it should only offer what we actually use in the kernel, or
we'll either end up with bitrot or with a disproportionate maintenance
burden for stuff nobody actually uses.
