Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:59785 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726499AbeKUDDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 22:03:10 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 21acca6c
        for <linux-crypto@vger.kernel.org>;
        Tue, 20 Nov 2018 16:27:01 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7b134e4e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 20 Nov 2018 16:27:01 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id p82-v6so1981082oih.11
        for <linux-crypto@vger.kernel.org>; Tue, 20 Nov 2018 08:33:09 -0800 (PST)
MIME-Version: 1.0
References: <20181111093630.28107-1-martin@strongswan.org> <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
 <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com>
 <dcf5e17b3d1b86081197cd67a8c617c0eb8017c1.camel@strongswan.org>
 <CAHmME9opX4XOvR3O5SV7Nx5sAJ4TVNtGzZj218j=g1U2aQ2JoA@mail.gmail.com> <71b15365d7bb59295531b6409b85906e648246a6.camel@strongswan.org>
In-Reply-To: <71b15365d7bb59295531b6409b85906e648246a6.camel@strongswan.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Nov 2018 17:32:57 +0100
Message-ID: <CAHmME9rDWufV5nMVv7MdSn0mHwoJMrRE_Ggu=+tYO7c8EAe_Fw@mail.gmail.com>
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

On Tue, Nov 20, 2018 at 5:29 PM Martin Willi <martin@strongswan.org> wrote:
> Thanks for the offer, no need at this time. But I certainly would
> welcome if you could do some (Wireguard) benching with that code to see
> if it works for you.

I certainly will test it in a few different network circumstances,
especially since real testing like this is sometimes more telling than
busy-loop benchmarks.

> > Actually, similarly here, a 10nm Cannon Lake machine should be
> > arriving at my house this week, which should make for some
> > interesting testing ground for non-throttled zmm, if you'd like to
> > play with it.
>
> Maybe in a future iteration, thanks. In fact would it be interesting to
> know if Cannon Lake can handle that throttling better.

Everything I've read on the Internet seems to indicate that's the
case, so one of the first things I'll be doing is seeing if that's
true. There are also the AVX512 IFMA instructions to play with!

Jason
