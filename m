From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: retrieve private ctx aligned
Date: Thu, 2 Aug 2007 20:44:38 +0800
Message-ID: <20070802124437.GA14399@gondor.apana.org.au>
References: <20070802074758.GB22601@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4029 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757414AbXHBMol (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 08:44:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGa2h-0001h3-0X
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 22:44:39 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGa2g-0003uX-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 20:44:38 +0800
Content-Disposition: inline
In-Reply-To: <20070802074758.GB22601@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 09:47:58AM +0200, Sebastian Siewior wrote:
> This is function does the same thing for ablkcipher that is done for
> blkcipher by crypto_blkcipher_ctx_aligned(): it returns an aligned
> address of the private ctx.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
