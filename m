From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/9] patchable function pointers for pluggable crypto routines
Date: Fri, 5 Oct 2018 19:15:13 +0200
Message-ID: <CAKv+Gu-f4uKBF=gtFcNJEeoC2L4qShX0+3p7kVhjTn0tR+3Gng@mail.gmail.com>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org> <20181005133705.GA4588@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richa
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005133705.GA4588@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5 October 2018 at 15:37, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
...
> Therefore, I think this patch goes in exactly the wrong direction. I
> mean, if you want to introduce dynamic patching as a means for making
> the crypto API's dynamic dispatch stuff not as slow in a post-spectre
> world, sure, go for it; that may very well be a good idea. But
> presenting it as an alternative to Zinc very widely misses the point and
> serves to prolong a series of bad design choices, which are now able to
> be rectified by putting energy into Zinc instead.
>

This series has nothing to do with dynamic dispatch: the call sites
call crypto functions using ordinary function calls (although my
example uses CRC-T10DIF), and these calls are redirected via what is
essentially a PLT entry, so that we can supsersede those routines at
runtime.
