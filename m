From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Sat, 12 Dec 2015 13:48:06 +0800
Message-ID: <20151212054806.GG17504@gondor.apana.org.au>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
 <20151209025242.GA24861@gondor.apana.org.au>
 <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
 <20151210014519.GA31692@gondor.apana.org.au>
 <1449765585.3057.9.camel@schen9-desk2.jf.intel.com>
 <20151211032340.GC10399@gondor.apana.org.au>
 <1449852880.3057.15.camel@schen9-desk2.jf.intel.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:34452 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbLLFsq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:48:46 -0500
Content-Disposition: inline
In-Reply-To: <1449852880.3057.15.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 11, 2015 at 08:54:40AM -0800, Tim Chen wrote:
> Direct call I assume have less overhead.  Let me think about

static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
{
	struct ablkcipher_tfm *crt =
		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
	return crt->encrypt(req);
}

I don't see any overhead there that you could eliminate by calling
crt->encrypt directly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
