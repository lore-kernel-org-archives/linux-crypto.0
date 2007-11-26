From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Add GCM/GMAC support to cryptoapi
Date: Mon, 26 Nov 2007 22:22:22 +0800
Message-ID: <20071126142222.GA28022@gondor.apana.org.au>
References: <Pine.LNX.4.64.0711251601100.3663@antarct>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2461 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753704AbXKZOW2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 09:22:28 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711251601100.3663@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 25, 2007 at 04:22:53PM +0200, Mikko Herranen wrote:
> These patches add GCM/GMAC support to the cryptoapi.
> 
> The first patch adds AEAD support to tcrypt, as it's currently not
> possible to do combined encryption/authentication tests. The
> second patch adds GCM to cryptoapi.

Both patches applied.  Thanks a lot Mikko!

I made one little change in the Kconfig and turned the depends
on CTR into a select.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
