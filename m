From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 14:15:11 -0600
Message-ID: <20170112201511.yj5ekqmj76r2yv6t@treble>
References: <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au>
 <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au>
 <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 12, 2017 at 12:08:07PM -0800, Andy Lutomirski wrote:
> On Thu, Jan 12, 2017 at 11:51 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Jan 12, 2017 at 6:02 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >>
> >> Just to clarify, I think you're asking if, for versions of gcc which
> >> don't support -mpreferred-stack-boundary=3, objtool can analyze all C
> >> functions to ensure their stacks are 16-byte aligned.
> >>
> >> It's certainly possible, but I don't see how that solves the problem.
> >> The stack will still be misaligned by entry code.  Or am I missing
> >> something?
> >
> > I think the argument is that we *could* try to align things, if we
> > just had some tool that actually then verified that we aren't missing
> > anything.
> >
> > I'm not entirely happy with checking the generated code, though,
> > because as Ingo says, you have a 50:50 chance of just getting it right
> > by mistake. So I'd much rather have some static tool that checks
> > things at a code level (ie coccinelle or sparse).
> 
> What I meant was checking the entry code to see if it aligns stack
> frames, and good luck getting sparse to do that.  Hmm, getting 16-byte
> alignment for real may actually be entirely a lost cause.  After all,
> I think we have some inline functions that do asm volatile ("call
> ..."), and I don't see any credible way of forcing alignment short of
> generating an entirely new stack frame and aligning that.

Actually we already found all such cases and fixed them by forcing a new
stack frame, thanks to objtool.  For example, see 55a76b59b5fe.

> Ick.  This
> whole situation stinks, and I wish that the gcc developers had been
> less daft here in the first place or that we'd noticed and gotten it
> fixed much longer ago.
> 
> Can we come up with a macro like STACK_ALIGN_16 that turns into
> __aligned__(32) on bad gcc versions and combine that with your sparse
> patch?

-- 
Josh
