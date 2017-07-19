From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 06/22] kvm: Adapt assembly for PIE support
Date: Wed, 19 Jul 2017 15:27:20 -0700
Message-ID: <0cdd02e1-8bf2-41cd-f085-c338c2fd8e25@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-7-thgarnie@google.com>
 <CAMzpN2gF7QxDbVG-6ad3Qarcn1N_JT5tit9CMvQL95LQGeZivA@mail.gmail.com>
 <CAJcbSZGqY=btU=+eWfgdhF0je0Yn_GxkymFHn+OV-1BuzgbRYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
        Borislav Petkov <bp@suse.de>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.
To: Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>
Return-path: <kernel-hardening-return-9070-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJcbSZGqY=btU=+eWfgdhF0je0Yn_GxkymFHn+OV-1BuzgbRYw@mail.gmail.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 07/19/17 08:40, Thomas Garnier wrote:
>>
>> This doesn't look right.  It's accessing a per-cpu variable.  The
>> per-cpu section is an absolute, zero-based section and not subject to
>> relocation.
> 
> PIE does not respect the zero-based section, it tries to have
> everything relative. Patch 16/22 also adapt per-cpu to work with PIE
> (while keeping the zero absolute design by default).
> 

This is silly.  The right thing is for PIE is to be explicitly absolute,
without (%rip).  The use of (%rip) memory references for percpu is just
an optimization.

	-hpa
