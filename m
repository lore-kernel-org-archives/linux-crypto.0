From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 20/22] x86/relocs: Add option to generate 64-bit relocations
Date: Wed, 19 Jul 2017 15:33:13 -0700
Message-ID: <e499e745-e276-a4c9-2cd6-0977ca025448@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-21-thgarnie@google.com>
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
Return-path: <kernel-hardening-return-9071-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170718223333.110371-21-thgarnie@google.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 07/18/17 15:33, Thomas Garnier wrote:
> The x86 relocation tool generates a list of 32-bit signed integers. There
> was no need to use 64-bit integers because all addresses where above the 2G
> top of the memory.
> 
> This change add a large-reloc option to generate 64-bit unsigned integers.
> It can be used when the kernel plan to go below the top 2G and 32-bit
> integers are not enough.

Why on Earth?  This would only be necessary if the *kernel itself* was
more than 2G, which isn't going to happen for the forseeable future.

	-hpa
