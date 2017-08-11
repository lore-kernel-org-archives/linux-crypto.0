From: Thomas Garnier <thgarnie@google.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 11 Aug 2017 08:09:04 -0700
Message-ID: <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Christoph La
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9339-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170811124127.kkb5pnkljz4umxuj@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 11, 2017 at 5:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> Changes:
>>  - v2:
>>    - Add support for global stack cookie while compiler default to fs without
>>      mcmodel=kernel
>>    - Change patch 7 to correctly jump out of the identity mapping on kexec load
>>      preserve.
>>
>> These patches make the changes necessary to build the kernel as Position
>> Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
>> the top 2G of the virtual address space. It allows to optionally extend the
>> KASLR randomization range from 1G to 3G.
>
> So this:
>
>  61 files changed, 923 insertions(+), 299 deletions(-)
>
> ... is IMHO an _awful_ lot of churn and extra complexity in pretty fragile pieces
> of code, to gain what appears to be only ~1.5 more bits of randomization!

The range increase is a way to use PIE right away.

>
> Do these changes get us closer to being able to build the kernel as truly position
> independent, i.e. to place it anywhere in the valid x86-64 address space? Or any
> other advantages?

Yes, PIE allows us to put the kernel anywhere in memory. It will allow
us to have a full randomized address space where position and order of
sections are completely random. There is still some work to get there
but being able to build a PIE kernel is a significant step.

>
> Thanks,
>
>         Ingo



-- 
Thomas
