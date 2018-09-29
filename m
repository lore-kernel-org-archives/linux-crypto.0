From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Sat, 29 Sep 2018 07:35:51 +0200
Message-ID: <20180929053551.GA13905@1wt.eu>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180927182944.GA22921@gmail.com>
 <20180927213537.GA27576@zx2c4.com>
 <20180928011726.GA98113@gmail.com>
 <20180928023546.GA20765@zx2c4.com>
 <20180928045542.GA545@zzz.localdomain>
 <CAHmME9rJ4CewfDEqWh00ZowjWg9TaYpksVSzKSSxoKya-M8_LA@mail.gmail.com>
 <CAKv+Gu-8eiMkrJtpnMKzT=m9zGvY5qHVAmLM_rFA3gxk2gV-zw@mail.gmail.com>
 <CAHmME9pPTxx5JP+8WQ0jLVBXxJmRKy2=z5YOSx_ar7JZqBQ1CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9pPTxx5JP+8WQ0jLVBXxJmRKy2=z5YOSx_ar7JZqBQ1CA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 29, 2018 at 04:40:03AM +0200, Jason A. Donenfeld wrote:
> > CRC32 is another case study that I would like to bring up:
> > - the current status is a bit of a mess, where we treat crc32() and
> > crc32c() differently - the latter is exposed by libcrc32.ko as a
> > wrapper around the crypto API, and there is some networking code (SCTP
> > iirc) that puts another kludge on top of that to ensure that the code
> > is not used before the module is loaded
> > - we have C versions, scalar hw instruction based versions and
> > carryless multiplication based versions for various architectures
> > - on ST platforms, we have a synchronous hw accelerator that is 10x
> > faster than C code on the same platform.
> >
> > AFAICT none of its current users rely on the async interface or
> > runtime dispatch of the 'hash'.
> 
> I've added Willy to the CC, as we were actually discussing the crc32
> case together two days ago. If my understanding was correct, he seemed
> to think it'd be pretty useful too.

Yep, I've had a hard time finding a suitable implementation when I wrote
libslz (deflate+gzip compression). Some were totally inefficient in C,
spending their time negating the value twice for each byte because they
were using the pre-computed tables found in literature, some were using
optimized SIMD and I didn't understand them at all. Finally I spent some
time studying the principle and implemented mine. Later I discovered
that ARMv8 chips have a crc32 instruction for this which is very fast.
I tried it and it works much faster than my C implementation. For me
it's a perfect example of something that could go into a lib like zinc.

> It seems like unifying the crc32 implementations at some point would
> make sense, and since there's no usage of these as part of the crypto
> api, providing crc32 via a vanilla function call seems reasonable.
> It's not clear that on some strict formal level, crc32 belongs
> anywhere near Zinc, since it's not _exactly_ in the same category...

Well, it's a hash. Not a cryptographically secure one (32 bits only)
but definitely a hash usable (and used) for many cases. Those who need
a hash could start with SHA2 and figure that they don't need something
that secure since they only use 32 output bits and be fine with CRC32
instead. So that would make sense.

> But one could broaden the scope a bit and make the argument that this
> general idea of accepting some bytes, doing some "pure" arithmetic
> operations from a particular discipline on them in slightly different
> ways depending on the architecture, and then returning some other
> bytes, is what in essence is happening with these all of these
> function calls, no matter their security or intended use; so if crc32
> would benefit from being implemented using the exact same design
> patterns, then it might as well be grouped in with the rest of Zinc.

You should avoid suggesting it like this because you may end up
implementing addition :-) You should stick to the initial intent which
is to implement painful and boring stuff like crypto. But when you
see how to implement CRC32, you'll see that it's as painful to
implement as a crypto function. You start with a reference, you're
not satisfied and start to optimize various parts of it until you
break it for some inputs without noticing. I'm pretty sure that it
reminds you your own experience with some crypto functions because
I think we've all been in that situation in this domain.

> On the other hand, this might be a bit of a slippery slope ("are
> compression functions next?"),

I was thinking about it as well. There's a relation between crypto
and compression, all transform intelligible information into hidden
one in a reversable way, so the API is quite similar. One could argue
that compression usually requires memory allocation and huge states,
so that's probably not for the same use cases if the functions have
to deal with memory allocations.

In my opinion currently we have :
  - asymmetric crypto whose goal is to reversably encrypt/decrypt
    in order to protect confidentiality on small data like keys,
    or to sign in order to authenticate small data like hashes

  - symmetric crypto whose goal is to protect confidentiality on
    data blocks.

  - hashes whose goal is to provide integrity of data blocks (crc32
    fall into this category by the way)

It's visible that despite using similar APIs, compression doesn't
fit into any of these categories.

> and a libcrc32.ko could just as well
> exist as a standalone thing.

Having it included could simplify exposing it as a static inline
function when it's a single native instruction on the CPU.

Just my two cents,
Willy
