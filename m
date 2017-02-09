From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] Revert "hwrng: core - zeroize buffers with random data"
Date: Thu, 09 Feb 2017 10:32:18 +0100
Message-ID: <10800323.FrV6YrZeG5@positron.chronox.de>
References: <20170208002331.29408-1-david.daney@cavium.com> <CA+55aFwBdG42kk8J0t2tufHE=OUk4qWXEkFyySNgU3Ru2TA-tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Daney <david.daney@cavium.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwBdG42kk8J0t2tufHE=OUk4qWXEkFyySNgU3Ru2TA-tQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 8. Februar 2017, 17:57:23 CET schrieb Linus Torvalds:

Hi Linus,

> Stephan, Herbert? The zeroes in /dev/hwrng output are obviously
> complete crap, so there's something badly wrong somewhere.
> 
> The locking, for example, is completely buggered. There's even a
> comment about it, but that comment makes the correct observation of
> "but y'know: randomness". But the memset() also being outside the lock
> makes a complete joke of the whole thing.

That is correct, the patch is broken and should be reverted.

May I ask, however, why the add_device_randomness is invoked outside the lock 
as well. Shouldn't it be moved into the lock?

Besides, I still would think that a memset(0) is needed because we have long-
living memory locations (rng_buffer and rng_fillbuf) which may be overwritten 
sporadically. As these memory locations are expected to hold entropy, they 
should be overwritten as soon as the data is processed. Obviously, such memset 
must be done within the lock.

Ciao
Stephan
