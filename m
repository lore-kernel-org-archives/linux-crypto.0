From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Thu, 21 Sep 2017 17:59:19 +0200
Message-ID: <20170921155919.skpyt7dutod5ul4t@gmail.com>
References: <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
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
Return-path: <kernel-hardening-return-9906-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org


( Sorry about the delay in answering this. I could blame the delay on the merge 
  window, but in reality I've been procrastinating this is due to the permanent,
  non-trivial impact PIE has on generated C code. )

* Thomas Garnier <thgarnie@google.com> wrote:

> 1) PIE sometime needs two instructions to represent a single
> instruction on mcmodel=kernel.

What again is the typical frequency of this occurring in an x86-64 defconfig 
kernel, with the very latest GCC?

Also, to make sure: which unwinder did you use for your measurements, 
frame-pointers or ORC? Please use ORC only for future numbers, as
frame-pointers is obsolete from a performance measurement POV.

> 2) GCC does not optimize switches in PIE in order to reduce relocations:

Hopefully this can either be fixed in GCC or at least influenced via a compiler 
switch in the future.

> The switches are the biggest increase on small functions but I don't
> think they represent a large portion of the difference (number 1 is).

Ok.

> A side note, while testing gcc 7.2.0 on hackbench I have seen the PIE
> kernel being faster by 1% across multiple runs (comparing 50 runs done
> across 5 reboots twice). I don't think PIE is faster than a
> mcmodel=kernel but recent versions of gcc makes them fairly similar.

So I think we are down to an overhead range where the inherent noise (both random 
and systematic one) in 'hackbench' overwhelms the signal we are trying to measure.

So I think it's the kernel .text size change that is the best noise-free proxy for 
the overhead impact of PIE.

It doesn't hurt to double check actual real performance as well, just don't expect 
there to be much of a signal for anything but fully cached microbenchmark 
workloads.

Thanks,

	Ingo
