From: LABBE Corentin <clabbe@baylibre.com>
Subject: Re: [PATCH RFC 2/3] crypto: Implement a generic crypto statistics
Date: Thu, 21 Dec 2017 21:03:42 +0100
Message-ID: <20171221200342.GA954@Red>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
 <3836147.1hXCrOrRkh@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37993 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdLUUDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 15:03:46 -0500
Received: by mail-wm0-f68.google.com with SMTP id 64so17943229wme.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Dec 2017 12:03:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <3836147.1hXCrOrRkh@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 21, 2017 at 07:38:35AM +0100, Stephan Mueller wrote:
> Am Mittwoch, 20. Dezember 2017, 21:09:26 CET schrieb Corentin Labbe:
> 
> Hi Corentin,
> 
> > This patch implement a generic way to get statistics about all crypto
> > usages.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/Kconfig             |  11 +++
> >  crypto/ahash.c             |  18 +++++
> >  crypto/algapi.c            | 186
> > +++++++++++++++++++++++++++++++++++++++++++++ crypto/rng.c               | 
> >  3 +
> >  include/crypto/acompress.h |  10 +++
> >  include/crypto/akcipher.h  |  12 +++
> >  include/crypto/kpp.h       |   9 +++
> >  include/crypto/rng.h       |   5 ++
> >  include/crypto/skcipher.h  |   8 ++
> >  include/linux/crypto.h     |  22 ++++++
> >  10 files changed, 284 insertions(+)
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index d6e9b60fc063..69f1822a026b 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1781,6 +1781,17 @@ config CRYPTO_USER_API_AEAD
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
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index 3a35d67de7d9..93b56892f1b8 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -356,18 +356,36 @@ static int crypto_ahash_op(struct ahash_request *req,
> > 
> >  int crypto_ahash_final(struct ahash_request *req)
> >  {
> > +#ifdef CONFIG_CRYPTO_STATS
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +
> > +	tfm->base.__crt_alg->enc_cnt++;
> > +	tfm->base.__crt_alg->enc_tlen += req->nbytes;
> > +#endif
> >  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_ahash_final);
> > 
> >  int crypto_ahash_finup(struct ahash_request *req)
> >  {
> > +#ifdef CONFIG_CRYPTO_STATS
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +
> > +	tfm->base.__crt_alg->enc_cnt++;
> > +	tfm->base.__crt_alg->enc_tlen += req->nbytes;
> > +#endif
> >  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_ahash_finup);
> > 
> >  int crypto_ahash_digest(struct ahash_request *req)
> >  {
> > +#ifdef CONFIG_CRYPTO_STATS
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +
> > +	tfm->base.__crt_alg->enc_cnt++;
> > +	tfm->base.__crt_alg->enc_tlen += req->nbytes;
> > +#endif
> 
> This is ugly. May I ask that one inlne function is made that has these ifdefs 
> instead of adding them throughout multiple functions? This comment would apply 
> to the other instrumentation code below as well. The issue is that these 
> ifdefs should not be spread around through the code.
> 
> Besides, I would think that the use of normal integers is not thread-safe. 
> What about using atomic_t?

I will do all your suggestions.

> 
> >  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->digest);
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_ahash_digest);
> > diff --git a/crypto/algapi.c b/crypto/algapi.c
> > index b8f6122f37e9..4fca4576af78 100644
> > --- a/crypto/algapi.c
> > +++ b/crypto/algapi.c
> > @@ -20,11 +20,158 @@
> >  #include <linux/rtnetlink.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> > +#include <linux/kobject.h>
> > 
> >  #include "internal.h"
> > 
> >  static LIST_HEAD(crypto_template_list);
> > 
> > +#ifdef CONFIG_CRYPTO_STATS
> 
> Instead of ifdefing in the code, may I suggest adding a new file that is 
> compiled / not compiled via the Makefile?

I agree, it will be better.

> 
> > +static struct kobject *crypto_root_kobj;
> > +
> > +static struct kobj_type dynamic_kobj_ktype = {
> > +	.sysfs_ops      = &kobj_sysfs_ops,
> > +};
> > +
> > +static ssize_t fcrypto_priority(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%d\n", alg->cra_priority);
> > +}
> > +
> > +static ssize_t fcrypto_stat_enc_cnt(struct kobject *kobj,
> > +				    struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->enc_cnt);
> > +}
> > +
> > +static ssize_t fcrypto_stat_enc_tlen(struct kobject *kobj,
> > +				     struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->enc_tlen);
> > +}
> > +
> > +static ssize_t fcrypto_stat_dec_cnt(struct kobject *kobj,
> > +				    struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->dec_cnt);
> > +}
> > +
> > +static ssize_t fcrypto_stat_dec_tlen(struct kobject *kobj,
> > +				     struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->dec_tlen);
> > +}
> > +
> > +static ssize_t fcrypto_stat_verify_cnt(struct kobject *kobj,
> > +				       struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->verify_cnt);
> > +}
> > +
> > +static ssize_t fcrypto_stat_sign_cnt(struct kobject *kobj,
> > +				     struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	return snprintf(buf, 9, "%lu\n", alg->sign_cnt);
> > +}
> > +
> > +static ssize_t fcrypto_stat_type(struct kobject *kobj,
> > +				 struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct crypto_alg *alg;
> > +	u32 type;
> > +
> > +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> > +	type = (alg->cra_flags & CRYPTO_ALG_TYPE_MASK);
> > +	if (type == CRYPTO_ALG_TYPE_ABLKCIPHER ||
> > +	    type == CRYPTO_ALG_TYPE_SKCIPHER ||
> > +	    type == CRYPTO_ALG_TYPE_CIPHER ||
> > +	    type == CRYPTO_ALG_TYPE_BLKCIPHER
> > +		)
> > +		return snprintf(buf, 9, "cipher\n");
> 
> "skcipher" ?

Fixed!

Thanks for your review.
Regards
Corentin Labbe
