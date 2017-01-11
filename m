From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 11:15:26 +0800
Message-ID: <20170111031526.GB4515@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 05:30:48PM +0000, Ard Biesheuvel wrote:
> 
> Apologies for introducing this breakage. It seemed like an obvious and
> simple cleanup, so I didn't even bother to mention it in the commit
> log, but if the kernel does not guarantee 16 byte alignment, I guess
> we should revert to the old method. If SSE instructions are the only
> ones that require this alignment, then I suppose not having a ABI
> conforming stack pointer should not be an issue in general.

I think we need to address this regardless of your patch.  You
won't be the last person to use __attribute__ to get 16-byte
alignment on the stack.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
