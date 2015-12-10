From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Thu, 10 Dec 2015 09:45:19 +0800
Message-ID: <20151210014519.GA31692@gondor.apana.org.au>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
 <20151209025242.GA24861@gondor.apana.org.au>
 <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:50207 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbLJBqX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 20:46:23 -0500
Content-Disposition: inline
In-Reply-To: <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 09:23:14AM -0800, Tim Chen wrote:
> 
> This is an internal algorithm.  We are indeed casting the request
> to the outer ablkcipher request when we do the async cipher walk.

The question remain: why does it have to be a blkcipher rather
than an ablkcipher?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
