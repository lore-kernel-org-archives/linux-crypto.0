From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 16/16] crypto: hmac - Prehash ipad/opad
Date: Thu, 9 Jul 2009 13:13:14 +0800
Message-ID: <20090709051314.GA21444@gondor.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au> <E1MOldy-0005Xj-RH@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53148 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351AbZGIFNQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 01:13:16 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOlwZ-0006Se-9D
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 15:13:15 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MOlwY-0005aE-Il
	for linux-crypto@vger.kernel.org; Thu, 09 Jul 2009 13:13:14 +0800
Content-Disposition: inline
In-Reply-To: <E1MOldy-0005Xj-RH@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2009 at 12:54:02PM +0800, Herbert Xu wrote:
> crypto: hmac - Prehash ipad/opad
> 
> This patch uses crypto_shash_export/crypto_shash_import to prehash
> ipad/opad to speed up hmac.  This is partly based on a similar patch
> by Steffen Klassert.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I've dropped this for now because padlock doesn't work with the
current export/import model.  I'll work on a fix similar to the
one outlined earlier whereby we export/import the exact hash state
rather than the whole descriptor.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
