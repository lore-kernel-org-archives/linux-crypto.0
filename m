From: Christopher Lameter <cl@linux.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Wed, 19 Jul 2017 09:08:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1707190906490.17764@nuc-kabylake>
References: <20170718223333.110371-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
    "David S . Miller" <davem@davemloft.net>,
    Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
    "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
    Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
    Matthias Kaehlcke <mka@chromium.org>,
    Boris Ostrovsky <boris.ostrovsky@oracle.com>,
    Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
    =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
    Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
    Borislav Petkov <bp@alien8.de>,
    "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
    Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
    Christian Borntraeger <borntraeger@de.ibm.com>,
    "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brow
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9036-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
List-Id: linux-crypto.vger.kernel.org

On Tue, 18 Jul 2017, Thomas Garnier wrote:

> Performance/Size impact:
> Hackbench (50% and 1600% loads):
>  - PIE enabled: 7% to 8% on half load, 10% on heavy load.
> slab_test (average of 10 runs):
>  - PIE enabled: 3% to 4%
> Kernbench (average of 10 Half and Optimal runs):
>  - PIE enabled: 5% to 6%
>
> Size of vmlinux (Ubuntu configuration):
>  File size:
>  - PIE disabled: 472928672 bytes (-0.000169% from baseline)
>  - PIE enabled: 216878461 bytes (-54.14% from baseline)

Maybe we need something like CONFIG_PARANOIA so that we can determine at
build time how much performance we want to sacrifice for performance?

Its going to be difficult to understand what all these hardening config
options do.
