From: Thomas Garnier via Virtualization
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Wed, 14 Mar 2018 17:09:37 +0000
Message-ID: <CAJcbSZHz9c-W4ZEVFVn3Fepj9Tau6YzDdcvxAQdK5Aw-8S6Jzg@mail.gmail.com>
References: <20180313205945.245105-1-thgarnie@google.com>
	<20180313205945.245105-7-thgarnie@google.com>
	<20180314102951.GQ4043@hirez.programming.kicks-ass.net>
	<alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
Reply-To: Thomas Garnier <thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Petr Mladek <pmladek@suse.com>, Len Brown <len.brown@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jiri Slaby <jslaby@suse.cz>, Alok Kataria <akataria@vmware.com>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.c
To: Christoph Lameter <cl@linux.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 14, 2018 at 8:55 AM Christopher Lameter <cl@linux.com> wrote:



> On Wed, 14 Mar 2018, Peter Zijlstra wrote:

> > On Tue, Mar 13, 2018 at 01:59:24PM -0700, Thomas Garnier wrote:
> > > @@ -1576,7 +1578,9 @@ first_nmi:
> > >     addq    $8, (%rsp)      /* Fix up RSP */
> > >     pushfq                  /* RFLAGS */
> > >     pushq   $__KERNEL_CS    /* CS */
> > > -   pushq   $1f             /* RIP */
> > > +   pushq   %rax            /* Support Position Independent Code */
> > > +   leaq    1f(%rip), %rax  /* RIP */
> > > +   xchgq   %rax, (%rsp)    /* Restore RAX, put 1f */
> > >     iretq                   /* continues at repeat_nmi below */
> > >     UNWIND_HINT_IRET_REGS
> > >  1:
> >
> > Urgh, xchg with a memop has an implicit LOCK prefix.

> this_cpu_xchg uses no lock cmpxchg as a replacement to reduce latency.

Great, I will update my implementation.

Thanks Peter and Christoph.


>  From linux/arch/x86/include/asm/percpu.h

> /*
>   * xchg is implemented using cmpxchg without a lock prefix. xchg is
>   * expensive due to the implied lock prefix.  The processor cannot
prefetch
>   * cachelines if xchg is used.
>   */
> #define percpu_xchg_op(var, nval)                                       \
> ({                                                                      \
>          typeof(var) pxo_ret__;                                          \
>          typeof(var) pxo_new__ = (nval);                                 \
>          switch (sizeof(var)) {                                          \
>          case 1:                                                         \
>                  asm("\n\tmov "__percpu_arg(1)",%%al"                    \
>                      "\n1:\tcmpxchgb %2, "__percpu_arg(1)                \
>                      "\n\tjnz 1b"                                        \
>                              : "=&a" (pxo_ret__), "+m" (var)             \
>                              : "q" (pxo_new__)                           \
>                              : "memory");                                \
>                  break;                                                  \
>          case 2:                                                         \
>                  asm("\n\tmov "__percpu_arg(1)",%%ax"                    \
>                      "\n1:\tcmpxchgw %2, "__percpu_arg(1)                \
>                      "\n\tjnz 1b"                                        \
>                              : "=&a" (pxo_ret__), "+m" (var)             \
>                              : "r" (pxo_new__)                           \
>                              : "memory");                                \
>                  break;                                                  \
>          case 4:                                                         \
>                  asm("\n\tmov "__percpu_arg(1)",%%eax"                   \
>                      "\n1:\tcmpxchgl %2, "__percpu_arg(1)                \
>                      "\n\tjnz 1b"                                        \
>                              : "=&a" (pxo_ret__), "+m" (var)             \
>                              : "r" (pxo_new__)                           \
>                              : "memory");                                \
>                  break;                                                  \
>          case 8:                                                         \
>                  asm("\n\tmov "__percpu_arg(1)",%%rax"                   \
>                      "\n1:\tcmpxchgq %2, "__percpu_arg(1)                \
>                      "\n\tjnz 1b"                                        \
>                              : "=&a" (pxo_ret__), "+m" (var)             \
>                              : "r" (pxo_new__)                           \
>                              : "memory");                                \
>                  break;                                                  \
>          default: __bad_percpu_size();                                   \
>          }                                                               \
>          pxo_ret__;                                                      \




-- 
Thomas
