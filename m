From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/5] crypto: Multi-buffer encryptioin infrastructure
 support
Date: Tue, 17 Nov 2015 14:59:29 -0800
Message-ID: <1447801169.4933.28.camel@schen9-desk2.jf.intel.com>
References: <cover.1446158797.git.tim.c.chen@linux.intel.com>
	 <1446157263.14635.15.camel@schen9-desk2.jf.intel.com>
	 <20151117130633.GB8032@gondor.apana.org.au>
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
In-Reply-To: <20151117130633.GB8032@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2015-11-17 at 21:06 +0800, Herbert Xu wrote:
> On Thu, Oct 29, 2015 at 03:21:03PM -0700, Tim Chen wrote:
> > 
> > c) Add support to crypto scatterwalk support that can sleep during
> > encryption operation, as we may have buffers for jobs in data lanes
> > that are half-finished, waiting for additional jobs to come to fill
> > empty lanes before we start the encryption again.  Therefore, we need to
> > enhance crypto walk with the option to map data buffers non-atomically.
> > This is done by algorithms run from crypto daemon who knows it is safe
> > to do so as it can save and restore FPU state in correct context.
> 
> What about the existing ablkcipher scatterwalk helpers?
> 
> Cheers,

I suppose blkcipher was originally used because we 
were under the impression that there are less buffer copying
and less allocation of intermediate buffers
with blkcipher walk. 

But looking at the blkcipher walk and ablkcipher
walk code more carefully now, I am not sure that's really true
as it seems like ablkcipher keep all intermediate buffers till the
end and copy them to destination in one shot while blkcipher does
that at walk of every chunk.  The advantage of blkcipher is
you don't have as many outstanding buffers in a list.  If there's
really not much speed difference, I can try to use ablkcipher.

Herbert, would you prefer me to use ablkcipher scatter walk instead,
assuming the overhead of both walk are about the same?

Thanks.

Tim
