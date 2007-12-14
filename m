From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/4] Fix null algorithm with IPsec
Date: Fri, 14 Dec 2007 16:39:09 +0800
Message-ID: <20071214083909.GA15726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4676 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754397AbXLNIjL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 03:39:11 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J364c-000085-1F
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 19:39:10 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J364b-00046N-00
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 16:39:09 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I tried to use the null algorithm to test the IPsec infrastructure
and found that it didn't work anymore.  So here's a bunch of fixes
for that.  The first patch also does a faster null encryption so
we can better measure the IPsec stack overhead as opposed to the
encryption overhead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
