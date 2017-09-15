From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Fri, 15 Sep 2017 23:06:29 +0200
Message-ID: <20170915210629.p5tv42za4ux7s2sy@gmail.com>
References: <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170913223303.pskmy2v7nto6rvtg@treble>
 <20170915045451.GA26063@zzz.localdomain>
 <20170915053431.xizfyla7lobrwqn3@gmail.com>
 <20170915160732.GA687@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915160732.GA687@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Eric Biggers <ebiggers3@gmail.com> wrote:

> On Fri, Sep 15, 2017 at 07:34:31AM +0200, Ingo Molnar wrote:
> > 
> > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > 
> > > Hi Josh,
> > > 
> > > On Wed, Sep 13, 2017 at 05:33:03PM -0500, Josh Poimboeuf wrote:
> > > > And here's v2 of the sha512-avx2 patch.  It should hopefully gain back
> > > > most of the performance lost by v1.
> > > > 
> > > > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > Subject: [PATCH] x86/crypto: Fix RBP usage in sha512-avx2-asm.S
> > > > 
> > > > Using RBP as a temporary register breaks frame pointer convention and
> > > > breaks stack traces when unwinding from an interrupt in the crypto code.
> > > > 
> > > > Mix things up a little bit to get rid of the RBP usage, without
> > > > destroying performance.  Use RDI instead of RBP for the TBL pointer.
> > > > That will clobber CTX, so save CTX on the stack and use RDI as CTX
> > > > before it gets clobbered, and R12 as CTX after it gets clobbered.
> > > > 
> > > > Also remove the unused y4 variable.
> > > > 
> > > 
> > > I tested the v2 patches for both sha256-avx2 and sha512-avx2 on Skylake.  They
> > > both pass the crypto self-tests, and there was no noticable performance
> > > difference compared to the unpatched versions.  Thanks!
> > 
> > Cool, thanks for review and the testing! Can we add your Tested-by + Acked-by tags 
> > to the patches?
> > 
> 
> Yes, that's fine for all the patches in the series.
> 
> Will these patches go in through the crypto tree or through the x86 tree?

Indeed, I suspect they should go through the crypto tree, these fixes are 
independent, they don't depend on anything in the x86 tree.

Thanks,

	Ingo
