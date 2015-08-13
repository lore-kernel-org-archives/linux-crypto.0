From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Fix error handling in caam_rng_init()
Date: Thu, 13 Aug 2015 15:17:35 +0800
Message-ID: <20150813071735.GD21239@gondor.apana.org.au>
References: <1439390922-25091-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: vicki.milhoan@freescale.com, steve.cornelius@freescale.com,
	horia.geanta@freescale.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43510 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbbHMHRi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 03:17:38 -0400
Content-Disposition: inline
In-Reply-To: <1439390922-25091-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 12, 2015 at 11:48:42AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> In the error paths we should free the resources that were 
> previously acquired, so fix it accordingly.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
