From: Daniel Micay <danielmicay@gmail.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Wed, 16 Aug 2017 12:26:36 -0400
Message-ID: <1502900796.1302.52.camel@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com>
	 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
	 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
	 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
	 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
	 <20170816151235.oamkdva6cwpc4cex@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann
 <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky
 <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?=
 <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky
 <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav
 Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov"
 <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki"
 <rjw@rjwysocki.net>,  Len Brown <len.brown@intel.com>, Pavel Machek
 <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph La
To: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9477-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170816151235.oamkdva6cwpc4cex@gmail.com>
List-Id: linux-crypto.vger.kernel.org

> How are these assumptions hardcoded by GCC? Most of the instructions
> should be 
> relocatable straight away, as most call/jump/branch instructions are
> RIP-relative.
> 
> I.e. is there no GCC code generation mode where code can be placed
> anywhere in the 
> canonical address space, yet call and jump distance is within 31 bits
> so that the 
> generated code is fast?

That's what PIE is meant to do. However, not disabling support for lazy
linking (-fno-plt) / symbol interposition (-Bsymbolic) is going to cause
it to add needless overhead.

arm64 is using -pie -shared -Bsymbolic in arch/arm64/Makefile for their
CONFIG_RELOCATABLE option. See 08cc55b2afd97a654f71b3bebf8bb0ec89fdc498.
