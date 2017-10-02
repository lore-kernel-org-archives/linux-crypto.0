From: Thomas Garnier <thgarnie@google.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Mon, 2 Oct 2017 13:28:52 -0700
Message-ID: <CAJcbSZEOtx6PMhgmpwkLvcqSgZr1F41PgQRx3yGkZCjRWb8z-Q@mail.gmail.com>
References: <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com> <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
 <20170922163225.bfrd5myl6d7deiim@gmail.com> <CAJcbSZFbNACVrSQ7yFkDMs+4L56_4e73kvdesSdD5W4bdBoOpg@mail.gmail.com>
 <20170923094312.td3mrfos6konic6g@gmail.com>
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
Return-path: <kernel-hardening-return-9989-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170923094312.td3mrfos6konic6g@gmail.com>
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 23, 2017 at 2:43 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> >   2) we first implement the additional entropy bits that Linus suggested.
>> >
>> > does this work for you?
>>
>> Sure, I can look at how feasible that is. If it is, can I send
>> everything as part of the same patch set? The additional entropy would
>> be enabled for all KASLR but PIE will be off-by-default of course.
>
> Sure, can all be part of the same series.

I looked deeper in the change Linus proposed (moving the .text section
based on the cacheline). I think the complexity is too high for the
value of this change.

To move only the .text section would require at least the following changes:
 - Overall change on how relocations are processed, need to separate
relocations in and outside of the .text section.
 - Break assumptions on _text alignment while keeping calculation on
size accurate (for example _end - _text).

With a rough attempt at this, I managed to pass early boot and still
crash later on.

This change would be valuable if you leak the address of a section
other than .text and you want to know where .text is. Meaning the main
bug that you are trying to exploit only allow you to execute code (and
you are trying to ROP in .text). I would argue that a better
mitigation for this type of bugs is moving function pointer to
read-only sections and using stack cookies (for ret address). This
change won't prevent other type of attacks, like data corruption.

I think it would be more valuable to look at something like selfrando
/ pagerando [1] but maybe wait a bit for it to be more mature
(especially on the debugging side).

What do you think?

[1] http://lists.llvm.org/pipermail/llvm-dev/2017-June/113794.html

>
> Thanks,
>
>         Ingo



-- 
Thomas
