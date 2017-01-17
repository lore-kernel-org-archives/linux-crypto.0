From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Tue, 17 Jan 2017 09:30:30 +0000
Message-ID: <CAKv+Gu-KdLk4XB_W8OHSJ5jHMXT0J70FUJN=Bjuq3yhOURzSxA@mail.gmail.com>
References: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170117091152.GA31379@gondor.apana.org.au> <CAKv+Gu_8dkkMUpd5FoNqXoPM-1LQcALWYxZ5c-Er9xWBFmMJgQ@mail.gmail.com>
 <20170117092519.GB31379@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37908 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdAQJab (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 04:30:31 -0500
Received: by mail-it0-f49.google.com with SMTP id c7so38397355itd.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 01:30:31 -0800 (PST)
In-Reply-To: <20170117092519.GB31379@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 January 2017 at 09:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 17, 2017 at 09:20:11AM +0000, Ard Biesheuvel wrote:
>>
>> So to be clear, it is part of the API that after calling
>> crypto_skcipher_encrypt(req), and completing the request, req->iv
>> should contain a value that could potentially be used to encrypt
>> additional data? That sounds highly specific to CBC (e.g., this could
>> never work with XTS, since the tweak generation is only performed
>> once), so it does not make sense for skciphers in general. For
>> instance, drivers for h/w peripherals that never need to map the data
>> to begin with (since they only pass the physical addresses to the
>> hardware) will need to explicitly map the destination buffer to
>> retrieve those bytes, on the off chance that the transform may be
>> wrapped by CTS.
>
> Yes this is part of the API.  There was a patch to test this in
> testmgr but I wanted to give the drivers some more time before
> adding it.
>

Got a link?

> It isn't just CBC that uses chaining.  Other modes such as CTR
> use it too.  Disk encryption in general don't chaining but that's
> because they are sector-oriented.
>

OK, so that means chaining skcipher_set_crypt() calls, where req->iv
is passed on between requests? Are there chaining modes beyond
cts(cbc) encryption that rely on this?

It is easily fixed in the chaining mode code, so I'm perfectly happy
to fix it there instead, but I'd like to understand the requirements
exactly before doing so
