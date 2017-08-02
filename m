From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
Date: Wed, 2 Aug 2017 11:05:38 -0700
Message-ID: <CAJcbSZH+v_Kr_WkjLvzkTOX7RLWkZB7yPqe2SPXnRvgP8PuGPA@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-17-thgarnie@google.com>
 <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
 <CAJcbSZFXrDZikh9P5M81ztkiMv7EhO4x0bzBdYE8RYC=HMZgqg@mail.gmail.com>
 <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com> <CAJcbSZHuOhMHW6OTyt7-vZkPLS3XRQ48gpkF-TyohXpDW+825w@mail.gmail.com>
 <CAJcbSZF5-gVg=Q6yAV2ymHo+SC6Go=vQHXMR0UTdKH2Jbe-s-g@mail.gmail.com> <CAGXu5jLhg5d0rxkfTGDjNxcsqd9BH8BSOPEOn=PBKx_dYeq8ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
To: Kees Cook <keescook@chromium.org>
Return-path: <kernel-hardening-return-9213-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jLhg5d0rxkfTGDjNxcsqd9BH8BSOPEOn=PBKx_dYeq8ow@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 2, 2017 at 9:56 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Aug 2, 2017 at 9:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> I noticed that not only we have the problem of gs:0x40 not being
>> accessible. The compiler will default to the fs register if
>> mcmodel=kernel is not set.
>>
>> On the next patch set, I am going to add support for
>> -mstack-protector-guard=global so a global variable can be used
>> instead of the segment register. Similar approach than ARM/ARM64.
>
> While this is probably understood, I have to point out that this would
> be a major regression for the stack protection on x86.

I agree, the optimal solution will be using updated gcc/clang.

>
>> Following this patch, I will work with gcc and llvm to add
>> -mstack-protector-reg=<segment register> support similar to PowerPC.
>> This way we can have gs used even without mcmodel=kernel. Once that's
>> an option, I can setup the GDT as described in the previous email
>> (similar to RFG).
>
> It would be much nicer if we could teach gcc about the percpu area
> instead. This would let us solve the global stack protector problem on
> the other architectures:
> http://www.openwall.com/lists/kernel-hardening/2017/06/27/6

Yes, while I am looking at gcc I will take a look at other
architecture to see if I can help there too.

>
> -Kees
>
> --
> Kees Cook
> Pixel Security



-- 
Thomas
