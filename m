From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v4 0/8] crypto: aes - retire table based generic AES
Date: Mon, 24 Jul 2017 09:57:18 -0700
Message-ID: <20170724165718.GA143373@gmail.com>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu8tzQOcehEtTu2nJVXRxxSNe5==-stKKkGjCzmvweNX1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "nico@linaro.org" <nico@linaro.org>,
        Eric Biggers <ebiggers@google.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36223 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753624AbdGXQ5W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 12:57:22 -0400
Received: by mail-pf0-f194.google.com with SMTP id 1so2834669pfi.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 09:57:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8tzQOcehEtTu2nJVXRxxSNe5==-stKKkGjCzmvweNX1Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 24, 2017 at 07:59:43AM +0100, Ard Biesheuvel wrote:
> On 18 July 2017 at 13:06, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > The generic AES driver uses 16 lookup tables of 1 KB each, and has
> > encryption and decryption routines that are fully unrolled. Given how
> > the dependencies between this code and other drivers are declared in
> > Kconfig files, this code is always pulled into the core kernel, even
> > if it is usually superseded at runtime by accelerated drivers that
> > exist for many architectures.
> >
> > This leaves us with 25 KB of dead code in the kernel, which is negligible
> > in typical environments, but which is actually a big deal for the IoT
> > domain, where every kilobyte counts.
> >
> > Also, the scalar, table based AES routines that exist for ARM, arm64, i586
> > and x86_64 share the lookup tables with AES generic, and may be invoked
> > occasionally when the time-invariant AES-NI or other special instruction
> > drivers are called in interrupt context, at which time the SIMD register
> > file cannot be used. Pulling 16 KB of code and 9 KB of instructions into
> > the L1s (and evicting what was already there) when a softirq happens to
> > be handled in the context of an interrupt taken from kernel mode (which
> > means no SIMD on x86) is also something that we may like to avoid, by
> > falling back to a much smaller and moderately less performant driver.
> > (Note that arm64 will be updated shortly to supply fallbacks for all
> > SIMD based AES implementations, which will be based on the core routines)
> >
> > For the reasons above, this series refactors the way the various AES
> > implementations are wired up, to allow the generic version in
> > crypto/aes_generic.c to be omitted from the build entirely.
> >
> > Patch #1 removes some bogus 'select CRYPTO_AES' statement.
> >
> > Patch #2 factors out aes-generic's lookup tables, which are shared with
> > arch-specific implementations in arch/x86, arch/arm and arch/arm64.
> >
> > Patch #3 replaces the table based aes-generic.o with a new aes.o based on
> > the fixed time cipher, and uses it to fulfil dependencies on CRYPTO_AES.
> >
> > Patch #4 switches the fallback in the AES-NI code to the new, generic encrypt
> > and decrypt routines so it no longer depends on the x86 scalar code or
> > [transitively] on AES-generic.
> >
> > Patch #5 tweaks the ARM table based code to only use 2 KB + 256 bytes worth
> > of lookup tables instead of 4 KB.
> >
> > Patch #6 does the same for arm64
> >
> > Patch #7 removes the local copy of the AES sboxes from the arm64 NEON driver,
> > and switches to the ones exposed by the new AES core module instead.
> >
> > Patch #8 updates the Kconfig help text to be more descriptive of what they
> > actually control, rather than duplicating AES's wikipedia entry a number of
> > times.
> >
> > v4: - remove aes-generic altogether instead of allow a preference to be set
> 
> Actually, after benchmarking the x86_64 asm AES code, I am not so sure
> we should remove AES_GENERIC at all, since it turns out to be faster.
> Interestingly, I found a remark by Eric in the git log stating the
> same, so if we want to cut down on AES variants, we should probably
> start by deleting the x86 code instead.
> 
> So please disregard this for now: I will rework the other stuff I have
> so it no longer depends on this, and repost, because it is much more
> important for me that that makes it into v4.14. This can wait for
> v4.15, as far as I am concerned, and I will benchmark a bit more to
> see if we can get rid of the i586 code as well.
> 

Yes I did notice that aes-generic was actually faster.  Probably the x86_64-asm
implementation should be removed, but it may be worthwhile to try a few
different gcc versions to see how well they compile aes-generic.  I expect that
x86_64-asm used to be faster but gcc has gotten smarter.  Also x86_64-asm is
only really useful on older CPUs, so ideally it should be benchmarked on an
older CPU.

Eric
