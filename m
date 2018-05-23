From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 23/27] x86/modules: Adapt module loading for PIE support
Date: Wed, 23 May 2018 15:01:38 -0700
Message-ID: <CAJcbSZHPc2w7g8Q4UZV3sx=s6LVL_+dsomro7to6RNhd-4F4Ag@mail.gmail.com>
References: <20180523195421.180248-1-thgarnie@google.com> <20180523195421.180248-24-thgarnie@google.com>
 <168ebedb-7c27-d1f3-c2f9-223d44186a52@infradead.org>
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
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <kernel-hardening-return-13377-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <168ebedb-7c27-d1f3-c2f9-223d44186a52@infradead.org>
List-Id: linux-crypto.vger.kernel.org

On Wed, May 23, 2018 at 2:27 PM Randy Dunlap <rdunlap@infradead.org> wrote:

> Hi,

> (for several patches in this series:)
> The commit message is confusing.  See below.

Thanks for the edits, I will change the different commit messages.



> On 05/23/2018 12:54 PM, Thomas Garnier wrote:
> > Adapt module loading to support PIE relocations. Generate dynamic GOT if
> > a symbol requires it but no entry exist in the kernel GOT.

>                                      exists

> >
> > Position Independent Executable (PIE) support will allow to extended the

>                                                  will allow us to extend
the

> > KASLR randomization range below the -2G memory limit.

> Does that say "below th negative 2G memory limit"?
> I don't get it.

Yes, below 0xffffffff80000000 basically. I think I will just say that.



> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > ---
> >  arch/x86/Makefile               |   4 +
> >  arch/x86/include/asm/module.h   |  11 ++
> >  arch/x86/include/asm/sections.h |   4 +
> >  arch/x86/kernel/module.c        | 181 +++++++++++++++++++++++++++++++-
> >  arch/x86/kernel/module.lds      |   3 +
> >  5 files changed, 198 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/x86/kernel/module.lds


> Thanks,
> --
> ~Randy



-- 
Thomas
