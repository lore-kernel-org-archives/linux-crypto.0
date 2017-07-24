From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 21/22] x86/module: Add support for mcmodel large and PLTs
Date: Mon, 24 Jul 2017 09:32:58 -0700
Message-ID: <CAJcbSZF=gCLRzqAzPgb46CJ6YDibUK0bG0NsVsAqV6jOHzZskA@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-22-thgarnie@google.com>
 <c0bc2d98-d6eb-e3db-3799-2e28e9919f3d@zytor.com> <CAMzpN2j+Z27uudHXqqMhbk=s=pnk7LdA2FPkgmsdZzO3ysemsQ@mail.gmail.com>
 <CAJcbSZFphkF8bcodkcwpK-oi3D7GTQXyTkOLPkmtWSPLPkvB0Q@mail.gmail.com> <CAMzpN2jWTS8R5V6i5q=bq4NGW_svELw5bjgWTOX=Ow3ddWx-6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
	Christ
To: Brian Gerst <brgerst@gmail.com>
Return-path: <kernel-hardening-return-9115-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAMzpN2jWTS8R5V6i5q=bq4NGW_svELw5bjgWTOX=Ow3ddWx-6Q@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 10:34 AM, Brian Gerst <brgerst@gmail.com> wrote:
> On Wed, Jul 19, 2017 at 11:58 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> On Tue, Jul 18, 2017 at 8:59 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>> On Tue, Jul 18, 2017 at 9:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 07/18/17 15:33, Thomas Garnier wrote:
>>>>> With PIE support and KASLR extended range, the modules may be further
>>>>> away from the kernel than before breaking mcmodel=kernel expectations.
>>>>>
>>>>> Add an option to build modules with mcmodel=large. The modules generated
>>>>> code will make no assumptions on placement in memory.
>>>>>
>>>>> Despite this option, modules still expect kernel functions to be within
>>>>> 2G and generate relative calls. To solve this issue, the PLT arm64 code
>>>>> was adapted for x86_64. When a relative relocation go outside its range,
>>>>> a dynamic PLT entry is used to correctly jump to the destination.
>>>>
>>>> Why large as opposed to medium or medium-PIC?
>>>
>>> Or for that matter, why not small-PIC?  We aren't changing the size of
>>> the kernel to be larger than 2G text or data.  Small-PIC would still
>>> allow it to be placed anywhere in the address space, and would
>>> generate far better code.
>>
>> My understanding was that small=PIC and medium=PIC assume that the
>> module code is in the lower 2G of memory. I will do additional testing
>> on the modules to confirm that.
>
> That is only for small/medium absolute (non-PIC) code.  Think about
> userspace shared libraries.  They are not limited to being mapped in
> the lower 2G of the address space.

I built lkdtm with mcmodel=(kernel, small, medium & large).

Comparing the same instruction and its relocation in lkdtm
(lkdtm_register_cpoint).

On mcmodel=kernel:

     1b8:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        1bb: R_X86_64_32S       .rodata.str1.8+0x50

On mcmodel=small and mcmodel=medium:

     1b8:       bf 00 00 00 00          mov    $0x0,%edi
     1b9: R_X86_64_32        .rodata.str1.8+0x50

On mcmodel=large:

     235:       48 bf 00 00 00 00 00    movabs $0x0,%rdi
     23c:       00 00 00
                        237: R_X86_64_64        .rodata.str1.8+0x50

The kernel mcmodel extends the sign of the address. It assumes you are
in the top 2G of the address space. So the relocated pointer
0x8XXXXXXX becomes 0xFFFFFFFF8XXXXXXX.

The small and medium mcmodels assume the pointer is within the lower
part of the address space. The generate pointer has the 32-bit high
part to zero. You can only map the module between 0 and 0xFFFFFFFF.

The large mcmodel can handle a full 64-bit pointer.

That's why I use the large mcmodel on modules. I cannot use PIE due to
how the modules are linked.

>
> --
> Brian Gerst



-- 
Thomas
