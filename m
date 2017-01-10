From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 19:16:20 +0000
Message-ID: <CAKv+Gu8XVUXQrWCzgL6WRA=zY=5iTbbJ3Jp2kegCm0R7d6LwGA@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10 January 2017 at 19:00, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jan 10, 2017 at 9:30 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 10 January 2017 at 14:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> I recently applied the patch
>>>
>>>         https://patchwork.kernel.org/patch/9468391/
>>>
>>> and ended up with a boot crash when it tried to run the x86 chacha20
>>> code.  It turned out that the patch changed a manually aligned
>>> stack buffer to one that is aligned by gcc.  What was happening was
>>> that gcc can stack align to any value on x86-64 except 16.  The
>>> reason is that gcc assumes that the stack is always 16-byte aligned,
>>> which is not actually the case in the kernel.
>>>
>>
>> Apologies for introducing this breakage. It seemed like an obvious and
>> simple cleanup, so I didn't even bother to mention it in the commit
>> log, but if the kernel does not guarantee 16 byte alignment, I guess
>> we should revert to the old method. If SSE instructions are the only
>> ones that require this alignment, then I suppose not having a ABI
>> conforming stack pointer should not be an issue in general.
>
> Here's what I think is really going on.  This is partially from
> memory, so I could be off base.  The kernel is up against
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383, which means that,
> on some GCC versions (like the bad one and maybe even current ones),
> things compiled without -mno-sse can't have the stack alignment set
> properly.  IMO we should fix this in the affected code, not the entry
> code.  In fact, I think that fixing it in the entry code won't even
> fully fix it because modern GCC will compile the rest of the kernel
> with 8-byte alignment and the stack will get randomly unaligned (GCC
> 4.8 and newer).
>
> Can we just add __attribute__((force_align_arg_pointer)) to the
> affected functions?  Maybe have:
>
> #define __USES_SSE __attribute__((force_align_arg_pointer))
>
> on affected gcc versions?
>
> ***HOWEVER***
>
> I think this is missing the tree for the supposed forest.  The actual
> affected code appears to be:
>
> static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
>                          struct scatterlist *src, unsigned int nbytes)
> {
>         u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];
>
> ...
>
>         state = (u32 *)roundup((uintptr_t)state_buf, CHACHA20_STATE_ALIGN);
>
> gcc presumably infers (incorrectly) that state_buf is 16-byte aligned
> and optimizes out the roundup.  How about just declaring an actual
> __aligned(16) buffer, marking the function
> __attribute__((force_align_arg_pointer)), and being done with it?
> After all, we need that forcible alignment on *all* gcc versions.
>

Actually, the breakage is introduced by the patch Herbert refers to

https://patchwork.kernel.org/patch/9468391/

where the state is replaced by a simple

u32 state[16] __aligned(CHACHA20_STATE_ALIGN);

which seemed harmless enough to me. So the code above works fine.
