From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 09:18:40 +0100
Message-ID: <20170112081840.GA32596@gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170112070534.GA14016@gondor.apana.org.au>
 <CALCETrV78gNs5ZqunaSPZ4AATapb1+ESKd6Wv+5rdMpZe9TSJQ@mail.gmail.com>
 <20170112080422.GA14355@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34724 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdALISp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 03:18:45 -0500
Content-Disposition: inline
In-Reply-To: <20170112080422.GA14355@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > But if we can't do this with automatic verification, then I'm not sure
> > I want to do it at all.  The asm is already more precarious than I'd
> > like, and having a code path that is misaligned is asking for obscure
> > bugs down the road.
> 
> I understand the need for automated checks at this point in time.
>  But longer term this is just part of the calling ABI.  After all,
> we don't add checks everywhere to ensure people preserve rbx.

The intelligent and responsible way to introduce such post facto ABI changes is 
via a smarter assembler: which would detect the obvious cases where assembly code 
generates a misaligned stack, at build time.

Assembly code can obviously still mess up in a hard to detect fashion if it tries 
- but that's OK, as most assembly code doesn't try to go outside regular stack 
allocation patterns.

Such a static check is relatively straightforward to do in assembly tooling - and 
perhaps objtool could do this too, as it already tracks the instructions that 
change the stack offset.

( And yes, this is what the GCC guys should have done, instead of sloppily 
  introducing such silent breakages and making the whole application landscape 
  less robust ... )

Thanks,

	Ingo
