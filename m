From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 6/7] crypto: omap-aes: Add support for GCM mode
Date: Wed, 8 Jul 2015 15:53:07 +0800
Message-ID: <20150708075307.GA19381@gondor.apana.org.au>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
 <1436283109-13318-7-git-send-email-lokeshvutla@ti.com>
 <20150708041838.GA12744@gondor.apana.org.au>
 <559CCA63.4080609@ti.com>
 <20150708074805.GA18991@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150708074805.GA18991@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 08, 2015 at 03:48:05PM +0800, Herbert Xu wrote:
> On Wed, Jul 08, 2015 at 12:29:47PM +0530, Lokesh Vutla wrote:
> >
> > >> +	if (req->assoclen + req->cryptlen == 0) {
> > >> +		scatterwalk_map_and_copy(ctx->auth_tag, req->dst, 0, authlen,
> > >> +					 1);
> > >> +		return 0;
> > >> +	}
> > > 
> > > How can this be right? Did you enable the selftest?
> > Why not? Self tests are passed for this case.
> > 
> > As per the equation given in GCM spec[1], we can see that
> > if assoclen and cryptlen is 0, then output of GCM  is just E(K, Y0)
> > where Y0 = IV||(0^31)1
> > I have E(K, Y0) calculated in previous step. And copying it
> > to destination if assoclen and cryptlen is 0.
> > 
> > Correct me if I am wrong.
> 
> It should be E(K, Y0) ^ GHASH(0).  So unless GHASH(0) == 0, your
> code doesn't work.

OK, GHASH(0) is indeed zero so I guess your code does work after
all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
