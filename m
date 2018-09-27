From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Thu, 27 Sep 2018 11:29:45 -0700
Message-ID: <20180927182944.GA22921@gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 25, 2018 at 04:55:59PM +0200, Jason A. Donenfeld wrote:
> 
> It is intended that this entire patch series enter the kernel through
> DaveM's net-next tree. Subsequently, WireGuard patches will go through
> DaveM's net-next tree, while Zinc patches will go through Greg KH's tree.
> 

Why is Herbert Xu's existing crypto tree being circumvented, especially for
future patches (the initial merge isn't quite as important as that's a one-time
event)?  I like being able to check out cryptodev to test upcoming crypto
patches.  And currently, changes to APIs, algorithms, tests, and implementations
all go through cryptodev, which is convenient for crypto developers.

Apparently, you're proposing that someone adding a new algorithm will now have
to submit the API portion to one maintainer (Herbert Xu) and the implementation
portion to another maintainer (you), and they'll go through separate git trees.
That's inconvenient for developers, and it seems that in practice you and
Herbert will be stepping on each other's toes a lot.

Can you please reach some kind of sane agreement with Herbert so that the
development process isn't fractured into two?  Perhaps you could review patches,
but Herbert could still apply them?

I'm also wondering about the criteria for making additions and changes to
"Zinc".  You mentioned before that one of the "advantages" of Zinc is that it
doesn't include "cipher modes from 90s cryptographers" -- what does that mean
exactly?  You've also indicated before that you don't want people modifying the
Poly1305 implementations as they are too error-prone.  Yet apparently it's fine
to change them yourself, e.g. when you added the part that converts the
accumulator from base 26 to base 32.  I worry there may be double standards
here, and useful contributions could be blocked or discouraged in the future.
Can you please elaborate on your criteria for contributions to Zinc?

Also, will you allow algorithms that aren't up to modern security standards but
are needed for compatibility reasons, e.g. MD5, SHA-1, and DES?  There are
existing standards, APIs, and data formats that use these "legacy" algorithms;
so implementations of them are often still needed, whether we like it or not.

And does it matter who designed the algorithms, e.g. do algorithms from Daniel
Bernstein get effectively a free pass, while algorithms from certain countries,
governments, or organizations are not allowed?  E.g. wireless driver developers
may need the SM4 block cipher (which is now supported by the crypto API) as it's
specified in a Chinese wireless standard.  Will you allow SM4 in Zinc?  Or will
people have to submit some algorithms to Herbert and some to you due to
disagreements about what algorithms should be included?

- Eric
