From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Check for CAAM block presence before
 registering with crypto layer
Date: Fri, 21 Mar 2014 22:41:19 +0800
Message-ID: <20140321144118.GF25820@gondor.apana.org.au>
References: <1395384261-30377-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47876 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbaCUOlV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 10:41:21 -0400
Content-Disposition: inline
In-Reply-To: <1395384261-30377-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 21, 2014 at 12:14:21PM +0530, Ruchika Gupta wrote:
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
