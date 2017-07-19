From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 20/22] x86/relocs: Add option to generate 64-bit relocations
Date: Wed, 19 Jul 2017 16:25:56 -0700
Message-ID: <CAJcbSZE0rVuzi0tQj6_vUu47GBKnHQM1N-Mom9PZHTG88z-noA@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-21-thgarnie@google.com>
 <e499e745-e276-a4c9-2cd6-0977ca025448@zytor.com> <CAJcbSZE3fQ5vgUm4648kwExY_-p7a3d+QdNQ8K8tbhZVhOHFtA@mail.gmail.com>
 <89b77a4a-ef77-f746-1ae5-79bfc0d12ab0@zytor.com>
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
Return-path: <kernel-hardening-return-9077-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <89b77a4a-ef77-f746-1ae5-79bfc0d12ab0@zytor.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 4:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/19/17 15:47, Thomas Garnier wrote:
>> On Wed, Jul 19, 2017 at 3:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 07/18/17 15:33, Thomas Garnier wrote:
>>>> The x86 relocation tool generates a list of 32-bit signed integers. There
>>>> was no need to use 64-bit integers because all addresses where above the 2G
>>>> top of the memory.
>>>>
>>>> This change add a large-reloc option to generate 64-bit unsigned integers.
>>>> It can be used when the kernel plan to go below the top 2G and 32-bit
>>>> integers are not enough.
>>>
>>> Why on Earth?  This would only be necessary if the *kernel itself* was
>>> more than 2G, which isn't going to happen for the forseeable future.
>>
>> Because the relocation integer is an absolute address, not an offset
>> in the binary. Next iteration, I can try using a 32-bit offset for
>> everyone.
>
> It is an absolute address *as the kernel was originally linked*, for
> obvious reasons.

Sure when the kernel was just above 0xffffffff80000000, it doesn't
work when it goes down to 0xffffffff00000000. That's why using an
offset might make more sense in general.

>
>         -hpa
>



-- 
Thomas.
