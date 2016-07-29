From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell: Don't copy IV vectors from the _process
 op for ciphers
Date: Fri, 29 Jul 2016 18:37:08 +0800
Message-ID: <20160729103708.GA12568@gondor.apana.org.au>
References: <1469699983-21370-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56533 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcG2Khf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 06:37:35 -0400
Content-Disposition: inline
In-Reply-To: <1469699983-21370-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> The IV output vectors should only be copied from the _complete operation
> and not from the _process operation, i.e only from the operation that is
> designed to copy the result of the request to the right location. This
> copy is already done in the _complete operation, so this commit removes
> the duplicated code in the _process op.
> 
> Fixes: 3610d6cd5231 ("crypto: marvell - Add a complete...")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
