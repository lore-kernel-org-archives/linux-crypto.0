From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: arm64/crc32 - remove PMULL based CRC32 driver
Date: Tue, 4 Sep 2018 13:21:09 +0800
Message-ID: <20180904052109.bprmzgstknh6yecz@gondor.apana.org.au>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
 <20180827110245.14812-5-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com, ebiggers@google.com,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180827110245.14812-5-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 27, 2018 at 01:02:45PM +0200, Ard Biesheuvel wrote:
> Now that the scalar fallbacks have been moved out of this driver into
> the core crc32()/crc32c() routines, we are left with a CRC32 crypto API
> driver for arm64 that is based only on 64x64 polynomial multiplication,
> which is an optional instruction in the ARMv8 architecture, and is less
> and less likely to be available on cores that do not also implement the
> CRC32 instructions, given that those are mandatory in the architecture
> as of ARMv8.1.
> 
> Since the scalar instructions do not require the special handling that
> SIMD instructions do, and since they turn out to be considerably faster
> on some cores (Cortex-A53) as well, there is really no point in keeping
> this code around so let's just remove it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
