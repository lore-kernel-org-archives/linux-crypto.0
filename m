Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:36635 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388694AbeKTDKJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Nov 2018 22:10:09 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c65a04e3
        for <linux-crypto@vger.kernel.org>;
        Mon, 19 Nov 2018 16:39:56 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fc91a10f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 19 Nov 2018 16:39:56 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id a11so24580853otr.10
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 08:45:56 -0800 (PST)
MIME-Version: 1.0
References: <20181111093630.28107-1-martin@strongswan.org> <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
 <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com> <dcf5e17b3d1b86081197cd67a8c617c0eb8017c1.camel@strongswan.org>
In-Reply-To: <dcf5e17b3d1b86081197cd67a8c617c0eb8017c1.camel@strongswan.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 19 Nov 2018 17:45:44 +0100
Message-ID: <CAHmME9opX4XOvR3O5SV7Nx5sAJ4TVNtGzZj218j=g1U2aQ2JoA@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: x86/chacha20 - SIMD performance improvements
To: Martin Willi <martin@strongswan.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

On Mon, Nov 19, 2018 at 8:52 AM Martin Willi <martin@strongswan.org> wrote:
>
> Adding AVX-512VL support is relatively simple. I have a patchset mostly
> ready that is more than competitive with the code from Zinc. I'll clean
> that up and do more testing before posting it later this week.

Terrific. Depending on how it turns out, it'll be nice to try
integrating this into Zinc. I have a massive Xeon Gold 5120 machine
that I can give you access to if you'd like to do some testing and
benching. Poke me on IRC -- I'm zx2c4.

> I don't think that having AVX-512F is that important until it is really
> usable on CPUs in the market.

Actually, similarly here, a 10nm Cannon Lake machine should be
arriving at my house this week, which should make for some interesting
testing ground for non-throttled zmm, if you'd like to play with it.

Jason
