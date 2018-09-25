From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Tue, 25 Sep 2018 16:44:39 +0200
Message-ID: <CAHmME9oG6HSUV+UcohTbnt2VxVR8CQ2vFOZ8JSPb_uCoYcuy+g@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu_Wsp7s31KowyA20ag4t=VyiPLLhzg1ySp31sOFvo7FQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_Wsp7s31KowyA20ag4t=VyiPLLhzg1ySp31sOFvo7FQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Ard,

On Tue, Sep 25, 2018 at 12:25 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Kees is currently dealing with VLA uses in crypto API skcipher
> invocations [0] that don't benefit from its async capabilities nor
> from the runtime resolution of cipher name strings, given that they
> always select the same one.
>
> drivers/net/ppp/ppp_mppe.c: "ecb(arc4)"
> drivers/usb/wusbcore/crypto.c: "cbc(aes)"
> net/ceph/crypto.c: "cbc(aes)"
> net/mac802154/llsec.c: "ctr(aes)"
> net/rxrpc/rxkad.c: "pcbc(fcrypt)"
> net/rxrpc/rxkad.c: "pcbc(fcrypt)"
> net/sunrpc/auth_gss/gss_krb5_mech.c: "cbc(des)"
> net/sunrpc/auth_gss/gss_krb5_mech.c: "ecb(arc4)"
> net/sunrpc/auth_gss/gss_krb5_mech.c: "cbc(des3_ede)"
> net/sunrpc/auth_gss/gss_krb5_mech.c: "cts(cbc(aes))"
> net/sunrpc/auth_gss/gss_krb5_mech.c: "cts(cbc(aes))"
> net/wireless/lib80211_crypt_tkip.c: "ecb(arc4)"
> net/wireless/lib80211_crypt_wep.c: "ecb(arc4)"
>
> To me, these are prime candidates for moving into your library [at
> some point]. I guess AES should be non-controversial, but moving the
> others is actually more important in my view, since we will be able to
> stop exposing them via the crypto API in that case. Any thoughts?

In order of priority, I'll probably tackle lib/ first and then the
cases like you mentioned after. Indeed AES is an obvious candidate.
For the others, we'll evaluate them on a case-by-case basis. For
example, Ted T'so's "halfmd4" algorithm was moved from lib/ directly
into that portion of the ext4 driver, since it's some "half"-baked
random crypto that should only be used in that one place and then
never again. On the other hand, it seems likely RC4 and DES are used
multiple places, and so we'll have to carefully evaluate these. We can
also discuss this in November and see where thoughts are at that time.

> Also, you haven't yet responded to my question about WireGuard's
> limitation to synchronous encryption, or whether and how you expect to
> support asynchronous accelerators for ChaCha20/Poly1305 in the future.
> This shouldn't impede adoption of this series, but this is something
> that is going to come up sooner than you think, and so I would like to
> understand whether this means your library will grow asynchronous
> interfaces as well, or whether it will be moved to the crypto API.

I have no concrete plans to introduce an asynchronous interface to
Zinc at this time, but that could change at some later date. At the
moment however, I prefer for it to be just a simple collection of
software ciphers, just as the description reads. Regarding hardware
acceleration in WireGuard: I've actually been talking to some people
interested in producing these types of ASICs lately, and hopefully
something cool will come out of it. It's not obvious, however, that
this _must_ imply an asynchronous interface, even though that may very
well seem like the intuitive thing. This is, as well, a discussion for
the future indeed.

> (Also, I'd like to know whether the RFC7539 construction of ChaCha20
> and Poly1305 is compatible with WireGuard's)

WireGuard uses 64-bit nonces, but since they're both little-endian,
and because of the maximum size of a series of IP fragments (namely,
less than 2^32), they're "compatible".

Jason
