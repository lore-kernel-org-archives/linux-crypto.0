From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 06/22] kvm: Adapt assembly for PIE support
Date: Wed, 19 Jul 2017 08:40:14 -0700
Message-ID: <CAJcbSZGqY=btU=+eWfgdhF0je0Yn_GxkymFHn+OV-1BuzgbRYw@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-7-thgarnie@google.com>
 <CAMzpN2gF7QxDbVG-6ad3Qarcn1N_JT5tit9CMvQL95LQGeZivA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Chris
To: Brian Gerst <brgerst@gmail.com>
Return-path: <kernel-hardening-return-9038-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAMzpN2gF7QxDbVG-6ad3Qarcn1N_JT5tit9CMvQL95LQGeZivA@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 7:49 PM, Brian Gerst <brgerst@gmail.com> wrote:
> On Tue, Jul 18, 2017 at 6:33 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> Change the assembly code to use only relative references of symbols for the
>> kernel to be PIE compatible. The new __ASM_GET_PTR_PRE macro is used to
>> get the address of a symbol on both 32 and 64-bit with PIE support.
>>
>> Position Independent Executable (PIE) support will allow to extended the
>> KASLR randomization range below the -2G memory limit.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 6 ++++--
>>  arch/x86/kernel/kvm.c           | 6 ++++--
>>  arch/x86/kvm/svm.c              | 4 ++--
>>  3 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 87ac4fba6d8e..3041201a3aeb 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1352,9 +1352,11 @@ asmlinkage void kvm_spurious_fault(void);
>>         ".pushsection .fixup, \"ax\" \n" \
>>         "667: \n\t" \
>>         cleanup_insn "\n\t"                   \
>> -       "cmpb $0, kvm_rebooting \n\t"         \
>> +       "cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t" \
>>         "jne 668b \n\t"                       \
>> -       __ASM_SIZE(push) " $666b \n\t"        \
>> +       __ASM_SIZE(push) "%%" _ASM_AX " \n\t"           \
>> +       __ASM_GET_PTR_PRE(666b) "%%" _ASM_AX "\n\t"     \
>> +       "xchg %%" _ASM_AX ", (%%" _ASM_SP ") \n\t"      \
>>         "call kvm_spurious_fault \n\t"        \
>>         ".popsection \n\t" \
>>         _ASM_EXTABLE(666b, 667b)
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 71c17a5be983..53b8ad162589 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -618,8 +618,10 @@ asm(
>>  ".global __raw_callee_save___kvm_vcpu_is_preempted;"
>>  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>>  "__raw_callee_save___kvm_vcpu_is_preempted:"
>> -"movq  __per_cpu_offset(,%rdi,8), %rax;"
>> -"cmpb  $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
>> +"leaq  __per_cpu_offset(%rip), %rax;"
>> +"movq  (%rax,%rdi,8), %rax;"
>> +"addq  " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rip), %rax;"
>
> This doesn't look right.  It's accessing a per-cpu variable.  The
> per-cpu section is an absolute, zero-based section and not subject to
> relocation.
>

PIE does not respect the zero-based section, it tries to have
everything relative. Patch 16/22 also adapt per-cpu to work with PIE
(while keeping the zero absolute design by default).

>> +"cmpb  $0, (%rax);
>>  "setne %al;"
>>  "ret;"
>>  ".popsection");
>
> --
> Brian Gerst



-- 
Thomas
