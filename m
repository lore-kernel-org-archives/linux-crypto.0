From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/5] New algorithm testing infrastructure
Date: Mon, 4 Aug 2008 14:59:58 +0800
Message-ID: <20080804065958.GA8264@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47184 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762100AbYHDHAB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 03:00:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KPu2w-0001kY-KX
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 16:59:58 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KPu2w-00029v-00
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 14:59:58 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series introduces a new algorithm testing infrastructure
that ensures algorithms are tested where possible before they
are made available to the users.

Essentially it takes the existing tests from tcrypt and plugs
them into the registration function.

The actual mechanics is baed on notifications so theoretically
this could be moved to user-space later (or be augmented by it).

The main user-visible change is that tcrypt is now a lot quieter
when there is no error (and I mean quiet :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
