From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: Locking for HW crypto accelerators
Date: Thu, 30 Aug 2018 16:00:45 +0200
Message-ID: <CAJKOXPc4aFZYXCy8Kt_ky7-KEcQXtu0pH_PYpdvFQFrqtM2M4w@mail.gmail.com>
References: <CAJKOXPfVXnazraHq-NCCM+h26FFi1U6Z3OSYOX17XH3bj-UDLQ@mail.gmail.com>
 <20180830133930.r7s5hmnriif46hlr@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830133930.r7s5hmnriif46hlr@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 30 Aug 2018 at 15:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 30, 2018 at 02:22:22PM +0200, Krzysztof Kozlowski wrote:
> > Hi,
> >
> > I am trying to figure out necessary locking on the driver side of
> > crypto HW accelerator for symmetric hash (actually: CRC). I
> > implemented quite simple driver for shash_alg.
> >
> > I looked at the docs, I looked at the crypto kcapi core code... and
> > there is nothing about necessary locking. kcapi does not perform it.
> >
> > My HW is quite similar to drivers/crypto/stm32/stm32_crc32.c so it has
> > only one HW set of registers for dealing with CRC. Or in other words,
> > only one queue of one element. :) I implemented all shash_alg
> > callbacks - init(), update(), final()... and also finup() (manually
> > calling update+final) and digest() (init+update+final).
> >
> > Now imagine multiple user-space users of this crypto alg where all of
> > them call kcapi_md_digest() (so essentially init() -> update() ->
> > final()). It seems that kcapi does not perform any locking here so at
> > some point updates from different processes might be mixed with
> > finals:
> >
> > Process A:             Process B:
> > init()
> >                        init()
> > update()
> >                        update()
> > final()
> >                        final()
> >
> > My findings show that the requests are indeed being mixed with each other...
>
> After each operation all state must be stored in the ahash_request
> object.  The next operation should then load the state from the
> request object into the hardware.

Thanks, that's the solution I was missing.

Best regards,
Krzysztof
