From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Sat, 29 Sep 2018 04:40:03 +0200
Message-ID: <CAHmME9pPTxx5JP+8WQ0jLVBXxJmRKy2=z5YOSx_ar7JZqBQ1CA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180927182944.GA22921@gmail.com>
 <20180927213537.GA27576@zx2c4.com> <20180928011726.GA98113@gmail.com>
 <20180928023546.GA20765@zx2c4.com> <20180928045542.GA545@zzz.localdomain>
 <CAHmME9rJ4CewfDEqWh00ZowjWg9TaYpksVSzKSSxoKya-M8_LA@mail.gmail.com> <CAKv+Gu-8eiMkrJtpnMKzT=m9zGvY5qHVAmLM_rFA3gxk2gV-zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Willy Tarreau <w@1wt.eu>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-8eiMkrJtpnMKzT=m9zGvY5qHVAmLM_rFA3gxk2gV-zw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+Willy]

Hi Ard,

On Fri, Sep 28, 2018 at 7:47 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 28 September 2018 at 07:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > WireGuard is indeed quite opinionated in its primitive choices, but I
> > don't think it'd be wise to apply the same design to Zinc. There are
> > APIs where the goal is to have a limited set of high-level functions,
> > and have those implemented in only a preferred set of primitives. NaCl
> > is a good example of this -- functions like "crypto_secretbox" that
> > are actually xsalsapoly under the hood. Zinc doesn't intend to become
> > an API like those, but rather to provide the actual primitives for use
> > cases where that specific primitive is used. Sometimes the kernel is
> > in the business of being able to pick its own crypto -- random.c, tcp
> > sequence numbers, big_key.c, etc -- but most of the time the kernel is
> > in the business of implementing other people's crypto, for specific
> > devices/protocols/diskformats. And for those use cases we need not
> > some high-level API like NaCl, but rather direct access to the
> > primitives that are required to implement those drivers. WireGuard is
> > one such example, but so would be Bluetooth, CIFS/SMB, WiFi, and so
> > on. We're in the business of writing drivers, after all. So, no, I
> > don't think I'd knock down the addition of a primitive because of a
> > simple preference for a different primitive, if it was clearly the
> > case that the driver requiring it really benefited from having
> > accessible via the plain Zinc function calls. Sorry if I hadn't made
> > this clear earlier -- I thought Ard had asked more or less the same
> > thing about DES and I answered accordingly, but maybe that wasn't made
> > clear enough there.
> >
>
> CRC32 is another case study that I would like to bring up:
> - the current status is a bit of a mess, where we treat crc32() and
> crc32c() differently - the latter is exposed by libcrc32.ko as a
> wrapper around the crypto API, and there is some networking code (SCTP
> iirc) that puts another kludge on top of that to ensure that the code
> is not used before the module is loaded
> - we have C versions, scalar hw instruction based versions and
> carryless multiplication based versions for various architectures
> - on ST platforms, we have a synchronous hw accelerator that is 10x
> faster than C code on the same platform.
>
> AFAICT none of its current users rely on the async interface or
> runtime dispatch of the 'hash'.

I've added Willy to the CC, as we were actually discussing the crc32
case together two days ago. If my understanding was correct, he seemed
to think it'd be pretty useful too.

It seems like unifying the crc32 implementations at some point would
make sense, and since there's no usage of these as part of the crypto
api, providing crc32 via a vanilla function call seems reasonable.
It's not clear that on some strict formal level, crc32 belongs
anywhere near Zinc, since it's not _exactly_ in the same category...
But one could broaden the scope a bit and make the argument that this
general idea of accepting some bytes, doing some "pure" arithmetic
operations from a particular discipline on them in slightly different
ways depending on the architecture, and then returning some other
bytes, is what in essence is happening with these all of these
function calls, no matter their security or intended use; so if crc32
would benefit from being implemented using the exact same design
patterns, then it might as well be grouped in with the rest of Zinc.
On the other hand, this might be a bit of a slippery slope ("are
compression functions next?"), and a libcrc32.ko could just as well
exist as a standalone thing. I can see it both ways and some other
arguments too, but also this might form a good setting for some much
needed cleanup of the crc32. So that's definitely something we can
consider.

Regarding the synchronous ST driver: I'll give it a thorough read
through, but I do wonder off the bat if actually it'd be possible to
incorporate that into the Zinc paradigm in a fairly non-intrusive way.
I'll give that some thought and play around a bit with it.

Jason
