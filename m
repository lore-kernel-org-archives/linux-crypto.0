From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Wed, 18 Nov 2015 13:06:45 +0800
Message-ID: <20151118050645.GA15327@gondor.apana.org.au>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
 <20151117130633.GB8032@gondor.apana.org.au>
 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
 <20151118000748.GC13894@gondor.apana.org.au>
 <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44622 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbKRFH1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 00:07:27 -0500
Content-Disposition: inline
In-Reply-To: <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 04:30:14PM -0800, Tim Chen wrote:
> On Wed, 2015-11-18 at 08:07 +0800, Herbert Xu wrote:
> > On Tue, Nov 17, 2015 at 02:59:29PM -0800, Tim Chen wrote:
> > >
> > > Herbert, would you prefer me to use ablkcipher scatter walk instead,
> > > assuming the overhead of both walk are about the same?
> > 
> > Well since you are going to potentially sleep in the middle of
> > an operation I'd think ablkcipher is required, no?
> 
> We're using blkcipher walk in the implementation. 
> As long as we use kmap and instead of kmap_atomic,
> it allows us to sleep in the middle of the walk.

What if you were called from an atomic context, such as IPsec?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
