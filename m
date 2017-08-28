From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Sun, 27 Aug 2017 18:26:05 -0700
Message-ID: <728a9499-67e9-0828-bb7a-f9b441a220b5@zytor.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170821143117.22sekggxizt3mhze@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Matthias Kaehlcke <mka@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross
 <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
        Brian Gerst <brgerst@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.c
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9570-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170821143117.22sekggxizt3mhze@hirez.programming.kicks-ass.net>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 08/21/17 07:31, Peter Zijlstra wrote:
> On Tue, Aug 15, 2017 at 07:20:38AM -0700, Thomas Garnier wrote:
>> On Tue, Aug 15, 2017 at 12:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
> 
>>> Have you considered a kernel with -mcmodel=small (or medium) instead of -fpie
>>> -mcmodel=large? We can pick a random 2GB window in the (non-kernel) canonical
>>> x86-64 address space to randomize the location of kernel text. The location of
>>> modules can be further randomized within that 2GB window.
>>
>> -model=small/medium assume you are on the low 32-bit. It generates
>> instructions where the virtual addresses have the high 32-bit to be
>> zero.
> 
> That's a compiler fail, right? Because the SDM states that for "CALL
> rel32" the 32bit displacement is sign extended on x86_64.
> 

No.  It is about whether you can do something like:

	movl $variable, %eax		/* rax = &variable; */

or

	addl %ecx,variable(,%rsi,4)	/* variable[rsi] += ecx */
