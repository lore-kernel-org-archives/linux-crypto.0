From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Tue, 17 Nov 2015 16:30:14 -0800
Message-ID: <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
	 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
	 <20151117130633.GB8032@gondor.apana.org.au>
	 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
	 <20151118000748.GC13894@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbbKRAaP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 19:30:15 -0500
In-Reply-To: <20151118000748.GC13894@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2015-11-18 at 08:07 +0800, Herbert Xu wrote:
> On Tue, Nov 17, 2015 at 02:59:29PM -0800, Tim Chen wrote:
> >
> > Herbert, would you prefer me to use ablkcipher scatter walk instead,
> > assuming the overhead of both walk are about the same?
> 
> Well since you are going to potentially sleep in the middle of
> an operation I'd think ablkcipher is required, no?

We're using blkcipher walk in the implementation. 
As long as we use kmap and instead of kmap_atomic,
it allows us to sleep in the middle of the walk.

Tim
