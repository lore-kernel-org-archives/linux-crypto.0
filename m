From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v1 01/27] x86/crypto: Adapt assembly for PIE support
Date: Fri, 20 Oct 2017 07:48:57 -0700
Message-ID: <CAJcbSZEhkdy9S3qtN4jFaj2doQsp1ORyHiNmzncDb2+bRatXmw@mail.gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com> <20171011203027.11248-2-thgarnie@google.com>
 <20171020082420.lsvu7mqjrgnahm5t@gmail.com> <CAKv+Gu9XMnNA0UoGfFMQmC9=Ryh6dcOduxH+tq49bcdvBwhyQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
	Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.or
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <kernel-hardening-return-10211-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAKv+Gu9XMnNA0UoGfFMQmC9=Ryh6dcOduxH+tq49bcdvBwhyQw@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 20, 2017 at 1:28 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 20 October 2017 at 09:24, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Thomas Garnier <thgarnie@google.com> wrote:
>>
>>> Change the assembly code to use only relative references of symbols for the
>>> kernel to be PIE compatible.
>>>
>>> Position Independent Executable (PIE) support will allow to extended the
>>> KASLR randomization range below the -2G memory limit.
>>
>>> diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
>>> index 8739cf7795de..86fa068e5e81 100644
>>> --- a/arch/x86/crypto/aes-x86_64-asm_64.S
>>> +++ b/arch/x86/crypto/aes-x86_64-asm_64.S
>>> @@ -48,8 +48,12 @@
>>>  #define R10  %r10
>>>  #define R11  %r11
>>>
>>> +/* Hold global for PIE suport */
>>> +#define RBASE        %r12
>>> +
>>>  #define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
>>>       ENTRY(FUNC);                    \
>>> +     pushq   RBASE;                  \
>>>       movq    r1,r2;                  \
>>>       leaq    KEY+48(r8),r9;          \
>>>       movq    r10,r11;                \
>>> @@ -74,54 +78,63 @@
>>>       movl    r6 ## E,4(r9);          \
>>>       movl    r7 ## E,8(r9);          \
>>>       movl    r8 ## E,12(r9);         \
>>> +     popq    RBASE;                  \
>>>       ret;                            \
>>>       ENDPROC(FUNC);
>>>
>>> +#define round_mov(tab_off, reg_i, reg_o) \
>>> +     leaq    tab_off(%rip), RBASE; \
>>> +     movl    (RBASE,reg_i,4), reg_o;
>>> +
>>> +#define round_xor(tab_off, reg_i, reg_o) \
>>> +     leaq    tab_off(%rip), RBASE; \
>>> +     xorl    (RBASE,reg_i,4), reg_o;
>>> +
>>>  #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
>>>       movzbl  r2 ## H,r5 ## E;        \
>>>       movzbl  r2 ## L,r6 ## E;        \
>>> -     movl    TAB+1024(,r5,4),r5 ## E;\
>>> +     round_mov(TAB+1024, r5, r5 ## E)\
>>>       movw    r4 ## X,r2 ## X;        \
>>> -     movl    TAB(,r6,4),r6 ## E;     \
>>> +     round_mov(TAB, r6, r6 ## E)     \
>>>       roll    $16,r2 ## E;            \
>>>       shrl    $16,r4 ## E;            \
>>>       movzbl  r4 ## L,r7 ## E;        \
>>>       movzbl  r4 ## H,r4 ## E;        \
>>>       xorl    OFFSET(r8),ra ## E;     \
>>>       xorl    OFFSET+4(r8),rb ## E;   \
>>> -     xorl    TAB+3072(,r4,4),r5 ## E;\
>>> -     xorl    TAB+2048(,r7,4),r6 ## E;\
>>> +     round_xor(TAB+3072, r4, r5 ## E)\
>>> +     round_xor(TAB+2048, r7, r6 ## E)\
>>>       movzbl  r1 ## L,r7 ## E;        \
>>>       movzbl  r1 ## H,r4 ## E;        \
>>> -     movl    TAB+1024(,r4,4),r4 ## E;\
>>> +     round_mov(TAB+1024, r4, r4 ## E)\
>>>       movw    r3 ## X,r1 ## X;        \
>>>       roll    $16,r1 ## E;            \
>>>       shrl    $16,r3 ## E;            \
>>> -     xorl    TAB(,r7,4),r5 ## E;     \
>>> +     round_xor(TAB, r7, r5 ## E)     \
>>>       movzbl  r3 ## L,r7 ## E;        \
>>>       movzbl  r3 ## H,r3 ## E;        \
>>> -     xorl    TAB+3072(,r3,4),r4 ## E;\
>>> -     xorl    TAB+2048(,r7,4),r5 ## E;\
>>> +     round_xor(TAB+3072, r3, r4 ## E)\
>>> +     round_xor(TAB+2048, r7, r5 ## E)\
>>>       movzbl  r1 ## L,r7 ## E;        \
>>>       movzbl  r1 ## H,r3 ## E;        \
>>>       shrl    $16,r1 ## E;            \
>>> -     xorl    TAB+3072(,r3,4),r6 ## E;\
>>> -     movl    TAB+2048(,r7,4),r3 ## E;\
>>> +     round_xor(TAB+3072, r3, r6 ## E)\
>>> +     round_mov(TAB+2048, r7, r3 ## E)\
>>>       movzbl  r1 ## L,r7 ## E;        \
>>>       movzbl  r1 ## H,r1 ## E;        \
>>> -     xorl    TAB+1024(,r1,4),r6 ## E;\
>>> -     xorl    TAB(,r7,4),r3 ## E;     \
>>> +     round_xor(TAB+1024, r1, r6 ## E)\
>>> +     round_xor(TAB, r7, r3 ## E)     \
>>>       movzbl  r2 ## H,r1 ## E;        \
>>>       movzbl  r2 ## L,r7 ## E;        \
>>>       shrl    $16,r2 ## E;            \
>>> -     xorl    TAB+3072(,r1,4),r3 ## E;\
>>> -     xorl    TAB+2048(,r7,4),r4 ## E;\
>>> +     round_xor(TAB+3072, r1, r3 ## E)\
>>> +     round_xor(TAB+2048, r7, r4 ## E)\
>>>       movzbl  r2 ## H,r1 ## E;        \
>>>       movzbl  r2 ## L,r2 ## E;        \
>>>       xorl    OFFSET+8(r8),rc ## E;   \
>>>       xorl    OFFSET+12(r8),rd ## E;  \
>>> -     xorl    TAB+1024(,r1,4),r3 ## E;\
>>> -     xorl    TAB(,r2,4),r4 ## E;
>>> +     round_xor(TAB+1024, r1, r3 ## E)\
>>> +     round_xor(TAB, r2, r4 ## E)
>>
>> This appears to be adding unconditional overhead to a function that was moved to
>> assembly to improve its performance.
>>

It adds couple extra instructions, how much overhead it creates is
hard for me to tell. It would increase the code complexity if
everything is ifdef.

>
> I did some benchmarking on this code a while ago and, interestingly,
> it was slower than the generic C implementation (on a Pentium E2200),
> so we may want to consider whether we still need this driver in the
> first place.

Interesting.

-- 
Thomas
