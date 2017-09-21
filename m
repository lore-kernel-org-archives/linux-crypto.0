From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Thu, 21 Sep 2017 09:10:55 -0700
Message-ID: <CAKv+Gu8Uw18pW9nK8aVdBoyuybAV6_mhtagVrje_cBUHMGY4WA@mail.gmail.com>
References: <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com> <20170921155919.skpyt7dutod5ul4t@gmail.com>
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
Return-path: <kernel-hardening-return-9908-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170921155919.skpyt7dutod5ul4t@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On 21 September 2017 at 08:59, Ingo Molnar <mingo@kernel.org> wrote:
>
> ( Sorry about the delay in answering this. I could blame the delay on the merge
>   window, but in reality I've been procrastinating this is due to the permanent,
>   non-trivial impact PIE has on generated C code. )
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> 1) PIE sometime needs two instructions to represent a single
>> instruction on mcmodel=kernel.
>
> What again is the typical frequency of this occurring in an x86-64 defconfig
> kernel, with the very latest GCC?
>
> Also, to make sure: which unwinder did you use for your measurements,
> frame-pointers or ORC? Please use ORC only for future numbers, as
> frame-pointers is obsolete from a performance measurement POV.
>
>> 2) GCC does not optimize switches in PIE in order to reduce relocations:
>
> Hopefully this can either be fixed in GCC or at least influenced via a compiler
> switch in the future.
>

There are somewhat related concerns in the ARM world, so it would be
good if we could work with the GCC developers to get a more high level
and arch neutral command line option (-mkernel-pie? sounds yummy!)
that stops the compiler from making inferences that only hold for
shared libraries and/or other hosted executables (GOT indirections,
avoiding text relocations etc). That way, we will also be able to drop
the 'hidden' visibility override at some point, which we currently
need to prevent the compiler from redirecting all global symbol
references via entries in the GOT.

All we really need is the ability to move the image around in virtual
memory, and things like reducing the CoW footprint or enabling ELF
symbol preemption are completely irrelevant for us.
