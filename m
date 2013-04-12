From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: linux-next: Tree for Apr 11 [ crypto: aesni-intel ]
Date: Fri, 12 Apr 2013 16:46:20 +0200
Message-ID: <CA+icZUXkaOE2wyzxR-jPjxYAgzi8LEQJJDJo8fa5cfN+UMgErQ@mail.gmail.com>
References: <CA+icZUXR-dYRWkkz=V8=zn7cO=G1Ksa0bNweGn6kbYpjPn4mTg@mail.gmail.com>
	<20130412021336.GA14735@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20130412021336.GA14735@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 12, 2013 at 4:13 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Apr 11, 2013 at 07:14:31PM +0200, Sedat Dilek wrote:
>> On Thu, Apr 11, 2013 at 10:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi all,
>> >
>> > Changes since 20130410:
>> >
>> > The tip tree gained conflicts against the net-next and pm trees.
>> >
>> > The driver-core tree gained a conflict against the tip tree.
>> >
>> > The arm-soc tree gained a conflict against the arm-current tree.
>> >
>> > The akpm tree lost a patch that turned up elsewhere.
>> >
>> > ----------------------------------------------------------------------------
>>
>> [ CC linux-crypto folks ]
>>
>> On Ubuntu/precise AMD64 I see:
>>
>> ERROR: "glue_xts_crypt_128bit_one" [arch/x86/crypto/aesni-intel.ko] undefined!
>> ERROR: "glue_xts_crypt_128bit" [arch/x86/crypto/aesni-intel.ko] undefined!
>> make[3]: *** [__modpost] Error 1
>> make[2]: *** [modules] Error 2
>
> Should be fixed by:
>
> commit 110e7610190cc4693f26c05b43ea83468a0a925c
> Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Date:   Wed Apr 10 18:39:20 2013 +0300
>
>     crypto: aesni_intel - fix Kconfig problem with CRYPTO_GLUE_HELPER_X86
>
>

Yeah, that's fixing the issue.

Can you and your patch-supplier also CC Linux-Next ML for crypto-next fixes?
( ...would have saved one linux-kernel compilation. )
Thanks!

- Sedat -

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
