From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Sun, 24 Jun 2018 13:44:49 +0300
Message-ID: <20180624104449.GA20159@avx2>
References: <20180507213755.GA32406@avx2>
 <tip-51bad67ffbce0aaa44579f84ef5d05597054ec6a@git.kernel.org>
 <1529235613.4572.7.camel@gmx.de>
 <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de>
 <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic>
 <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
 <20180624071105.GA29407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org,
        tglx@linutronix.de, jpoimboe@redhat.com, luto@kernel.org,
        peterz@infradead.org, brgerst@gmail.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com,
        h.peter.anvin@intel.com,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180624071105.GA29407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 24, 2018 at 09:11:05AM +0200, Ingo Molnar wrote:
> > Add explicit RETs to the tail calls of AEGIS and MORUS crypto algorithms
> > otherwise they run into INT3 padding due to
> > 
> >   51bad67ffbce ("x86/asm: Pad assembly functions with INT3 instructions")
> > 
> > leading to spurious debug exceptions.
> > 
> > Mike Galbraith <efault@gmx.de> took care of all the remaining callsites.
> 
> Note that 51bad67ffbce has been zapped because it caused too many problems like 
> this, but the explicit RETs make sense nevertheless.

So commit which found real bug(s) was zapped.

OK
