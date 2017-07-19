From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 21/22] x86/module: Add support for mcmodel large and PLTs
Date: Tue, 18 Jul 2017 18:35:05 -0700
Message-ID: <c0bc2d98-d6eb-e3db-3799-2e28e9919f3d@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-22-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
To: Thomas Garnier <thgarnie@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Matthias Kaehlcke <mka@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross
 <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
Return-path: <kernel-hardening-return-9025-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170718223333.110371-22-thgarnie@google.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 07/18/17 15:33, Thomas Garnier wrote:
> With PIE support and KASLR extended range, the modules may be further
> away from the kernel than before breaking mcmodel=kernel expectations.
> 
> Add an option to build modules with mcmodel=large. The modules generated
> code will make no assumptions on placement in memory.
> 
> Despite this option, modules still expect kernel functions to be within
> 2G and generate relative calls. To solve this issue, the PLT arm64 code
> was adapted for x86_64. When a relative relocation go outside its range,
> a dynamic PLT entry is used to correctly jump to the destination.

Why large as opposed to medium or medium-PIC?

	-hpa
