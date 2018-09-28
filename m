From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Fri, 28 Sep 2018 19:47:05 +0200
Message-ID: <CAKv+Gu-8eiMkrJtpnMKzT=m9zGvY5qHVAmLM_rFA3gxk2gV-zw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180927182944.GA22921@gmail.com>
 <20180927213537.GA27576@zx2c4.com> <20180928011726.GA98113@gmail.com>
 <20180928023546.GA20765@zx2c4.com> <20180928045542.GA545@zzz.localdomain> <CAHmME9rJ4CewfDEqWh00ZowjWg9TaYpksVSzKSSxoKya-M8_LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rJ4CewfDEqWh00ZowjWg9TaYpksVSzKSSxoKya-M8_LA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 28 September 2018 at 07:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Eric,
>
> On Fri, Sep 28, 2018 at 6:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
>> And you still haven't answered my question about adding a new algorithm that is
>> useful to have in both APIs.  You're proposing that in most cases the crypto API
>> part will need to go through Herbert while the implementation will need to go
>> through you/Greg, right?  Or will you/Greg be taking both?  Or will Herbert take
>> both?
>
> If an implementation enters Zinc, it will go through my tree. If it
> enters the crypto API, it will go through Herbert's tree. If there
> wind up being messy tree dependency and merge timing issues, I can
> work this out in the usual way with Herbert. I'll be sure to discuss
> these edge cases with him when we discuss. I think there's a way to
> handle that with minimum friction.
>
>> A documentation file for Zinc is a good idea.  Some of the information in your
>> commit messages should be moved there too.
>
> Will do.
>
>> I'm not trying to "politicize" this, but rather determine your criteria for
>> including algorithms in Zinc, which you haven't made clear.  Since for the
>> second time you've avoided answering my question about whether you'd allow the
>> SM4 cipher in Zinc, and you designed WireGuard to be "cryptographically
>> opinionated", and you were one of the loudest voices calling for the Speck
>> cipher to be removed, and your justification for Zinc complains about cipher
>> modes from "90s cryptographers", I think it's reasonable for people to wonder
>> whether as the Zinc (i.e. Linux crypto library) maintainer you will restrict the
>> inclusion of crypto algorithms to the ones you prefer, rather than the ones that
>> users need.  Note that the kernel is used by people all over the world and needs
>> to support various standards, protocols, and APIs that use different crypto
>> algorithms, not always the ones we'd like; and different users have different
>> preferences.  People need to know whether the Linux kernel's crypto library will
>> meet (or be allowed to meet) their crypto needs.
>
> WireGuard is indeed quite opinionated in its primitive choices, but I
> don't think it'd be wise to apply the same design to Zinc. There are
> APIs where the goal is to have a limited set of high-level functions,
> and have those implemented in only a preferred set of primitives. NaCl
> is a good example of this -- functions like "crypto_secretbox" that
> are actually xsalsapoly under the hood. Zinc doesn't intend to become
> an API like those, but rather to provide the actual primitives for use
> cases where that specific primitive is used. Sometimes the kernel is
> in the business of being able to pick its own crypto -- random.c, tcp
> sequence numbers, big_key.c, etc -- but most of the time the kernel is
> in the business of implementing other people's crypto, for specific
> devices/protocols/diskformats. And for those use cases we need not
> some high-level API like NaCl, but rather direct access to the
> primitives that are required to implement those drivers. WireGuard is
> one such example, but so would be Bluetooth, CIFS/SMB, WiFi, and so
> on. We're in the business of writing drivers, after all. So, no, I
> don't think I'd knock down the addition of a primitive because of a
> simple preference for a different primitive, if it was clearly the
> case that the driver requiring it really benefited from having
> accessible via the plain Zinc function calls. Sorry if I hadn't made
> this clear earlier -- I thought Ard had asked more or less the same
> thing about DES and I answered accordingly, but maybe that wasn't made
> clear enough there.
>

CRC32 is another case study that I would like to bring up:
- the current status is a bit of a mess, where we treat crc32() and
crc32c() differently - the latter is exposed by libcrc32.ko as a
wrapper around the crypto API, and there is some networking code (SCTP
iirc) that puts another kludge on top of that to ensure that the code
is not used before the module is loaded
- we have C versions, scalar hw instruction based versions and
carryless multiplication based versions for various architectures
- on ST platforms, we have a synchronous hw accelerator that is 10x
faster than C code on the same platform.

AFAICT none of its current users rely on the async interface or
runtime dispatch of the 'hash'.

CRC32/c is an area that I would *really* like to clean up (and am
already doing for arm64) - just having a function call interface would
be a huge improvement but it seems to me that the choice for
monolithic modules per algo/architecture implies that we will have to
leave ST behind in this case.

On the one hand, disregarding this seems fair, at least for the
moment. On the other hand, fixing this in the crypto API, e.g., by
permitting direct function calls to synchronous hashes and without the
need to allocate a transform/request etc, blurs the line even more
where different pieces should live.

Any thoughts?
