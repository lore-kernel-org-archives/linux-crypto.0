From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Tue, 15 Aug 2017 09:56:09 +0200
Message-ID: <20170815075609.mmzbfwritjzvrpsn@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Tejun Heo <tj@kernel.org>, Christoph Lamete
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9438-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> > Do these changes get us closer to being able to build the kernel as truly 
> > position independent, i.e. to place it anywhere in the valid x86-64 address 
> > space? Or any other advantages?
> 
> Yes, PIE allows us to put the kernel anywhere in memory. It will allow us to 
> have a full randomized address space where position and order of sections are 
> completely random. There is still some work to get there but being able to build 
> a PIE kernel is a significant step.

So I _really_ dislike the whole PIE approach, because of the huge slowdown:

+config RANDOMIZE_BASE_LARGE
+       bool "Increase the randomization range of the kernel image"
+       depends on X86_64 && RANDOMIZE_BASE
+       select X86_PIE
+       select X86_MODULE_PLTS if MODULES
+       default n
+       ---help---
+         Build the kernel as a Position Independent Executable (PIE) and
+         increase the available randomization range from 1GB to 3GB.
+
+         This option impacts performance on kernel CPU intensive workloads up
+         to 10% due to PIE generated code. Impact on user-mode processes and
+         typical usage would be significantly less (0.50% when you build the
+         kernel).
+
+         The kernel and modules will generate slightly more assembly (1 to 2%
+         increase on the .text sections). The vmlinux binary will be
+         significantly smaller due to less relocations.

To put 10% kernel overhead into perspective: enabling this option wipes out about 
5-10 years worth of painstaking optimizations we've done to keep the kernel fast 
... (!!)

I think the fundamental flaw is the assumption that we need a PIE executable to 
have a freely relocatable kernel on 64-bit CPUs.

Have you considered a kernel with -mcmodel=small (or medium) instead of -fpie 
-mcmodel=large? We can pick a random 2GB window in the (non-kernel) canonical 
x86-64 address space to randomize the location of kernel text. The location of 
modules can be further randomized within that 2GB window.

It should have far less performance impact than the register-losing and 
overhead-inducing -fpie / -mcmodel=large (for modules) execution models.

My quick guess is tha the performance impact might be close to zero in fact.

Thanks,

	Ingo
