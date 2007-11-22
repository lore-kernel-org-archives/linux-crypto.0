From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/5] Add generic crypto_xor/crypto_inc functions
Date: Thu, 22 Nov 2007 16:36:56 +0800
Message-ID: <20071122083656.GB7368@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4625 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbXKVIsG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:06 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j9-0008A8-7d
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:03 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Iv7YO-0001vb-00
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 16:36:56 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

This series of patches introduces the fcuntionc crypto_xor and
crypto_inc.  It then uses them in the spots where duplicates
have been created for the same operations.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
