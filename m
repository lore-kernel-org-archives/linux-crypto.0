From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: mxs-dcp: Use devm_kzalloc()
Date: Sun, 9 Feb 2014 17:22:02 +0800
Message-ID: <20140209092201.GF19429@gondor.apana.org.au>
References: <1390955772-6936-1-git-send-email-festevam@gmail.com>
 <201401290158.15327.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:32971 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBIJWD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:22:03 -0500
Content-Disposition: inline
In-Reply-To: <201401290158.15327.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 29, 2014 at 01:58:15AM +0100, Marek Vasut wrote:
> On Wednesday, January 29, 2014 at 01:36:11 AM, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Using devm_kzalloc() can make the code cleaner.
> > 
> > While at it, remove the devm_kzalloc error message as there is standard OOM
> > message done by the core.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Marek Vasut <marex@denx.de>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
