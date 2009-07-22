From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ahash - Use GFP_KERNEL on allocation if the
	request can sleep
Date: Wed, 22 Jul 2009 20:23:07 +0800
Message-ID: <20090722122307.GA463@gondor.apana.org.au>
References: <20090722095123.GL20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40194 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753712AbZGVMXI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 08:23:08 -0400
Content-Disposition: inline
In-Reply-To: <20090722095123.GL20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2009 at 11:51:23AM +0200, Steffen Klassert wrote:
> ahash_op_unaligned() and ahash_def_finup() allocate memory atomically,
> regardless whether the request can sleep or not. This patch changes
> this to use GFP_KERNEL if the request can sleep.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Doh, I don't know what I was thinking when I wrote that :)

Thanks for catching this, I'll apply the patch.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
