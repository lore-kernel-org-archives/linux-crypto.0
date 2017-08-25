From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 25 Aug 2017 10:04:43 +0200
Message-ID: <20170825080443.tvvr6wzs362cjcuu@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
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
Return-path: <kernel-hardening-return-9560-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> With the fix for function tracing, the hackbench results have an
> average of +0.8 to +1.4% (from +8% to +10% before). With a default
> configuration, the numbers are closer to 0.8%.
> 
> On the .text size, with gcc 4.9 I see +0.8% on default configuration
> and +1.180% on the ubuntu configuration.

A 1% text size increase is still significant. Could you look at the disassembly, 
where does the size increase come from?

Thanks,

	Ingo
