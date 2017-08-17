From: Boris Lukashev <blukashev@sempervictus.com>
Subject: Re: Re: x86: PIE support and option to extend
 KASLR randomization
Date: Thu, 17 Aug 2017 10:12:19 -0400
Message-ID: <CAFUG7CdUEFYANSGRuNX0Xt1TJ0Z7f+M_ERgR03dUVxVqLENLpw@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, T
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9501-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170817080920.5ljlkktngw2cisfg@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 17, 2017 at 4:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> > > -model=small/medium assume you are on the low 32-bit. It generates
>> > > instructions where the virtual addresses have the high 32-bit to be zero.
>> >
>> > How are these assumptions hardcoded by GCC? Most of the instructions should be
>> > relocatable straight away, as most call/jump/branch instructions are
>> > RIP-relative.
>>
>> I think PIE is capable to use relative instructions well. mcmodel=large assumes
>> symbols can be anywhere.
>
> So if the numbers in your changelog and Kconfig text cannot be trusted, there's
> this description of the size impact which I suspect is less susceptible to
> measurement error:
>
> +         The kernel and modules will generate slightly more assembly (1 to 2%
> +         increase on the .text sections). The vmlinux binary will be
> +         significantly smaller due to less relocations.
>
> ... but describing a 1-2% kernel text size increase as "slightly more assembly"
> shows a gratituous disregard to kernel code generation quality! In reality that's
> a huge size increase that in most cases will almost directly transfer to a 1-2%
> slowdown for kernel intense workloads.
>
> Where does that size increase come from, if PIE is capable of using relative
> instructins well? Does it come from the loss of a generic register and the
> resulting increase in register pressure, stack spills, etc.?
>
> So I'm still unhappy about this all, and about the attitude surrounding it.
>
> Thanks,
>
>         Ingo

Is the expectation then to have security functions also decrease size
and operational latency? Seems a bit unrealistic if so.
1-2% performance hit on systems which have become at least several
hundred % faster over recent years is not a significant performance
regression compared to the baseline before.
While nobody is saying that performance and size concerns are
irrelevant, the paradigm of leveraging single digit losses in
performance metrics as a reason to leave security functions out has
made Linux the equivalent of the broad side of the barn in security
terms.
If it has real-world benefit to the security posture of the system, it
should be a configurable option for users to decide if a percentage
point or two of op time is worth the mitigation/improvement provided
in security terms.

Separately, reading this thread i've noticed that people are using
different compiler versions in their efforts which makes any of these
sub 10% deltas moot - building a kernel with GCC4.9 vs 7.1 has more of
an impact, and not having all the same compiler flags available (like
the no PLT thing) flat out creates confusion. Shouldn't all of these
tests be executed on a standardized build config and toolchain?

Thanks,
-Boris
