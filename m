From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] crypto: Remove mcryptd
Date: Wed, 8 Aug 2018 17:56:21 +0800
Message-ID: <20180808095621.h7ecacftx5ofe5ki@gondor.apana.org.au>
References: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
 <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
 <1532651107.19157.24.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1532651107.19157.24.camel@megha-Z97X-UD7-TH>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 26, 2018 at 05:25:07PM -0700, Megha Dey wrote:
> 
> 1. On the existing algorithms covered in aesni_intel-glue.c (eg:
> __cbc-aes-aesni), 3 algorithms are registered in /proc/crypto:
> 
>      __cbc(aes)
>      cryptd(__cbc-aes-aesni)--> registered via cryptd_create_skcipher
> 
>      cbc(aes)
>      cbc-aes-aesni	--> registered via simd_skcipher_create_compat
> 
>      __cbc(aes)
>      __cbc-aes-aesni    --> registered as the internal algorithm
> 
> I would want to know why do we need the cryptd(__cbc-aes-aesni)
> algorithm at all. I do not see any of the associated setkey, encrypt or
> decrypt functions getting called during the selftest or while running
> tcrypt. I just see the simd_(setkey, encrypt, decrypt) functions
> directly called the inner algorithms. However, if I remove the cryptd
> algorithm, none of the algorithms are registered.

The simd functions are the fast path where you are running in a
context where SIMD can be used directly.  cryptd is the slow path
where we defer the work to a work queue.

> > What you need to do is create an actual simd wrapper with cryptd
>  
> This simd wrapper is already present for skcipher right(in simd.c)?
> Assuming we only have ciphers and no hash algorithms, are any changes
> required in these wrappers?

For skcipher yes they already exist.  But this thread was about
hashes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
