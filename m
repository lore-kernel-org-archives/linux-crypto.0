From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: [sha] Restructure x86 sha trasforms glue
 code to expose all available transform algorithms
Date: Fri, 18 Sep 2015 22:07:24 +0800
Message-ID: <20150918140724.GJ9249@gondor.apana.org.au>
References: <cover.1442451609.git.tim.c.chen@linux.intel.com>
 <1442446472.6240.1.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45473 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbIROHz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:07:55 -0400
Content-Disposition: inline
In-Reply-To: <1442446472.6240.1.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 16, 2015 at 04:34:32PM -0700, Tim Chen wrote:
> 
> During the posting of patches of new x86 sha1 and sha256 algorithms based
> on new x86 SHA extensions, I got requests to expose all the available
> sha transform implementations that are based on SSSE3, AVX and AVX2 as
> separate individual crypto driver.  The result is this series of patches.
> I've also performed clean up of the glue code to make them easier to
> maintain.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
