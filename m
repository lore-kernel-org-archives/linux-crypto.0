From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][REPOST] crypto: caam - Fix missing init of '.type' in
 AEAD algos.
Date: Thu, 21 Mar 2013 17:55:00 +0800
Message-ID: <20130321095500.GE26931@gondor.apana.org.au>
References: <1363077564-25886-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:51216 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933524Ab3CUJzC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Mar 2013 05:55:02 -0400
Content-Disposition: inline
In-Reply-To: <1363077564-25886-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 12, 2013 at 02:09:24PM +0530, Vakul Garg wrote:
> Following AEAD algo templates are updated for '.type' initialization.
> 	(a) authenc(hmac(sha224),cbc(aes))
> 	(b) authenc(hmac(sha384),cbc(aes))
> 	(c) authenc(hmac(sha224),cbc(des3_ede))
> 	(d) authenc(hmac(sha384),cbc(des3_ede))
> 	(e) authenc(hmac(sha224),cbc(des))
> 	(f) authenc(hmac(sha384),cbc(des))
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> Reviewed-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Andy Fleming <afleming@freescale.com>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
