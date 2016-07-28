From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell - Fix memory leaks in TDMA chain for
 cipher requests
Date: Thu, 28 Jul 2016 13:18:59 +0800
Message-ID: <20160728051859.GA636@gondor.apana.org.au>
References: <1469191239-17296-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47537 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcG1FTc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 01:19:32 -0400
Content-Disposition: inline
In-Reply-To: <1469191239-17296-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> So far in mv_cesa_ablkcipher_dma_req_init, if an error is thrown while
> the tdma chain is built there is a memory leak. This issue exists
> because the chain is assigned later at the end of the function, so the
> cleanup function is called with the wrong version of the chain.
> 
> Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
