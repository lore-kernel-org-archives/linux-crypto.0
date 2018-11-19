Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:35714 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbeKSSPU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Nov 2018 13:15:20 -0500
Message-ID: <dcf5e17b3d1b86081197cd67a8c617c0eb8017c1.camel@strongswan.org>
Subject: Re: [PATCH 0/6] crypto: x86/chacha20 - SIMD performance improvements
From: Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 19 Nov 2018 08:52:29 +0100
In-Reply-To: <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com>
References: <20181111093630.28107-1-martin@strongswan.org>
         <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
         <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jason,

> I'd be inclined to roll with your implementation if it can eventually
> become competitive with Andy Polyakov's, [...]

I think for the SSSE3/AVX2 code paths it is competitive; especially for
small sizes it is faster, which is not that unimportant when
implementing layer 3 VPNs.

> there are still no AVX-512 paths, which means it's considerably
> slower on all newer generation Intel chips. Andy's has the AVX-512VL
> implementation for Skylake (using ymm, so as not to hit throttling)
> and AVX-512F for Cannon Lake and beyond (using zmm).

I don't think that having AVX-512F is that important until it is really
usable on CPUs in the market.

Adding AVX-512VL support is relatively simple. I have a patchset mostly
ready that is more than competitive with the code from Zinc. I'll clean
that up and do more testing before posting it later this week.

Best regards
Martin
