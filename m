From: LABBE Corentin <clabbe@baylibre.com>
Subject: Re: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Fri, 12 Jan 2018 10:07:30 +0100
Message-ID: <20180112090730.GA15630@Red>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
 <1515700617-3513-2-git-send-email-clabbe@baylibre.com>
 <3297958.ndliyBY1jk@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3297958.ndliyBY1jk@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 12, 2018 at 07:49:43AM +0100, Stephan Mueller wrote:
> Am Donnerstag, 11. Januar 2018, 20:56:56 CET schrieb Corentin Labbe:
> 
> Hi Corentin,
> 
> > This patch implement a generic way to get statistics about all crypto
> > usages.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/Kconfig                  | 11 ++++++++
> >  crypto/ablkcipher.c             |  9 +++++++
> >  crypto/acompress.c              |  9 +++++++
> >  crypto/aead.c                   | 10 ++++++++
> >  crypto/ahash.c                  |  8 ++++++
> >  crypto/akcipher.c               | 13 ++++++++++
> >  crypto/algapi.c                 |  6 +++++
> >  crypto/blkcipher.c              |  9 +++++++
> >  crypto/crypto_user.c            | 28 +++++++++++++++++++++
> >  crypto/kpp.c                    |  7 ++++++
> >  crypto/rng.c                    |  8 ++++++
> >  crypto/scompress.c              |  9 +++++++
> >  crypto/shash.c                  |  5 ++++
> >  crypto/skcipher.c               |  9 +++++++
> >  include/crypto/acompress.h      | 22 ++++++++++++++++
> >  include/crypto/aead.h           | 22 ++++++++++++++++
> >  include/crypto/akcipher.h       | 42 +++++++++++++++++++++++++++++++
> >  include/crypto/hash.h           | 21 ++++++++++++++++
> >  include/crypto/kpp.h            | 28 +++++++++++++++++++++
> >  include/crypto/rng.h            | 17 +++++++++++++
> >  include/crypto/skcipher.h       | 22 ++++++++++++++++
> >  include/linux/crypto.h          | 56
> > +++++++++++++++++++++++++++++++++++++++++ include/uapi/linux/cryptouser.h |
> > 34 +++++++++++++++++++++++++
> >  23 files changed, 405 insertions(+)
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 971d558494c3..3b88fba14b59 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1780,6 +1780,17 @@ config CRYPTO_USER_API_AEAD
> >  	  This option enables the user-spaces interface for AEAD
> >  	  cipher algorithms.
> > 
> > +config CRYPTO_STATS
> > +	bool "Crypto usage statistics for User-space"
> > +	help
> > +	  This option enables the gathering of crypto stats.
> > +	  This will collect:
> > +	  - encrypt/decrypt size and numbers of symmeric operations
> > +	  - compress/decompress size and numbers of compress operations
> > +	  - size and numbers of hash operations
> > +	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
> > +	  - generate/seed numbers for rng operations
> > +
> >  config CRYPTO_HASH_INFO
> >  	bool
> > 

[...]
> >   * crypto_acomp_compress() -- Invoke asynchronous compress operation
> >   *
> > @@ -247,6 +267,7 @@ static inline int crypto_acomp_compress(struct acomp_req
> > *req) {
> >  	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> > 
> > +	crypto_stat_compress(req);
> >  	return tfm->compress(req);
> 
> In general: should'nt the statistics increment only happen if the associated 
> operation was successful?
> 

I will do it.
This bring also a possibility to get errors counters.

> >  /**
> >   * crypto_ahash_finup() - update and finalize message digest
> >   * @req: reference to the ahash_request handle that holds all information
> > @@ -519,6 +538,8 @@ static inline int crypto_ahash_init(struct ahash_request
> > *req) */
> >  static inline int crypto_ahash_update(struct ahash_request *req)
> >  {
> > +
> > +	crypto_stat_ahash_update(req);
> >  	return crypto_ahash_reqtfm(req)->update(req);
> 
> In case you roll another update: please remove the blank line.

Ok
 
> > diff --git a/include/uapi/linux/cryptouser.h
> > b/include/uapi/linux/cryptouser.h index 19bf0ca6d635..15e51ccb3679 100644
> > --- a/include/uapi/linux/cryptouser.h
> > +++ b/include/uapi/linux/cryptouser.h
> > @@ -73,6 +73,8 @@ struct crypto_report_hash {
> >  	char type[CRYPTO_MAX_NAME];
> >  	unsigned int blocksize;
> >  	unsigned int digestsize;
> > +	__u64 stat_hash;
> 
> Why do you use __u64? The atomic_t variable is an int, i.e. 32 bit. Thus I 
> would think that __u32 would suffice?

You are right, I will downgrade to __u32
But I think I will set len stats to atomic64/__u64 and keep count on atomic_t/__u32.

> 
> 
> > +	__u64 stat_hash_tlen;
> >  };
> 
> What I am slightly unsure here is: how should user space detect whether these 
> additional parameters are part of the NETLINK_USER API or not? I use that 
> interface in my libkcapi whose binary may be used on multiple different kernel 
> versions. How should that library operate if one kernel has these parameters 
> and another does not?
> 

Userspace could check for kernel version and know if stat are present or not.
Another way is to add a new netlink request.

Thanks for your review.
Regards
Corentin Labbe
