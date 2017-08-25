From: Christopher Lameter <cl@linux.com>
Subject: Re: Re: x86: PIE support and option to extend
 KASLR randomization
Date: Fri, 25 Aug 2017 10:38:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1708251036150.5830@nuc-kabylake>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com> <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com> <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com> <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAFUG7CdUEFYANSGRuNX0Xt1TJ0Z7f+M_ERgR03dUVxVqLENLpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>,
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
    "Rafael J . Wysocki"
To: Boris Lukashev <blukashev@sempervictus.com>
Return-path: <kernel-hardening-return-9565-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAFUG7CdUEFYANSGRuNX0Xt1TJ0Z7f+M_ERgR03dUVxVqLENLpw@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org



On Thu, 17 Aug 2017, Boris Lukashev wrote:

> Is the expectation then to have security functions also decrease size
> and operational latency? Seems a bit unrealistic if so.
> 1-2% performance hit on systems which have become at least several
> hundred % faster over recent years is not a significant performance
> regression compared to the baseline before.

Where do you get these fantastic numbers? Where can I buy a system like
that? Commonly we see regressions with single threaded integer
performance on most newer processor generations.

These hundreds of percent improvement can only come from floating point
performance using specialized instructions. There are only a very limited
number of applications that can make use of it.
