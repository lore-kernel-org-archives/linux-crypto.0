From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - pass the correct buffer length
Date: Fri, 4 Dec 2015 22:41:38 +0800
Message-ID: <20151204144138.GD17703@gondor.apana.org.au>
References: <1448888638-7921-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@freescale.com, linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53531 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbbLDOlm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:41:42 -0500
Content-Disposition: inline
In-Reply-To: <1448888638-7921-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 30, 2015 at 11:03:58AM -0200, Fabio Estevam wrote:
> When buffer 0 is used we should use buflen_0 instead of buflen_1.
> 
> Fix it.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
