From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Date: Tue, 29 May 2012 19:27:43 -0700
Message-ID: <m2396il7xc.fsf@firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120527145112.GF17705@kronos.redsun> (Johannes Goetzfried's
	message of "Sun, 27 May 2012 16:51:12 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Johannes Goetzfried
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de> writes:
> +
> +static int __init serpent_init(void)
> +{
> +	u64 xcr0;
> +
> +	if (!cpu_has_avx || !cpu_has_osxsave) {
> +		printk(KERN_INFO "AVX instructions are not detected.\n");
> +		return -ENODEV;
> +	}
> +
> +	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> +	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
> +		printk(KERN_INFO "AVX detected but unusable.\n");
> +		return -ENODEV;
> +	}
> +
> +	return crypto_register_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
> +}
> +
> +static void __exit serpent_exit(void)
> +{
> +	crypto_unregister_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
> +}
> +
> +module_init(serpent_init);
> +module_exit(serpent_exit);
> +
> +MODULE_DESCRIPTION("Serpent Cipher Algorithm, AVX optimized");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("serpent");

The driver needs CPUID annotations now (since 3.3), so that it can be 
autoloaded.  Something like:

#include <asm/cpu_device_id.h>


static const struct x86_cpu_id avx_cpu_id[] = {
        X86_FEATURE_MATCH(X86_FEATURE_AVX),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, avx_cpu_id);


Replace the manual check in init with

            if (!x86_match_cpu(avx_cpu_id))
                return -ENODEV;

Also drivers should never print anything when they cannot find hardware.
Remove that printk.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
