From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 20:17:17 -0800
Message-ID: <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 7:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If you really want more stack alignment, you have to generate that
> alignment yourself by hand (and have a bigger buffer that you do that
> alignment inside).

Side note: gcc can (and does) actually generate forced alignment using
"and" instructions on %rsp rather than assuming pre-existing
alignment.  And that would be valid.

The problem with "alignof(16)" is not that gcc couldn't generate the
alignment itself, it's just the broken "it's already aligned to 16
bytes" assumption because -mpreferred-stack-boundary=3 doesn't work.

You *could* try to hack around it by forcing a 32-byte alignment
instead. That (I think) will make gcc generate the "and" instruction
mess.

And it shouldn't actually use any more memory than doing it by hand
(by having twice the alignment and hand-aligning the pointer).

So we *could* try to just have a really hacky rule saying that you can
align stack data to 8 or 32 bytes, but *not* to 16 bytes.

That said, I do think that the "don't assume stack alignment, do it by
hand" may be the safer thing. Because who knows what the random rules
will be on other architectures.

               Linus
