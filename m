From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 08:46:01 +0100
Message-ID: <20170112074601.GB30151@gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170112070534.GA14016@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112070534.GA14016@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Jan 10, 2017 at 09:05:28AM -0800, Linus Torvalds wrote:
> >
> > I'm pretty sure we have random asm code that may not maintain a
> > 16-byte stack alignment when it calls other code (including, in some
> > cases, calling C code).
> > 
> > So I'm not at all convinced that this is a good idea. We shouldn't
> > expect 16-byte alignment to be something trustworthy.
> 
> So what if we audited all the x86 assembly code to fix this? Would
> it then be acceptable to do a 16-byte aligned stack?

Audits for small but deadly details that isn't checked automatically by tooling 
would inevitably bitrot again - and in this particular case there's a 50% chance 
that a new, buggy change would test out to be 'fine' on a kernel developer's own 
box - and break on different configs, different hw or with unrelated (and 
innocent) kernel changes, sometime later - spreading the pain unnecessarily.

So my feeling is that we really need improved tooling for this (and yes, the GCC 
toolchain should have handled this correctly).

But fortunately we have related tooling in the kernel: could objtool handle this? 
My secret hope was always that objtool would grow into a kind of life insurance 
against toolchain bogosities (which is a must for things like livepatching or a 
DWARF unwinder - but I digress).

Thanks,

	Ingo
