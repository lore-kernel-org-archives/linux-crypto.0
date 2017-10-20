From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 20 Oct 2017 10:13:20 +0200
Message-ID: <20171020081320.h5hsp46m7rgocusm@gmail.com>
References: <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <20170821133222.2ek6bhqgdeoymxsg@hirez.programming.kicks-ass.net>
 <20170821142854.dmuusnbc2tsrai3v@hirez.programming.kicks-ass.net>
 <c830ba59-65d3-187f-3868-732059269f28@zytor.com>
 <20170923100029.6nzpui6c3ke76bbs@gmail.com>
 <20170924223708.GA12616@amd>
 <20170925073342.2yoghmanhx6c75ho@gmail.com>
 <20171006103933.GA9497@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Thomas Garnier <thgarnie@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
	Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>,
	Christo
To: Pavel Machek <pavel@ucw.cz>
Return-path: <kernel-hardening-return-10206-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <20171006103933.GA9497@amd>
List-Id: linux-crypto.vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2017-09-25 09:33:42, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > For example, there would be collision with regular user-space mappings, right? 
> > > > Can local unprivileged users use mmap(MAP_FIXED) probing to figure out where 
> > > > the kernel lives?
> > > 
> > > Local unpriviledged users can probably get your secret bits using cache probing 
> > > and jump prediction buffers.
> > > 
> > > Yes, you don't want to leak the information using mmap(MAP_FIXED), but CPU will 
> > > leak it for you, anyway.
> > 
> > Depends on the CPU I think, and CPU vendors are busy trying to mitigate this 
> > angle.
> 
> I believe any x86 CPU running Linux will leak it. And with CPU vendors
> putting "artifical inteligence" into branch prediction, no, I don't
> think it is going to get better.
> 
> That does not mean we shoudl not prevent mmap() info leak, but...

That might or might not be so, but there's a world of a difference between
running a relatively long statistical attack figuring out the kernel's
location, versus being able to programmatically probe the kernel's location
by using large MAP_FIXED user-space mmap()s, within a few dozen microseconds
or so and a 100% guaranteed, non-statistical result.

Thanks,

	Ingo
