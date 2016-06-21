From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/5] crypto: Fix IPsec reordering caused by cryptd
Date: Tue, 21 Jun 2016 16:53:21 +0800
Message-ID: <20160621085321.GA21044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Raj Ammanur <rammanur@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60796 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcFUIyW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:54:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I finally got around to working on this.  I quickly gave up on the
notion of hijacking the queued requests as we may end up overwhelming
our caller.

So the solution is the obvious one of using cryptd as long as there
are requests queued there belonging to the same tfm.  This is
totally untested so please tread carefully.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
