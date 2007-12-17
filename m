From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/8] Fix AEAD bugs when tested with IPsec
Date: Mon, 17 Dec 2007 18:30:37 +0800
Message-ID: <20071217103037.GA11988@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4824 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbXLQKaj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:30:39 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DF7-0008Uc-Qa
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:30:38 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J4DF7-00037z-00
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 18:30:37 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Further testing using IPsec revealed a number of bugs with the
AEAD API and the algorithms.  These patches fix those problems.

I'll recombine them with previous patches where appropriate.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
