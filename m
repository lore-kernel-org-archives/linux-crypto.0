From: Thomas Garnier <thgarnie@google.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 25 Aug 2017 08:35:49 -0700
Message-ID: <CAJcbSZH6ZSmua4FqbxVox3yZ9O1KDdYJ4+WYreRq6RHiH0DbWg@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com> <CA+55aFy4ZMSEFO48nZsvBX-Ymy-Zw+LN5duKDna_6A1idg2XUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun H
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <kernel-hardening-return-9564-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CA+55aFy4ZMSEFO48nZsvBX-Ymy-Zw+LN5duKDna_6A1idg2XUQ@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 24, 2017 at 2:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Aug 24, 2017 at 2:13 PM, Thomas Garnier <thgarnie@google.com> wrote:
> >
> > My original performance testing was done with an Ubuntu generic
> > configuration. This configuration has the CONFIG_FUNCTION_TRACER
> > option which was incompatible with PIE. The tracer failed to replace
> > the __fentry__ call by a nop slide on each traceable function because
> > the instruction was not the one expected. If PIE is enabled, gcc
> > generates a difference call instruction based on the GOT without
> > checking the visibility options (basically call *__fentry__@GOTPCREL).
>
> Gah.
>
> Don't we actually have *more* address bits for randomization at the
> low end, rather than getting rid of -mcmodel=kernel?

We have but I think we use most of it for potential modules and the
fixmap but it is not that big. The increase in range from 1G to 3G is
just an example and a way to ensure PIE work as expected. The long
term goal is being able to put the kernel where we want in memory,
randomizing the position and the order of almost all memory sections.

That would be valuable against BTB attack [1] for example where
randomization on the low 32-bit is ineffective.

[1] https://github.com/felixwilhelm/mario_baslr

>
> Has anybody looked at just moving kernel text by smaller values than
> the page size? Yeah, yeah, the kernel has several sections that need
> page alignment, but I think we could relocate normal text by just the
> cacheline size, and that sounds like it would give several bits of
> randomness with little downside.

I didn't look into it. There is value in it depending on performance
impact. I think both PIE and lower grain randomization would be
useful.

>
> Or has somebody already looked at it and I just missed it?
>
>                Linus




-- 
Thomas
