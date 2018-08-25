From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Sat, 25 Aug 2018 11:06:31 -0600
Message-ID: <20180825170629.GA8971@zx2c4.com>
References: <20180824213849.23647-1-Jason@zx2c4.com>
 <20180824213849.23647-3-Jason@zx2c4.com>
 <CAKv+Gu-u7vPkU49AzToGHyf_cWp0MiOmpD3cRUt8260QC2wj-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-u7vPkU49AzToGHyf_cWp0MiOmpD3cRUt8260QC2wj-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Ard,

On Sat, Aug 25, 2018 at 11:17:42AM +0100, Ard Biesheuvel wrote:
> Do we really need a new crypto API for WireGuard? Surely, you yourself
> are not affected by these concerns, and I don't anticipate an
> explosion of new crypto use cases in the kernel that would justify
> maintaining two parallel crypto stacks.

Yes, we really do. And the new API won't be useful for WireGuard but
also for the majority of cryptography users within the kernel, which
will gradually be ported to use the new API.

> Also, I take it this means that WireGuard will only work with your
> routines? We don't usually impose that kind of policy in the kernel:
> on my arm64 systems, AES/GCM runs at 2.3 cycles per byte, which is a
> good enough reason to prefer it over a ChaCha20/Poly1305 based AEAD,
> even if your code is faster than the current code (which is debatable,
> as you know)

WireGuard is a protocol that specifies ChaPoly, and I am proposing an
implementation of that protocol. The protocol explicitly does not
specify other ciphers. Please read the whitepaper for extensive
discussion and feel free to come on over to wireguard@lists.zx2c4.com if
you really want to hardcore bikeshed on protocol particulars. The short
answer, however, is: no WireGuard won't be adding cipher negotiation,
and no, this isn't considered a good feature, and no, you won't have
any luck changing that. I am certain, though, that pushing this point
will be a terrific means of steering this implementation thread far off
course, as various folks with their various opinions feel compelled to
jump in about their thoughts on cipher negotiation. Yawn.

Besides, your claim about "impos[ing] that kind of policy in the kernel"
is bogus: with the exception of IPsec, dm-crypt, and AF_ALG, basically
all users of cryptography I can find are using a very particular set of
ciphers. For example, Bluetooth uses a particular elliptic curve that
has been specified by the Bluetooth people, and the kernel therefore
implements a driver that does computations over that elliptic curve.
Nobody on LKML is clamoring for that driver to also support Curve448 or
something, since that's not what Bluetooth specifies or how Bluetooth
works. So too, that's not what WireGuard specifies or how WireGuard
works.

> It also means that users of the crypto API will not benefit from your
> better code. I'm sure you agree that it is a bad idea to force those
> same crypto-impaired programmers to port their code to a new API.

As mentioned, I think we'll certainly be gradually porting existing
crypto API users over to the new API where appropriate. As always, this
is a gradual thing, and won't ever come all at once in the first
patchset, but I'm pretty confident we can get there somewhat quickly,
especially as new primitives become available in the new API.

> I also suggested that we work with Andy Polyakov (as I have in the
> past) to make the changes required for the kernel in the OpenSSL
> upstream. That way, we can take the .pl files unmodified, and benefit
> from the maintenance and review upstream. Dumping 10,000s of lines of
> generated assembler in the kernel tree like that is really
> unacceptable IMO.

I'm happy to do that, and indeed I do enjoy working with Andy. However,
I don't think your characterization of the current situation is at all
accurate. Rather, those .S files have been extensively worked with and
crafted. They're far from being merely generated, and they've been
pretty heavily reviewed.

> I'm not sure what the relevance of
> formally verified implementations is, though, since it only proves
> that the code is true to the algorithm, not that the algorithm is
> secure. Or am I missing something?

You are indeed missing something.

When the code is not true to the algorithm, that is very bad.
When the code is true to the algorithm, that is very good.

Formally verified implementations intend to increase our confidence
in the latter.

Meanwhile on the algorithm side of thing, the WireGuard protocol has a
number of proofs that the protocol is secure:
  - https://www.wireguard.com/papers/wireguard-formal-verification.pdf
  - https://www.wireguard.com/papers/dowling-paterson-computational-2018.pdf
  - https://www.wireguard.com/formal-verification/
Before you get too excited though, keep in mind that this is a proof of
the protocol, and not of each primitive, like, say, "ChaCha20" or
"Curve25519." However, academic literature is full of all sorts of
curious and fascinating security analyses of the various primitives if
this is something you're interested in.

Jason
