From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
Subject: Re: Crypto Fixes for 4.18
Date: Mon, 9 Jul 2018 11:47:42 +0200
Message-ID: <CAAUqJDsHzgGZTpYCAxAy=b3P0bq7dGrw6St68SkwjqwHpusN+A@mail.gmail.com>
References: <20161213132414.GA7898@gondor.apana.org.au> <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au> <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au> <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au> <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au> <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180708162035.zunfeflnq5hgwq6n@gondor.apana.org.au> <CA+55aFwe3HrgMBUhyHC7kAOCvp31S4kpAqDSFQ+BQY6r=WBiiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        =?UTF-8?Q?Milan_Bro=C5=BE?= <gmazyland@gmail.com>
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwe3HrgMBUhyHC7kAOCvp31S4kpAqDSFQ+BQY6r=WBiiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus,

ne 8. 7. 2018 o 20:32 Linus Torvalds <torvalds@linux-foundation.org> nap=C3=
=ADsal(a):
>
> On Sun, Jul 8, 2018 at 9:20 AM Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
> >
> > - Add missing RETs in x86 aegis/morus.
>
> Side note - I queried earlier during the discussion about this: how
> was this code taken despite having clearly never tested on _anything_?
>
> That's a serious question. Code that simply has never had any testing
> AT ALL should not have gotten in.

I did test the code using the included test vectors (and I found and
resolved lots of issues before submitting the patches thanks to that).
A good deal of the test vectors actually do trigger the code path that
calls the buggy function, so somehow it must have been working despite
the bug (see below).

> The use of 'int3' in padding showed the issue, but I don't believe the
> code could possibly have worked with the nops and fallthroughs.

I just looked at the disassembly of the function and its surroundings
(as compiled by my testing environment) and it seems that by a curious
but logical coincidence, the code actually *did* work and without any
side effects (other than executing a few useless instructions before
returning).

This is what the C signatures of the relevant functions look like (for
aegis128, the other cases are analogical):

asmlinkage void crypto_aegis128_aesni_enc_tail(
        void *state, unsigned int length, const void *src, void *dst);

asmlinkage void crypto_aegis128_aesni_dec(
        void *state, unsigned int length, const void *src, void *dst);

Notice that these two functions have identical signatures, this will
be important later. Now, the disassembly for
crypto_aegis128_aesni_enc_tail looks roughly like this:

0000000000000950 <crypto_aegis128_aesni_enc_tail>:
 [some code...]
 9c3:   0f 1f 00                nopl   (%rax)
 9c6:   66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
 9cd:   00 00 00

00000000000009d0 <crypto_aegis128_aesni_dec>:
 9d0:   48 83 fe 10             cmp    $0x10,%rsi
 9d4:   0f 82 c3 03 00 00       jb     d9d <crypto_aegis128_aesni_dec+0x3cd=
>
 [some code...]
 d9d:   c3                      retq    # <---
<crypto_aegis128_aesni_dec+0x3cd> is here
 d9e:   66 90                   xchg   %ax,%ax

So... thanks to the NOP padding, the control after the end of the
_enc_tail function walks right into the _dec function. This looks
scary at first glance, but here we are "saved" by the combination of
the following:
1. The second argument of the _enc_tail function (length; passed via
%rsi) is implictly always less than the block size (16 or 32 bytes).
2. The second argument of the _dec function (length; also passed via
%rsi) is checked to be greater than or equal to the block size (16 or
32 bytes); if it is less, then the function does nothing and just
returns.
3. _enc_tail does not modify the value in %rsi.

In conclusion, the bug remained undiscovered not because of lack of
testing, but because by sheer luck it was "working" anyway...

Sorry for introducing this (and other) bugs that had to be fixed
post-merging (I am the one who wrote the code). It is a lot of new
code that is hard to review, as it contains a lot of repetitive
boilerplate and assembly code.

Cheers,
Ondrej
