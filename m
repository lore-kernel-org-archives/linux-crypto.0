From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 16:04:22 +0800
Message-ID: <20170112080422.GA14355@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170112070534.GA14016@gondor.apana.org.au>
 <CALCETrV78gNs5ZqunaSPZ4AATapb1+ESKd6Wv+5rdMpZe9TSJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV78gNs5ZqunaSPZ4AATapb1+ESKd6Wv+5rdMpZe9TSJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 11, 2017 at 11:51:10PM -0800, Andy Lutomirski wrote:
>
> The problem is that we have nasties like TRACE_IRQS_OFF.  Performance

I don't understand.  What's the issue with TRACE_IRQS_OFF? It should
be treated as any other function call.  That is, enter it with an
aligned stack, and the TRACE_IRQS_OFF code itself should ensure
the stack stays aligned before it calls down into C.
 
> But if we can't do this with automatic verification, then I'm not sure
> I want to do it at all.  The asm is already more precarious than I'd
> like, and having a code path that is misaligned is asking for obscure
> bugs down the road.

I understand the need for automated checks at this point in time.
 But longer term this is just part of the calling ABI.  After all,
we don't add checks everywhere to ensure people preserve rbx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
