From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Wed, 6 Aug 2008 11:42:26 +0200
Message-ID: <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
References: <1218000211.4231.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765086AbYHFJmo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1218000211.4231.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> ??????Revised by comments:
> Add 'static' for limitation namespace;
> Resend for fixing lines-folded by adjusting evolution config;
> (The patch was created against 2.6.27-rc1)
> 
> >From NHM processor onward, Intel processors can support hardware accelerated
> CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction set.
> The patch detects the availability of the feature, and chooses the most proper
> way to calculate CRC32c checksum.
> Byte code instructions are used for compiler compatibility.
> No MMX / XMM registers is involved in the implementation.
> 
> Signed-off-by: Austin Zhang <austin.zhang@intel.com>
> Signed-off-by: Kent Liu <kent.liu@intel.com>
> ---
>  arch/x86/crypto/Makefile       |    2
>  arch/x86/crypto/crc32c-intel.c |  190 +++++++++++++++++++++++++++++++++++++++++
>  crypto/Kconfig                 |   12 ++
>  include/asm-x86/cpufeature.h   |    2
>  4 files changed, 206 insertions(+)
> 
> diff -Naurp linux-2.6/arch/x86/crypto/crc32c-intel.c linux-2.6-patch/arch/x86/crypto/crc32c-intel.c
> --- linux-2.6/arch/x86/crypto/crc32c-intel.c	1969-12-31 19:00:00.000000000 -0500
> +++ linux-2.6-patch/arch/x86/crypto/crc32c-intel.c	2008-08-05 21:57:37.000000000 -0400
> @@ -0,0 +1,190 @@
> +/*
> + * Using hardware provided CRC32 instruction to accelerate the CRC32 disposal.
> + * CRC32C polynomial:0x1EDC6F41(BE)/0x82F63B78(LE)
> + * CRC32 is a new instruction in Intel SSE4.2, the reference can be found at:
> + * http://www.intel.com/products/processor/manuals/
> + * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
> + * Volume 2A: Instruction Set Reference, A-M

Copyright / GPL?

> +#ifdef CONFIG_X86_64
> +#define REX_PRE "0x48, "
> +#define SCALE_F 8
> +#else
> +#define REX_PRE
> +#define SCALE_F 4
> +#endif

Ouch...

> +static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t length)
> +{
> +	while (length--) {
> +		__asm__ __volatile__(

Are all the underscores neccessary?

> +			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"

Ouch...


> +static int crc32c_intel_final(struct ahash_request *req)
> +{
> +	u32 *crcp = ahash_request_ctx(req);
> +
> +	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
> +	return 0;

This is not user visible, so le32 should be enough.

> +static int __init crc32c_intel_mod_init(void)
> +{
> +	if (cpu_has_xmm4_2)
> +		return crypto_register_alg(&alg);
> +	else {
> +		printk(KERN_ERR"No support in current hardware.\n");

Missing space.

> +		return -1;

That's supposed to be errno, right?

> +config CRYPTO_CRC32C_INTEL
> +        tristate "CRC32c INTEL hardware acceleration"
> +	depends on X86
> +        select CRYPTO_ALGAPI
> +        help
> +          In Intel processor with SSE4.2 supported, the processor will
> +          support CRC32C implementation using hardware accelerated CRC32
> +          instruction. This option will create 'crc32c-intel' module,

In Intel processor with SSE4.2, we can use hardware CRC32 acceleration.

> +          which will enable any routine to use the CRC32 instruction to
> +          gain performance compared with software implementation.
> +          Module will be crc32c-intel.

crc32c-intel.ko?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
