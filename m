From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][v2] crypto: caam - Check for CAAM block presence before
 registering with crypto layer
Date: Thu, 10 Jul 2014 16:59:58 +0800
Message-ID: <20140710085958.GA15621@gondor.apana.org.au>
References: <1404709932-19242-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, alexandru.porosanu@freescale.com,
	horia.geanta@freescale.com, NiteshNarayanLal@freescale.com,
	vakul@freescale.com, marex@denx.de, kim.phillips@freescale.com,
	pebolle@tiscali.nl
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44032 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJJAH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2014 05:00:07 -0400
Content-Disposition: inline
In-Reply-To: <1404709932-19242-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 07, 2014 at 10:42:12AM +0530, Ruchika Gupta wrote:
> The layer which registers with the crypto API should check for the presence of
> the CAAM device it is going to use.  If the platform's device tree doesn't have
> the required CAAM node, the layer should return an error and not register the
> algorithms with crypto API layer.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
