From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 22 Sep 2017 18:32:25 +0200
Message-ID: <20170922163225.bfrd5myl6d7deiim@gmail.com>
References: <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com>
 <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
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
Return-path: <kernel-hardening-return-9928-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> On Thu, Sep 21, 2017 at 8:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > ( Sorry about the delay in answering this. I could blame the delay on the merge
> >   window, but in reality I've been procrastinating this is due to the permanent,
> >   non-trivial impact PIE has on generated C code. )
> >
> > * Thomas Garnier <thgarnie@google.com> wrote:
> >
> >> 1) PIE sometime needs two instructions to represent a single
> >> instruction on mcmodel=kernel.
> >
> > What again is the typical frequency of this occurring in an x86-64 defconfig
> > kernel, with the very latest GCC?
> 
> I am not sure what is the best way to measure that.

If this is the dominant factor then 'sizeof vmlinux' ought to be enough:

> With ORC: PIE .text is 0.814224% than baseline

I.e. the overhead is +0.81% in both size and (roughly) in number of instructions 
executed.

BTW., I think things improved with ORC because with ORC we have RBP as an extra 
register and with PIE we lose RBX - so register pressure in code generation is 
lower.

Ok, I suspect we can try it, but my preconditions for merging it would be:

  1) Linus doesn't NAK it (obviously)
  2) we first implement the additional entropy bits that Linus suggested.

does this work for you?

Thanks,

	Ingo
