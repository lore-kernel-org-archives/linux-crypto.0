From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Wed, 18 Nov 2015 18:39:30 -0800
Message-ID: <1447900770.4933.75.camel@schen9-desk2.jf.intel.com>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
	 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
	 <20151117130633.GB8032@gondor.apana.org.au>
	 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
	 <20151118000748.GC13894@gondor.apana.org.au>
	 <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
	 <20151118050645.GA15327@gondor.apana.org.au>
	 <1447862336.4933.36.camel@schen9-desk2.jf.intel.com>
	 <20151119001201.GA24293@gondor.apana.org.au>
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
Received: from mga02.intel.com ([134.134.136.20]:49012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbbKSCjd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 21:39:33 -0500
In-Reply-To: <20151119001201.GA24293@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-11-19 at 08:12 +0800, Herbert Xu wrote:
> On Wed, Nov 18, 2015 at 07:58:56AM -0800, Tim Chen wrote:
> >
> > IPSec will invoke this multi-buffer encrypt with async request.
> > The work is done in crypto daemon, so it wouldn't be in atomic
> > context.  But anyway, I'm okay with switching to ablkcipher walk,
> > as long as it doesn't incur too much more overhead than blkcipher
> > walk.
> 
> What if some other user called the blkcipher interface in an atomic
> context? You can't guarantee that your algorithm is only picked up
> through the ablkcipher interface, unless of course you do something
> like __driver-ctr-aes-aesni.

The __cbc-aes-aesni-mb algorithm is marked as internal algorithm 
with flag CRYPTO_ALG_INTERNAL, so it should not be picked up by other
algorithms and should only be invoked from mcryptd.

Anyway, I've udpated the aes_cbc_mb code with ablkcipher helper.
So I will be posting the new series with ablkcipher walk
after testing is done.

> 
> Hmm I was just looking at the sha_mb code and something doesn't
> look right.  For instance, can sha1_mb_update ever return
> -EINPROGRESS? This would be wrong as it's registered as an shash
> algorithm.

The __sha1-mb works in tandem with the outer layer of mcryptd 
aysnc algorithm. It does the completion for the outer 
async algorithm.  So as far as mcryptd is concerned, the
inner algorithm is synchronous in the sense that it is done
once it dispatch the job to __sha1-mb and don't have to worry about it.
I don't think mcryptd check for the return value from __sha1-mb
so it should be okay to return 0 instead of -EINPROGRESS.  
I'll double check that.

Tim
