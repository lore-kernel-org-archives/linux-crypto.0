From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
Date: Wed, 2 Aug 2017 09:42:36 -0700
Message-ID: <CAJcbSZF5-gVg=Q6yAV2ymHo+SC6Go=vQHXMR0UTdKH2Jbe-s-g@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-17-thgarnie@google.com>
 <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
 <CAJcbSZFXrDZikh9P5M81ztkiMv7EhO4x0bzBdYE8RYC=HMZgqg@mail.gmail.com>
 <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com> <CAJcbSZHuOhMHW6OTyt7-vZkPLS3XRQ48gpkF-TyohXpDW+825w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Brian Gerst <brgerst@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Christo
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <kernel-hardening-return-9210-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJcbSZHuOhMHW6OTyt7-vZkPLS3XRQ48gpkF-TyohXpDW+825w@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 20, 2017 at 7:26 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Wed, Jul 19, 2017 at 4:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/19/17 11:26, Thomas Garnier wrote:
>>> On Tue, Jul 18, 2017 at 8:08 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>>> On Tue, Jul 18, 2017 at 6:33 PM, Thomas Garnier <thgarnie@google.com> wrote:
>>>>> Perpcu uses a clever design where the .percu ELF section has a virtual
>>>>> address of zero and the relocation code avoid relocating specific
>>>>> symbols. It makes the code simple and easily adaptable with or without
>>>>> SMP support.
>>>>>
>>>>> This design is incompatible with PIE because generated code always try to
>>>>> access the zero virtual address relative to the default mapping address.
>>>>> It becomes impossible when KASLR is configured to go below -2G. This
>>>>> patch solves this problem by removing the zero mapping and adapting the GS
>>>>> base to be relative to the expected address. These changes are done only
>>>>> when PIE is enabled. The original implementation is kept as-is
>>>>> by default.
>>>>
>>>> The reason the per-cpu section is zero-based on x86-64 is to
>>>> workaround GCC hardcoding the stack protector canary at %gs:40.  So
>>>> this patch is incompatible with CONFIG_STACK_PROTECTOR.
>>>
>>> Ok, that make sense. I don't want this feature to not work with
>>> CONFIG_CC_STACKPROTECTOR*. One way to fix that would be adding a GDT
>>> entry for gs so gs:40 points to the correct memory address and
>>> gs:[rip+XX] works correctly through the MSR.
>>
>> What are you talking about?  A GDT entry and the MSR do the same thing,
>> except that a GDT entry is limited to an offset of 0-0xffffffff (which
>> doesn't work for us, obviously.)
>>
>
> A GDT entry would allow gs:0x40 to be valid while all gs:[rip+XX]
> addresses uses the MSR.
>
> I didn't tested it but that was used on the RFG mitigation [1]. The fs
> segment register was used for both thread storage and shadow stack.
>
> [1] http://xlab.tencent.com/en/2016/11/02/return-flow-guard/
>

Small update on that.

I noticed that not only we have the problem of gs:0x40 not being
accessible. The compiler will default to the fs register if
mcmodel=kernel is not set.

On the next patch set, I am going to add support for
-mstack-protector-guard=global so a global variable can be used
instead of the segment register. Similar approach than ARM/ARM64.

Following this patch, I will work with gcc and llvm to add
-mstack-protector-reg=<segment register> support similar to PowerPC.
This way we can have gs used even without mcmodel=kernel. Once that's
an option, I can setup the GDT as described in the previous email
(similar to RFG).

Let me know what you think about this approach.

>>> Given the separate
>>> discussion on mcmodel, I am going first to check if we can move from
>>> PIE to PIC with a mcmodel=small or medium that would remove the percpu
>>> change requirement. I tried before without success but I understand
>>> better percpu and other components so maybe I can make it work.
>>
>>>> This is silly.  The right thing is for PIE is to be explicitly absolute,
>>>> without (%rip).  The use of (%rip) memory references for percpu is just
>>>> an optimization.
>>>
>>> I agree that it is odd but that's how the compiler generates code. I
>>> will re-explore PIC options with mcmodel=small or medium, as mentioned
>>> on other threads.
>>
>> Why should the way compiler generates code affect the way we do things
>> in assembly?
>>
>> That being said, the compiler now has support for generating this kind
>> of code explicitly via the __seg_gs pointer modifier.  That should let
>> us drop the __percpu_prefix and just use variables directly.  I suspect
>> we want to declare percpu variables as "volatile __seg_gs" to account
>> for the possibility of CPU switches.
>>
>> Older compilers won't be able to work with this, of course, but I think
>> that it is acceptable for those older compilers to not be able to
>> support PIE.
>>
>>         -hpa
>>
>
>
>
> --
> Thomas



-- 
Thomas
