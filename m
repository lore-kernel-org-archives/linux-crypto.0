From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - avoid kernel warnings on probe failure
Date: Tue, 9 Aug 2016 19:03:32 +0800
Message-ID: <20160809110332.GG7099@gondor.apana.org.au>
References: <E1bX1UI-0006vt-K7@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <fabio.estevam@freescale.com>, horia.geanta@nxp.com,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42691 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcHILDr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 07:03:47 -0400
Content-Disposition: inline
In-Reply-To: <E1bX1UI-0006vt-K7@rmk-PC.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:30:10AM +0100, Russell King wrote:
> While debugging setkey issues, the following warnings were found while
> trying to reinsert the caam module.  Fix this by avoiding the duplicated
> cleanup in the probe path after caam_remove(), which has already cleaned
> up the resources.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
