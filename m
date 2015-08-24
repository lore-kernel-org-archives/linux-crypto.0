From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: caam: ctrl: Fix the error handling
Date: Mon, 24 Aug 2015 22:17:17 +0800
Message-ID: <20150824141717.GB31146@gondor.apana.org.au>
References: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34256 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbbHXORc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 10:17:32 -0400
Content-Disposition: inline
In-Reply-To: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 21, 2015 at 01:51:58PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> In the error path we should disable the resources that were previously
> acquired, so fix the error handling accordingly.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
