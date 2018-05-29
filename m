From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 09/27] x86/acpi: Adapt assembly for PIE support
Date: Tue, 29 May 2018 08:55:34 -0700
Message-ID: <CAJcbSZHuR8AJVU2mENi9KD7j=dWL4PqEUUgUc880X7Nizvkjbg@mail.gmail.com>
References: <20180523195421.180248-1-thgarnie@google.com> <20180523195421.180248-10-thgarnie@google.com>
 <20180524110306.GA20225@amd> <CAJcbSZFJ84+VC5xDQZGHctupdqwmMBgqzLzFRqCTBpi5t-2Gvw@mail.gmail.com>
 <20180525091447.GC9666@amd> <CAJcbSZH17D01Stk4vRKKzjW6dxvK8x+S9sWL6vUopSP9=-x7Nw@mail.gmail.com>
 <20180529123114.GB21399@amd>
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
Return-path: <kernel-hardening-return-13428-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180529123114.GB21399@amd>
List-Id: linux-crypto.vger.kernel.org

On Tue, May 29, 2018 at 5:31 AM Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2018-05-25 10:00:04, Thomas Garnier wrote:
> > On Fri, May 25, 2018 at 2:14 AM Pavel Machek <pavel@ucw.cz> wrote:
> >
> > > On Thu 2018-05-24 09:35:42, Thomas Garnier wrote:
> > > > On Thu, May 24, 2018 at 4:03 AM Pavel Machek <pavel@ucw.cz> wrote:
> > > >
> > > > > On Wed 2018-05-23 12:54:03, Thomas Garnier wrote:
> > > > > > Change the assembly code to use only relative references of
symbols
> > for
> > > > the
> > > > > > kernel to be PIE compatible.
> > > > > >
> > > > > > Position Independent Executable (PIE) support will allow to
> > extended the
> > > > > > KASLR randomization range below the -2G memory limit.
> > > >
> > > > > What testing did this get?
> > > >
> > > > Tested boot, hibernation and performance on qemu and dedicated
machine.
> >
> > > Well, this is suspend, not hibernation code.
> >
> > > So "sudo pm-suspend" or "echo mem > /sys/power/state" would be good
> > > way to test this.
> >
> > Thanks, it worked. I added this to the testsuite I use for KASLR.

> Thanks!

> You can add my Acked-by:.

Will do. Thanks for the review.


>                                                                  Pavel

> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Thomas
