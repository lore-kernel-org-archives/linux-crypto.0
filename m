From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Sun, 16 Sep 2018 21:09:11 -0700
Message-ID: <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: andrew@lunn.ch, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911.165739.2032677219588723041.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 4:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Wed, 12 Sep 2018 01:30:15 +0200
>
> > Just as an FYI:
> >
> > 1) I don't think anybody in netdev has taken a serious look at the
> > network code yet. There is little point until the controversial part
> > of the code, Zinc, has been sorted out.
> >
> > 2) I personally would be surprised if DaveM took this code without
> > having an Acked-by from the crypto subsystem people. In the same way,
> > i doubt the crypto people would take an Ethernet driver without having
> > DaveM's Acked-by.
>
> Both of Andrew's statements are completely true.
>
> I'm not looking at any of the networking bits until the crypto stuff
> is fully sorted and fully supported and Ack'd by crypto folks.

So, as a process question, whom exactly are we waiting for:

CRYPTO API
M:      Herbert Xu <herbert@gondor.apana.org.au>
M:      "David S. Miller" <davem@davemloft.net>
L:      linux-crypto@vger.kernel.org

Herbert hasn't replied to any of these submissions.  You're the other
maintainer :)

To the extent that you (DaveM) want my ack, here's what I think of the
series so far:

The new APIs to the crypto primitives are good.  For code that wants
to do a specific known crypto operation, they are much, much more
pleasant to use than the existing crypto API.  The code cleanups in
the big keys patch speak for themselves IMO.  I have no problem with
the addition of a brand-new API to the kernel, especially when it's a
nice one like Zinc's, even if that API starts out with only a couple
of users.

Zinc's arrangement of arch code is just fine.  Sure, there are
arguments that putting arch-specific code in arch/ is better, but this
is mostly bikeshedding IMO.

There has been some discussion of the exact best way to handle
simd_relax() and some other minor nitpicks of API details.  This kind
of stuff doesn't need to block the series -- it can always be reworked
down the road if needed.

There are two things I don't like right now, though:

1. Zinc conflates the addition of a new API with the replacement of
some algorithm implementations.  This is problematic.  Look at the
recent benchmarks of ipsec before and after this series.  Apparently
big packets get faster and small packets get slower.  It would be
really nice to bisect the series to narrow down *where* the regression
came from, but, as currently structured, you can't.

The right way to do this is to rearrange the series.  First, the new
Zinc APIs should be added, and they should be backed with the
*existing* crypto code.  (If the code needs to be moved or copied to a
new location, so be it.  The patch will be messy because somehow the
Zinc API is going to have to dispatch to the arch-specific code, and
the way that the crypto API handles it is not exactly friendly to this
type of use.  So be it.)  Then another patch should switch the crypto
API to use the Zinc interface.  That patch, *by itself*, can be
benchmarked.  If it causes a regression for small ipsec packets, then
it can be tracked down relatively easily.  Once this is all done, the
actual crypto implementation can be changed, and that changed can be
reviewed on its own merits.

As a simplistic example, I wrote this code a while back:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=e9e12f056f2abed50a30b762db9185799f5864e6

and its two parents.  This series added a more Zinc-like API to
SHA256.  And it did it without replacing the SHA256 implementation.
Doing this for Zinc would be a bit more complication, since the arch
code would need to be invoked too, but it should be doable.

FWIW, Wireguard should not actually depend on the replacement of the
crypto implementation.

2. The new Zinc crypto implementations look like they're brand new.  I
realize that they have some history, some of them are derived from
OpenSSL, etc, but none of this is really apparent in the patches
themselves.  It would be great if the kernel could literally share the
same code as something like OpenSSL, since OpenSSL gets much more
attention than the kernel's crypto.  Failing that, it would be nice if
the patches made it more clear how the code differs from its origin.
At the very least, though, if the replacement of the crypto code were,
as above, a patch that just replaced the crypto code, it would be much
easier to review and benchmark intelligently.

--Andy
