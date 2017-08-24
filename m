From: Thomas Garnier <thgarnie@google.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Thu, 24 Aug 2017 14:13:38 -0700
Message-ID: <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Christoph La
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9555-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 17, 2017 at 7:10 AM, Thomas Garnier <thgarnie@google.com> wrote:
>
> On Thu, Aug 17, 2017 at 1:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Thomas Garnier <thgarnie@google.com> wrote:
> >
> > > > > -model=small/medium assume you are on the low 32-bit. It generates
> > > > > instructions where the virtual addresses have the high 32-bit to be zero.
> > > >
> > > > How are these assumptions hardcoded by GCC? Most of the instructions should be
> > > > relocatable straight away, as most call/jump/branch instructions are
> > > > RIP-relative.
> > >
> > > I think PIE is capable to use relative instructions well. mcmodel=large assumes
> > > symbols can be anywhere.
> >
> > So if the numbers in your changelog and Kconfig text cannot be trusted, there's
> > this description of the size impact which I suspect is less susceptible to
> > measurement error:
> >
> > +         The kernel and modules will generate slightly more assembly (1 to 2%
> > +         increase on the .text sections). The vmlinux binary will be
> > +         significantly smaller due to less relocations.
> >
> > ... but describing a 1-2% kernel text size increase as "slightly more assembly"
> > shows a gratituous disregard to kernel code generation quality! In reality that's
> > a huge size increase that in most cases will almost directly transfer to a 1-2%
> > slowdown for kernel intense workloads.
> >
> >
> > Where does that size increase come from, if PIE is capable of using relative
> > instructins well? Does it come from the loss of a generic register and the
> > resulting increase in register pressure, stack spills, etc.?
>
> I will try to gather more information on the size increase. The size
> increase might be smaller with gcc 4.9 given performance was much
> better.

Coming back on this thread as I identified the root cause of the
performance issue.

My original performance testing was done with an Ubuntu generic
configuration. This configuration has the CONFIG_FUNCTION_TRACER
option which was incompatible with PIE. The tracer failed to replace
the __fentry__ call by a nop slide on each traceable function because
the instruction was not the one expected. If PIE is enabled, gcc
generates a difference call instruction based on the GOT without
checking the visibility options (basically call *__fentry__@GOTPCREL).

With the fix for function tracing, the hackbench results have an
average of +0.8 to +1.4% (from +8% to +10% before). With a default
configuration, the numbers are closer to 0.8%.

On the .text size, with gcc 4.9 I see +0.8% on default configuration
and +1.180% on the ubuntu configuration.

Next iteration should have an updated set of performance metrics (will
try to use gcc 6.0 or higher) and incorporate the fix on function
tracing.

Let me know if you have questions and feedback.

>
> >
> > So I'm still unhappy about this all, and about the attitude surrounding it.
> >
> > Thanks,
> >
> >         Ingo
>
>
>
>
> --
> Thomas




-- 
Thomas
