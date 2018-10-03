From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 19/23] zinc: Curve25519 ARM implementation
Date: Wed, 3 Oct 2018 03:03:09 +0200
Message-ID: <CAHmME9rp0Fi5ObK5oi8FHj1_nK5hP4T2Bq7_dAmzq4OQ0mp0uw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-20-Jason@zx2c4.com>
 <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Peter Schwabe <peter@cryptojedi.org>,
        "Daniel J . Bernstein" <djb@cr.yp.to>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(+Dan,Peter in CC. Replying to:
<https://lore.kernel.org/lkml/CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com/>
for context.)

Hi Ard,

On Tue, Oct 2, 2018 at 6:59 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Shouldn't this use the new simd abstraction as well?

Yes, it probably should, thanks.

> I guess qhasm means generated code, right?
> Because many of these adds are completely redundant ...
> This looks odd as well.
> Could you elaborate on what qhasm is exactly? And, as with the other
> patches, I would prefer it if we could have your changes as a separate
> patch (although having the qhasm base would be preferred)

Indeed qhasm converts this --
<https://github.com/floodyberry/supercop/blob/master/crypto_scalarmult/curve25519/neon2/scalarmult.pq>
-- into this. It's a thing from Dan (CC'd now) --
<http://cr.yp.to/qhasm.html>. As you've requested, I can layer the
patches to show our changes on top.

> ... you can drop this add
> same here
> and here
> and here
> and here
> and here
> and here
> and here
> redundant add
> I'll stop here - let me just note that this code does not strike me as
> particularly well optimized for in-order cores (such as A7).
> For instance, the sequence
> can be reordered as
> and not have every other instruction depend on the output of the previous one.
> Obviously, the ultimate truth is in the benchmark numbers, but I'd
> thought I'd mention it anyway.

Yes indeed the output is suboptimal in a lot of places. We can
gradually clean this up -- slowly and carefully over time -- if you
want. I can also look into producing a new implementation within HACL*
so that it's verified. Assurance-wise, though, I feel pretty good
about this implementation considering its origins, its breadth of use
(in BoringSSL), the fuzzing hours it's incurred, and the actual
implementation itself.

 Either way, performance-wise, it's really worth having.

For example, on a Cortex-A7, we get these results (according to get_cycles()):

neon: 23142 cycles per call
fiat32: 49136 cycles per call
donna32: 71988 cycles per call

And on a Cortex-A9, we get these results (according to get_cycles()):

neon: 5020 cycles per call
fiat32: 17326 cycles per call
donna32: 28076 cycles per call

Jason
