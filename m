From: Megha Dey <megha.dey@intel.com>
Subject: Re: [RFC] crypto: Remove mcryptd
Date: Thu, 26 Jul 2018 17:25:07 -0700
Message-ID: <1532651107.19157.24.camel@megha-Z97X-UD7-TH>
References: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
         <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-07-20 at 11:53 +0800, Herbert Xu wrote:
> On Fri, May 11, 2018 at 06:44:13PM -0700, Megha Dey wrote:
> >
> > +static struct ahash_alg *simd_ahash_create_compat(const char *algname,
> > +						       const char *drvname,
> > +						       const char *basename)
> > +{
> > +	struct ahash_alg *alg;
> > +	struct ahash_alg *ialg;
> > +	int err;
> 
> I think there has been a misunderstsanding.  You're not actually
> using the simd wrapper here.  All you're doing is creating a function
> with the word simd in its name.  In all other respects this is just
> exposing the underlying algorithm to users directly, which cannot
> work because the underlying algorithm requires SIMD.

Hi Herbert,

Thanks for the feedback.

I still have some questions though:

1. On the existing algorithms covered in aesni_intel-glue.c (eg:
__cbc-aes-aesni), 3 algorithms are registered in /proc/crypto:

     __cbc(aes)
     cryptd(__cbc-aes-aesni)--> registered via cryptd_create_skcipher

     cbc(aes)
     cbc-aes-aesni	--> registered via simd_skcipher_create_compat

     __cbc(aes)
     __cbc-aes-aesni    --> registered as the internal algorithm

I would want to know why do we need the cryptd(__cbc-aes-aesni)
algorithm at all. I do not see any of the associated setkey, encrypt or
decrypt functions getting called during the selftest or while running
tcrypt. I just see the simd_(setkey, encrypt, decrypt) functions
directly called the inner algorithms. However, if I remove the cryptd
algorithm, none of the algorithms are registered.

> 
> What you need to do is create an actual simd wrapper with cryptd
 
This simd wrapper is already present for skcipher right(in simd.c)?
Assuming we only have ciphers and no hash algorithms, are any changes
required in these wrappers?

Pseudo code:
1. Register inner algorithm (cbc-aes-aesni-mb) in aes_cbc_mb_mod_init()
2. Register outer algorithm with the mcryptd- prefix for the driver name
using the simd_skcipher_create_compat(mcryptd-cbc-aes-aesni-mb)
3. tcrypt/testmanager calls the
crypto_skcipher_encrypt->simd_skcipher_encrypt->mb_cbc_aes_encrypt 
4. Shift helper functions which help flush outstanding jobs to glue
layer.
5. Delete mcryptd.c
6. All similar simd wrapper for hash algorithms. 

> and all the functions that may do SIMD work needs to invoke cryptd
> if may_use_simd() (and other conditions) is false.
> 
> This wrapper should live in crypto/simd.c.
> 
> Cheers,
