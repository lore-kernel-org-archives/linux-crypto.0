From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Tue, 15 Dec 2015 10:36:39 -0800
Message-ID: <1450204599.3057.40.camel@schen9-desk2.jf.intel.com>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
	 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
	 <20151209025242.GA24861@gondor.apana.org.au>
	 <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
	 <20151210014519.GA31692@gondor.apana.org.au>
	 <1449765585.3057.9.camel@schen9-desk2.jf.intel.com>
	 <20151211032340.GC10399@gondor.apana.org.au>
	 <1449852880.3057.15.camel@schen9-desk2.jf.intel.com>
	 <20151212054806.GG17504@gondor.apana.org.au>
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
Received: from mga04.intel.com ([192.55.52.120]:25750 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933669AbbLOSgj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Dec 2015 13:36:39 -0500
In-Reply-To: <20151212054806.GG17504@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2015-12-12 at 13:48 +0800, Herbert Xu wrote:
> On Fri, Dec 11, 2015 at 08:54:40AM -0800, Tim Chen wrote:
> > Direct call I assume have less overhead.  Let me think about
> 
> static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
> {
> 	struct ablkcipher_tfm *crt =
> 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
> 	return crt->encrypt(req);
> }
> 
> I don't see any overhead there that you could eliminate by calling
> crt->encrypt directly.
> 
> Cheers,

Okay, I'll attempt to convert the inner cipher to ablk.  It may
take me a bit of time.

Thanks.

Tim
