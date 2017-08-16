From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Wed, 16 Aug 2017 17:32:14 +0100
Message-ID: <CAKv+Gu96ZFRu7Qf0RRBMdPhBgBreTgCQ10PH5aOXG6+PrNM7Rw@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <1502900796.1302.52.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>
To: Daniel Micay <danielmicay@gmail.com>
Return-path: <kernel-hardening-return-9478-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1502900796.1302.52.camel@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On 16 August 2017 at 17:26, Daniel Micay <danielmicay@gmail.com> wrote:
>> How are these assumptions hardcoded by GCC? Most of the instructions
>> should be
>> relocatable straight away, as most call/jump/branch instructions are
>> RIP-relative.
>>
>> I.e. is there no GCC code generation mode where code can be placed
>> anywhere in the
>> canonical address space, yet call and jump distance is within 31 bits
>> so that the
>> generated code is fast?
>
> That's what PIE is meant to do. However, not disabling support for lazy
> linking (-fno-plt) / symbol interposition (-Bsymbolic) is going to cause
> it to add needless overhead.
>
> arm64 is using -pie -shared -Bsymbolic in arch/arm64/Makefile for their
> CONFIG_RELOCATABLE option. See 08cc55b2afd97a654f71b3bebf8bb0ec89fdc498.

The difference with arm64 is that its generic small code model is
already position independent, so we don't have to pass -fpic or -fpie
to the compiler. We only link in PIE mode to get the linker to emit
the dynamic relocation tables into the ELF binary. Relative branches
have a range of +/- 128 MB, which covers the kernel and modules
(unless the option to randomize the module region independently has
been selected, in which case branches between the kernel and modules
may be resolved via PLT entries that are emitted at module load time)

I am not sure how this extrapolates to x86, just adding some context.
