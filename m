From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/8] s390:
Date: Tue, 19 Apr 2011 13:25:35 +0200
Message-ID: <1303212335.14322.48.camel@bender>
References: <1303212097.14322.44.camel@bender>
	 <1303212206.14322.46.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Gerald =?ISO-8859-1?Q?Sch=E4fer?= <geraldsc@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:58924 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1DSL0p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 07:26:45 -0400
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JBQife012563
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 11:26:44 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JBReVW1531962
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 12:27:40 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JBQiMa017594
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 05:26:44 -0600
In-Reply-To: <1303212206.14322.46.camel@bender>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry, hit the undo once too often. Just ignore.

On Tue, 2011-04-19 at 13:23 +0200, Jan Glauber wrote:
> > Subject: [PATCH] crypto: extend crypto facility check 
> > 
> > From: Jan Glauber <jang@linux.vnet.ibm.com>
> > 
> > The specification which crypto facility is required for an algorithm
> > is added
> > as a parameter to the availability check which is done before an
> > algorithm is
> > registered. With this change it is easier to add new algorithms that
> > require
> > different facilities.
> > 
> > Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
> > ---
> >  arch/s390/crypto/aes_s390.c    |    6 +++---
> >  arch/s390/crypto/crypt_s390.h  |   14 +++++++++++---
> >  arch/s390/crypto/des_s390.c    |    4 ++--
> >  arch/s390/crypto/prng.c        |    2 +-
> >  arch/s390/crypto/sha1_s390.c   |    2 +-
> >  arch/s390/crypto/sha256_s390.c |    2 +-
> >  arch/s390/crypto/sha512_s390.c |    2 +-
> >  7 files changed, 20 insertions(+), 12 deletions(-)
> > 
> > --- a/arch/s390/crypto/aes_s390.c
> > +++ b/arch/s390/crypto/aes_s390.c
> > @@ -508,11 +508,11 @@ static int __init aes_s390_init(void)
> >  {
> >  	int ret;
> >  
> > -	if (crypt_s390_func_available(KM_AES_128_ENCRYPT))
> > +	if (crypt_s390_func_available(KM_AES_128_ENCRYPT, CRYPT_S390_MSA))
> >  		keylen_flag |= AES_KEYLEN_128;
> > -	if (crypt_s390_func_available(KM_AES_192_ENCRYPT))
> > +	if (crypt_s390_func_available(KM_AES_192_ENCRYPT, CRYPT_S390_MSA))
> >  		keylen_flag |= AES_KEYLEN_192;
> > -	if (crypt_s390_func_available(KM_AES_256_ENCRYPT))
> > +	if (crypt_s390_func_available(KM_AES_256_ENCRYPT, CRYPT_S390_MSA))
> >  		keylen_flag |= AES_KEYLEN_256;
> >  
> >  	if (!keylen_flag)
> > --- a/arch/s390/crypto/crypt_s390.h
> > +++ b/arch/s390/crypto/crypt_s390.h
> > @@ -24,6 +24,10 @@
> >  #define CRYPT_S390_PRIORITY 300
> >  #define CRYPT_S390_COMPOSITE_PRIORITY 400
> >  
> > +#define CRYPT_S390_MSA	0x1
> > +#define CRYPT_S390_MSA3	0x2
> > +#define CRYPT_S390_MSA4	0x4
> > +
> >  /* s390 cryptographic operations */
> >  enum crypt_s390_operations {
> >  	CRYPT_S390_KM   = 0x0100,
> > @@ -291,13 +295,17 @@ static inline int crypt_s390_kmac(long f
> >   *
> >   * Returns 1 if func available; 0 if func or op in general not
> > available
> >   */
> > -static inline int crypt_s390_func_available(int func)
> > +static inline int crypt_s390_func_available(int func,
> > +					    unsigned int facility_mask)
> >  {
> >  	unsigned char status[16];
> >  	int ret;
> >  
> > -	/* check if CPACF facility (bit 17) is available */
> > -	if (!test_facility(17))
> > +	if (facility_mask & CRYPT_S390_MSA && !test_facility(17))
> > +		return 0;
> > +	if (facility_mask & CRYPT_S390_MSA3 && !test_facility(76))
> > +		return 0;
> > +	if (facility_mask & CRYPT_S390_MSA4 && !test_facility(77))
> >  		return 0;
> >  
> >  	switch (func & CRYPT_S390_OP_MASK) {
> > --- a/arch/s390/crypto/des_s390.c
> > +++ b/arch/s390/crypto/des_s390.c
> > @@ -381,8 +381,8 @@ static int des_s390_init(void)
> >  {
> >  	int ret;
> >  
> > -	if (!crypt_s390_func_available(KM_DEA_ENCRYPT) ||
> > -	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT))
> > +	if (!crypt_s390_func_available(KM_DEA_ENCRYPT, CRYPT_S390_MSA) ||
> > +	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT, CRYPT_S390_MSA))
> >  		return -EOPNOTSUPP;
> >  
> >  	ret = crypto_register_alg(&des_alg);
> > --- a/arch/s390/crypto/prng.c
> > +++ b/arch/s390/crypto/prng.c
> > @@ -166,7 +166,7 @@ static int __init prng_init(void)
> >  	int ret;
> >  
> >  	/* check if the CPU has a PRNG */
> > -	if (!crypt_s390_func_available(KMC_PRNG))
> > +	if (!crypt_s390_func_available(KMC_PRNG, CRYPT_S390_MSA))
> >  		return -EOPNOTSUPP;
> >  
> >  	if (prng_chunk_size < 8)
> > --- a/arch/s390/crypto/sha1_s390.c
> > +++ b/arch/s390/crypto/sha1_s390.c
> > @@ -90,7 +90,7 @@ static struct shash_alg alg = {
> >  
> >  static int __init sha1_s390_init(void)
> >  {
> > -	if (!crypt_s390_func_available(KIMD_SHA_1))
> > +	if (!crypt_s390_func_available(KIMD_SHA_1, CRYPT_S390_MSA))
> >  		return -EOPNOTSUPP;
> >  	return crypto_register_shash(&alg);
> >  }
> > --- a/arch/s390/crypto/sha256_s390.c
> > +++ b/arch/s390/crypto/sha256_s390.c
> > @@ -86,7 +86,7 @@ static struct shash_alg alg = {
> >  
> >  static int sha256_s390_init(void)
> >  {
> > -	if (!crypt_s390_func_available(KIMD_SHA_256))
> > +	if (!crypt_s390_func_available(KIMD_SHA_256, CRYPT_S390_MSA))
> >  		return -EOPNOTSUPP;
> >  
> >  	return crypto_register_shash(&alg);
> > --- a/arch/s390/crypto/sha512_s390.c
> > +++ b/arch/s390/crypto/sha512_s390.c
> > @@ -132,7 +132,7 @@ static int __init init(void)
> >  {
> >  	int ret;
> >  
> > -	if (!crypt_s390_func_available(KIMD_SHA_512))
> > +	if (!crypt_s390_func_available(KIMD_SHA_512, CRYPT_S390_MSA))
> >  		return -EOPNOTSUPP;
> >  	if ((ret = crypto_register_shash(&sha512_alg)) < 0)
> >  		goto out;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
