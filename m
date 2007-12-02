From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/5] Various authenc fixes
Date: Sun, 2 Dec 2007 18:52:42 +1100
Message-ID: <20071202075242.GA5826@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2728 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbXLBHwp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 02:52:45 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iyjd5-00088q-Lh
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:52:43 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Iyjd5-0001WG-00
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:52:43 +1100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Here's a set of patches to fix authenc for use by IPsec.  Most importantly,
the encryption key length and ICV size are no longer template parameters
but are set at run-time.  This is important for future drivers that need
to use this interface.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
