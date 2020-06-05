Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEC3C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F186720823
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgFEGth (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 02:49:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40848 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFEGth (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 02:49:37 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jh6AV-0007M4-4g; Fri, 05 Jun 2020 16:49:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2020 16:49:31 +1000
Date:   Fri, 5 Jun 2020 16:49:31 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200605064931.GB595@gondor.apana.org.au>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605054049.GT2667@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605054049.GT2667@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 04, 2020 at 10:40:49PM -0700, Eric Biggers wrote:
> On Thu, Jun 04, 2020 at 04:33:24PM +1000, Herbert Xu wrote:
> > +static void crc_t10dif_rehash(struct work_struct *work)
> > +{
> > +	struct crypto_shash *new, *old;
> > +
> >  	mutex_lock(&crc_t10dif_mutex);
> >  	old = rcu_dereference_protected(crct10dif_tfm,
> >  					lockdep_is_held(&crc_t10dif_mutex));
> >  	if (!old) {
> >  		mutex_unlock(&crc_t10dif_mutex);
> > -		return 0;
> > +		return;
> >  	}
> >  	new = crypto_alloc_shash("crct10dif", 0, 0);
> >  	if (IS_ERR(new)) {
> >  		mutex_unlock(&crc_t10dif_mutex);
> > -		return 0;
> > +		return;
> >  	}
> >  	rcu_assign_pointer(crct10dif_tfm, new);
> >  	mutex_unlock(&crc_t10dif_mutex);
> >  
> >  	synchronize_rcu();
> >  	crypto_free_shash(old);
> > -	return 0;
> > +	return;
> >  }
> 
> The last return statement is unnecessary.

Thanks I'll change this.

> >  static int __init crc_t10dif_mod_init(void)
> >  {
> > +	struct crypto_shash *tfm;
> > +
> > +	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
> >  	crypto_register_notifier(&crc_t10dif_nb);
> > -	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
> > -	if (IS_ERR(crct10dif_tfm)) {
> > +	mutex_lock(&crc_t10dif_mutex);
> > +	tfm = crypto_alloc_shash("crct10dif", 0, 0);
> > +	if (IS_ERR(tfm)) {
> >  		static_key_slow_inc(&crct10dif_fallback);
> > -		crct10dif_tfm = NULL;
> > +		tfm = NULL;
> >  	}
> > +	RCU_INIT_POINTER(crct10dif_tfm, tfm);
> > +	mutex_unlock(&crc_t10dif_mutex);
> >  	return 0;
> >  }
> 
> Wouldn't it make more sense to initialize crct10dif_tfm before registering the
> notifier?  Then the mutex wouldn't be needed.

Right the mutex wouldn't be needed, but you open up a race window
where a better algorithm could be registered in between the first
crypto_alloc call and the notifier registration.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
