From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 19:30:39 -0800
Message-ID: <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com> <20170111031124.GA4515@gondor.apana.org.au>
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
In-Reply-To: <20170111031124.GA4515@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 7:11 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Well the only other alternative I see is to ban compilers which
> enforce 16-byte stack alignment, such as gcc 4.7.2.

No,  you don't have to ban the compiler - it's just a "generate overly
stupid code that just uses extra instructions to likely mis-align the
stack more" issue. So it's "stupid code generation" vs "buggy".

What we should ban is code that assumes that stack objects can be
aligned to more than word boundary.

__attribute__((align)) simply doesn't work on stack objects, because
the stack isn't aligned.

If you really want more stack alignment, you have to generate that
alignment yourself by hand (and have a bigger buffer that you do that
alignment inside).

So this was just simply buggy:

      u32 state[16] __aligned(CHACHA20_STATE_ALIGN);

because you just can't do that. It's that simple. There is a reason
why the code does the dance with

    u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];

    state = (u32 *)roundup((uintptr_t)state_buf, CHACHA20_STATE_ALIGN);

rather than ask the compiler to do something invalid.

                Linus
