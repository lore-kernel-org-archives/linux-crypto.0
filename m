From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Tue, 17 Nov 2015 21:06:33 +0800
Message-ID: <20151117130633.GB8032@gondor.apana.org.au>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
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
In-Reply-To: <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 29, 2015 at 03:21:03PM -0700, Tim Chen wrote:
> 
> c) Add support to crypto scatterwalk support that can sleep during
> encryption operation, as we may have buffers for jobs in data lanes
> that are half-finished, waiting for additional jobs to come to fill
> empty lanes before we start the encryption again.  Therefore, we need to
> enhance crypto walk with the option to map data buffers non-atomically.
> This is done by algorithms run from crypto daemon who knows it is safe
> to do so as it can save and restore FPU state in correct context.

What about the existing ablkcipher scatterwalk helpers?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
