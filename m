From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Mon, 21 Aug 2017 15:32:22 +0200
Message-ID: <20170821133222.2ek6bhqgdeoymxsg@hirez.programming.kicks-ass.net>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Garnier <thgarnie@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
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
	Tejun Heo <tj@kernel.org>, Christoph Lameter
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9535-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170816151235.oamkdva6cwpc4cex@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 16, 2017 at 05:12:35PM +0200, Ingo Molnar wrote:
> Unfortunately mcmodel=large looks pretty heavy too AFAICS, at the machine 
> instruction level.
> 
> Function calls look like this:
> 
>  -mcmodel=medium:
> 
>    757:   e8 98 ff ff ff          callq  6f4 <test_code>
> 
>  -mcmodel=large
> 
>    77b:   48 b8 10 f7 df ff ff    movabs $0xffffffffffdff710,%rax
>    782:   ff ff ff 
>    785:   48 8d 04 03             lea    (%rbx,%rax,1),%rax
>    789:   ff d0                   callq  *%rax
> 
> And we'd do this for _EVERY_ function call in the kernel. That kind of crap is 
> totally unacceptable.

So why does this need to be computed for every single call? How often
will we move the kernel around at runtime?

Why can't we process the relocation at load time and then discard the
relocation tables along with the rest of __init ?
