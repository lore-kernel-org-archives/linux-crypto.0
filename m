From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 3/6] crypto: Linux Random Number Generator
Date: Sun, 24 Apr 2016 16:12:34 +0200
Message-ID: <1907949.voNH4FmKbt@positron.chronox.de>
References: <1589319.WyasadRQQe@positron.chronox.de> <4513249.IuhZztB3y6@positron.chronox.de> <1461497424.2726.55.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53444 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbcDXOMj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 10:12:39 -0400
In-Reply-To: <1461497424.2726.55.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 24. April 2016, 04:30:24 schrieb Joe Perches:

Hi Joe,

thank you very much for your comments.

> On Sun, 2016-04-24 at 12:40 +0200, Stephan Mueller wrote:
> > The LRNG with all its properties is documented in [1]. This
> > documentation covers the functional discussion as well as testing of all
> > aspects of entropy processing. In addition, the documentation explains
> > the conducted regression tests to verify that the LRNG is API and ABI
> > compatible with the legacy /dev/random implementation.
> > 
> > [1] http://www.chronox.de/lrng.html
> 
> Thanks.
> 
> Links get stale.
> 
> It may be better to put an ascii version of the pdf
> in Documentation/ and the test code in tools/

I surely can do that. What would you think would be the proper location to add 
such documentation? Simply Documentation/lrng.txt?

How would you propose to handle the pictures (at least the big picture)?

Regarding the tests: those are no regression tests, but tests to allow other 
researches to verify whether the LRNG operates appropriately. Thus, would 
adding it to a new directory of tools/crypto/rng be appropriate?
> 
> and some trivial notes:
> > diff --git a/crypto/lrng.c b/crypto/lrng.c
> 
> []
> 
> > +/* debug macro */
> > +#define DRIVER_NAME "lrng"
> 
> Using
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include would be a lot more common.

Fixed
> 
> > +#if 0
> > +#define dbg(fmt, ...) pr_info(DRIVER_NAME": " fmt, ##__VA_ARGS__)
> > +#else
> > +#define dbg(fmt, ...)
> > +#endif
> 
> pr_debug or is there some interaction with
> dynamic_debug you want to avoid?
> 
> And it's generally better to use something like
> 
> #if 0
> #define dbg(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
> #else
> #define dbg(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
> 
> so that new dbg statements would not have
> format/argument mismatches and argument
> evaluation side-effects are still eliminated.

Fixed: I have replaced all invocations with pr_debug.
> 
> > +static void lrng_pdrbg_init_ops(u32 entropy_bits)
> > +{
> > +	if (lrng_pdrbg.pdrbg_fully_seeded)
> > +		return;
> > +
> > +	BUILD_BUG_ON(LRNG_IRQ_MIN_NUM % LRNG_POOL_WORD_BITS);
> > +	BUILD_BUG_ON((LRNG_MIN_SEED_ENTROPY_BITS * LRNG_IRQ_ENTROPY_BITS /
> > +		     LRNG_DRBG_SECURITY_STRENGTH_BITS) > LRNG_IRQ_MIN_NUM);
> > +
> > +	/* DRBG is seeded with full security strength */
> > +	if (entropy_bits >= LRNG_DRBG_SECURITY_STRENGTH_BITS) {
> > +		lrng_pdrbg.pdrbg_fully_seeded = true;
> > +		lrng_pdrbg.pdrbg_min_seeded = true;
> > +		pr_info(DRIVER_NAME": primary DRBG fully seeded\n");
> 
> Using pr_fmt eliminates the need for these
> DRIVER_NAME ": " prefix inclusions in the format

All occurrences corrected.
> 
> > +static int __init lrng_init(void)
> > +{
> 
> []
> 
> > +	pr_info(DRIVER_NAME": deactivating initial RNG - %d bytes delivered",
> > +		atomic_read(&lrng_initrng_bytes));
> 
> Should use \n to terminate the format.

Thank you, fixed. Though, I am wondering why I do see the line feed in dmesg. 
Whatever, it is fixed.

I have cover the fixes in my code. I will wait for more comments and release 
these changes in a couple of days.

Thanks a lot.


Ciao
Stephan
