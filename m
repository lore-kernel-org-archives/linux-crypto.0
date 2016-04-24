From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 3/6] crypto: Linux Random Number Generator
Date: Sun, 24 Apr 2016 04:30:24 -0700
Message-ID: <1461497424.2726.55.camel@perches.com>
References: <1589319.WyasadRQQe@positron.chronox.de>
	 <4513249.IuhZztB3y6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandyinchina@gmail.com, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4513249.IuhZztB3y6@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2016-04-24 at 12:40 +0200, Stephan Mueller wrote:
> The LRNG with all its properties is documented in [1]. This
> documentation covers the functional discussion as well as testing of =
all
> aspects of entropy processing. In addition, the documentation explain=
s
> the conducted regression tests to verify that the LRNG is API and ABI
> compatible with the legacy /dev/random implementation.
>=20
> [1] http://www.chronox.de/lrng.html

Thanks.

Links get stale.

It may be better to put an ascii version of the pdf
in Documentation/ and the test code in tools/

and some trivial notes:

> diff --git a/crypto/lrng.c b/crypto/lrng.c
[]
> +/* debug macro */
> +#define DRIVER_NAME "lrng"

Using
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include would be a lot more common.

> +#if 0
> +#define dbg(fmt, ...) pr_info(DRIVER_NAME": " fmt, ##__VA_ARGS__)
> +#else
> +#define dbg(fmt, ...)
> +#endif

pr_debug or is there some interaction with
dynamic_debug you want to avoid?

And it's generally better to use something like

#if 0
#define dbg(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
#else
#define dbg(fmt, ...) no_printk(fmt, ##__VA_ARGS__)

so that new dbg statements would not have
format/argument mismatches and argument
evaluation side-effects are still eliminated.

> +static void lrng_pdrbg_init_ops(u32 entropy_bits)
> +{
> +	if (lrng_pdrbg.pdrbg_fully_seeded)
> +		return;
> +
> +	BUILD_BUG_ON(LRNG_IRQ_MIN_NUM % LRNG_POOL_WORD_BITS);
> +	BUILD_BUG_ON((LRNG_MIN_SEED_ENTROPY_BITS * LRNG_IRQ_ENTROPY_BITS /
> +		=A0=A0=A0=A0=A0LRNG_DRBG_SECURITY_STRENGTH_BITS) > LRNG_IRQ_MIN_NU=
M);
> +
> +	/* DRBG is seeded with full security strength */
> +	if (entropy_bits >=3D LRNG_DRBG_SECURITY_STRENGTH_BITS) {
> +		lrng_pdrbg.pdrbg_fully_seeded =3D true;
> +		lrng_pdrbg.pdrbg_min_seeded =3D true;
> +		pr_info(DRIVER_NAME": primary DRBG fully seeded\n");

Using pr_fmt eliminates the need for these
DRIVER_NAME ": " prefix inclusions in the format
> +static int __init lrng_init(void)
> +{
[]
> +	pr_info(DRIVER_NAME": deactivating initial RNG - %d bytes delivered=
",
> +		atomic_read(&lrng_initrng_bytes));

Should use \n to terminate the format.
