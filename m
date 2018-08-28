From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/4] arm64: cpufeature: add feature for CRC32 instructions
Date: Tue, 28 Aug 2018 18:01:36 +0100
Message-ID: <20180828170135.GC19825@arm.com>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
 <20180827110245.14812-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        catalin.marinas@arm.com, herbert@gondor.apana.org.au,
        ebiggers@google.com, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180827110245.14812-3-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 27, 2018 at 01:02:43PM +0200, Ard Biesheuvel wrote:
> Add a CRC32 feature bit and wire it up to the CPU id register so we
> will be able to use alternatives patching for CRC32 operations.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/cpucaps.h | 3 ++-
>  arch/arm64/kernel/cpufeature.c   | 9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)

Acked-by: Will Deacon <will.deacon@arm.com>

With the minor caveat below...

> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index ae1f70450fb2..9932aca9704b 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -51,7 +51,8 @@
>  #define ARM64_SSBD				30
>  #define ARM64_MISMATCHED_CACHE_TYPE		31
>  #define ARM64_HAS_STAGE2_FWB			32
> +#define ARM64_HAS_CRC32				33
>  
> -#define ARM64_NCAPS				33
> +#define ARM64_NCAPS				34


... if this goes via crypto, you'll almost certainly get a (trivial)
conflict with arm64, since these numbers get bumped all the time.

Will

>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e238b7932096..7626b80128f5 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1222,6 +1222,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.cpu_enable = cpu_enable_hw_dbm,
>  	},
>  #endif
> +	{
> +		.desc = "CRC32 instructions",
> +		.capability = ARM64_HAS_CRC32,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		.sys_reg = SYS_ID_AA64ISAR0_EL1,
> +		.field_pos = ID_AA64ISAR0_CRC32_SHIFT,
> +		.min_field_value = 1,
> +	},
>  	{},
>  };
>  
> -- 
> 2.18.0
> 
