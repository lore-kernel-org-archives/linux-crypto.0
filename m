From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 1/6] crypto: SHA1 multibuffer crypto hash
 infrastructure
Date: Fri, 20 Jun 2014 12:15:34 -0700
Message-ID: <1403291734.2970.587.camel@schen9-DESK>
References: <cover.1402491749.git.tim.c.chen@linux.intel.com>
	 <1402520625.2970.537.camel@schen9-DESK>
	 <20140620175751.GA2802@gondor.apana.org.au>
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
Received: from mga09.intel.com ([134.134.136.24]:62110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaFTTPg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 15:15:36 -0400
In-Reply-To: <20140620175751.GA2802@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2014-06-21 at 01:57 +0800, Herbert Xu wrote:
> On Wed, Jun 11, 2014 at 02:03:45PM -0700, Tim Chen wrote:
> >
> > diff --git a/crypto/shash.c b/crypto/shash.c
> > index 929058a..234ece0 100644
> > --- a/crypto/shash.c
> > +++ b/crypto/shash.c
> > @@ -271,6 +271,18 @@ static int shash_async_finup(struct ahash_request *req)
> >  	return shash_ahash_finup(req, desc);
> >  }
> >  
> > +int shash_ahash_mcryptd_digest(struct ahash_request *req,
> > +			       struct shash_desc *desc)
> > +{
> > +	int err;
> > +
> > +	err = crypto_shash_init(desc) ?:
> > +	      shash_ahash_mcryptd_finup(req, desc);
> > +
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_digest);
> > +
> 
> This bit causes your patch to not build for me.

This bit should have been moved to mcryptd.c.  Will fix and repost.

Tim
