Return-Path: <SRS0=rw2L=VZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFBDC433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 17:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF1E82085A
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564335043;
	bh=SApeSAOCEes0PWkM4Uh50Tvyqo+7swUjjTFdEFhSzAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j2EW6MhokKssanC5997Jq/qFKZwIEauVDSckXAIt71CENRJooNojnCbmQZdlN9hyi
	 +MosG6DJ20puPfyWcY+jdl3nNuXXtaotVfySt43xNGwsvaMwWgRSzV8dh17hU4EOIq
	 p6uXwC1+cv1L7ck6+F8Wj9q+XvjRlAyPG9rY2llI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfG1Ram (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jul 2019 13:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfG1Ram (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jul 2019 13:30:42 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10C0206A2;
        Sun, 28 Jul 2019 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564335041;
        bh=SApeSAOCEes0PWkM4Uh50Tvyqo+7swUjjTFdEFhSzAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUE16JYtVIAxQerWha8ioutdihk9i50igFJ/bTJjlXehrVkqLF0u2U5Hq4hnYuKU/
         tyU0Qr5zDghEpQkxVisTPfK1hKaB+J3gvy07ssNHHCgfbqiW2iNdT6me2Uhx6BFn63
         QEjtw4VaEzuQv2KnCsal0OyBUBzQRFZRzz/f/P4o=
Date:   Sun, 28 Jul 2019 10:30:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190728173040.GA699@sol.localdomain>
Mail-Followup-To: Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal, thanks for the patch!

On Wed, Jul 24, 2019 at 11:35:17AM +0200, Pascal van Leeuwen wrote:
> The probability of hitting specific input length corner cases relevant
> for certain hardware driver(s) (specifically: inside-secure) was found
> to be too low. Additionally, for authenc AEADs, the probability of
> generating a *legal* key blob approached zero, i.e. most vectors
> generated would only test the proper generation of a key blob error.
> 
> This patch address both of these issues by improving the random
> generation of data lengths (for the key, but also for the ICV output
> and the AAD and plaintext inputs), making the random generation
> individually tweakable on a per-ciphersuite basis.
> 
> Finally, this patch enables fuzz testing for AEAD ciphersuites that do
> not have a regular testsuite defined as it no longer depends on that
> regular testsuite for figuring out the key size.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

More comments below, but first I see some test failures and warnings with this
patch applied:

alg: aead: authenc(hmac(sha1-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=26 plen=594 authsize=20 klen=60"; expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[33.6%@+12, 18.23%@+2452, 13.7%@+3761, 35.64%@+4019] iv_offset=43"
alg: aead: empty test suite for authenc(hmac(sha1-ni),rfc3686(ctr(aes-generic)))
alg: aead: empty test suite for authenc(hmac(sha1-generic),rfc3686(ctr(aes-generic)))
alg: aead: authenc(hmac(sha256-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=14 plen=6237 authsize=32 klen=72"; expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[93.90%@+2019, 4.74%@alignmask+4094, 1.36%@+21] dst_divs=[100.0%@+4000]"
alg: aead: empty test suite for authenc(hmac(sha256-ni),rfc3686(ctr-aes-aesni))
alg: aead: empty test suite for authenc(hmac(sha256-generic),rfc3686(ctr(aes-generic)))
alg: aead: empty test suite for authenc(hmac(sha384-avx2),rfc3686(ctr-aes-aesni))
alg: aead: empty test suite for authenc(hmac(sha384-generic),rfc3686(ctr(aes-generic)))
alg: aead: authenc(hmac(sha512-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=14 plen=406 authsize=12 klen=104"; expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[41.41%@+852, 58.59%@+4011] dst_divs=[100.0%@alignmask+4017]"
alg: aead: empty test suite for authenc(hmac(sha512-avx2),rfc3686(ctr-aes-aesni))
alg: aead: empty test suite for authenc(hmac(sha512-generic),rfc3686(ctr(aes-generic)))


Note that the "empty test suite" message shouldn't be printed (especially not at
KERN_ERR level!) if it's working as intended.

> ---
>  crypto/testmgr.c | 269 +++++++++++++++++++++++++++++++++++++++++++------
>  crypto/testmgr.h | 298 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 535 insertions(+), 32 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 2ba0c48..9c856d3 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -84,11 +84,24 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>  #define ENCRYPT 1
>  #define DECRYPT 0
>  
> +struct len_range_set {
> +	const struct len_range_sel *lensel;
> +	unsigned int count;
> +};
> +
>  struct aead_test_suite {
>  	const struct aead_testvec *vecs;
>  	unsigned int count;
>  };
>  
> +struct aead_test_params {
> +	struct len_range_set ckeylensel;
> +	struct len_range_set akeylensel;
> +	struct len_range_set authsizesel;
> +	struct len_range_set aadlensel;
> +	struct len_range_set ptxtlensel;
> +};
> +
>  struct cipher_test_suite {
>  	const struct cipher_testvec *vecs;
>  	unsigned int count;
> @@ -143,6 +156,10 @@ struct alg_test_desc {
>  		struct akcipher_test_suite akcipher;
>  		struct kpp_test_suite kpp;
>  	} suite;
> +
> +	union {
> +		struct aead_test_params aead;
> +	} params;
>  };

Why not put these new fields in the existing 'struct aead_test_suite'?

I don't see the point of the separate 'params' struct.  It just confuses things.

>  
>  static void hexdump(unsigned char *buf, unsigned int len)
> @@ -189,9 +206,6 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
>  	__testmgr_free_buf(buf, 0);
>  }
>  
> -#define TESTMGR_POISON_BYTE	0xfe
> -#define TESTMGR_POISON_LEN	16
> -
>  static inline void testmgr_poison(void *addr, size_t len)
>  {
>  	memset(addr, TESTMGR_POISON_BYTE, len);
> @@ -2035,6 +2049,19 @@ static int test_aead_vec(const char *driver, int enc,
>  }
>  
>  #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> +/* Select a random length value from a list of range specs */

Perhaps mention the meaning of the -1 return value in this comment?

> +int random_lensel(const struct len_range_set *lens)

static

> +{
> +	u32 i, sel = prandom_u32() % 1000;
> +
> +	for (i = 0; i < lens->count; i++)
> +		if (sel < lens->lensel[i].threshold)
> +			return (prandom_u32() % (lens->lensel[i].len_hi  -
> +						 lens->lensel[i].len_lo + 1)) +
> +				lens->lensel[i].len_lo;
> +	return -1;
> +}

This function isn't really AEAD-specific, so it seems it should be moved to near
the other common fuzz test helpers like generate_random_length(), rather than be
here where the AEAD-specific code is.

> +
>  /*
>   * Generate an AEAD test vector from the given implementation.
>   * Assumes the buffers in 'vec' were already allocated.
> @@ -2043,44 +2070,83 @@ static void generate_random_aead_testvec(struct aead_request *req,
>  					 struct aead_testvec *vec,
>  					 unsigned int maxkeysize,
>  					 unsigned int maxdatasize,
> +					 const struct aead_test_params *lengths,
>  					 char *name, size_t max_namelen)
>  {
>  	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>  	const unsigned int ivsize = crypto_aead_ivsize(tfm);
>  	unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
> -	unsigned int authsize;
> +	int authsize, clen, alen;
>  	unsigned int total_len;
>  	int i;
>  	struct scatterlist src[2], dst;
>  	u8 iv[MAX_IVLEN];
>  	DECLARE_CRYPTO_WAIT(wait);
>  
> -	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
> -	vec->klen = maxkeysize;
> -	if (prandom_u32() % 4 == 0)
> -		vec->klen = prandom_u32() % (maxkeysize + 1);
> -	generate_random_bytes((u8 *)vec->key, vec->klen);
> +	alen = random_lensel(&lengths->akeylensel);
> +	clen = random_lensel(&lengths->ckeylensel);
> +	if ((alen >= 0) && (clen >= 0)) {
> +		/* Corect blob header. TBD: Do we care about corrupting this? */
> +#ifdef __LITTLE_ENDIAN
> +		memcpy((void *)vec->key, "\x08\x00\x01\x00\x00\x00\x00\x10", 8);
> +#else
> +		memcpy((void *)vec->key, "\x00\x08\x00\x01\x00\x00\x00\x10", 8);
> +#endif

Isn't this specific to "authenc" AEADs?  There needs to be something in the test
suite that says an authenc formatted key is needed.

> +
> +		/* Generate keys based on length templates */
> +		generate_random_bytes((u8 *)(vec->key + 8), alen);
> +		generate_random_bytes((u8 *)(vec->key + 8 + alen),
> +				      clen);
> +
> +		vec->klen = 8 + alen + clen;
> +	} else {
> +		if (clen >= 0)
> +			maxkeysize = clen;
> +
> +		vec->klen = maxkeysize;
> +
> +		/*
> +		 * Key: length in [0, maxkeysize],
> +		 * but usually choose maxkeysize
> +		 */
> +		if (prandom_u32() % 4 == 0)
> +			vec->klen = prandom_u32() % (maxkeysize + 1);
> +		generate_random_bytes((u8 *)vec->key, vec->klen);
> +	}
>  	vec->setkey_error = crypto_aead_setkey(tfm, vec->key, vec->klen);

The generate_random_aead_testvec() function is getting too long and complicated.
It doesn't help that now the 'clen' variable is used for multiple different
purposes (encryption key length and ciphertext length).  Could you maybe factor
out the key generation into a separate function?

>  
>  	/* IV */
>  	generate_random_bytes((u8 *)vec->iv, ivsize);
>  
> -	/* Tag length: in [0, maxauthsize], but usually choose maxauthsize */
> -	authsize = maxauthsize;
> -	if (prandom_u32() % 4 == 0)
> -		authsize = prandom_u32() % (maxauthsize + 1);
> +	authsize = random_lensel(&lengths->authsizesel);
> +	if (authsize < 0) {
> +		/*
> +		 * Tag length: in [0, maxauthsize],
> +		 * but usually choose maxauthsize
> +		 */
> +		authsize = maxauthsize;
> +		if (prandom_u32() % 4 == 0)
> +			authsize = prandom_u32() % (maxauthsize + 1);
> +	}
>  	if (WARN_ON(authsize > maxdatasize))
>  		authsize = maxdatasize;
> -	maxdatasize -= authsize;
>  	vec->setauthsize_error = crypto_aead_setauthsize(tfm, authsize);

Updating the comments to better match the code changes would be helpful too.
E.g. here comments like the following would be helpful:

        /* Authentication tag size */
        authsize = random_lensel(&lengths->authsizesel);
        if (authsize < 0) {
                /*
                 * No length hints for this algorithm.  Fall back to a random
                 * value in [0, maxauthsize], but usually choose maxauthsize.
                 */
                authsize = maxauthsize;
                if (prandom_u32() % 4 == 0)
                        authsize = prandom_u32() % (maxauthsize + 1);
        }

>  
>  	/* Plaintext and associated data */
> -	total_len = generate_random_length(maxdatasize);
> -	if (prandom_u32() % 4 == 0)
> -		vec->alen = 0;
> -	else
> -		vec->alen = generate_random_length(total_len);
> -	vec->plen = total_len - vec->alen;
> +	alen = random_lensel(&lengths->aadlensel);
> +	clen = random_lensel(&lengths->ptxtlensel);
> +	maxdatasize -= authsize;
> +	if ((alen < 0) || (clen < 0) || ((alen + clen) > maxdatasize)) {
> +		total_len = generate_random_length(maxdatasize);
> +		if (prandom_u32() % 4 == 0)
> +			vec->alen = 0;
> +		else
> +			vec->alen = generate_random_length(total_len);
> +		vec->plen = total_len - vec->alen;
> +	} else {
> +		vec->alen = alen;
> +		vec->plen = clen;
> +	}
>  	generate_random_bytes((u8 *)vec->assoc, vec->alen);
>  	generate_random_bytes((u8 *)vec->ptext, vec->plen);
>  
> @@ -2133,7 +2199,7 @@ static int test_aead_vs_generic_impl(const char *driver,
>  	char _generic_driver[CRYPTO_MAX_ALG_NAME];
>  	struct crypto_aead *generic_tfm = NULL;
>  	struct aead_request *generic_req = NULL;
> -	unsigned int maxkeysize;
> +	unsigned int maxkeysize, maxakeysize;
>  	unsigned int i;
>  	struct aead_testvec vec = { 0 };
>  	char vec_name[64];
> @@ -2203,9 +2269,27 @@ static int test_aead_vs_generic_impl(const char *driver,
>  	 */
>  
>  	maxkeysize = 0;
> -	for (i = 0; i < test_desc->suite.aead.count; i++)
> +	for (i = 0; i < test_desc->params.aead.ckeylensel.count; i++)
>  		maxkeysize = max_t(unsigned int, maxkeysize,
> -				   test_desc->suite.aead.vecs[i].klen);
> +			test_desc->params.aead.ckeylensel.lensel[i].len_hi);
> +
> +	if (maxkeysize && test_desc->params.aead.akeylensel.count) {
> +		/* authenc, explicit keylen ranges defined, use them */
> +		maxakeysize = 0;
> +		for (i = 0; i < test_desc->params.aead.akeylensel.count; i++)
> +			maxakeysize = max_t(unsigned int, maxakeysize,
> +			   test_desc->params.aead.akeylensel.lensel[i].len_hi);
> +		maxkeysize = 8 + maxkeysize + maxakeysize;
> +	} else if (!maxkeysize && test_desc->suite.aead.count) {
> +		/* attempt to derive from test vectors */
> +		for (i = 0; i < test_desc->suite.aead.count; i++)
> +			maxkeysize = max_t(unsigned int, maxkeysize,
> +					test_desc->suite.aead.vecs[i].klen);
> +	} else {
> +		pr_err("alg: aead: no key length templates or test vectors for %s - unable to fuzz\n",
> +		       driver);
> +		err = -EINVAL;
> +	}

Can you put the "find the maxkeysize" logic in its own function, so it doesn't
make test_aead_vs_generic_impl() longer and harder to understand?

>  
>  	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
>  	vec.iv = kmalloc(ivsize, GFP_KERNEL);
> @@ -2220,6 +2304,7 @@ static int test_aead_vs_generic_impl(const char *driver,
>  	for (i = 0; i < fuzz_iterations * 8; i++) {
>  		generate_random_aead_testvec(generic_req, &vec,
>  					     maxkeysize, maxdatasize,
> +					     &test_desc->params.aead,
>  					     vec_name, sizeof(vec_name));
>  		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
>  
> @@ -2280,11 +2365,6 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
>  	struct cipher_test_sglists *tsgls = NULL;
>  	int err;
>  
> -	if (suite->count <= 0) {
> -		pr_err("alg: aead: empty test suite for %s\n", driver);
> -		return -EINVAL;
> -	}
> -
>  	tfm = crypto_alloc_aead(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
> @@ -2308,6 +2388,11 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
>  		goto out;
>  	}
>  
> +	if (suite->count <= 0) {
> +		pr_err("alg: aead: empty test suite for %s\n", driver);
> +		goto aead_skip_testsuite;
> +	}
> +

This should be at most pr_warn(), and maybe not printed at all.  We already know
that some authenc compositions don't have their own test vectors; kernel users
can't do anything about it.

> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 6b459a6..105f2ce 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -28,6 +28,8 @@
>  #include <linux/oid_registry.h>
>  
>  #define MAX_IVLEN		32
> +#define TESTMGR_POISON_BYTE	0xfe
> +#define TESTMGR_POISON_LEN	16
>  
>  /*
>   * hash_testvec:	structure to describe a hash (message digest) test
> @@ -176,6 +178,302 @@ struct kpp_testvec {
>  static const char zeroed_string[48];
>  
>  /*
> + * length range declaration lo-hi plus selection threshold 0 - 1000
> + */
> +struct len_range_sel {
> +	unsigned int len_lo;
> +	unsigned int len_hi;
> +	unsigned int threshold;
> +};
> +
> +/*
> + * List of length ranges sorted on increasing threshold
> + *
> + * 25% of each of the legal key sizes (128, 192, 256 bits)
> + * plus 25% of illegal sizes in between 0 and 1024 bits.
> + */
> +static const struct len_range_sel aes_klen_template[] = {
> +	{
> +	.len_lo = 0,
> +	.len_hi = 15,
> +	.threshold = 25,
> +	}, {
> +	.len_lo = 16,
> +	.len_hi = 16,
> +	.threshold = 325,
> +	}, {
> +	.len_lo = 17,
> +	.len_hi = 23,
> +	.threshold = 350,
> +	}, {
> +	.len_lo = 24,
> +	.len_hi = 24,
> +	.threshold = 650,
> +	}, {
> +	.len_lo = 25,
> +	.len_hi = 31,
> +	.threshold = 675,
> +	}, {
> +	.len_lo = 32,
> +	.len_hi = 32,
> +	.threshold = 975,
> +	}, {
> +	.len_lo = 33,
> +	.len_hi = 128,
> +	.threshold = 1000,
> +	}
> +};

Can you please move these to be next to the test vectors for each algorithm, so
things are kept in one place for each algorithm?

Also, perhaps these should use the convention '.proportion_of_total', like
'struct testvec_config' already does, rather than '.threshold'?  That would be
more consistent with the existing test code, and would also make it slightly
easier to change the probabilities later.

E.g. if someone wanted to increase the probability of the first case and
decrease the probability of the last case, then with the '.threshold' convention
they'd have to change for every entry, but with the '.proportion_of_total'
convention they'd only have to change the first and last entries.

> +
> +/* 90% legal keys of size 8, rest illegal between 0 and 32 */
> +static const struct len_range_sel des_klen_template[] = {
> +	{
> +	.len_lo = 0,
> +	.len_hi = 7,
> +	.threshold = 50,
> +	}, {
> +	.len_lo = 8,
> +	.len_hi = 8,
> +	.threshold = 950,
> +	}, {
> +	.len_lo = 9,
> +	.len_hi = 32,
> +	.threshold = 1000,
> +	}
> +};
> +
> +/* 90% legal keys of size 24, rest illegal between 0 and 32 */
> +static const struct len_range_sel des3_klen_template[] = {
> +	{
> +	.len_lo = 0,
> +	.len_hi = 23,
> +	.threshold = 50,
> +	}, {
> +	.len_lo = 24,
> +	.len_hi = 24,
> +	.threshold = 950,
> +	}, {
> +	.len_lo = 25,
> +	.len_hi = 32,
> +	.threshold = 1000,
> +	}
> +};
> +
> +/*
> + * For HMAC's, favour the actual digest size for both key
> + * size and authenticator size, but do verify some tag
> + * truncation cases and some larger keys, including keys
> + * exceeding the block size.
> + */
> +
> +static const struct len_range_sel md5_klen_template[] = {

This really should be called "hmac_md5_klen", since md5 by itself is unkeyed.

Likewise for sha1, sha256, etc.

> +	{
> +	.len_lo = 0, /* Allow 0 here? */
> +	.len_hi = 15,
> +	.threshold = 50,
> +	}, {
> +	.len_lo = 16,
> +	.len_hi = 16,
> +	.threshold = 950,
> +	}, {
> +	.len_lo = 17,
> +	.len_hi = 256,
> +	.threshold = 1000,
> +	}
> +};
> +
> +static const struct len_range_sel md5_alen_template[] = {

Likewise here: it should be "hmac_md5".

Also, "alen" is used elsewhere in the test code, including in the test vectors
themselves, to mean the associated data length, *not* the authentication tag
length.  But here these lengths are for authentication tags.  So please use
"authsize".  Likewise for sha1, sha256, etc.

> +
> +static const struct len_range_sel aead_alen_template[] = {
> +	{
> +	.len_lo = 0,
> +	.len_hi = 0,
> +	.threshold = 200,
> +	}, {
> +	.len_lo = 1,
> +	.len_hi = 32,
> +	.threshold = 900,
> +	}, {
> +	.len_lo = 33,
> +	.len_hi = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN,
> +	.threshold = 1000,
> +	}
> +};

Is this for authenc or for all AEADs?  Likewise for aead_plen_template[].

Again, "alen" => "authsize".

- Eric
