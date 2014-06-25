From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 9/28] crypto/drbg.c:1998:1: sparse: directive
 in argument list
Date: Wed, 25 Jun 2014 17:04:52 +0800
Message-ID: <20140625090452.GA8727@gondor.apana.org.au>
References: <53a496d6.fJew+2t1cC5Ih4rL%fengguang.wu@intel.com>
 <1568803.2elWF5jpR4@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42929 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaFYJFG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 05:05:06 -0400
Content-Disposition: inline
In-Reply-To: <1568803.2elWF5jpR4@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 21, 2014 at 02:30:29PM +0200, Stephan Mueller wrote:
> Am Samstag, 21. Juni 2014, 04:17:26 schrieb kbuild test robot:
> 
> Hi,
> 
> > tree:  
> > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> > master head:   6c9e3dcd36691c8690861a5f6902226ed2d8a75e
> > commit: 5bfcf65b385f3e011b72261612abfd49df102086 [9/28] crypto: drbg -
> > compile the DRBG code reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> crypto/drbg.c:1998:1: sparse: directive in argument list
> > >> crypto/drbg.c:2000:1: sparse: directive in argument list
> > >> crypto/drbg.c:2001:1: sparse: directive in argument list
> > >> crypto/drbg.c:2003:1: sparse: directive in argument list
> > >> crypto/drbg.c:2004:1: sparse: directive in argument list
> > >> crypto/drbg.c:2006:1: sparse: directive in argument list
> > 
> > vim +1998 crypto/drbg.c
> > 
> > 541af946 Stephan Mueller 2014-05-31  1992
> > 541af946 Stephan Mueller 2014-05-31  1993  module_init(drbg_init);
> > 541af946 Stephan Mueller 2014-05-31  1994  module_exit(drbg_exit);
> > 541af946 Stephan Mueller 2014-05-31  1995  MODULE_LICENSE("GPL");
> > 541af946 Stephan Mueller 2014-05-31  1996  MODULE_AUTHOR("Stephan Mueller
> > <smueller@chronox.de>"); 541af946 Stephan Mueller 2014-05-31  1997 
> > MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator
> > (DRBG) using following cores:" 541af946 Stephan Mueller 2014-05-31 @1998 
> > #ifdef CONFIG_CRYPTO_DRBG_HMAC 541af946 Stephan Mueller 2014-05-31  1999 
> > "HMAC "
> > 541af946 Stephan Mueller 2014-05-31 @2000  #endif
> > 541af946 Stephan Mueller 2014-05-31 @2001  #ifdef CONFIG_CRYPTO_DRBG_HASH
> > 541af946 Stephan Mueller 2014-05-31  2002  "Hash "
> > 541af946 Stephan Mueller 2014-05-31 @2003  #endif
> > 541af946 Stephan Mueller 2014-05-31 @2004  #ifdef CONFIG_CRYPTO_DRBG_CTR
> > 541af946 Stephan Mueller 2014-05-31  2005  "CTR"
> > 541af946 Stephan Mueller 2014-05-31 @2006  #endif
> > 541af946 Stephan Mueller 2014-05-31  2007  );
> > 
> > :::::: The code at line 1998 was first introduced by commit
> > :::::: 541af946fe1360ec1b45730964e87d7f93c50781 crypto: drbg - SP800-90A
> > :::::: Deterministic Random Bit Generator
> > :::::: 
> > :::::: TO: Stephan Mueller <smueller@chronox.de>
> > :::::: CC: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> 
> I am unsure what to do here. The code looks good, but the analyzer does not 
> seem to like ifdefed print statements.

Please move the ifdef out, say by defining a new string macro
which contains what you want.

#ifdef CONFIG_CRYPTO_DRBG_HASH
#define CRYPTO_DRBG_HASH_STRING "Hash "
#endif

...

Then you just use CRYPTO_DRBG_HASH_STRING.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
