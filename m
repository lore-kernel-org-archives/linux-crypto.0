From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Thu, 19 Nov 2015 08:12:01 +0800
Message-ID: <20151119001201.GA24293@gondor.apana.org.au>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
 <20151117130633.GB8032@gondor.apana.org.au>
 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
 <20151118000748.GC13894@gondor.apana.org.au>
 <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
 <20151118050645.GA15327@gondor.apana.org.au>
 <1447862336.4933.36.camel@schen9-desk2.jf.intel.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:38918 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbbKSANI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 19:13:08 -0500
Content-Disposition: inline
In-Reply-To: <1447862336.4933.36.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 18, 2015 at 07:58:56AM -0800, Tim Chen wrote:
>
> IPSec will invoke this multi-buffer encrypt with async request.
> The work is done in crypto daemon, so it wouldn't be in atomic
> context.  But anyway, I'm okay with switching to ablkcipher walk,
> as long as it doesn't incur too much more overhead than blkcipher
> walk.

What if some other user called the blkcipher interface in an atomic
context? You can't guarantee that your algorithm is only picked up
through the ablkcipher interface, unless of course you do something
like __driver-ctr-aes-aesni.

Hmm I was just looking at the sha_mb code and something doesn't
look right.  For instance, can sha1_mb_update ever return
-EINPROGRESS? This would be wrong as it's registered as an shash
algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
