From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 18 Jul 2017 09:35:03 +0100
Message-ID: <CAKv+Gu_ZEsPnFmb6q5c1YmoEQaPNLxTf5YO2=nJiW6SQO0pLsQ@mail.gmail.com>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170718052556.GA4532@gondor.apana.org.au> <CAKv+Gu_6Gw5dD7rnmL-AUUSFFC8W077F8FqDK7m_wYYUizmZFg@mail.gmail.com>
 <20170718071849.GA5536@gondor.apana.org.au> <CAKv+Gu-FAfcfAiPju_+X=3ZOC_NqGYo7DaMpx9YosH=OpWaVCw@mail.gmail.com>
 <20170718083003.GA5648@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37922 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdGRIfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:35:04 -0400
Received: by mail-it0-f42.google.com with SMTP id h199so9709672ith.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 01:35:04 -0700 (PDT)
In-Reply-To: <20170718083003.GA5648@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 July 2017 at 09:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jul 18, 2017 at 08:57:28AM +0100, Ard Biesheuvel wrote:
>>
>> So if you care about security and/or the cache/memory footprint more
>> than about speed, you can disable the table based implementations that
>> exist for i586, x86, ARM and arm64 (all of which have faster and time
>> invariant implementations based on SIMD or special instructions
>> anyway, so for 95% of the cases, it does not really matter).
>
> The thing is that anybody who cares about speed won't be using
> aes-generic anyway.  We have way too many AES implementations
> as it is, and having two C implementations is really getting
> silly.
>
> So would it be possible for you to proceed with your work in
> such a way that we end up with just aes-ti as the generic C
> implementation?
>

Sure.

> As for the table-based asm implementations yes they can stay and
> work out some way of sharing that table at the source-code level.
> At run-time the table can just go into the asm module directly
> since you'd only have one on each platform, right?
>

Indeed. And ARM only uses 4 of those 16 tables anyway (and really only
needs two of them, so I will fix that as well)
