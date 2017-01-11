From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 08:06:54 +0000
Message-ID: <CAKv+Gu9yAxLHM4anS0m+gyeNio=RLcG=VvtRDeO5YNnJBvW95A@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au> <CA+55aFw+Z_ieo6DzTVB6_-TvQ0jj60s=T0mvXfqkBVFdKFPw_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Lutomirski <luto@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw+Z_ieo6DzTVB6_-TvQ0jj60s=T0mvXfqkBVFdKFPw_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11 January 2017 at 06:53, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Jan 10, 2017 8:36 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:
>
>
> Sure we can ban the use of attribute aligned on stacks.  But
> what about indirect uses through structures?
>
>
> It should be pretty trivial to add a sparse warning for that, though.
>

Couldn't we update the __aligned(x) macro to emit 32 if arch == x86
and x == 16? All other cases should work just fine afaict
