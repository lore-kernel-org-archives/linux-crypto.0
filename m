From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 22:21:07 -0800
Message-ID: <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au> <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 10:01 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jan 10, 2017 at 8:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Tue, Jan 10, 2017 at 08:17:17PM -0800, Linus Torvalds wrote:
>>>
>>> That said, I do think that the "don't assume stack alignment, do it by
>>> hand" may be the safer thing. Because who knows what the random rules
>>> will be on other architectures.
>>
>> Sure we can ban the use of attribute aligned on stacks.  But
>> what about indirect uses through structures?  For example, if
>> someone does
>>
>> struct foo {
>> } __attribute__ ((__aligned__(16)));
>>
>> int bar(...)
>> {
>>         struct foo f;
>>
>>         return baz(&f);
>> }
>>
>> then baz will end up with an unaligned argument.  The worst part
>> is that it is not at all obvious to the person writing the function
>> bar.
>
> Linus, I'm starting to lean toward agreeing with Herbert here, except
> that we should consider making it conditional on having a silly GCC
> version.  After all, the silly GCC versions are wasting space and time
> with alignment instructions no matter what we do, so this would just
> mean tweaking the asm and adding some kind of check_stack_alignment()
> helper to throw out a WARN_ONCE() if we miss one.  The problem with
> making it conditional is that making pt_regs effectively live at a
> variable offset from %rsp is just nasty.

So actually doing this is gross because we have calls from asm to C
all over the place.  But... maybe we can automate all the testing.
Josh, how hard would it be to teach objtool to (if requested by an
option) check that stack frames with statically known size preserve
16-byte stack alignment?

I find it rather annoying that gcc before 4.8 malfunctions when it
sees __aligned__(16) on x86_64 kernels.  Sigh.

--Andy
