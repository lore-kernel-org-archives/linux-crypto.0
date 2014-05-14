From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 2/6] crypto: SHA1 multibuffer crypto hash infrastructure
Date: Wed, 14 May 2014 09:08:48 -0700
Message-ID: <1400083728.2970.248.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
	 <1400023185.2970.239.camel@schen9-DESK>
	 <20140514001020.GA28593@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaENQIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 12:08:50 -0400
In-Reply-To: <20140514001020.GA28593@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-14 at 08:10 +0800, Herbert Xu wrote:
> On Tue, May 13, 2014 at 04:19:45PM -0700, Tim Chen wrote:
> >
> > diff --git a/crypto/shash.c b/crypto/shash.c
> > index 929058a..6f40424 100644
> > --- a/crypto/shash.c
> > +++ b/crypto/shash.c
> > @@ -229,6 +229,42 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
> >  }
> >  EXPORT_SYMBOL_GPL(shash_ahash_update);
> >  
> > +int shash_ahash_mcryptd_update(struct ahash_request *req,
> > +			       struct shash_desc *desc)
> > +{
> > +	struct crypto_shash *tfm = desc->tfm;
> > +	struct shash_alg *shash = crypto_shash_alg(tfm);
> > +
> > +	/* alignment is to be done by multi-buffer crypto algorithm if needed */
> > +
> > +	return shash->update(desc, NULL, 0);
> > +}
> > +EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_update);
> 
> Why are these functions in shash.c instead of mcryptd.c?

Sure, I can move them to mcryptd.c.

Tim
