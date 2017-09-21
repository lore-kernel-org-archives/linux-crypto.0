From: Thomas Garnier <thgarnie@google.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Thu, 21 Sep 2017 14:16:43 -0700
Message-ID: <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
References: <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com> <20170921155919.skpyt7dutod5ul4t@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Christoph La
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9918-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170921155919.skpyt7dutod5ul4t@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 21, 2017 at 8:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
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

I am not sure what is the best way to measure that.

>
> Also, to make sure: which unwinder did you use for your measurements,
> frame-pointers or ORC? Please use ORC only for future numbers, as
> frame-pointers is obsolete from a performance measurement POV.

I used the default configuration which uses frame-pointer. I built all
the different binaries with ORC and I see an improvement in size:

On latest revision (just built and ran performance tests this week):

With framepointer: PIE .text is 0.837324% than baseline

With ORC: PIE .text is 0.814224% than baseline

Comparing baselines only, ORC is -2.849832% than frame-pointers.

>
>> 2) GCC does not optimize switches in PIE in order to reduce relocations:
>
> Hopefully this can either be fixed in GCC or at least influenced via a compiler
> switch in the future.
>
>> The switches are the biggest increase on small functions but I don't
>> think they represent a large portion of the difference (number 1 is).
>
> Ok.
>
>> A side note, while testing gcc 7.2.0 on hackbench I have seen the PIE
>> kernel being faster by 1% across multiple runs (comparing 50 runs done
>> across 5 reboots twice). I don't think PIE is faster than a
>> mcmodel=kernel but recent versions of gcc makes them fairly similar.
>
> So I think we are down to an overhead range where the inherent noise (both random
> and systematic one) in 'hackbench' overwhelms the signal we are trying to measure.
>
> So I think it's the kernel .text size change that is the best noise-free proxy for
> the overhead impact of PIE.

I agree but it might be hard to measure the exact impact. What is
acceptable and what is not?

>
> It doesn't hurt to double check actual real performance as well, just don't expect
> there to be much of a signal for anything but fully cached microbenchmark
> workloads.

That's aligned with what I see in the latest performance testing.
Performance is close enough that it is hard to get exact numbers (pie
is just a bit slower than baseline on hackench (~1%)).

>
> Thanks,
>
>         Ingo



-- 
Thomas
