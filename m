From: Thomas Garnier via Virtualization
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v3 11/27] x86/power/64: Adapt assembly for PIE support
Date: Thu, 24 May 2018 09:37:20 -0700
Message-ID: <CAJcbSZEnRhFDvYCG4ORH71LrcH2bAzOU5yF-oa9KkLpKo5UuSQ@mail.gmail.com>
References: <20180523195421.180248-1-thgarnie@google.com>
	<20180523195421.180248-12-thgarnie@google.com>
	<20180524110341.GB20225@amd>
Reply-To: Thomas Garnier <thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Petr Mladek <pmladek@suse.com>, Len Brown <len.brown@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Yonghong Song <yhs@fb.com>, Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Jan Beulich <JBeulich@suse.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christoph Lameter <cl@linux.com>, Alok Kataria <akataria@vmware.com>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Herbert Xu <herbert@gondor.
To: Pavel Machek <pavel@ucw.cz>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180524110341.GB20225@amd>
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

On Thu, May 24, 2018 at 4:04 AM Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2018-05-23 12:54:05, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for
the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extended the
> > KASLR randomization range below the -2G memory limit.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>

> Again, was this tested?

Hibernation was tested as much as I can with qemu and my dedicated machine.
Any specific test you think I should use?


> > diff --git a/arch/x86/power/hibernate_asm_64.S
b/arch/x86/power/hibernate_asm_64.S
> > index ce8da3a0412c..6fdd7bbc3c33 100644
> > --- a/arch/x86/power/hibernate_asm_64.S
> > +++ b/arch/x86/power/hibernate_asm_64.S
> > @@ -24,7 +24,7 @@
> >  #include <asm/frame.h>
> >
> >  ENTRY(swsusp_arch_suspend)
> > -     movq    $saved_context, %rax
> > +     leaq    saved_context(%rip), %rax
> >       movq    %rsp, pt_regs_sp(%rax)
> >       movq    %rbp, pt_regs_bp(%rax)
> >       movq    %rsi, pt_regs_si(%rax)
> > @@ -115,7 +115,7 @@ ENTRY(restore_registers)
> >       movq    %rax, %cr4;  # turn PGE back on
> >
> >       /* We don't restore %rax, it must be 0 anyway */
> > -     movq    $saved_context, %rax
> > +     leaq    saved_context(%rip), %rax
> >       movq    pt_regs_sp(%rax), %rsp
> >       movq    pt_regs_bp(%rax), %rbp
> >       movq    pt_regs_si(%rax), %rsi

> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Thomas
