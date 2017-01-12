From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 09:10:07 -0600
Message-ID: <20170112151007.jutqc5zw4btupsyv@treble>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170112070534.GA14016@gondor.apana.org.au>
 <CALCETrV78gNs5ZqunaSPZ4AATapb1+ESKd6Wv+5rdMpZe9TSJQ@mail.gmail.com>
 <20170112150318.eq4lmfitxvitpix4@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112150318.eq4lmfitxvitpix4@treble>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 12, 2017 at 09:03:18AM -0600, Josh Poimboeuf wrote:
> On Wed, Jan 11, 2017 at 11:51:10PM -0800, Andy Lutomirski wrote:
> > On Wed, Jan 11, 2017 at 11:05 PM, Herbert Xu
> > <herbert@gondor.apana.org.au> wrote:
> > > On Tue, Jan 10, 2017 at 09:05:28AM -0800, Linus Torvalds wrote:
> > >>
> > >> I'm pretty sure we have random asm code that may not maintain a
> > >> 16-byte stack alignment when it calls other code (including, in some
> > >> cases, calling C code).
> > >>
> > >> So I'm not at all convinced that this is a good idea. We shouldn't
> > >> expect 16-byte alignment to be something trustworthy.
> > >
> > > So what if we audited all the x86 assembly code to fix this? Would
> > > it then be acceptable to do a 16-byte aligned stack?
> > >
> > > On the face of it it doesn't seem to be a huge amount of code
> > > assuming they mostly live under arch/x86.
> > 
> > The problem is that we have nasties like TRACE_IRQS_OFF.  Performance
> > doesn't really matter for these macros, so we could probably rig up a
> > helper for forcibly align the stack there.  Maybe
> > FRAME_BEGIN_FORCE_ALIGN?  I also think I'd rather not to modify
> > pt_regs.  We should just fix the small number of code paths that
> > create a pt_regs and then call into C code to align the stack.
> > 
> > But if we can't do this with automatic verification, then I'm not sure
> > I want to do it at all.  The asm is already more precarious than I'd
> > like, and having a code path that is misaligned is asking for obscure
> > bugs down the road.
> 
> For the entry code, could we just replace all calls with CALL_ALIGNED?
> That might be less intrusive than trying to adjust all the pt_regs
> accesses.
> 
> Then to ensure that nobody ever uses 'call' directly:
> 
>   '#define call please-use-CALL-ALIGNED-instead-of-call'
> 
> I think that would be possible if CALL_ALIGNED were a ".macro".

To clarify, CALL_ALIGNED could be (completely untested):

.macro CALL_ALIGNED \func
	push	%rbp
	movq	%rsp, %rbp
	and	$0xfffffffffffffff0,%rsp
	call	\func
	movq	%rbp, %rsp
	pop	%rbp
.endm

-- 
Josh
