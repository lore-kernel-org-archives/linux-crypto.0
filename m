From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Thu, 10 Dec 2015 08:39:45 -0800
Message-ID: <1449765585.3057.9.camel@schen9-desk2.jf.intel.com>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
	 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
	 <20151209025242.GA24861@gondor.apana.org.au>
	 <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
	 <20151210014519.GA31692@gondor.apana.org.au>
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
In-Reply-To: <20151210014519.GA31692@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2015-12-10 at 09:45 +0800, Herbert Xu wrote:
> On Wed, Dec 09, 2015 at 09:23:14AM -0800, Tim Chen wrote:
> > 
> > This is an internal algorithm.  We are indeed casting the request
> > to the outer ablkcipher request when we do the async cipher walk.
> 
> The question remain: why does it have to be a blkcipher rather
> than an ablkcipher?
> 
> Cheers,

The inner cipher is called synchronously from the outer layer 
async cipher algorithm in cbc_mb_async_ablk_decrypt via

        err = crypto_blkcipher_crt(child_tfm)->decrypt(
                &rctx->desc, req->dst, req->src, req->nbytes);

or directly by mcrytpd_queue_worker via mcryptd_blkcipher_crypt. We
do not allow this operation to return something like EINPROGRESS.  

But the walk of the scattered list is done with async walk.

Thanks.

Tim
