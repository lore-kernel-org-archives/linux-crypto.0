From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: caam: pair irq map and dispose in the same
 function
Date: Mon, 26 Jan 2015 13:56:25 +1100
Message-ID: <20150126025624.GG19796@gondor.apana.org.au>
References: <1421935249-27549-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	kim.phillips@freescale.com, horia.geanta@freescale.com
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39035 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbbAZC42 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 21:56:28 -0500
Content-Disposition: inline
In-Reply-To: <1421935249-27549-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 22, 2015 at 04:00:48PM +0200, Cristian Stoica wrote:
> irq_dispose_mapping is not called on all error paths from caam_jr_init.
> This takes care of several clean-up issues by performing resource
> clean-up and allocation at the same level.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
