From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Mon, 13 Apr 2015 12:12:37 +0800
Message-ID: <20150413041236.GA11091@gondor.apana.org.au>
References: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	davem@davemloft.net, arnd@arndb.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 11, 2015 at 03:32:34PM +0200, Ard Biesheuvel wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> How about something like this:
> 
> A warning will be emitted by make when descending into the arch/arm/crypto
> directory, but only if any ARMv8 Crypto modules were in fact selected.
> 
> /home/ard/linux-2.6/arch/arm/crypto/Makefile:22: These ARMv8 Crypto Extensions modules need binutils 2.23 or higher
> /home/ard/linux-2.6/arch/arm/crypto/Makefile:23: aes-arm-ce.o sha1-arm-ce.o sha2-arm-ce.o ghash-arm-ce.o
> 
> 
> ----------------->8------------------
> Old versions of binutils (before 2.23) do not yet understand the
> crypto-neon-fp-armv8 fpu instructions, and an attempt to build these
> files results in a build failure:
> 
> arch/arm/crypto/aes-ce-core.S:133: Error: selected processor does not support ARM mode `vld1.8 {q10-q11},[ip]!'
> arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q8'
> arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'
> arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q9'
> arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'
> 
> Since the affected versions are still in widespread use, and this breaks
> 'allmodconfig' builds, we should try to at least get a successful kernel
> build. Unfortunately, I could not come up with a way to make the Kconfig
> symbol depend on the binutils version, which would be the nicest solution.
> 
> Instead, this patch uses the 'as-instr' Kbuild macro to find out whether
> the support is present in the assembler, and otherwise emits a non-fatal
> warning indicating which selected modules could not be built.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Link: http://storage.kernelci.org/next/next-20150410/arm-allmodconfig/build.log
> Fixes: 864cbeed4ab22d ("crypto: arm - add support for SHA1 using ARMv8 Crypto Instructions")
> [ard.biesheuvel:
>  - omit modules entirely instead of building empty ones if binutils is too old
>  - update commit log accordingly]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
