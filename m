From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 07:41:40 +0200
Message-ID: <CAKv+Gu8z1r7F_wbR6-e0Vbryqby7djDy2OR6JJURCsTo6ZMa2g@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com> <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13 September 2018 at 01:45, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, Sep 12, 2018 at 3:56 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> I realize you've put a lot of good and hard work into the existing
>> I am also concerned about your claim that all software algorithms will
>> be moved into this crypto library. You are not specific about whose
>> responsibility it will be that this is going to happen in a timely
>> fashion. But more importantly, it is not clear at all how you expect
>> this to work for, e.g., h/w instruction based SHAxxx or AES in various
>> chaining modes, which should be used only on cores that implement
>> those instructions (note that on arm64, we have optional instructions
>> for AES, PMULL, SHA1, SHA256, SHA512, SHA3, SM3 and SM4). Are all
>> those implementations (only few of which will be used on a certain
>> core) going to be part of the monolithic library? What are the APIs
>> going to look like for block ciphers, taking chaining modes into
>> account?
>
> I'm not convinced that there's any real need for *all* crypto
> algorithms to move into lib/zinc or to move at all.  As I see it,
> there are two classes of crypto algorithms in the kernel:
>
> a) Crypto that is used by code that chooses its algorithm statically
> and wants synchronous operations.  These include everything in
> drivers/char/random.c, but also a bunch of various networking things
> that are hardcoded and basically everything that uses stack buffers.
> (This means it includes all the code that I broke when I did
> VMAP_STACK.  Sign.)
>
> b) Crypto that is used dynamically.  This includes dm-crypt
> (aes-xts-plain64, aes-cbc-essiv, etc), all the ALG_IF interfaces, a
> lot of IPSEC stuff, possibly KCM, and probably many more.  These will
> get comparatively little benefit from being converted to a zinc-like
> interface.  For some of these cases, it wouldn't make any sense at all
> to convert them.  Certainly the ones that do async hardware crypto
> using DMA engines will never look at all like zinc, even under the
> hood.
>
> I think that, as a short-term goal, it makes a lot of sense to have
> implementations of the crypto that *new* kernel code (like Wireguard)
> wants to use in style (a) that live in /lib, and it obviously makes
> sense to consolidate their implementations with the crypto/
> implementations in a timely manner.  As a medium-term goal, adding
> more algorithms as needed for things that could use the simpler APIs
> (Bluetooth, perhaps) would make sense.
>
> But I see no reason at all that /lib should ever contain a grab-bag of
> crypto implementations just for the heck of it.  They should have real
> in-kernel users IMO.  And this means that there will probably always
> be some crypto implementations in crypto/ for things like aes-xts.
>

But one of the supposed selling points of this crypto library is that
it gives engineers who are frightened of crypto in general and the
crypto API in particular simple and easy to use crypto primitives
rather than having to jump through the crypto API's hoops.

A crypto library whose only encryption algorithm is a stream cipher
does *not* deliver on that promise, since it is only suitable for
cases where IVs are guaranteed not to be reused. You yourself were
bitten by the clunkiness of the crypto API when attempting to use the
SHA26 code, right? So shouldn't we move that into this crypto library
as well?

I think it is reasonable for WireGuard to standardize on
ChaCha20/Poly1305 only, although I have my concerns about the flag day
that will be required if this 'one true cipher' ever does turn out to
be compromised (either that, or we will have to go back in time and
add some kind of protocol versioning to existing deployments of
WireGuard)

And frankly, if the code were as good as the prose, we wouldn't be
having this discussion. Zinc adds its own clunky ways to mix arch and
generic code, involving GCC -include command line arguments and
#ifdefs everywhere. My review comments on this were completely ignored
by Jason.
