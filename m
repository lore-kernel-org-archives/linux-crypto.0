From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Fri, 25 Sep 2015 16:56:10 +0900
Message-ID: <20150925075610.GD865@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921061817.GC5313@swordfish>
 <20150925052617.GB7158@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150925052617.GB7158@js1304-P5Q-DELUXE>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (09/25/15 14:26), Joonsoo Kim wrote:
[..]
> > > +struct crypto_comp *crypto_alloc_comp_noctx(const char *alg_name,
> > > +					u32 type, u32 mask);
> > > +
> > 
> > this should be EXPORT_SYMBOL_GPL().
> > 
> 
> Will do in next version.
> 

so you want to go with _noctx() callbacks implementation?
that CRYPTO_ALG_TFM_MAY_SHARE flag looks quite simple to
me. or you guys hate it?

	-ss
