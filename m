From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions
 optimized SHA1 & SHA256
Date: Sat, 12 Sep 2015 16:09:15 +0800
Message-ID: <20150912080914.GA12998@gondor.apana.org.au>
References: <1441929871.4322.15.camel@schen9-desk2.jf.intel.com>
 <1671234.vBOzL28The@tauon.atsec.com>
 <1441997372.4322.37.camel@schen9-desk2.jf.intel.com>
 <20150911.121509.844598934515668336.davem@davemloft.net>
 <1442002227.4322.45.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, smueller@chronox.de,
	hpa@zytor.com, sean.m.gulley@intel.com, mouli_7982@yahoo.com,
	vinodh.gopal@intel.com, james.guilford@intel.com,
	wajdi.k.feghali@intel.com, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442002227.4322.45.camel@schen9-desk2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 11, 2015 at 01:10:27PM -0700, Tim Chen wrote:
> 
> Mmmm..., this is a restructuring of the algorithms within
> the glue code into multiple drivers instead of one and exposing
> them all.  It is a bit orthogonal to the intention of this
> patch set.  I think it is better that I create a 
> separate patch on the glue code on top of this patch set 
> to implement this.
> 
> Herbert, do you agree with this approach?

Yes I think we can work on the individual crypto registration
separately from this patch-set.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
