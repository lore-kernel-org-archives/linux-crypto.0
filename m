From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
Date: Tue, 18 Jul 2017 23:08:34 -0400
Message-ID: <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-17-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Chris
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9027-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170718223333.110371-17-thgarnie@google.com>
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 6:33 PM, Thomas Garnier <thgarnie@google.com> wrote:
> Perpcu uses a clever design where the .percu ELF section has a virtual
> address of zero and the relocation code avoid relocating specific
> symbols. It makes the code simple and easily adaptable with or without
> SMP support.
>
> This design is incompatible with PIE because generated code always try to
> access the zero virtual address relative to the default mapping address.
> It becomes impossible when KASLR is configured to go below -2G. This
> patch solves this problem by removing the zero mapping and adapting the GS
> base to be relative to the expected address. These changes are done only
> when PIE is enabled. The original implementation is kept as-is
> by default.

The reason the per-cpu section is zero-based on x86-64 is to
workaround GCC hardcoding the stack protector canary at %gs:40.  So
this patch is incompatible with CONFIG_STACK_PROTECTOR.

--
Brian Gerst
