From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Date: Thu, 15 Jan 2009 20:49:26 +1100
Message-ID: <20090115094926.GA410@gondor.apana.org.au>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com> <20090115084750.GA32239@gondor.apana.org.au> <1232011307.5937.204.camel@yhuang-dev.sh.intel.com> <20090115092314.GA32559@gondor.apana.org.au> <1232011851.5937.208.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761782AbZAOJtt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1232011851.5937.208.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 15, 2009 at 05:30:51PM +0800, Huang Ying wrote:
>
> > > Why do we need this check? Someone else may register cryptd template?
> > > Which error number should be return? -EINVAL?
> > 
> > -ENOMEM for example.
> 
> You mean something as follow:
> 
> if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module != THIS_MODULE)
>         return ERR_PTR(-ENOMEM);

No I meant that crypto_alloc_ablkcipher can return -ENOMEM.

If the check fails you should return -EINVAL.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
