From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Tue, 2 Oct 2018 11:18:48 +0800
Message-ID: <20181002031848.lyxrergyyxyc5cwi@gondor.apana.org.au>
References: <20180925145622.29959-5-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Jason@zx2c4.com, sneves@dei.uc.pt,
        luto@kernel.org, jeanphilippe.aumasson@gmail.com,
        appro@openssl.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-5-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This provides SSSE3, AVX-2, AVX-512F, and AVX-512VL implementations for
> ChaCha20. The AVX-512F implementation is disabled on Skylake, due to
> throttling, and the VL ymm implementation is used instead. These come
> from Andy Polyakov's implementation, with the following modifications
> from Samuel Neves:
> 
>  - Some cosmetic changes, like renaming labels to .Lname, constants,
>    and other Linux conventions.
> 
>  - CPU feature checking is done in C by the glue code, so that has been
>    removed from the assembly.
> 
>  - Eliminate translating certain instructions, such as pshufb, palignr,
>    vprotd, etc, to .byte directives. This is meant for compatibility
>    with ancient toolchains, but presumably it is unnecessary here,
>    since the build system already does checks on what GNU as can
>    assemble.
> 
>  - When aligning the stack, the original code was saving %rsp to %r9.
>    To keep objtool happy, we use instead the DRAP idiom to save %rsp
>    to %r10:
> 
>      leaq    8(%rsp),%r10
>      ... code here ...
>      leaq    -8(%r10),%rsp
> 
>  - The original code assumes the stack comes aligned to 16 bytes. This
>    is not necessarily the case, and to avoid crashes,
>    `andq $-alignment, %rsp` was added in the prolog of a few functions.
> 
>  - The original hardcodes returns as .byte 0xf3,0xc3, aka "rep ret".
>    We replace this by "ret". "rep ret" was meant to help with AMD K8
>    chips, cf. http://repzret.org/p/repzret. It makes no sense to
>    continue to use this kludge for code that won't even run on ancient
>    AMD chips.
> 
> While this is CRYPTOGAMS code, the originating code for this happens to
> be the same as OpenSSL's commit cded951378069a478391843f5f8653c1eb5128da
> 
> Cycle counts on a Core i7 6700HQ using the AVX-2 codepath:
> 
> size    old     new
> ----    ----    ----
> 0       62      52

What is the old column? Is it the existing x86-64 implementation
in the kernel or something else? This needs to be made clear in the
patch description.

The same comment from the previous patch also stands here.  Please
ensure that we only have one copy of chacha x86-64 code in the kernel.
Either replace the existing one right here or in a follow-up patch
in the same series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
