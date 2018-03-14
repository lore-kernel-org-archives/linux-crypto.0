From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v2 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Wed, 14 Mar 2018 10:54:58 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
References: <20180313205945.245105-1-thgarnie@google.com> <20180313205945.245105-7-thgarnie@google.com> <20180314102951.GQ4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Thomas Garnier <thgarnie@google.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David S . Miller" <davem@davemloft.net>,
    Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
    "H . Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
    Kate Stewart <kstewart@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
    Philippe Ombredanne <pombredanne@nexb.com>,
    Arnaldo Carvalho de Melo <acme@redhat.com>,
    Andrey Ryabinin <aryabinin@virtuozzo.com>,
    Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>,
    Tom Lendacky <thomas.lendacky@amd.com>,
    "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
    Andy Lutomirski <luto@kernel.org>,
    Dominik Brodowski <linux@dominikbrodowski.net>,
    Borislav Petkov <bp@alien8.de>, Borislav Petkov
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <kernel-hardening-return-12603-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180314102951.GQ4043@hirez.programming.kicks-ass.net>
List-Id: linux-crypto.vger.kernel.org



On Wed, 14 Mar 2018, Peter Zijlstra wrote:

> On Tue, Mar 13, 2018 at 01:59:24PM -0700, Thomas Garnier wrote:
> > @@ -1576,7 +1578,9 @@ first_nmi:
> >  	addq	$8, (%rsp)	/* Fix up RSP */
> >  	pushfq			/* RFLAGS */
> >  	pushq	$__KERNEL_CS	/* CS */
> > -	pushq	$1f		/* RIP */
> > +	pushq	%rax		/* Support Position Independent Code */
> > +	leaq	1f(%rip), %rax	/* RIP */
> > +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
> >  	iretq			/* continues at repeat_nmi below */
> >  	UNWIND_HINT_IRET_REGS
> >  1:
>
> Urgh, xchg with a memop has an implicit LOCK prefix.

this_cpu_xchg uses no lock cmpxchg as a replacement to reduce latency.

>From linux/arch/x86/include/asm/percpu.h

/*
 * xchg is implemented using cmpxchg without a lock prefix. xchg is
 * expensive due to the implied lock prefix.  The processor cannot prefetch
 * cachelines if xchg is used.
 */
#define percpu_xchg_op(var, nval)                                       \
({                                                                      \
        typeof(var) pxo_ret__;                                          \
        typeof(var) pxo_new__ = (nval);                                 \
        switch (sizeof(var)) {                                          \
        case 1:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%al"                    \
                    "\n1:\tcmpxchgb %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "q" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 2:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%ax"                    \
                    "\n1:\tcmpxchgw %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 4:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%eax"                   \
                    "\n1:\tcmpxchgl %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 8:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%rax"                   \
                    "\n1:\tcmpxchgq %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        default: __bad_percpu_size();                                   \
        }                                                               \
        pxo_ret__;                                                      \
