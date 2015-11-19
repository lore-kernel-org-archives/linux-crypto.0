From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Thu, 19 Nov 2015 17:39:20 +0800
Message-ID: <20151119093920.GA27655@gondor.apana.org.au>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
 <20151117130633.GB8032@gondor.apana.org.au>
 <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
 <20151118000748.GC13894@gondor.apana.org.au>
 <1447806614.4933.32.camel@schen9-desk2.jf.intel.com>
 <20151118050645.GA15327@gondor.apana.org.au>
 <1447862336.4933.36.camel@schen9-desk2.jf.intel.com>
 <20151119001201.GA24293@gondor.apana.org.au>
 <1447900770.4933.75.camel@schen9-desk2.jf.intel.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:42430 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbKSJkK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 04:40:10 -0500
Content-Disposition: inline
In-Reply-To: <1447900770.4933.75.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 18, 2015 at 06:39:30PM -0800, Tim Chen wrote:
>
> The __cbc-aes-aesni-mb algorithm is marked as internal algorithm 
> with flag CRYPTO_ALG_INTERNAL, so it should not be picked up by other
> algorithms and should only be invoked from mcryptd.

OK I guess that's fine then.

> Anyway, I've udpated the aes_cbc_mb code with ablkcipher helper.
> So I will be posting the new series with ablkcipher walk
> after testing is done.

Yes I think what you have is a very special case.  As you said
the ablkcipher interface should be fairly low in overhead so I
think it makes sense to use that instead of blkcipher.

> The __sha1-mb works in tandem with the outer layer of mcryptd 
> aysnc algorithm. It does the completion for the outer 
> async algorithm.  So as far as mcryptd is concerned, the
> inner algorithm is synchronous in the sense that it is done
> once it dispatch the job to __sha1-mb and don't have to worry about it.
> I don't think mcryptd check for the return value from __sha1-mb
> so it should be okay to return 0 instead of -EINPROGRESS.  
> I'll double check that.

If it can never return EINPROGRESS then we should probably remove
the code in it that says "return -EINPROGRESS".

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
