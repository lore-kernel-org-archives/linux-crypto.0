From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Sat, 23 Sep 2017 11:49:59 +0200
Message-ID: <20170923094959.hfzx7fzrdyj47vdn@gmail.com>
References: <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com>
 <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
 <20170922163225.bfrd5myl6d7deiim@gmail.com>
 <b65e912f-eeb3-5f1e-bb4a-2dffc0b6481e@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Garnier <thgarnie@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
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
	Tejun Heo <tj@kernel.org>, Christoph La
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <kernel-hardening-return-9944-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <b65e912f-eeb3-5f1e-bb4a-2dffc0b6481e@zytor.com>
List-Id: linux-crypto.vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/22/17 09:32, Ingo Molnar wrote:
> > 
> > BTW., I think things improved with ORC because with ORC we have RBP as an extra 
> > register and with PIE we lose RBX - so register pressure in code generation is 
> > lower.
> > 
> 
> We lose EBX on 32 bits, but we don't lose RBX on 64 bits - since x86-64
> has RIP-relative addressing there is no need for a dedicated PIC register.

Indeed, but we'd use a new register _a lot_ for constructs, transforming:

  mov    r9,QWORD PTR [r11*8-0x7e3da060] (8 bytes)

into:

  lea    rbx,[rip+<off>] (7 bytes)
  mov    r9,QWORD PTR [rbx+r11*8] (6 bytes)

... which I suppose is quite close to (but not the same as) 'losing' RBX.

Of course the compiler can pick other registers as well, not that it matters much 
to register pressure in larger functions in the end. Plus if the compiler has to 
pick a callee-saved register there's the additional saving/restoring overhead of 
that as well.

Right?

> I'm somewhat confused how we can have as much as almost 1% overhead.  I suspect 
> that we end up making a GOT and maybe even a PLT for no good reason.

So the above transformation alone would explain a good chunk of the overhead I 
think.

Thanks,

	Ingo
