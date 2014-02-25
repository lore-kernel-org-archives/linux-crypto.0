From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp: Fix platform_get_irq() error handling
Date: Tue, 25 Feb 2014 20:18:15 +0800
Message-ID: <20140225121815.GF12216@gondor.apana.org.au>
References: <1392347084-7801-1-git-send-email-festevam@gmail.com>
 <201402140922.03163.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58567 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaBYMSW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:18:22 -0500
Content-Disposition: inline
In-Reply-To: <201402140922.03163.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 14, 2014 at 09:22:03AM +0100, Marek Vasut wrote:
> On Friday, February 14, 2014 at 04:04:44 AM, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > We should test the error case for each platform_get_irq() assignment and
> > propagate the error accordingly.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Marek Vasut <marex@denx.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
