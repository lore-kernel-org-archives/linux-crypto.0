From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function
 [ver #2]
Date: Fri, 24 Jun 2016 18:02:15 +0800
Message-ID: <20160624100215.GA19150@gondor.apana.org.au>
References: <alpine.OSX.2.20.1606230832370.22282@alvander-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, mathew.j.martineau@linux.intel.com,
	dwmw2@infradead.org, tadeusz.struk@intel.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.20.1606230832370.22282@alvander-mobl1.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
>
>> +     if (strcmp(encoding, "pkcs1") == 0) {
>> +             /* The data wangled by the RSA algorithm is typically padded
>> +              * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
>> +              * sec 8.2].
>> +              */
>> +             if (!hash_algo)
>> +                     n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
>> +                                  "pkcs1pad(%s)",
>> +                                  pkey->pkey_algo);
> 
> Did you see Herbert's patch that strips out non-hash pkcs1pad capabilities 
> (and the ensuing discussion)?
> 
> http://www.spinics.net/lists/linux-crypto/index.html#20432
> 
> I'm making use of pkcs1pad(rsa) with a TLS implementation, so it's good to 
> see it supported here.

Indeed I'm nacking this patch because it's exporting a purely
software algorithm to user-space for no good reason.  AFAICS
there is nothing in the pkcs1pad code that cannot be done in
user-space, even assuming that your private key is secret and
only accessible from the kernel.

IOW exporting the raw RSA might make sense because the key may
not be visible to user-space, or that the RSA might be implemented
in hardware offload, but there is no sane reason to export pkcs1pad.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
