From: Ingo Molnar <mingo@kernel.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 08:40:59 +0100
Message-ID: <20170112074059.GA30151@gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au>
 <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au>
 <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> I find it rather annoying that gcc before 4.8 malfunctions when it
> sees __aligned__(16) on x86_64 kernels.  Sigh.

Ran into this when writing silly FPU in-kernel testcases a couple of months ago...

Thanks,

	Ingo
