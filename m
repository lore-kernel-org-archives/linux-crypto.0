From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Wed, 18 Nov 2015 07:58:56 -0800
Message-ID: <1447862336.4933.36.camel@schen9-desk2.jf.intel.com>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
	 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
	 <20151117130633.GB8032@gondor.apana.org.au>
	 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
	 <20151118000748.GC13894@gondor.apana.org.au>
	 <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
	 <20151118050645.GA15327@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118050645.GA15327@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-11-18 at 13:06 +0800, Herbert Xu wrote:
> On Tue, Nov 17, 2015 at 04:30:14PM -0800, Tim Chen wrote:
> > On Wed, 2015-11-18 at 08:07 +0800, Herbert Xu wrote:
> > > On Tue, Nov 17, 2015 at 02:59:29PM -0800, Tim Chen wrote:
> > > >
> > > > Herbert, would you prefer me to use ablkcipher scatter walk instead,
> > > > assuming the overhead of both walk are about the same?
> > > 
> > > Well since you are going to potentially sleep in the middle of
> > > an operation I'd think ablkcipher is required, no?
> > 
> > We're using blkcipher walk in the implementation. 
> > As long as we use kmap and instead of kmap_atomic,
> > it allows us to sleep in the middle of the walk.
> 
> What if you were called from an atomic context, such as IPsec?
> 

IPSec will invoke this multi-buffer encrypt with async request.
The work is done in crypto daemon, so it wouldn't be in atomic
context.  But anyway, I'm okay with switching to ablkcipher walk,
as long as it doesn't incur too much more overhead than blkcipher
walk.

Tim
