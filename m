From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell - Update cache with input sg only when
 it is unmapped
Date: Thu, 28 Jul 2016 13:21:52 +0800
Message-ID: <20160728052152.GA676@gondor.apana.org.au>
References: <1469195184-4700-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49337 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbcG1FV6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 01:21:58 -0400
Content-Disposition: inline
In-Reply-To: <1469195184-4700-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> So far, the cache of the ahash requests was updated from the 'complete'
> operation. This complete operation is called from mv_cesa_tdma_process
> before the cleanup operation, which means that the content of req->src
> can be read and copied when it is still mapped. This commit fixes the
> issue by moving this cache update from mv_cesa_ahash_complete to
> mv_cesa_ahash_req_cleanup, so the copy is done once the sglist is
> unmapped.
> 
> Fixes: 1bf6682cb31d ("crypto: marvell - Add a complete operation for..")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
