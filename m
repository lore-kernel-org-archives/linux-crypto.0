From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Remove unneeded 'ret' variable
Date: Thu, 13 Aug 2015 15:17:47 +0800
Message-ID: <20150813071747.GE21239@gondor.apana.org.au>
References: <1439401178-3583-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@freescale.com, vicki.milhoan@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49610 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbHMHRu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 03:17:50 -0400
Content-Disposition: inline
In-Reply-To: <1439401178-3583-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 12, 2015 at 02:39:38PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Variable 'ret' is only used for returning the value 0.
> 
> We can make it simpler and just return 0 instead.
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/misc/returnvar.cocci.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
