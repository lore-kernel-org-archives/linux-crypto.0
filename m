From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - simplify and harden key parsing
Date: Fri, 20 Dec 2013 22:08:30 +0800
Message-ID: <20131220140830.GE356@gondor.apana.org.au>
References: <1387466855-4705-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46924 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422647Ab3LTOIc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Dec 2013 09:08:32 -0500
Content-Disposition: inline
In-Reply-To: <1387466855-4705-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 19, 2013 at 05:27:35PM +0200, Horia Geanta wrote:
> Use the common helper function crypto_authenc_extractkeys() for key
> parsing.
> Also fix the key buffer overflow condition: use split key pad length
> instead of authentication key length.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
