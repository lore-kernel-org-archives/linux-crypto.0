From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Sat, 23 Sep 2017 12:00:29 +0200
Message-ID: <20170923100029.6nzpui6c3ke76bbs@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <20170821133222.2ek6bhqgdeoymxsg@hirez.programming.kicks-ass.net>
 <20170821142854.dmuusnbc2tsrai3v@hirez.programming.kicks-ass.net>
 <c830ba59-65d3-187f-3868-732059269f28@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
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
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Tejun Heo <tj@kernel.org>, Christoph La
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <kernel-hardening-return-9945-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <c830ba59-65d3-187f-3868-732059269f28@zytor.com>
List-Id: linux-crypto.vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> We do need to consider how we want modules to fit into whatever model we
> choose, though.  They can be adjacent, or we could go with a more
> traditional dynamic link model where the modules can be separate, and
> chained together with the main kernel via the GOT.

So I believe we should start with 'adjacent'. The thing is, having modules 
separately randomized mostly helps if any of the secret locations fails and
we want to prevent hopping from one to the other. But if one the kernel-privileged
secret location fails then KASLR has already failed to a significant degree...

So I think the large-PIC model for modules does not buy us any real advantages in 
practice, and the disadvantages of large-PIC are real and most Linux users have to 
pay that cost unconditionally, as distro kernels have half of their kernel 
functionality living in modules.

But I do see fundamental value in being able to hide the kernel somewhere in a ~48 
bits address space, especially if we also implement Linus's suggestion to utilize 
the lower bits as well. 0..281474976710656 is a nicely large range and will get 
larger with time.

But it should all be done smartly and carefully:

For example, there would be collision with regular user-space mappings, right?
Can local unprivileged users use mmap(MAP_FIXED) probing to figure out where
the kernel lives?

Thanks,

	Ingo
