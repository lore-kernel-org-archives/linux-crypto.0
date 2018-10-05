From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 0/9] patchable function pointers for pluggable crypto routines
Date: Fri, 5 Oct 2018 10:26:08 -0700
Message-ID: <CALCETrVxv1fHt6WE4ZpvVEwtfsKQ19gRrhhA40zwCXGMk+DTLQ@mail.gmail.com>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
 <20181005133705.GA4588@zx2c4.com> <CAKv+Gu-f4uKBF=gtFcNJEeoC2L4qShX0+3p7kVhjTn0tR+3Gng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-f4uKBF=gtFcNJEeoC2L4qShX0+3p7kVhjTn0tR+3Gng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 5, 2018 at 10:15 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 5 October 2018 at 15:37, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> ...
> > Therefore, I think this patch goes in exactly the wrong direction. I
> > mean, if you want to introduce dynamic patching as a means for making
> > the crypto API's dynamic dispatch stuff not as slow in a post-spectre
> > world, sure, go for it; that may very well be a good idea. But
> > presenting it as an alternative to Zinc very widely misses the point and
> > serves to prolong a series of bad design choices, which are now able to
> > be rectified by putting energy into Zinc instead.
> >
>
> This series has nothing to do with dynamic dispatch: the call sites
> call crypto functions using ordinary function calls (although my
> example uses CRC-T10DIF), and these calls are redirected via what is
> essentially a PLT entry, so that we can supsersede those routines at
> runtime.

If you really want to do it PLT-style, then just do:

extern void whatever_func(args);

Call it like:
whatever_func(args here);

And rig up something to emit asm like:

GLOBAL(whatever_func)
  jmpq default_whatever_func
ENDPROC(whatever_func)

Architectures without support can instead do:

void whatever_func(args)
{
  READ_ONCE(patchable_function_struct_for_whatever_func->ptr)(args);
}

and patch the asm function for basic support.  It will be slower than
necessary, but maybe the relocation trick could be used on top of this
to redirect the call to whatever_func directly to the target for
architectures that want to squeeze out the last bit of performance.
This might actually be the best of all worlds: easy implementation on
all architectures, no inline asm, and the totally non-magical version
works with okay performance.

(Is this what your code is doing?  I admit I didn't follow all the way
through all the macros.)
