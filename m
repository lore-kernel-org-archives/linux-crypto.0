From: Christopher Lameter <cl@linux.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Wed, 16 Aug 2017 11:09:27 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1708161106370.11379@nuc-kabylake>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com> <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com> <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Thomas Garnier <thgarnie@google.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David S . Miller" <davem@davemloft.net>,
    Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
    "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
    Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
    Matthias Kaehlcke <mka@chromium.org>,
    Boris Ostrovsky <boris.ostrovsky@oracle.com>,
    Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
    =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
    Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
    Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
    Brian Gerst <brgerst@gmail.com>,
    "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
    "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9476-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170816151235.oamkdva6cwpc4cex@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, 16 Aug 2017, Ingo Molnar wrote:

> And we'd do this for _EVERY_ function call in the kernel. That kind of crap is
> totally unacceptable.

Ahh finally a limit is in sight as to how much security hardening etc can
reduce kernel performance.
