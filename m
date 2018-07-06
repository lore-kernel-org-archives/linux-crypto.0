From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Fri, 6 Jul 2018 16:57:35 +0200
Message-ID: <20180706145735.GA7100@gmail.com>
References: <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
 <20180624071105.GA29407@gmail.com>
 <20180624104449.GA20159@avx2>
 <20180625072438.GA19063@gmail.com>
 <20180625131932.sge43esxdb5ejoxg@treble>
 <20180626064930.GB25879@gmail.com>
 <20180626123154.unjji5glpokedwal@treble>
 <20180705075815.GA20903@gmail.com>
 <20180706140643.u2vau63nncg23hmi@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org,
        tglx@linutronix.de, luto@kernel.org, peterz@infradead.org,
        brgerst@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, h.peter.anvin@intel.com,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706140643.u2vau63nncg23hmi@treble>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> > Great, I'd be perfectly fine with such an approach.
> > 
> > Also, if we have that then we could re-apply Alexey's patch and switch to INT3 
> > (only on 64-bit kernels) without any trouble, because objtool should detect any 
> > execution flow bugs before the INT3 could trigger, right?
> > 
> > I.e. any INT3 fault would show a combination of *both* an objtool bug and a 
> > probable code flow bug - which I suspect would warrant crashing the box ...
> 
> Sounds good to me.  I can take Alexey's patch and submit a 64-bit
> version of it, along with the relevant objtool changes (though it may
> still be a few weeks before I get the chance).

Sounds good to me, thanks!

	Ingo
