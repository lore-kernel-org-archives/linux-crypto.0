From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Sun, 24 Jun 2018 09:11:05 +0200
Message-ID: <20180624071105.GA29407@gmail.com>
References: <20180507213755.GA32406@avx2>
 <tip-51bad67ffbce0aaa44579f84ef5d05597054ec6a@git.kernel.org>
 <1529235613.4572.7.camel@gmx.de>
 <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de>
 <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic>
 <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        jpoimboe@redhat.com, luto@kernel.org, peterz@infradead.org,
        brgerst@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, h.peter.anvin@intel.com,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180623103622.GA2760@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Lemme send a proper patch now...
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Sun, 17 Jun 2018 13:57:42 +0200
> Subject: [PATCH] x86/crypto: Add missing RETs
> 
> Add explicit RETs to the tail calls of AEGIS and MORUS crypto algorithms
> otherwise they run into INT3 padding due to
> 
>   51bad67ffbce ("x86/asm: Pad assembly functions with INT3 instructions")
> 
> leading to spurious debug exceptions.
> 
> Mike Galbraith <efault@gmx.de> took care of all the remaining callsites.

Note that 51bad67ffbce has been zapped because it caused too many problems like 
this, but the explicit RETs make sense nevertheless. When applying the patch 
please don't include the SHA1 of the non-upstream (and probably never-upstream) 
commit.

Thanks,

	Ingo
