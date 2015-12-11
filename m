From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Fri, 11 Dec 2015 11:23:40 +0800
Message-ID: <20151211032340.GC10399@gondor.apana.org.au>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
 <20151209025242.GA24861@gondor.apana.org.au>
 <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
 <20151210014519.GA31692@gondor.apana.org.au>
 <1449765585.3057.9.camel@schen9-desk2.jf.intel.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449765585.3057.9.camel@schen9-desk2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 10, 2015 at 08:39:45AM -0800, Tim Chen wrote:
>
> The inner cipher is called synchronously from the outer layer 
> async cipher algorithm in cbc_mb_async_ablk_decrypt via
> 
>         err = crypto_blkcipher_crt(child_tfm)->decrypt(
>                 &rctx->desc, req->dst, req->src, req->nbytes);

We should avoid bypassing the API and directly calling crypto
driver functions like this.

What if you made it a proper ablkcipher and just called it through
the API?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
