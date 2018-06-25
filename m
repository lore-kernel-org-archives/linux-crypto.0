From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Mon, 25 Jun 2018 08:19:32 -0500
Message-ID: <20180625131932.sge43esxdb5ejoxg@treble>
References: <1529235613.4572.7.camel@gmx.de>
 <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de>
 <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic>
 <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
 <20180624071105.GA29407@gmail.com>
 <20180624104449.GA20159@avx2>
 <20180625072438.GA19063@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org,
        tglx@linutronix.de, luto@kernel.org, peterz@infradead.org,
        brgerst@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, h.peter.anvin@intel.com,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625072438.GA19063@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 09:24:38AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Sun, Jun 24, 2018 at 09:11:05AM +0200, Ingo Molnar wrote:
> > > > Add explicit RETs to the tail calls of AEGIS and MORUS crypto algorithms
> > > > otherwise they run into INT3 padding due to
> > > > 
> > > >   51bad67ffbce ("x86/asm: Pad assembly functions with INT3 instructions")
> > > > 
> > > > leading to spurious debug exceptions.
> > > > 
> > > > Mike Galbraith <efault@gmx.de> took care of all the remaining callsites.
> > > 
> > > Note that 51bad67ffbce has been zapped because it caused too many problems like 
> > > this, but the explicit RETs make sense nevertheless.
> > 
> > So commit which found real bug(s) was zapped.
> > 
> > OK
> 
> No, what happened is that the commit was first moved into WIP.x86/debug showing 
> its work-in-progress status, because it was incomplete and caused bugs:
> 
>    https://lore.kernel.org/lkml/20180518073644.GA8593@gmail.com/T/#u
> 
> ... and finally, after weeks of inaction I zapped it because I didn't see progress 
> and you didn't answer my question.
> 
> If a fixed patch with updated tooling to detect these crashes before they occur on 
> live systems is submitted we'll reconsider - it didn't get NAK-ed, it's just 
> incomplete in the current form.

Hm, what happened to the objtool patch to detect these at build time?
Did it not work?

  https://lore.kernel.org/lkml/20180517134934.eog2fgoby5azq5a7@treble

-- 
Josh
