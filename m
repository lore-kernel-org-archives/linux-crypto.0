From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/5] Fix gcm ICV handling and restore old scatterwalk
Date: Fri, 7 Dec 2007 16:19:05 +0800
Message-ID: <20071207081904.GA7733@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1978 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750883AbXLGITI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:19:08 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YQM-0005Dq-1k
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:19:06 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J0YQL-000210-00
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 16:19:05 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Here's a few misc patches in my tree that I'll push out soon.
It restores the old scatterwalk chaining because generic chaining
isn't portable yet.

It also fixes gcm to following the crypto_aead convention of
including the ICV in the output for encrypt and input for decrypt.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
