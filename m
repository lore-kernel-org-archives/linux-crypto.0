From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 10:20:45 -0800
Message-ID: <CALCETrW_+NT5b3ZqRKsJeoRvy5Y+nF1G9rPoiTvbVijyg_vzWg@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au> <CA+55aFw+Z_ieo6DzTVB6_-TvQ0jj60s=T0mvXfqkBVFdKFPw_Q@mail.gmail.com>
 <CAKv+Gu9yAxLHM4anS0m+gyeNio=RLcG=VvtRDeO5YNnJBvW95A@mail.gmail.com> <20170111080925.GA5341@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170111080925.GA5341@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 11, 2017 at 12:09 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 11, 2017 at 08:06:54AM +0000, Ard Biesheuvel wrote:
>>
>> Couldn't we update the __aligned(x) macro to emit 32 if arch == x86
>> and x == 16? All other cases should work just fine afaict
>
> Not everyone uses that macro.  You'd also need to add some checks
> to stop people from using the gcc __attribute__ directly.
>

You'd also have to audit things to make sure that __aligned__(16)
isn't being used for non-stack purposes.  After all, __aligned__(16)
in static data is fine, and it's also fine as a promise to GCC that
some object is 16-byte aligned.

--Andy
