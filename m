From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 07/22] x86: relocate_kernel - Adapt assembly for PIE support
Date: Wed, 19 Jul 2017 16:23:23 -0700
Message-ID: <CAJcbSZGJEfJytN_2ukM3BnV2uSF7ymsc3uTtmJKybcd0hVm7Kw@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-8-thgarnie@google.com>
 <73652a62-579d-a28a-dc89-0ff8795f0f00@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>,
	Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Tejun Heo <tj@kernel.org>, Christo
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <kernel-hardening-return-9076-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <73652a62-579d-a28a-dc89-0ff8795f0f00@zytor.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 3:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/18/17 15:33, Thomas Garnier wrote:
>> Change the assembly code to use only relative references of symbols for the
>> kernel to be PIE compatible.
>>
>> Position Independent Executable (PIE) support will allow to extended the
>> KASLR randomization range below the -2G memory limit.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>>  arch/x86/kernel/relocate_kernel_64.S | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
>> index 98111b38ebfd..da817d1628ac 100644
>> --- a/arch/x86/kernel/relocate_kernel_64.S
>> +++ b/arch/x86/kernel/relocate_kernel_64.S
>> @@ -186,7 +186,7 @@ identity_mapped:
>>       movq    %rax, %cr3
>>       lea     PAGE_SIZE(%r8), %rsp
>>       call    swap_pages
>> -     movq    $virtual_mapped, %rax
>> +     leaq    virtual_mapped(%rip), %rax
>>       pushq   %rax
>>       ret
>>
>
> This is completely wrong.  The whole point is that %rip here is on an
> identity-mapped page, which means that its offset to the actual symbol
> is ill-defined.
>
> The use of pushq/ret to do an indirect jump is bizarre, though, instead of:
>
>         pushq %r8
>         ret
>
> one ought to simply do
>
>         jmpq *%r8
>
> I think the author of this code was confused by the fact that we have to
> use this construct to do a *far* jump.
>
> There are some other very bizarre constructs in this file, that I can
> only assume comes from clumsy porting from 32 bits, for example:
>
>         call 1f
> 1:
>         popq %r8
>         subq $(1b - relocate_kernel), %r8
>
> ... instead of the much simpler ...
>
>         leaq relocate_kernel(%rip), %r8
>
> With this value in %r8 anyway, you can simply do:
>
>         leaq (virtual_mapped - relocate_kernel)(%r8), %rax
>         jmpq *%rax
>

Thanks I will look into that.

> This patchset scares me.  There seems to be a lot of places where you
> have not been very aware of what is actually happening in the code, nor
> have done research about how the ABIs actually work and affect things.

There is a lot of assembly that needed to be change. It was easier to
understand parts that are directly exercised like boot or percpu.
That's why I value people's feedback and will improve the patchset.

Thanks!

>
> Sorry.
>
>         -hpa



-- 
Thomas
