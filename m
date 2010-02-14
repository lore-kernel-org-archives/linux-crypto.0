From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Possible bug: blkcipher_walk_done()
Date: Sun, 14 Feb 2010 13:47:56 +0800
Message-ID: <20100214054756.GA9688@gondor.apana.org.au>
References: <4B727F75.20305@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47818 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751425Ab0BNFsA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2010 00:48:00 -0500
Content-Disposition: inline
In-Reply-To: <4B727F75.20305@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 10, 2010 at 09:42:13AM +0000, Dmitry Kasatkin wrote:
> Hi,
> 
> It seems that there is a mistake in the implementation of
> 
> int blkcipher_walk_done(struct blkcipher_desc *desc,
>             struct blkcipher_walk *walk, int err)
> 
> blkcipher_walk_virt() will call crypto_kmap() to map page.
> 
> But in the case then err argument is < 0 and we cannot continue then
> blkcipher_walk_done() will not
> unmap the page.
> 
> What do you think?

Only blkcipher.c itself calls blkcipher_walk_done with err < 0.
Algorithms are not supposed to do that as this interface is only
for synchronous implementations.

When blkcipher.c uses it with err < 0 the pages are never mapped.

Do you need to be able to fail with a synchronous algorithm?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
