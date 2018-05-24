From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 09/27] x86/acpi: Adapt assembly for PIE support
Date: Thu, 24 May 2018 09:35:42 -0700
Message-ID: <CAJcbSZFJ84+VC5xDQZGHctupdqwmMBgqzLzFRqCTBpi5t-2Gvw@mail.gmail.com>
References: <20180523195421.180248-1-thgarnie@google.com> <20180523195421.180248-10-thgarnie@google.com>
 <20180524110306.GA20225@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>,
	Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
	Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Juergen Gross <jgros
To: Pavel Machek <pavel@ucw.cz>
Return-path: <kernel-hardening-return-13386-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180524110306.GA20225@amd>
List-Id: linux-crypto.vger.kernel.org

On Thu, May 24, 2018 at 4:03 AM Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2018-05-23 12:54:03, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for
the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extended the
> > KASLR randomization range below the -2G memory limit.

> What testing did this get?

Tested boot, hibernation and performance on qemu and dedicated machine.


> > diff --git a/arch/x86/kernel/acpi/wakeup_64.S
b/arch/x86/kernel/acpi/wakeup_64.S
> > index 50b8ed0317a3..472659c0f811 100644
> > --- a/arch/x86/kernel/acpi/wakeup_64.S
> > +++ b/arch/x86/kernel/acpi/wakeup_64.S
> > @@ -14,7 +14,7 @@
> >        * Hooray, we are in Long 64-bit mode (but still running in low
memory)
> >        */
> >  ENTRY(wakeup_long64)
> > -     movq    saved_magic, %rax
> > +     movq    saved_magic(%rip), %rax
> >       movq    $0x123456789abcdef0, %rdx
> >       cmpq    %rdx, %rax
> >       jne     bogus_64_magic

> Because, as comment says, this is rather tricky code.

I agree, I think maintainers feedback is very important for this patchset.


Pavel

> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Thomas
