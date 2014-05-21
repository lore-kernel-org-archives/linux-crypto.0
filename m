From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Date: Wed, 21 May 2014 22:17:30 +0200
Message-ID: <1463834.NEeonhXFuP@myon.chronox.de>
References: <16102625.1uoi9eJz6k@myon.chronox.de> <4917794.FPSphFc8Fa@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, aquini@redhat.com,
	jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
	pwalten@au1.ibm.com, joe@perches.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4917794.FPSphFc8Fa@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 21. Mai 2014, 06:18:58 schrieb Stephan Mueller:

Hi,

> +/*
> + * Tests as defined in 11.3.2 in addition to the cipher tests: testing
> + * of the error handling.
> + *
> + * Note: testing of failing seed source as defined in 11.3.2 is not
> applicable + * as seed source of get_random_bytes does not fail.
> + *
> + * Note 2: There is no sensible way of testing the reseed counter
> + * enforcement, so skip it.
> + */
> +static inline int __init drbg_healthcheck_sanity(void)
> +{
> +#ifdef CONFIG_CRYPTO_FIPS
> +	unsigned int len = 0;

This variable must be signed int as otherwise the BUG_ON checks will always 
fail. This error is a leftover from the return code change of drbg_generate(). 
It will be fixed in the next release.

Ciao
Stephan
-- 
| Cui bono? |
