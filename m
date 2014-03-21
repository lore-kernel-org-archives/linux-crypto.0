From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto] crypto: caam - add missing key_dma unmap
Date: Fri, 21 Mar 2014 22:40:31 +0800
Message-ID: <20140321144031.GC25820@gondor.apana.org.au>
References: <1394812110-14139-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44481 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbaCUOkc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 10:40:32 -0400
Content-Disposition: inline
In-Reply-To: <1394812110-14139-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 14, 2014 at 05:48:30PM +0200, Horia Geanta wrote:
> (struct caam_ctx) ctx->key_dma needs to be unmapped
> when context is cleaned up.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
