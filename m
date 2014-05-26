From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Date: Mon, 26 May 2014 07:42:57 +0200
Message-ID: <1449817.RiX7azh5Ri@myon.chronox.de>
References: <20140523211459.GA21019@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140523211459.GA21019@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 24. Mai 2014, 05:14:59 schrieb Herbert Xu:

Hi Herbert,

> Stephan Mueller <smueller@chronox.de> wrote:
> > Hi,
> > 
> > the following set of patches implements the deterministic random bit
> > generator (DRBG) specified by SP800-90A.
> > 
> > The DRBG implementation offers the following:
> >        * All three DRBG types are implemented with a derivation function.
> >        * All DRBG types are available with and without prediction
> >        resistance.
> >        * All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
> >        
> >          for the HMAC and Hash DRBGs.
> >        
> >        * All AES types of AES-128, AES-192 and AES-256 are available for
> >        the
> >        
> >          CTR DRBG.
> >        
> >        * A self test is implemented with drbg_healthcheck().
> >        * The FIPS 140-2 continuous self test is implemented.
> >        * Additional cipher primitives, such as Serpent or Twofish, can be
> >        
> >          added to the DRBG without changing the implementation. The only
> >          change necessary is to the DRBG definition given in the cores[]
> >          array.
> 
> Where is the code that actually uses this?

There are several answers to this.

First: as required by NIST SP800-131A, the ANSI X9.31 DRNG is considered to be 
sunset by the end of 2015. The FIPS 140-2 validation part of NIST requires 
that ANSI X9.31 DRNGs are not allowed for new validations since the start of 
this year and prohibited for revalidations starting next year. The replacement 
of ANSI X9.31 is SP800-90A.

The Linux kernel currently implements one DRNG in ansi_cprng.c. This DRNG is 
an ANSI X9.31 DRNG. This means, the offered SP800-90A implementation can be 
considered a replacement of ansi_cprng.c.

A second aspect is the implementation of the stdrng. Currently, the offered 
patch does not include the stdrng selection. I am currently working on the 
completion of the addition of the stdrng selection to the offered patch. My 
idea is the following: currently, all DRBG types are registered with their own 
cra_name. However, there shall be one particular DRBG registered twice. When 
registering the instance again, the cra_name shall be "stdrng". In addition, 
if the kernel command line contains fips=1, the cra_priority of that stdrng 
should be set to 300. That implies that when the kernel resolves the stdrng, 
it resolves to get_random_bytes in normal mode, but to the stdrng DRBG in FIPS 
mode.

Here some code snippet from my patch I am working on:

if (fips_stdrng) {
                memcpy(alg->cra_name, "stdrng", 6);

...

if (fips_stdrng)
                alg->cra_priority = 300;
        else
                alg->cra_priority = 100;

Ciao
Stephan
-- 
| Cui bono? |
