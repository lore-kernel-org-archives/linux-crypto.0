From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Wed, 11 Jan 2017 11:26:22 +0800
Message-ID: <20170111032622.GD4515@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <CALCETrWGihhtbdkKcSD0kBrx-fWxM_TyUOUafvhsKMYXq5yEEQ@mail.gmail.com>
 <CAKv+Gu8XVUXQrWCzgL6WRA=zY=5iTbbJ3Jp2kegCm0R7d6LwGA@mail.gmail.com>
 <CALCETrW7mXxntZBTTHOgvaRLV4=9hcsNoTKM3o2O5Jod_6RR6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW7mXxntZBTTHOgvaRLV4=9hcsNoTKM3o2O5Jod_6RR6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 11:22:15AM -0800, Andy Lutomirski wrote:
>
> > Actually, the breakage is introduced by the patch Herbert refers to
> >
> > https://patchwork.kernel.org/patch/9468391/
> >
> > where the state is replaced by a simple
> >
> > u32 state[16] __aligned(CHACHA20_STATE_ALIGN);
> >
> > which seemed harmless enough to me. So the code above works fine.
> 
> So how about just the one-line patch of adding the
> force_align_arg_pointer?  Would that solve the problem?

It probably does.  However, this is too error-prone.  Surely
you can't expect random kernel developers to know to add this
force_align_arg_pointer every time they try to align a stack
variable to 16 bytes?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
