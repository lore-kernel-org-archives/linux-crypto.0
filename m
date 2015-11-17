From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Tue, 17 Nov 2015 22:09:38 +0800
Message-ID: <20151117140938.GH9546@gondor.apana.org.au>
References: <1447420229-17911-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
	maxime.ripard@free-electrons.com, wens@csie.org,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447420229-17911-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 13, 2015 at 02:10:28PM +0100, LABBE Corentin wrote:
> sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
> Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> made impossible to load them without giving statesize. This patch
> specifiy statesize for sha1 and md5.
> 
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org> # v4.3+
> Tested-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patch applied to cryptodev as I don't think it needs to go into
stable straight away.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
