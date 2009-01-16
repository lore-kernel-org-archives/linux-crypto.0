From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 14:26:39 +1100
Message-ID: <20090116032639.GA10390@gondor.apana.org.au>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com> <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com> <1232068858.5937.222.camel@yhuang-dev.sh.intel.com> <20090116015356.GA9822@gondor.apana.org.au> <1232073422.13948.3.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: roel kluin <roel.kluin@gmail.com>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37516 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229AbZAPD0r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 22:26:47 -0500
Content-Disposition: inline
In-Reply-To: <1232073422.13948.3.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 16, 2009 at 10:37:02AM +0800, Huang Ying wrote:
>
> But after checking blkcipher_walk_done() in 2.6.28, If input argument
> err != 0 and walk->flags & BLKCIPHER_WALK_SLOW != 0, when
> blkcipher_walk_done() return non-zero, walk->nbytes != 0. So I think it
> is a little fragile to use walk->nbytes == 0 indicate error.

Right, that's a bug.  Although this case shouldn't occur unless
wer have a buggy algorithm (that's why it's a WARN_ON).  But as
we're handling it anyway, we should ensure that the result is sane.

crypt: blkcipher - Fix WARN_ON handling in walk_done

When we get left-over bits from a slow walk, it means that the
underlying cipher has gone troppo.  However, as we're handling
that case we should ensure that the caller terminates the walk.

This patch does this by setting walk->nbytes to zero.

Reported-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 4a7e65c..d70a41c 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -124,6 +124,7 @@ int blkcipher_walk_done(struct blkcipher_desc *desc,
 	scatterwalk_done(&walk->in, 0, nbytes);
 	scatterwalk_done(&walk->out, 1, nbytes);
 
+err:
 	walk->total = nbytes;
 	walk->nbytes = nbytes;
 
@@ -132,7 +133,6 @@ int blkcipher_walk_done(struct blkcipher_desc *desc,
 		return blkcipher_walk_next(desc, walk);
 	}
 
-err:
 	if (walk->iv != desc->info)
 		memcpy(desc->info, walk->iv, crypto_blkcipher_ivsize(tfm));
 	if (walk->buffer != walk->page)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
