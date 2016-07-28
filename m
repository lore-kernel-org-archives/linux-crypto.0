From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell - Don't chain at DMA level when backlog
 is disabled
Date: Thu, 28 Jul 2016 13:19:46 +0800
Message-ID: <20160728051946.GA656@gondor.apana.org.au>
References: <1469191255-17443-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57464 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcG1FTv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 01:19:51 -0400
Content-Disposition: inline
In-Reply-To: <1469191255-17443-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> The flag CRYPTO_TFM_REQ_MAY_BACKLOG is optional and can be set from the
> user to put requests into the backlog queue when the main cryptographic
> queue is full. Before calling mv_cesa_tdma_chain we must check the value
> of the return status to be sure that the current request has been
> correctly queued or added to the backlog.
> 
> Fixes: 85030c5168f1 ("crypto: marvell - Add support for chaining...")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
