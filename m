From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Locking for HW crypto accelerators
Date: Thu, 30 Aug 2018 14:56:01 +0200
Message-ID: <3053033.se6UkFii4W@tauon.chronox.de>
References: <CAJKOXPfVXnazraHq-NCCM+h26FFi1U6Z3OSYOX17XH3bj-UDLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJKOXPfVXnazraHq-NCCM+h26FFi1U6Z3OSYOX17XH3bj-UDLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 30. August 2018, 14:22:22 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> Hi,
> 
> I am trying to figure out necessary locking on the driver side of
> crypto HW accelerator for symmetric hash (actually: CRC). I
> implemented quite simple driver for shash_alg.
> 
> I looked at the docs, I looked at the crypto kcapi core code... and
> there is nothing about necessary locking. kcapi does not perform it.
> 
> My HW is quite similar to drivers/crypto/stm32/stm32_crc32.c so it has
> only one HW set of registers for dealing with CRC. Or in other words,
> only one queue of one element. :) I implemented all shash_alg
> callbacks - init(), update(), final()... and also finup() (manually
> calling update+final) and digest() (init+update+final).
> 
> Now imagine multiple user-space users of this crypto alg where all of
> them call kcapi_md_digest() (so essentially init() -> update() ->
> final()). It seems that kcapi does not perform any locking here so at
> some point updates from different processes might be mixed with
> finals:
> 
> Process A:             Process B:
> init()
>                        init()
> update()
>                        update()
> final()
>                        final()
> 
> My findings show that the requests are indeed being mixed with each other...
> 
> Should driver perform any weird locking here? Or maybe that is the
> case of using ONLY the digest() callback (so no update, no final)
> because my HW cannot track different kcapi requests?

The hashing is performed on a buffer provided by the caller. E.g. it is the 
buffer pointed to by the ahash request or the shash desc structure. All 
operations of init/update/final operate on that memory.

If you have parallel requests, each caller has a private buffer that it 
provides to the kernel crypto API. This applies also to AF_ALG.

Thus, as long as the individual operations of init/update and final are atomic 
operations, there should be no locking necessary.

Thus, all your driver needs to guarantee is the atomicitcy of the init/update/
final operation in respect to your hardware state.

Ciao
Stephan
