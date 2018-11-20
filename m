Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:39018 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbeKUC7m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 21:59:42 -0500
Message-ID: <71b15365d7bb59295531b6409b85906e648246a6.camel@strongswan.org>
Subject: Re: [PATCH 0/6] crypto: x86/chacha20 - SIMD performance improvements
From: Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 20 Nov 2018 17:29:40 +0100
In-Reply-To: <CAHmME9opX4XOvR3O5SV7Nx5sAJ4TVNtGzZj218j=g1U2aQ2JoA@mail.gmail.com>
References: <20181111093630.28107-1-martin@strongswan.org>
         <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
         <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com>
         <dcf5e17b3d1b86081197cd67a8c617c0eb8017c1.camel@strongswan.org>
         <CAHmME9opX4XOvR3O5SV7Nx5sAJ4TVNtGzZj218j=g1U2aQ2JoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jason,

> [...] I have a massive Xeon Gold 5120 machine that I can give you
> access to if you'd like to do some testing and benching.

Thanks for the offer, no need at this time. But I certainly would
welcome if you could do some (Wireguard) benching with that code to see
if it works for you.

> Actually, similarly here, a 10nm Cannon Lake machine should be
> arriving at my house this week, which should make for some
> interesting testing ground for non-throttled zmm, if you'd like to
> play with it.

Maybe in a future iteration, thanks. In fact would it be interesting to
know if Cannon Lake can handle that throttling better.

Regards
Martin
