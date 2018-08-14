From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Tue, 14 Aug 2018 14:12:31 -0700
Message-ID: <20180814211229.GB24575@gmail.com>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 03, 2018 at 04:33:50AM +0200, Jason A. Donenfeld wrote:
> 
> > Also, earlier when I tested OpenSSL's ChaCha NEON implementation on ARM
> > Cortex-A7 it was actually quite a bit slower than the one in the Linux
> > kernel written by Ard Biesheuvel... I trust that when claiming the
> > performance of all implementations you're adding is "state-of-the-art
> > and unrivaled", you actually compared them to the ones already in the
> > Linux kernel which you're advocating replacing, right? :-)
> 
> Yes, I have, and my results don't corroborate your findings. It will
> be interesting to get out a wider variety of hardware for comparisons.
> I suspect, also, that if the snarky emoticons subside, AndyP would be
> very interested in whatever we find and could have interest in
> improving implementations, should we actually find performance
> differences.
> 

On ARM Cortex-A7, OpenSSL's ChaCha20 implementation is 13.9 cpb (cycles per
byte), whereas Linux's is faster: 11.9 cpb.  I've also recently improved the
Linux implementation to 11.3 cpb and would like to send out a patch soon...
I've also written a scalar ChaCha20 implementation (no NEON instructions!) that
is 12.2 cpb on one block at a time on Cortex-A7, taking advantage of the free
rotates; that would be useful for the single permutation used to compute
XChaCha's subkey, and also for the ends of messages.

The reason Linux's ChaCha20 NEON implementation is faster than OpenSSL's is that
Linux's does 4 blocks at once using NEON instructions, and the words are
de-interleaved so the rows don't need to be shifted between each round.
OpenSSL's implementation, on the other hand, only does 3 blocks at once with
NEON instructions and has to shift the rows between each round.  OpenSSL's
implementation also does a 4th block at the same time using regular ARM
instructions, but that doesn't help on Cortex-A7; it just makes it slower.

I understand there are tradeoffs, and different implementations can be faster on
different CPUs.  Just know that from my point of view, switching to the OpenSSL
implementation actually introduces a performance regression, and we care a *lot*
about this since we need ChaCha to be absolutely as fast as possible for HPolyC
disk encryption.  So if your proposal goes in, I'd likely need to write a patch
to get the old performance back, at least on Cortex-A7...

Also, I don't know whether Andy P. considered the 4xNEON implementation
technique.  It could even be fastest on other ARM CPUs too, I don't know.

- Eric
